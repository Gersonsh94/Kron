// Kron for VS Code -- build, run, debug, errors, completion, definitions, hover, outline.
// Plain JavaScript on the VS Code API: no dependencies, nothing to install.

const vscode = require('vscode');
const cp = require('child_process');
const fs = require('fs');
const path = require('path');

let diagnostics;
let output;

// ------------------------------------------------------------------ compiler

// The compiler, with no path written in. In this order: the open folder;
// the folder of the file being built (or the active one) and the folders
// above it; the repository the extension sits in, when it is installed
// from one (it lives in kron-vscode/kron-lang under the repository's
// root); the setting -- a path, absolute or relative to the open folder,
// or a command found on PATH ("kronc", the default).
function findCompiler(cwd) {
    const exeName = process.platform === 'win32' ? 'kronc.exe' : 'kronc';

    // 1. Open workspace folder root
    for (const f of vscode.workspace.workspaceFolders || []) {
        const p = path.join(f.uri.fsPath, exeName);
        if (fs.existsSync(p)) return p;
    }

    // 2. Walk up from the file being built, or the active one (finds the
    //    repo root when a subfolder is open)
    const starts = [];
    if (cwd) starts.push(path.resolve(cwd));
    const ed = vscode.window.activeTextEditor;
    if (ed && ed.document.fileName) starts.push(path.dirname(ed.document.fileName));
    for (let dir of starts) {
        for (let i = 0; i < 8; i++) {
            const candidate = path.join(dir, exeName);
            if (fs.existsSync(candidate)) return candidate;
            const parent = path.dirname(dir);
            if (parent === dir) break;
            dir = parent;
        }
    }

    // 3. The repository the extension is installed from: kron-vscode/kron-lang
    const repoExe = path.resolve(__dirname, '..', '..', exeName);
    if (fs.existsSync(repoExe)) return repoExe;

    // 4. Configured setting (relative to workspace, absolute path, or command in PATH)
    const p = vscode.workspace.getConfiguration('kron').get('compilerPath');
    if (p) {
        for (const f of vscode.workspace.workspaceFolders || []) {
            const rel = path.resolve(f.uri.fsPath, p);
            if (fs.existsSync(rel)) return rel;
        }
        if (fs.existsSync(p)) return p;
        if (p === 'kronc' || p === 'kronc.exe') return p;
    }

    return null;
}

const NOT_FOUND = 'kronc not found: not in the open folder, the folders above the file, ' +
                  'the repository, nor on PATH. Build it (BUILD.bat) or set "kron.compilerPath".';

