// Kron for VS Code -- build, run, errors, completion, definitions, hover, outline.
// Plain JavaScript on the VS Code API: no dependencies, nothing to install.

const vscode = require('vscode');
const cp = require('child_process');
const fs = require('fs');
const path = require('path');

let diagnostics;
let output;

// ------------------------------------------------------------------ compiler

// The compiler: a kronc.exe in an open folder wins, then the setting.
function findCompiler() {
    for (const f of vscode.workspace.workspaceFolders || []) {
        const p = path.join(f.uri.fsPath, 'kronc.exe');
        if (fs.existsSync(p)) return p;
    }
    const p = vscode.workspace.getConfiguration('kron').get('compilerPath');
    if (p && fs.existsSync(p)) return p;
    return null;
}

function runCompiler(args, cwd) {
    return new Promise(resolve => {
        const kronc = findCompiler();
        if (!kronc) {
            resolve({ ok: false, text: 'kronc.exe not found. Set "kron.compilerPath" in the settings, ' +
                                      'or open the compiler folder.', missing: true });
            return;
        }
        cp.execFile(kronc, args, { cwd, windowsHide: true, maxBuffer: 16 * 1024 * 1024 },
            (err, stdout, stderr) => {
                const text = (stdout || '') + (stderr || '');
                // kronc exits 0 on success; any other code is a failure
                resolve({ ok: !err, text });
            });
    });
}

// ------------------------------------------------------------------ errors

// kronc reports:   file.kr:LINE:COL: message 'name'
//                      <source line>
//                      ^^^^^
//                    hint: what to do
// Errors without a position start with "ERROR:".
function parseErrors(text, srcFile) {
    const byFile = new Map();
    const lines = text.split(/\r?\n/);
    const dir = path.dirname(srcFile);
    const add = (file, diag) => {
        if (!byFile.has(file)) byFile.set(file, []);
        byFile.get(file).push(diag);
    };
    for (let i = 0; i < lines.length; i++) {
        // a parser error is printed on the same line as "[3/6] Parser..."
        const text_i = lines[i].replace(/^\[\d+\/\d+\][^.]*\.\.\.\s*/, '');
        const m = /^(.+?\.kr):(\d+):(\d+):\s+(.*)$/.exec(text_i);
        if (m) {
            const file = path.isAbsolute(m[1]) ? m[1] : path.join(dir, m[1]);
            const line = Math.max(0, parseInt(m[2], 10) - 1);
            const col = Math.max(0, parseInt(m[3], 10) - 1);
            let width = 1;
            let message = m[4];
            for (let j = i + 1; j < Math.min(i + 4, lines.length); j++) {
                const carets = /\^+/.exec(lines[j]);
                if (carets && /^\s*\^+\s*$/.test(lines[j])) width = carets[0].length;
                const hint = /^\s*hint:\s*(.*)$/.exec(lines[j]);
                if (hint) message += '\nhint: ' + hint[1];
            }
            const range = new vscode.Range(line, col, line, col + width);
            const d = new vscode.Diagnostic(range, message, vscode.DiagnosticSeverity.Error);
            d.source = 'kron';
            add(file, d);
            continue;
        }
        const e = /^ERROR:\s*(.*)$/.exec(text_i);
        if (e) {
            let message = e[1];
            const next = lines[i + 1] || '';
            const hint = /^\s*hint:\s*(.*)$/.exec(next);
            if (hint) message += '\nhint: ' + hint[1];
            const d = new vscode.Diagnostic(new vscode.Range(0, 0, 0, 1), message,
                                            vscode.DiagnosticSeverity.Error);
            d.source = 'kron';
            add(srcFile, d);
        }
    }
    return byFile;
}

function showErrors(text, srcFile) {
    diagnostics.clear();
    const byFile = parseErrors(text, srcFile);
    for (const [file, list] of byFile) diagnostics.set(vscode.Uri.file(file), list);
    return byFile.size > 0;
}

// ------------------------------------------------------------------ commands

async function currentKronFile() {
    const ed = vscode.window.activeTextEditor;
    if (!ed || ed.document.languageId !== 'kron') {
        vscode.window.showWarningMessage('Open a .kr file first.');
        return null;
    }
    if (ed.document.isDirty) await ed.document.save();
    return ed.document.fileName;
}

// Compile, then assemble into an .exe. Returns the .exe path, or null.
async function build(file, quiet) {
    const cwd = path.dirname(file);
    output.clear();
    const step1 = await runCompiler([file], cwd);
    output.append(step1.text);
    if (!step1.ok || showErrors(step1.text, file)) {
        showErrors(step1.text, file);
        if (!quiet) {
            output.show(true);
            vscode.window.showErrorMessage(step1.missing ? step1.text : 'Kron: compilation failed. See the Problems panel.');
        }
        return null;
    }
    const asm = file.replace(/\.kr$/i, '.asm');
    const step2 = await runCompiler([asm, '--assemble', '--pe'], cwd);
    output.append(step2.text);
    if (!step2.ok) {
        output.show(true);
        vscode.window.showErrorMessage('Kron: the assembler failed. See the Kron output.');
        return null;
    }
    diagnostics.clear();
    return file.replace(/\.kr$/i, '.exe');
}

async function cmdBuild() {
    const file = await currentKronFile();
    if (!file) return;
    const exe = await build(file, false);
    if (exe) vscode.window.setStatusBarMessage('Kron: built ' + path.basename(exe), 4000);
}

async function cmdRun() {
    const file = await currentKronFile();
    if (!file) return;
    const exe = await build(file, false);
    if (!exe) return;
    let term = vscode.window.terminals.find(t => t.name === 'Kron');
    if (!term) term = vscode.window.createTerminal({ name: 'Kron', shellPath: 'powershell.exe' });
    term.show(true);
    term.sendText(`Set-Location -LiteralPath '${path.dirname(exe)}'; & '${exe}'`);
}

async function cmdCheck(doc) {
    const file = doc ? doc.fileName : await currentKronFile();
    if (!file) return;
    const res = await runCompiler([file], path.dirname(file));
    if (res.missing) return;
    if (!showErrors(res.text, file)) diagnostics.clear();
}

// ------------------------------------------------------------------ the index

// Declarations of a file and of every module it imports, found by reading
// the text: enough for completion, definitions and the outline.
const DECL = [
    { re: /^\s*fn\s+([A-Za-z_]\w*)\s*\(([^)]*)\)\s*(->\s*[^{]+)?/, kind: 'fn' },
    { re: /^\s*struct\s+([A-Za-z_]\w*)/, kind: 'struct' },
    { re: /^\s*enum\s+([A-Za-z_]\w*)/, kind: 'enum' },
    { re: /^(shared\s+)?var\s+([A-Za-z_]\w*)\s*:\s*(.*)$/, kind: 'global' },
    { re: /^()const\s+([A-Za-z_]\w*)\s*:\s*(.*)$/, kind: 'const' }
];

function declsOf(text, file) {
    const out = [];
    const lines = text.split(/\r?\n/);
    for (let i = 0; i < lines.length; i++) {
        for (const d of DECL) {
            const m = d.re.exec(lines[i]);
            if (m) {
                let name = m[1];
                let detail = '';
                if (d.kind === 'fn') detail = `fn ${m[1]}(${m[2].trim()})${m[3] ? ' ' + m[3].trim() : ''}`;
                else if (d.kind === 'global' || d.kind === 'const') {
                    // the type runs to the final ';' -- an array type has one inside: [i64; 4]
                    name = m[2];
                    const type = m[3].replace(/\/\/.*$/, '').replace(/=.*$/, '').replace(/;\s*$/, '').trim();
                    detail = `${d.kind === 'const' ? 'const' : (m[1] ? 'shared var' : 'var')} ${name}: ${type}`;
                }
                else detail = `${d.kind} ${m[1]}`;
                out.push({ name, kind: d.kind, line: i, col: lines[i].indexOf(name), file, detail });
                break;
            }
        }
    }
    return out;
}

function importsOf(text, dir) {
    const out = [];
    const re = /acquire_domain\s+"([^"]+)"/g;
    let m;
    while ((m = re.exec(text)) !== null) out.push(path.join(dir, m[1]));
    return out;
}