function runCompiler(args, cwd) {
    return new Promise(resolve => {
        const kronc = findCompiler(cwd);
        if (!kronc) {
            resolve({ ok: false, text: NOT_FOUND, missing: true });
            return;
        }
        cp.execFile(kronc, args, { cwd, windowsHide: true, maxBuffer: 16 * 1024 * 1024 },
            (err, stdout, stderr) => {
                // "kronc" taken from PATH, and not there
                if (err && err.code === 'ENOENT') {
                    resolve({ ok: false, text: NOT_FOUND, missing: true });
                    return;
                }
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

// kronc goes from the .kr straight to the .exe next to it:
// nothing else is written. Returns the .exe path, or null.
async function build(file, quiet) {
    const cwd = path.dirname(file);
    const exe = file.replace(/\.kr$/i, '.exe');
    output.clear();
    const res = await runCompiler([file], cwd);
    output.append(res.text);
    if (!res.ok || showErrors(res.text, file) || !fs.existsSync(exe)) {
        showErrors(res.text, file);
        if (!quiet) {
            output.show(true);
            vscode.window.showErrorMessage(res.missing ? res.text : 'Kron: compilation failed. See the Problems panel.');
        }
        return null;
    }
    diagnostics.clear();
    return exe;
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
    // --check runs every check, the thread rule included, and writes nothing
    const res = await runCompiler([file, '--check'], path.dirname(file));
    if (res.missing) return;
    if (!showErrors(res.text, file)) diagnostics.clear();
}

// Build for another system: the file next to the source, named for it.
const TARGETS = [
    { label: 'Windows', target: 'windows', out: f => f.replace(/\.kr$/i, '.exe') },
    { label: 'Linux (x86-64)', target: 'linux', out: f => f.replace(/\.kr$/i, '') },
    { label: 'Linux (ARM64)', target: 'linux-arm64', out: f => f.replace(/\.kr$/i, '_arm64') },
    { label: 'macOS (Apple silicon)', target: 'macos', out: f => f.replace(/\.kr$/i, '_mac') },
    { label: 'Web (WebAssembly)', target: 'web', out: f => path.join(path.dirname(f), 'web', path.basename(f).replace(/\.kr$/i, '.wasm')) },
    { label: 'Android library (.so)', target: 'android', lib: true, out: f => path.join(path.dirname(f), 'lib' + path.basename(f).replace(/\.kr$/i, '.so')) },
    { label: 'iOS library (.dylib)', target: 'ios', lib: true, out: f => f.replace(/\.kr$/i, '.dylib') }
];

async function cmdBuildTarget() {
    const file = await currentKronFile();
    if (!file) return;
    const pick = await vscode.window.showQuickPick(TARGETS.map(t => t.label), { placeHolder: 'Build for which system?' });
    if (!pick) return;
    const t = TARGETS.find(x => x.label === pick);
    const out = t.out(file);
    if (!fs.existsSync(path.dirname(out))) fs.mkdirSync(path.dirname(out), { recursive: true });
    const args = [file, '--target=' + t.target, '-o', out];
    if (t.lib) args.push('--lib');
    output.clear();
    const res = await runCompiler(args, path.dirname(file));
    output.append(res.text);
    if (!res.ok || showErrors(res.text, file) || !fs.existsSync(out)) {
        output.show(true);
        vscode.window.showErrorMessage(res.missing ? res.text : 'Kron: the build for ' + t.label + ' failed. See the Problems panel.');
        return;
    }
    diagnostics.clear();
    vscode.window.showInformationMessage('Kron: built ' + path.relative(path.dirname(file), out) + ' for ' + t.label +
        (t.target === 'web' ? ' (serve the folder with kron_serve and open the .html)' : ''));
}

async function cmdDebug() {
    const file = await currentKronFile();
    if (!file) return;
    vscode.debug.startDebugging(vscode.workspace.getWorkspaceFolder(vscode.Uri.file(file)),
        { type: 'kron', request: 'launch', name: 'Debug ' + path.basename(file), program: file });
}

// ------------------------------------------------------------------ the debugger

class KronDebugSession {
    constructor() {
        this.emitter = new vscode.EventEmitter();
        this.onDidSendMessage = this.emitter.event;
        this.seq = 1;
        this.proc = null;
        this.files = [];          // number -> absolute path
        this.ready = false;       // the program said ready
        this.configured = false;  // VS Code sent its breakpoints
        this.started = false;
        this.stopOnEntry = false;
        this.bps = new Map();     // absolute path -> [lines]
        this.frames = [];         // of the last stop: { id, file, line, name }
        this.vars = new Map();    // frame ('0', '1', ... or 'g') -> [{ path, type, value }]
        this.refs = [];           // variablesReference - 1 -> { frame, path }
        this.pending = null;      // the stop being read
        this.buf = '';
        this.cwd = '';
    }
    send(m) { m.seq = this.seq++; this.emitter.fire(m); }
    respond(req, body, ok, message) {
        this.send({ type: 'response', request_seq: req.seq, command: req.command,
                    success: ok !== false, message, body: body || {} });
    }
    event(name, body) { this.send({ type: 'event', event: name, body: body || {} }); }
    out(text, category) { this.event('output', { category: category || 'stdout', output: text }); }
    write(line) { if (this.proc && this.proc.stdin.writable) this.proc.stdin.write(line + '\n'); }

    key(p) { const r = path.resolve(p); return process.platform === 'win32' ? r.toLowerCase() : r; }

    sendBreakpoints() {
        this.write('c');
        for (const [file, lines] of this.bps) {
            this.files.forEach((f, i) => {
                if (f && this.key(f) === file) for (const l of lines) this.write('b ' + i + ' ' + l);
            });
        }
    }
    maybeStart() {
        if (this.started || !this.ready || !this.configured) return;
        this.started = true;
        this.sendBreakpoints();
        this.write(this.stopOnEntry ? 'step' : 'run');
    }

    line(text) {
        if (!text.startsWith('@@kdbg ')) { this.out(text + '\n'); return; }
        const rest = text.slice(7);
        const word = rest.split(' ', 1)[0];
        const args = rest.slice(word.length + 1);
        if (word === 'hello') { this.files = []; }
        else if (word === 'file') {
            const sp = args.indexOf(' ');
            const n = parseInt(args.slice(0, sp), 10);
            this.files[n] = path.resolve(this.cwd, args.slice(sp + 1));
        }
        else if (word === 'ready') { this.ready = true; this.maybeStart(); }
        else if (word === 'stop') { this.pending = { reason: args, frames: [], vars: new Map() }; }
        else if (word === 'frame' && this.pending) {
            const p = args.split(' ');
            this.pending.frames.push({ id: parseInt(p[0], 10), file: this.files[parseInt(p[1], 10)] || '',
                                       line: parseInt(p[2], 10), name: p.slice(3).join(' ') });
        }
        else if (word === 'var' && this.pending) {
            const a = args.indexOf(' '), b = args.indexOf(' ', a + 1), c = args.indexOf(' ', b + 1);
            const frame = args.slice(0, a), vpath = args.slice(a + 1, b);
            const type = c < 0 ? args.slice(b + 1) : args.slice(b + 1, c);
            const value = c < 0 ? '' : args.slice(c + 1);
            if (!this.pending.vars.has(frame)) this.pending.vars.set(frame, []);
            this.pending.vars.get(frame).push({ path: vpath, type, value });
        }
        else if (word === 'end' && this.pending) {
            this.frames = this.pending.frames;
            this.vars = this.pending.vars;
            this.refs = [];
            const reason = this.pending.reason === 'breakpoint' ? 'breakpoint' : (this.pending.reason === 'entry' ? 'entry' : 'step');
            this.pending = null;
            this.event('stopped', { reason, threadId: 1, allThreadsStopped: true });
        }
    }

    async launch(req) {
        const a = req.arguments || {};
        const program = a.program;
        if (!program || !fs.existsSync(program)) {
            this.respond(req, {}, false, 'Kron: no program to debug (set "program" to a .kr file)');
            return;
        }
        this.cwd = path.dirname(program);
        this.stopOnEntry = !!a.stopOnEntry;
        const exe = program.replace(/\.kr$/i, '') + '_debug' + (process.platform === 'win32' ? '.exe' : '');
        this.out('Building ' + path.basename(program) + ' for debugging...\n', 'console');
        const res = await runCompiler([program, '--debug', '-o', exe], this.cwd);
        if (!res.ok || showErrors(res.text, program) || !fs.existsSync(exe)) {
            this.out(res.text, 'stderr');
            this.respond(req, {}, false, res.missing ? res.text : 'Kron: the program does not compile; see the Problems panel.');
            return;
        }
        diagnostics.clear();
        if (process.platform !== 'win32') { try { fs.chmodSync(exe, 0o755); } catch (e) { /* as it is */ } }
        try {
            this.proc = cp.spawn(exe, a.args || [], { cwd: a.cwd || this.cwd, windowsHide: false });
        } catch (e) {
            this.respond(req, {}, false, 'Kron: the program would not start: ' + e.message);
            return;
        }
        this.proc.stdout.setEncoding('utf8');
        this.proc.stdout.on('data', d => {
            this.buf += d;
            let i;
            while ((i = this.buf.indexOf('\n')) >= 0) {
                const l = this.buf.slice(0, i).replace(/\r$/, '');
                this.buf = this.buf.slice(i + 1);
                this.line(l);
            }
        });
        this.proc.on('error', e => {
            this.out('Kron: the program would not start: ' + e.message + '\n', 'stderr');
            this.event('terminated');
            this.proc = null;
        });
        this.proc.stderr.setEncoding('utf8');
        this.proc.stderr.on('data', d => this.out(d, 'stderr'));
        this.proc.on('exit', code => {
            if (this.buf) { this.line(this.buf); this.buf = ''; }
            this.event('exited', { exitCode: code === null ? 0 : code });
            this.event('terminated');
            this.proc = null;
        });
        this.respond(req);
        this.event('initialized');
    }

    children(frame, parent) {
        const list = this.vars.get(frame) || [];
        const out = [];
        for (const v of list) {
            let rest;
            if (parent === '') {
                if (/[.\[]/.test(v.path)) continue;
                rest = v.path;
            } else {
                if (!v.path.startsWith(parent)) continue;
                rest = v.path.slice(parent.length);
                if (!/^(\.[A-Za-z_]\w*|\[\d+\])$/.test(rest)) continue;
                if (rest[0] === '.') rest = rest.slice(1);
            }
            const hasKids = list.some(w => w.path.startsWith(v.path) && /^(\.|\[)/.test(w.path.slice(v.path.length)));
            let ref = 0;
            if (hasKids) { this.refs.push({ frame, path: v.path }); ref = this.refs.length; }
            out.push({ name: rest, value: v.value, type: v.type, variablesReference: ref,
                       evaluateName: v.path });
        }
        return out;
    }

    handleMessage(req) {
        switch (req.command) {
            case 'initialize':
                this.respond(req, { supportsConfigurationDoneRequest: true, supportsEvaluateForHovers: true,
                                    supportsTerminateRequest: true });
                break;
            case 'launch':
                this.launch(req);
                break;
            case 'setBreakpoints': {
                const src = req.arguments.source || {};
                const lines = (req.arguments.breakpoints || []).map(b => b.line);
                if (src.path) this.bps.set(this.key(src.path), lines);
                if (this.started) this.sendBreakpoints();
                this.respond(req, { breakpoints: lines.map(l => ({ verified: true, line: l })) });
                break;
            }
            case 'setExceptionBreakpoints':
                this.respond(req, { breakpoints: [] });
                break;
            case 'configurationDone':
                this.configured = true;
                this.respond(req);
                this.maybeStart();
                break;
            case 'threads':
                this.respond(req, { threads: [{ id: 1, name: 'main' }] });
                break;
            case 'stackTrace':
                this.respond(req, {
                    stackFrames: this.frames.map(f => ({ id: f.id, name: f.name, line: f.line, column: 1,
                        source: f.file ? { name: path.basename(f.file), path: f.file } : undefined })),
                    totalFrames: this.frames.length
                });
                break;
            case 'scopes': {
                const fid = String(req.arguments.frameId);
                this.refs.push({ frame: fid, path: '' });
                const locals = this.refs.length;
                this.refs.push({ frame: 'g', path: '' });
                const globals = this.refs.length;
                this.respond(req, { scopes: [
                    { name: 'Locals', variablesReference: locals, expensive: false },
                    { name: 'Globals', variablesReference: globals, expensive: false }] });
                break;
            }
            case 'variables': {
                const r = this.refs[req.arguments.variablesReference - 1];
                this.respond(req, { variables: r ? this.children(r.frame, r.path) : [] });
                break;
            }
            case 'evaluate': {
                const e = (req.arguments.expression || '').trim();
                const fid = req.arguments.frameId !== undefined ? String(req.arguments.frameId) : '0';
                const find = fr => (this.vars.get(fr) || []).find(v => v.path === e);
                const v = find(fid) || find('g');
                if (v) this.respond(req, { result: v.value, type: v.type, variablesReference: 0 });
                else this.respond(req, {}, false, 'Kron: only the names shown under Variables can be read here (p, p.x, a[3])');
                break;
            }
            case 'continue': this.write('run'); this.respond(req, { allThreadsContinued: true }); break;
            case 'next': this.write('next'); this.respond(req); break;
            case 'stepIn': this.write('step'); this.respond(req); break;
            case 'stepOut': this.write('out'); this.respond(req); break;
            case 'pause':
                this.respond(req, {}, false, 'Kron: set a breakpoint to stop the program; it cannot be paused from outside yet');
                break;
            case 'terminate':
            case 'disconnect':
                if (this.proc) { try { this.proc.kill(); } catch (e) { /* gone */ } }
                this.respond(req);
                break;
            default:
                this.respond(req, {}, false, 'Kron: ' + req.command + ' is not supported');
        }
    }
    dispose() { if (this.proc) { try { this.proc.kill(); } catch (e) { /* gone */ } } }
}

// ------------------------------------------------------------------ the index

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
    call: 'call ptr(args) -- calls a function through its address, with the Windows convention.',
    extern: 'extern "libm.so.6", "libm.dylib", "msvcrt.dll" {\n    fn cos(x: f64) -> f64;\n}\n\nFunctions of a system library (.dll .so .dylib): the first library that loads is used. Call them inside raw { }.',
    export: 'fn export name(...) -> T { }\n\nAn exported function: of a library built with --lib, or a callback (c_fn).',
    c_fn: 'c_fn(f) -> the native address to reach the exported function f (callbacks: qsort, a window procedure...). Only inside raw { }.',
    c_call: 'c_call(address, args...) -- calls a native function through its address, in the system\'s calling convention. Only inside raw { }.',
    target_os: 'target_os() -> 1 Windows, 2 Linux, 3 krn, 4 bare: known when compiling.',
    say: 'say(x): prints a text, a number or a "..." and a new line.'
};

const KEYWORDS = ('if else while for loop break continue return switch case default in fn var const struct enum ' +
    'shared raw fail hint call as true false null i8 i16 i32 i64 u8 u16 u32 u64 f32 f64 bool void stream ptr slice ' +
    'extern export text list map str').split(' ');
const BUILTINS = ('print printc failed print_fail peek peek8 peek16 peek32 poke poke8 poke16 poke32 sizeof trunc ' +
    'loadfile savefile cpu_count thread_start thread_wait thread_yield lock_init lock_take lock_give ' +
    'ticks ticks_per_sec rotl rotr vec2_load vec2_store vec2_add vec2_sub vec2_mul readkey dll_load dll_proc ' +
    'c_fn c_call target_os syscall say').split(' ');

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
        vscode.commands.registerCommand('kron.check', () => cmdCheck(null)),
        vscode.commands.registerCommand('kron.buildTarget', cmdBuildTarget),
        vscode.commands.registerCommand('kron.debug', cmdDebug));

    // the debugger: built in, nothing to install
    context.subscriptions.push(vscode.debug.registerDebugAdapterDescriptorFactory('kron', {
        createDebugAdapterDescriptor: () => new vscode.DebugAdapterInlineImplementation(new KronDebugSession())
    }));
    context.subscriptions.push(vscode.debug.registerDebugConfigurationProvider('kron', {
        // F5 with no launch.json: debug the file in the editor
        resolveDebugConfiguration(folder, config) {
            if (!config.type && !config.request && !config.name) {
                const ed = vscode.window.activeTextEditor;
                if (ed && ed.document.languageId === 'kron') {
                    config.type = 'kron';
                    config.request = 'launch';
                    config.name = 'Debug ' + path.basename(ed.document.fileName);
                    config.program = ed.document.fileName;
                }
            }
            if (!config.program) {
                return vscode.window.showWarningMessage('Open a .kr file to debug it.').then(() => undefined);
            }
            return config;
        }
    }));

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