// The document and its imports, following imports of imports, once each.
function indexFor(doc) {
    const seen = new Set();
    const all = [];
    const visit = (file, text) => {
        if (seen.has(file.toLowerCase()) || seen.size > 64) return;
        seen.add(file.toLowerCase());
        all.push(...declsOf(text, file));
        for (const imp of importsOf(text, path.dirname(file))) {
            try { visit(imp, fs.readFileSync(imp, 'utf8')); } catch (e) { /* missing: kronc reports it */ }
        }
    };
    visit(doc.fileName, doc.getText());
    return all;
}

// ------------------------------------------------------------------ help

const HELP = {
    fail: 'fail "cause" hint "what to do";\n\nLeaves the function at once, returning 0, and records the cause and the hint for this thread. The caller checks with failed().',
    hint: 'The second half of fail: what the caller should do about the failure.',
    failed: 'failed() -> 1 if the last call failed, 0 otherwise. Reading it clears it. Each thread has its own.',
    print_fail: 'Prints the cause and hint of this thread\'s last failure.',
    raw: 'raw { ... }\n\nThe only place where peek, poke and *p are allowed: direct memory access stays marked and visible.',
    peek: 'peek(address) -> the 64-bit value at that address. Only inside raw { }.',
    poke: 'poke(address, value): writes 64 bits at that address. Only inside raw { }.',
    shared: 'shared var name: type;\n\nA global that code running in a thread may touch. Guard it with a lock, or pass values through a channel instead.',
    slice: 'slice<i64>\n\nA run of an arena (std_arena.kr). v[i] is checked against its length, and using it after arena_free is a fail.',
    thread_start: 'thread_start(&function, argument) -> a handle, or 0 if the thread cannot start.',
    thread_wait: 'thread_wait(handle): waits for the thread to finish.',
    thread_yield: 'thread_yield(): gives the rest of the time slice to another thread.',
    lock_init: 'lock_init(n): creates lock n (0 to 7 for programs; 8 to 15 belong to the channels).',
    lock_take: 'lock_take(n): waits for lock n and takes it.',
    lock_give: 'lock_give(n): releases lock n.',
    cpu_count: 'cpu_count() -> how many processors the machine has.',
    sizeof: 'sizeof(T) -> the size of type T in bytes, worked out at compile time.',
    loadfile: 'loadfile(name, buffer, capacity) -> bytes read, or 0 if the file cannot be opened.',
    savefile: 'savefile(name, buffer, length): writes the bytes to a file.',
    acquire_domain: 'acquire_domain "module.kr";\n\nImports a module. Its own imports come along, once each, in dependency order.',
    kron_program: 'Header: this file is a Kron program.',
    kron_domain: 'Header: kron_domain name; -- the name of this program or module.',
    kron_imports: 'Header: the acquire_domain lines go after it.',
    kron_definitions: 'Header: the code starts here.',
    as: 'expression as type -- converts a value, for example x as f64.',
    trunc: 'trunc(x) -> a real truncated towards zero, as an integer.',
    dll_load: 'dll_load("x.dll") -> a library handle, 0 if it cannot be loaded. Only inside raw { }.',
    dll_proc: 'dll_proc(lib, "name") -> the function\'s address, 0 if not found. Call it with call ptr(args). Only inside raw { }.',
    call: 'call ptr(args) -- calls a function through its address, with the Windows convention.'
};

const KEYWORDS = ('if else while for loop break continue return switch case default in fn var const struct enum ' +
    'shared raw fail hint call as true false null i8 i16 i32 i64 u8 u16 u32 u64 f32 f64 bool void stream ptr slice').split(' ');
const BUILTINS = ('print printc failed print_fail peek peek8 peek16 peek32 poke poke8 poke16 poke32 sizeof trunc ' +
    'loadfile savefile cpu_count thread_start thread_wait thread_yield lock_init lock_take lock_give ' +
    'ticks ticks_per_sec rotl rotr vec2_load vec2_store vec2_add vec2_sub vec2_mul readkey dll_load dll_proc').split(' ');

function wordAt(doc, pos) {
    const r = doc.getWordRangeAtPosition(pos, /[A-Za-z_]\w*/);
    return r ? doc.getText(r) : null;
}

// ------------------------------------------------------------------ activate

function activate(context) {
    diagnostics = vscode.languages.createDiagnosticCollection('kron');
    output = vscode.window.createOutputChannel('Kron');
    context.subscriptions.push(diagnostics, output);

    context.subscriptions.push(
        vscode.commands.registerCommand('kron.build', cmdBuild),
        vscode.commands.registerCommand('kron.run', cmdRun),
        vscode.commands.registerCommand('kron.check', () => cmdCheck(null)));

    context.subscriptions.push(vscode.workspace.onDidSaveTextDocument(doc => {
        if (doc.languageId !== 'kron') return;
        if (!vscode.workspace.getConfiguration('kron').get('checkOnSave')) return;
        cmdCheck(doc);
    }));

    const sel = { language: 'kron' };

    context.subscriptions.push(vscode.languages.registerCompletionItemProvider(sel, {
        provideCompletionItems(doc) {
            const items = [];
            for (const k of KEYWORDS) items.push(new vscode.CompletionItem(k, vscode.CompletionItemKind.Keyword));
            for (const b of BUILTINS) {
                const it = new vscode.CompletionItem(b, vscode.CompletionItemKind.Function);
                if (HELP[b]) it.documentation = new vscode.MarkdownString().appendCodeblock(HELP[b], 'kron');
                items.push(it);
            }
            const seen = new Set();
            for (const d of indexFor(doc)) {
                if (seen.has(d.name)) continue;
                seen.add(d.name);
                const kind = d.kind === 'fn' ? vscode.CompletionItemKind.Function
                           : d.kind === 'struct' ? vscode.CompletionItemKind.Struct
                           : d.kind === 'enum' ? vscode.CompletionItemKind.Enum
                           : d.kind === 'const' ? vscode.CompletionItemKind.Constant
                           : vscode.CompletionItemKind.Variable;
                const it = new vscode.CompletionItem(d.name, kind);
                it.detail = d.detail + (d.file !== doc.fileName ? '   (' + path.basename(d.file) + ')' : '');
                items.push(it);
            }
            return items;
        }
    }));

    context.subscriptions.push(vscode.languages.registerDefinitionProvider(sel, {
        provideDefinition(doc, pos) {
            const w = wordAt(doc, pos);
            if (!w) return null;
            const d = indexFor(doc).find(x => x.name === w);
            if (!d) return null;
            return new vscode.Location(vscode.Uri.file(d.file), new vscode.Position(d.line, Math.max(0, d.col)));
        }
    }));

    context.subscriptions.push(vscode.languages.registerHoverProvider(sel, {
        provideHover(doc, pos) {
            const w = wordAt(doc, pos);
            if (!w) return null;
            if (HELP[w]) return new vscode.Hover(new vscode.MarkdownString().appendCodeblock(HELP[w], 'kron'));
            const d = indexFor(doc).find(x => x.name === w);
            if (d) {
                const md = new vscode.MarkdownString().appendCodeblock(d.detail, 'kron');
                if (d.file !== doc.fileName) md.appendMarkdown('\n\nin `' + path.basename(d.file) + '`');
                return new vscode.Hover(md);
            }
            return null;
        }
    }));

    context.subscriptions.push(vscode.languages.registerDocumentSymbolProvider(sel, {
        provideDocumentSymbols(doc) {
            return declsOf(doc.getText(), doc.fileName).map(d => {
                const kind = d.kind === 'fn' ? vscode.SymbolKind.Function
                           : d.kind === 'struct' ? vscode.SymbolKind.Struct
                           : d.kind === 'enum' ? vscode.SymbolKind.Enum
                           : d.kind === 'const' ? vscode.SymbolKind.Constant
                           : vscode.SymbolKind.Variable;
                const line = doc.lineAt(d.line).range;
                return new vscode.DocumentSymbol(d.name, d.detail, kind, line, line);
            });
        }
    }));

    // a file already open when the extension starts gets checked once
    const ed = vscode.window.activeTextEditor;
    if (ed && ed.document.languageId === 'kron' &&
        vscode.workspace.getConfiguration('kron').get('checkOnSave')) cmdCheck(ed.document);
}

function deactivate() {}

module.exports = { activate, deactivate };
