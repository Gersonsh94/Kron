// =============================================================================
// kron_web.js -- the host of a Kron program compiled with --target=web.
//
// The program is the Linux program, lowered to WebAssembly: everything it
// asks of the system goes through one import, env.syscall, with the Linux
// x86-64 numbers. This file answers those calls -- files, time, memory,
// threads, output -- the way Linux would, and adds its own from 1000 up:
// the window std_window draws in, which here is a <canvas>.
//
// One file, four roles:
//   node          node kron_web.js prog.wasm: console programs, files
//                 on the real disk, threads as worker threads (the tests)
//   page          <script src="kron_web.js"> then KronWeb.start({...}); the
//                 page draws the pictures and sends the keyboard and mouse
//   worker        the program runs in a worker, so its loop may block and
//                 sleep; each of its threads is one more worker, with its own
//                 instance of the module over the one shared memory
//   service       a service worker that adds the two headers shared memory
//                 needs (COOP, COEP) when the server does not send them
//
// Files, in a browser, are folders and files in memory: they start empty and
// go away with the page. Each thread has its own descriptors: a file one
// thread opened is not open in the others.
// =============================================================================
'use strict';

(function () {

const IS_NODE = typeof process !== 'undefined' && process.versions && process.versions.node &&
                typeof window === 'undefined' && typeof importScripts === 'undefined';
const IS_SERVICE = typeof ServiceWorkerGlobalScope !== 'undefined' &&
                   typeof self !== 'undefined' && self instanceof ServiceWorkerGlobalScope;
const IS_WORKER = !IS_SERVICE && typeof importScripts === 'function' && typeof window === 'undefined';
const IS_PAGE = typeof window !== 'undefined' && typeof document !== 'undefined';

// errno values the library looks at
const ENOENT = 2, EBADF = 9, ECHILD = 10, EAGAIN = 11, ENOMEM = 12, EACCES = 13,
      EEXIST = 17, ENOTDIR = 20, EISDIR = 21, EINVAL = 22, ENOTTY = 25,
      ENOSYS = 38, ENOTEMPTY = 39;

// the events the page sends (shared ring, 8 ints each)
const EV_KEY_DOWN = 1, EV_KEY_UP = 2, EV_MOVE = 3, EV_DOWN = 4, EV_UP = 5,
      EV_WHEEL = 6, EV_CLOSE = 7, EV_CHAR = 8;
const RING_SLOTS = 1024;            // events
const RING_INTS = 8;
const CTL_INTS = 16;                // head, tail, wake, clip length ...
const CLIP_BYTES = 65536;

class KronExit {
  constructor(code, all) { this.code = code; this.all = all; }
}

// words of the shared memory the hosts of all threads use (below .data)
const BRK_WORD = 64;                // the heap's end, in 64 KB pages
const TID_WORD = 65;                // the last thread id given

// the memory the module imports: where its flags are, its least and most
function memoryImport(bytes) {
  let p = 8;
  const uleb = () => { let r = 0, s = 0, b; do { b = bytes[p++]; r += (b & 0x7F) * 2 ** s; s += 7; } while (b & 0x80); return r; };
  while (p < bytes.length) {
    const id = bytes[p++], size = uleb();
    const end = p + size;
    if (id === 2) {
      let n = uleb();
      while (n-- > 0) {
        for (let i = 0; i < 2; i++) { const len = uleb(); p += len; }   // module, name
        const kind = bytes[p++];
        if (kind === 0) uleb();
        else if (kind === 1) { p++; const f = bytes[p++]; uleb(); if (f & 1) uleb(); }
        else if (kind === 3) p += 2;
        else if (kind === 2) {
          const at = p, f = bytes[p++], min = uleb(), max = (f & 1) ? uleb() : 65536;
          return { at, shared: (f & 2) !== 0, min, max };
        }
      }
      return null;
    }
    p = end;
  }
  return null;
}

// a memory for the module: shared when the platform has it (threads need
// it), as large as the module allows and the platform grants
function makeMemory(bytes) {
  const mi = memoryImport(bytes);
  if (!mi) throw new Error('not a Kron module: it imports no memory');
  const canShare = typeof SharedArrayBuffer !== 'undefined';
  if (mi.shared && !canShare) bytes[mi.at] &= ~2;     // run without threads
  const shared = mi.shared && canShare;
  for (const max of [mi.max, 32768, 16384, 8192, 4096]) {
    if (max > mi.max || max < mi.min) continue;
    try { return { memory: new WebAssembly.Memory({ initial: mi.min, maximum: max, shared }), shared }; }
    catch (e) { /* ask for less */ }
  }
  throw new Error('no memory for the program: it needs ' + (mi.min * 64) + ' KB');
}

// ---------------------------------------------------------------------------
// FILES. On node, the real disk; in a browser, folders and files in memory
// (they start empty and go away with the page).
// ---------------------------------------------------------------------------
class MemFS {
  constructor() { this.files = new Map(); this.dirs = new Set(['/']); this.cwd = '/'; }
  abs(p) {
    if (!p.startsWith('/')) p = (this.cwd.endsWith('/') ? this.cwd : this.cwd + '/') + p;
    const out = [];
    for (const part of p.split('/')) {
      if (part === '' || part === '.') continue;
      if (part === '..') out.pop(); else out.push(part);
    }
    return '/' + out.join('/');
  }
  parent(p) { const i = p.lastIndexOf('/'); return i <= 0 ? '/' : p.slice(0, i); }
  isDir(p) { return this.dirs.has(this.abs(p)); }
  isFile(p) { return this.files.has(this.abs(p)); }
  exists(p) { return this.isDir(p) || this.isFile(p); }
  read(p) { return this.files.get(this.abs(p)); }
  write(p, data) {
    const a = this.abs(p);
    if (!this.dirs.has(this.parent(a))) return -ENOENT;
    this.files.set(a, data);
    return 0;
  }
  mkdir(p) {
    const a = this.abs(p);
    if (this.exists(a)) return -EEXIST;
    if (!this.dirs.has(this.parent(a))) return -ENOENT;
    this.dirs.add(a);
    return 0;
  }
  rmdir(p) {
    const a = this.abs(p);
    if (!this.dirs.has(a)) return -ENOENT;
    for (const k of this.files.keys()) if (k.startsWith(a + '/')) return -ENOTEMPTY;
    for (const k of this.dirs) if (k.startsWith(a + '/')) return -ENOTEMPTY;
    this.dirs.delete(a);
    return 0;
  }
  unlink(p) { const a = this.abs(p); if (!this.files.has(a)) return -ENOENT; this.files.delete(a); return 0; }
  rename(a, b) {
    a = this.abs(a); b = this.abs(b);
    if (this.files.has(a)) { this.files.set(b, this.files.get(a)); this.files.delete(a); return 0; }
    return -ENOENT;
  }
  list(p) {
    const a = this.abs(p), pre = a === '/' ? '/' : a + '/', names = new Set();
    for (const k of this.files.keys()) if (k.startsWith(pre) && !k.slice(pre.length).includes('/')) names.add([k.slice(pre.length), 8]);
    for (const k of this.dirs) if (k !== a && k.startsWith(pre) && !k.slice(pre.length).includes('/')) names.add([k.slice(pre.length), 4]);
    return [...names];
  }
}

// ---------------------------------------------------------------------------
// THE MACHINE: one instance of the module and the system around it
// ---------------------------------------------------------------------------
class Kron {
  constructor(opts) {
    this.out = opts.out;                 // (fd, Uint8Array) -> void
    this.spawn = opts.spawn || null;     // starts a thread: { module, memory, stack, ctid, tid }
    this.freed = new Map();              // released mappings, by length
    this.debug = !!opts.debug;           // a call the host could not answer, to the console
    this.shared = opts.shared || null;   // { ctl: Int32Array, ring: Int32Array, clip: Uint8Array }
    this.hasWindow = !!opts.hasWindow;   // the page has a canvas for window_open
    this.post = opts.post || null;       // messages to the page: (message, transfer)
    this.fs = IS_NODE ? null : new MemFS();
    this.fds = new Map();                // fd -> { path, pos, data, dir, nodefd }
    this.nextFd = 3;
    this.decoder = new TextDecoder();
    this.encoder = new TextEncoder();
    this.sleeper = (typeof SharedArrayBuffer !== 'undefined') ? new Int32Array(new SharedArrayBuffer(4)) : null;
    if (IS_NODE) this.nodefs = require('fs');
  }

  // the program: compile, make its memory, instantiate
  async load(bytes) {
    bytes = new Uint8Array(bytes);
    const { memory, shared } = makeMemory(bytes);
    this.module = await WebAssembly.compile(bytes);
    await this.attach(this.module, memory, shared);
    const heap = Number(this.inst.exports.kron_heap.value);
    Atomics.store(this.i32(), BRK_WORD, heap / 65536);
    Atomics.store(this.i32(), TID_WORD, 1);
  }

  // one more thread of a program: the same module, the same memory
  async attach(module, memory, shared) {
    this.module = module;
    this.mem = memory;
    this.sharedMem = shared;
    const env = { syscall: (n, a, b, c, d, e, f) => this.syscall(n, a, b, c, d, e, f), memory };
    this.inst = await WebAssembly.instantiate(module, { env });
  }

  // a thread's life: kron_thread runs the function; then, as Linux does for
  // CLONE_CHILD_CLEARTID, its id word goes to 0 and whoever waits is woken
  runThread(stack, ctid) {
    let code = 0, all = false;
    try {
      this.inst.exports.kron_thread(BigInt(stack));
    } catch (e) {
      if (e instanceof KronExit) { code = e.code; all = e.all; }
      else {
        this.out(2, this.encoder.encode('kron_web: thread: ' + (e && e.stack ? e.stack : e) + '\n'));
        code = 70; all = true;
      }
    }
    const i32 = this.i32();
    Atomics.store(i32, ctid >>> 2, 0);
    Atomics.notify(i32, ctid >>> 2);
    return { code, all };
  }

  run() {
    try {
      this.inst.exports.kron_start();
      return 0;
    } catch (e) {
      if (e instanceof KronExit) return e.code;
      throw e;
    }
  }

  // views on memory, fresh after any growth
  u8() { return new Uint8Array(this.mem.buffer); }
  dv() { return new DataView(this.mem.buffer); }
  i32() { return new Int32Array(this.mem.buffer); }
  cstr(p) {
    const m = this.u8(); let e = p;
    while (m[e] !== 0) e++;
    return this.decoder.decode(m.slice(p, e));      // a copy: shared memory cannot be decoded
  }
  put64(p, v) { this.dv().setBigInt64(p, BigInt(v), true); }
  put32(p, v) { this.dv().setInt32(p, v, true); }

  // anonymous memory past the stack, as mmap gives it
  // the end of the heap is a word of the memory, so all threads move it
  map(len) {
    len = Math.ceil(len / 65536) * 65536;
    const again = this.freed.get(len);
    if (again && again.length) {
      const p = again.pop();
      this.u8().fill(0, p, p + len);
      return p;
    }
    const i32 = this.i32(), pages = len / 65536;
    let old;
    for (;;) {
      old = Atomics.load(i32, BRK_WORD);
      if (Atomics.compareExchange(i32, BRK_WORD, old, old + pages) === old) break;
    }
    const p = old * 65536, need = p + len;
    while (this.mem.buffer.byteLength < need) {
      const have = this.mem.buffer.byteLength;
      try { this.mem.grow(Math.ceil((need - have) / 65536)); }
      catch (e) { if (this.mem.buffer.byteLength < need) return -ENOMEM; }
    }
    return p;
  }

  unmap(p, len) {
    len = Math.ceil(len / 65536) * 65536;
    if (!this.freed.has(len)) this.freed.set(len, []);
    this.freed.get(len).push(p);
    return 0;
  }

  sleep(ms) {
    if (ms <= 0) return;
    if (this.shared) { Atomics.wait(this.shared.ctl, 4, 0, ms); return; }
    if (this.sleeper) { Atomics.wait(this.sleeper, 0, 0, ms); return; }
    const end = Date.now() + ms; while (Date.now() < end) { /* no way to wait */ }
  }

  now() { return (typeof performance !== 'undefined' ? performance.timeOrigin + performance.now() : Date.now()); }

  // ---- the system calls -------------------------------------------------
  syscall(nb, a, b, c, d, e, f) {
    const n = Number(nb);
    const A = Number(a), B = Number(b), C = Number(c), D = Number(d);
    let r;
    try {
      r = this.call(n, A, B, C, D, Number(e), Number(f), a);
    } catch (err) {
      if (err instanceof KronExit) throw err;
      if (typeof console !== "undefined" && this.debug) console.error("syscall " + n + ": " + err);
      r = -EINVAL;
    }
    return BigInt(r);
  }

  call(n, a, b, c, d, e, f, abig) {
    switch (n) {
      case 0: return this.read(a, b, c, -1);                     // read
      case 1: return this.write(a, b, c, -1);                    // write
      case 2: return this.open(this.cstr(a), b);                 // open
      case 257: return this.open(this.cstr(b), c);               // openat
      case 3: return this.close(a);                              // close
      case 4: case 6: return this.stat(this.cstr(a), b);         // stat, lstat
      case 5: return this.fstat(a, b);                           // fstat
      case 8: return this.lseek(a, abig === undefined ? b : b, c); // lseek
      case 9: return this.map(b);                                // mmap
      case 11: return this.unmap(a, b);                          // munmap
      case 12: return -ENOMEM;                                   // brk
      case 13: case 14: return 0;                                // signals
      case 16: return -ENOTTY;                                   // ioctl
      case 17: return this.read(a, b, c, d);                     // pread64
      case 18: return this.write(a, b, c, d);                    // pwrite64
      case 21: return this.exists(this.cstr(a)) ? 0 : -ENOENT;   // access
      case 24: return 0;                                         // sched_yield
      case 35: {                                                 // nanosleep
        const dv = this.dv();
        const s = Number(dv.getBigInt64(a, true)), ns = Number(dv.getBigInt64(a + 8, true));
        this.sleep(s * 1000 + Math.floor(ns / 1e6));
        return 0;
      }
      case 39: return 1;                                         // getpid
      case 186: return this.tid || 1;                            // gettid
      case 56: return this.clone(a, b, c, d);                    // clone: a thread
      case 57: case 58: case 59: return -ENOSYS;                 // fork vfork execve
      case 60: throw new KronExit(a | 0, !this.tid);             // exit: this thread
      case 231: throw new KronExit(a | 0, true);                 // exit_group: all
      case 61: return -ECHILD;                                   // wait4
      case 72: return 0;                                         // fcntl
      case 79: {                                                 // getcwd
        const cwd = this.encoder.encode((IS_NODE ? process.cwd() : this.fs.cwd) + '\0');
        if (cwd.length > b) return -34;
        this.u8().set(cwd, a);
        return cwd.length;
      }
      case 80: return this.chdir(this.cstr(a));                  // chdir
      case 82: return this.rename(this.cstr(a), this.cstr(b));   // rename
      case 83: return this.mkdir(this.cstr(a));                  // mkdir
      case 84: return this.rmdir(this.cstr(a));                  // rmdir
      case 87: return this.unlink(this.cstr(a));                 // unlink
      case 89: return -EINVAL;                                   // readlink
      case 90: return 0;                                         // chmod
      case 96: {                                                 // gettimeofday
        const t = this.now();
        this.put64(a, Math.floor(t / 1000)); this.put64(a + 8, Math.floor((t % 1000) * 1000));
        return 0;
      }
      case 97: this.put64(b, 0x800000); this.put64(b + 8, 0x800000); return 0; // getrlimit
      case 202: return this.futex(a, b, c, d);                   // futex
      case 204: if (b > 0) { this.u8().fill(0, c, c + b); this.u8()[c] = 1; } return 8; // affinity
      case 217: return this.getdents(a, b, c);                   // getdents64
      case 228: {                                                // clock_gettime
        let t;
        if (a === 1 || a === 4) t = (typeof performance !== 'undefined') ? performance.now() : Date.now();
        else t = this.now();
        const sec = Math.floor(t / 1000), ns = Math.floor((t - sec * 1000) * 1e6);
        this.put64(b, sec); this.put64(b + 8, ns);
        return 0;
      }
      case 318: {                                                // getrandom
        const buf = new Uint8Array(b);
        if (typeof crypto !== 'undefined' && crypto.getRandomValues) {
          for (let i = 0; i < b; i += 65536) crypto.getRandomValues(buf.subarray(i, Math.min(b, i + 65536)));
        } else for (let i = 0; i < b; i++) buf[i] = Math.random() * 256;
        this.u8().set(buf, a);
        return b;
      }
      // ---- the browser's own ----------------------------------------------
      case 1100: return 2;                                       // the system: the web
      case 1000: return this.hasWindow ? 1 : -ENOSYS;            // is there a window
      case 1001: return this.winOpen(a, b, c);                   // open: w, h, title
      case 1002: return this.winPresent(a, b, c);                // picture, w, h
      case 1003: return this.winEvent(a);                        // next event into a
      case 1005: return this.clipSet(a, b);                      // clipboard: set
      case 1006: return this.clipGet(a, b);                      // and get
      case 1007: return this.winClose();
      default: return -ENOSYS;
    }
  }

  // ---- threads ------------------------------------------------------------
  clone(flags, stack, ptid, ctid) {
    if (!this.sharedMem || !this.spawn) return -EAGAIN;
    const i32 = this.i32();
    const tid = Atomics.add(i32, TID_WORD, 1) + 1;
    if (flags & 0x100000) Atomics.store(i32, ptid >>> 2, tid);     // CLONE_PARENT_SETTID
    try {
      this.spawn({ module: this.module, memory: this.mem, stack, ctid, tid });
    } catch (e) {
      if (flags & 0x100000) Atomics.store(i32, ptid >>> 2, 0);
      return -EAGAIN;
    }
    return tid;
  }

  futex(addr, op, val, timeout) {
    op &= 127;
    if (!this.sharedMem) return op === 0 ? -EAGAIN : 0;
    const i32 = this.i32();
    if (op === 0) {
      let ms = Infinity;
      if (timeout) {
        const dv = this.dv();
        ms = Number(dv.getBigInt64(timeout, true)) * 1000 + Number(dv.getBigInt64(timeout + 8, true)) / 1e6;
      }
      const r = Atomics.wait(i32, addr >>> 2, val | 0, ms);
      return r === 'not-equal' ? -EAGAIN : (r === 'timed-out' ? -110 : 0);
    }
    if (op === 1) return Atomics.notify(i32, addr >>> 2, val);
    return -ENOSYS;
  }

  // ---- files --------------------------------------------------------------
  exists(path) {
    if (IS_NODE) return this.nodefs.existsSync(path);
    return this.fs.exists(path);
  }

  open(path, flags) {
    const acc = flags & 3, creat = flags & 0x40, trunc = flags & 0x200,
          append = flags & 0x400, excl = flags & 0x80, wantDir = flags & 0x10000;
    const fd = this.nextFd++;
    if (IS_NODE) {
      const fs = this.nodefs;
      try {
        const st = fs.existsSync(path) ? fs.statSync(path) : null;
        if (st && st.isDirectory()) {
          if (acc !== 0) return -EISDIR;
          this.fds.set(fd, { dir: fs.readdirSync(path, { withFileTypes: true }).map(x => [x.name, x.isDirectory() ? 4 : 8]), dpos: 0 });
          return fd;
        }
        if (wantDir) return st ? -ENOTDIR : -ENOENT;
        if (!st && !creat) return -ENOENT;
        if (st && creat && excl) return -EEXIST;
        let fl = acc === 0 ? 'r' : (acc === 1 ? 'w' : 'r+');
        if (acc !== 0 && !st) fl = acc === 1 ? 'w' : 'w+';
        else if (acc !== 0 && trunc) fl = acc === 1 ? 'w' : 'w+';
        else if (acc === 1 && st) fl = 'r+';
        const nfd = fs.openSync(path, fl);
        this.fds.set(fd, { nodefd: nfd, pos: 0, append: !!append });
        return fd;
      } catch (e) {
        return e.code === 'ENOENT' ? -ENOENT : (e.code === 'EACCES' ? -EACCES : -EINVAL);
      }
    }
    const m = this.fs;
    if (m.isDir(path)) {
      if (acc !== 0) return -EISDIR;
      this.fds.set(fd, { dir: m.list(path), dpos: 0 });
      return fd;
    }
    if (wantDir) return m.isFile(path) ? -ENOTDIR : -ENOENT;
    let data = m.read(path);
    if (!data) {
      if (!creat) return -ENOENT;
      data = new Uint8Array(0);
      const r = m.write(path, data);
      if (r < 0) return r;
    } else if (creat && excl) return -EEXIST;
    if (trunc && acc !== 0) { data = new Uint8Array(0); m.write(path, data); }
    this.fds.set(fd, { path: m.abs(path), pos: 0, append: !!append });
    return fd;
  }

  close(fd) {
    if (fd <= 2) return 0;
    const f = this.fds.get(fd);
    if (!f) return -EBADF;
    if (IS_NODE && f.nodefd !== undefined) this.nodefs.closeSync(f.nodefd);
    this.fds.delete(fd);
    return 0;
  }

  size(f) {
    if (IS_NODE) return this.nodefs.fstatSync(f.nodefd).size;
    return this.fs.read(f.path).length;
  }

  read(fd, p, n, at) {
    if (fd === 0) {
      if (IS_NODE) {
        const buf = Buffer.alloc(n);
        let got = 0;
        try { got = this.nodefs.readSync(0, buf, 0, n, null); } catch (e) { got = 0; }
        this.u8().set(buf.subarray(0, got), p);
        return got;
      }
      return 0;
    }
    const f = this.fds.get(fd);
    if (!f || f.dir) return -EBADF;
    const pos = at >= 0 ? at : f.pos;
    let got;
    if (IS_NODE) {
      const buf = Buffer.alloc(n);
      got = this.nodefs.readSync(f.nodefd, buf, 0, n, pos);
      this.u8().set(buf.subarray(0, got), p);
    } else {
      const data = this.fs.read(f.path) || new Uint8Array(0);
      const part = data.subarray(Math.min(pos, data.length), Math.min(pos + n, data.length));
      this.u8().set(part, p);
      got = part.length;
    }
    if (at < 0) f.pos = pos + got;
    return got;
  }

  write(fd, p, n, at) {
    const bytes = this.u8().slice(p, p + n);
    if (fd === 1 || fd === 2) { this.out(fd, bytes); return n; }
    const f = this.fds.get(fd);
    if (!f || f.dir) return -EBADF;
    let pos = at >= 0 ? at : (f.append ? this.size(f) : f.pos);
    if (IS_NODE) {
      this.nodefs.writeSync(f.nodefd, bytes, 0, n, pos);
    } else {
      const old = this.fs.read(f.path) || new Uint8Array(0);
      const len = Math.max(old.length, pos + n);
      const data = new Uint8Array(len);
      data.set(old);
      data.set(bytes, pos);
      this.fs.files.set(f.path, data);
    }
    if (at < 0) f.pos = pos + n;
    return n;
  }

  lseek(fd, off, whence) {
    const f = this.fds.get(fd);
    if (!f || f.dir) return -EBADF;
    let base = 0;
    if (whence === 1) base = f.pos;
    else if (whence === 2) base = this.size(f);
    const pos = base + off;
    if (pos < 0) return -EINVAL;
    f.pos = pos;
    return pos;
  }

  fillStat(p, isDir, size) {
    this.u8().fill(0, p, p + 144);
    const dv = this.dv();
    dv.setUint32(p + 24, isDir ? 0o40755 : 0o100644, true);
    dv.setBigInt64(p + 16, 1n, true);
    dv.setBigInt64(p + 48, BigInt(size), true);
    dv.setBigInt64(p + 56, 4096n, true);
    return 0;
  }
  stat(path, p) {
    if (IS_NODE) {
      try { const st = this.nodefs.statSync(path); return this.fillStat(p, st.isDirectory(), st.size); }
      catch (e) { return -ENOENT; }
    }
    if (this.fs.isDir(path)) return this.fillStat(p, true, 0);
    const d = this.fs.read(path);
    if (!d) return -ENOENT;
    return this.fillStat(p, false, d.length);
  }
  fstat(fd, p) {
    if (fd <= 2) return this.fillStat(p, false, 0);
    const f = this.fds.get(fd);
    if (!f) return -EBADF;
    if (f.dir) return this.fillStat(p, true, 0);
    return this.fillStat(p, false, this.size(f));
  }

  getdents(fd, p, cap) {
    const f = this.fds.get(fd);
    if (!f || !f.dir) return -EBADF;
    const m = this.u8(), dv = this.dv();
    let used = 0;
    const all = [['.', 4], ['..', 4], ...f.dir];
    while (f.dpos < all.length) {
      const [name, type] = all[f.dpos];
      const nb = this.encoder.encode(name);
      const reclen = (19 + nb.length + 1 + 7) & ~7;
      if (used + reclen > cap) break;
      const q = p + used;
      m.fill(0, q, q + reclen);
      dv.setBigUint64(q, BigInt(f.dpos + 1), true);
      dv.setBigInt64(q + 8, BigInt(f.dpos + 1), true);
      dv.setUint16(q + 16, reclen, true);
      m[q + 18] = type;
      m.set(nb, q + 19);
      used += reclen;
      f.dpos++;
    }
    return used;
  }

  chdir(path) {
    if (IS_NODE) { try { process.chdir(path); return 0; } catch (e) { return -ENOENT; } }
    if (!this.fs.isDir(path)) return -ENOENT;
    this.fs.cwd = this.fs.abs(path);
    return 0;
  }
  rename(a, b) {
    if (IS_NODE) { try { this.nodefs.renameSync(a, b); return 0; } catch (e) { return -ENOENT; } }
    return this.fs.rename(a, b);
  }
  mkdir(path) {
    if (IS_NODE) {
      try { this.nodefs.mkdirSync(path); return 0; }
      catch (e) { return e.code === 'EEXIST' ? -EEXIST : -ENOENT; }
    }
    return this.fs.mkdir(path);
  }
  rmdir(path) {
    if (IS_NODE) {
      try { this.nodefs.rmdirSync(path); return 0; }
      catch (e) { return e.code === 'ENOTEMPTY' ? -ENOTEMPTY : -ENOENT; }
    }
    return this.fs.rmdir(path);
  }
  unlink(path) {
    if (IS_NODE) { try { this.nodefs.unlinkSync(path); return 0; } catch (e) { return -ENOENT; } }
    return this.fs.unlink(path);
  }

  // ---- the window: the page's canvas ------------------------------------
  // The page draws: a worker that loops without returning to its event loop
  // never shows a canvas of its own, so each picture goes to the page as a
  // message, and while the page has not drawn the last one, the next waits.
  winOpen(w, h, title) {
    if (!this.hasWindow) return -ENOSYS;
    this.win = { w, h };
    if (this.shared) Atomics.store(this.shared.ctl, 5, 0);
    this.post({ kind: 'open', w, h, title: title ? this.cstr(title) : '' });
    return 1;
  }
  winPresent(fb, w, h) {
    if (!this.win) return 0;
    if (this.shared && Atomics.load(this.shared.ctl, 5) !== 0) return 1;   // a frame is waiting
    const src = new Uint32Array(this.mem.buffer, fb, w * h);
    const data = new Uint8ClampedArray(w * h * 4);
    const dst = new Uint32Array(data.buffer);
    // 0x00RRGGBB in memory; the canvas wants R, G, B, A bytes
    for (let i = 0; i < src.length; i++) {
      const v = src[i];
      dst[i] = 0xFF000000 | ((v & 0xFF) << 16) | (v & 0xFF00) | ((v >>> 16) & 0xFF);
    }
    if (this.shared) Atomics.store(this.shared.ctl, 5, 1);
    this.post({ kind: 'frame', w, h, data }, [data.buffer]);
    return 1;
  }
  winEvent(p) {
    if (!this.shared) return 0;
    const ctl = this.shared.ctl, ring = this.shared.ring;
    const head = Atomics.load(ctl, 0), tail = Atomics.load(ctl, 1);
    if (head === tail) return 0;
    const at = (head % RING_SLOTS) * RING_INTS;
    const dv = this.dv();
    for (let i = 0; i < 6; i++) dv.setBigInt64(p + i * 8, BigInt(ring[at + i]), true);
    Atomics.store(ctl, 0, head + 1);
    return 1;
  }
  clipSet(p, n) {
    const text = this.decoder.decode(this.u8().slice(p, p + n));
    if (this.post) this.post({ kind: 'clip', text });
    if (this.shared) {
      const bytes = this.encoder.encode(text).subarray(0, CLIP_BYTES);
      this.shared.clip.set(bytes);
      Atomics.store(this.shared.ctl, 3, bytes.length);
    }
    return n;
  }
  clipGet(p, cap) {
    if (!this.shared) return 0;
    const n = Math.min(Atomics.load(this.shared.ctl, 3), cap);
    this.u8().set(this.shared.clip.subarray(0, n), p);
    return n;
  }
  winClose() {
    if (this.post) this.post({ kind: 'close' });
    this.win = null;
    return 0;
  }
}

// =============================================================================
// node: run a module from the command line; its threads are worker threads
// =============================================================================
if (IS_NODE) {
  const fs = require('fs');
  const wt = require('worker_threads');
  const out = (fd, bytes) => { try { fs.writeSync(fd, bytes); } catch (e) { /* closed */ } };
  const spawn = (t) => {
    const w = new wt.Worker(__filename, { workerData: t });
    w.on('message', (m) => { if (m.kind === 'exit') process.exit(m.code); });
    w.on('error', (e) => { out(2, Buffer.from('kron_web: thread: ' + e + '\n')); process.exit(70); });
    w.unref();
  };
  if (!wt.isMainThread && wt.workerData && wt.workerData.module) {
    const t = wt.workerData;
    const k = new Kron({ out, spawn });
    k.tid = t.tid;
    k.attach(t.module, t.memory, true).then(() => {
      const r = k.runThread(t.stack, t.ctid);
      if (r.all) wt.parentPort.postMessage({ kind: 'exit', code: r.code });
    });
    return;
  }
  if (require.main === module) {
    const file = process.argv[2];
    if (!file) {
      process.stderr.write('usage: node kron_web.js program.wasm\n');
      process.exit(2);
    }
    const k = new Kron({ out, spawn, debug: !!process.env.KRON_WEB_DEBUG });
    k.load(fs.readFileSync(file)).then(() => {
      process.exit(k.run());
    }).catch(e => {
      process.stderr.write('kron_web: ' + (e && e.stack ? e.stack : e) + '\n');
      process.exit(70);
    });
  }
  if (typeof module !== 'undefined') module.exports = { Kron, KronExit };
  return;
}

// =============================================================================
// service worker: the two headers that make the page cross-origin isolated
// =============================================================================
if (IS_SERVICE) {
  self.addEventListener('install', () => self.skipWaiting());
  self.addEventListener('activate', e => e.waitUntil(self.clients.claim()));
  self.addEventListener('fetch', e => {
    const req = e.request;
    if (req.cache === 'only-if-cached' && req.mode !== 'same-origin') return;
    e.respondWith(fetch(req).then(res => {
      if (res.status === 0) return res;
      const h = new Headers(res.headers);
      h.set('Cross-Origin-Opener-Policy', 'same-origin');
      h.set('Cross-Origin-Embedder-Policy', 'require-corp');
      h.set('Cross-Origin-Resource-Policy', 'cross-origin');
      return new Response(res.body, { status: res.status, statusText: res.statusText, headers: h });
    }).catch(err => new Response(String(err), { status: 500 })));
  });
  return;
}

// =============================================================================
// worker: the program runs here, and each of its threads in a worker of its
// own; the page starts those, since this one may be blocked waiting
// =============================================================================
if (IS_WORKER) {
  const out = (fd, bytes) => self.postMessage({ kind: 'out', fd, text: new TextDecoder().decode(bytes) });
  const spawn = (t) => self.postMessage({ kind: 'thread', t });
  self.onmessage = async (msg) => {
    const m = msg.data;
    if (m.kind === 'thread') {
      const t = m.t;
      const k = new Kron({ out, spawn });
      k.tid = t.tid;
      try {
        await k.attach(t.module, t.memory, true);
        const r = k.runThread(t.stack, t.ctid);
        self.postMessage(r.all ? { kind: 'exit', code: r.code } : { kind: 'thread-end' });
      } catch (e) {
        self.postMessage({ kind: 'error', text: String(e && e.stack ? e.stack : e) });
      }
      return;
    }
    if (m.kind !== 'start') return;
    let shared = null;
    if (m.sab) {
      shared = {
        ctl: new Int32Array(m.sab, 0, CTL_INTS),
        ring: new Int32Array(m.sab, CTL_INTS * 4, RING_SLOTS * RING_INTS),
        clip: new Uint8Array(m.sab, (CTL_INTS + RING_SLOTS * RING_INTS) * 4, CLIP_BYTES)
      };
    }
    const k = new Kron({
      out, spawn,
      hasWindow: !!m.window,
      shared,
      post: (x, transfer) => self.postMessage(x, transfer || [])
    });
    try {
      const bytes = await (await fetch(m.wasm)).arrayBuffer();
      await k.load(bytes);
      const code = k.run();
      self.postMessage({ kind: 'exit', code });
    } catch (e) {
      self.postMessage({ kind: 'error', text: String(e && e.stack ? e.stack : e) });
    }
  };
  return;
}

// =============================================================================
// page: KronWeb.start({ wasm, canvas, console })
// =============================================================================
if (IS_PAGE) {
  const script = document.currentScript ? document.currentScript.src : 'kron_web.js';

  // keys as the program sees them: the same codes as on Windows and Linux
  function keyCode(e) {
    const k = e.key;
    const named = { Enter: 13, Escape: 27, Backspace: 8, Tab: 9, ArrowLeft: 37, ArrowUp: 38,
      ArrowRight: 39, ArrowDown: 40, Delete: 46, Home: 36, End: 35, PageUp: 33, PageDown: 34,
      ' ': 32, Shift: 16, Control: 17, Alt: 18 };
    if (named[k] !== undefined) return named[k];
    if (/^F([1-9]|1[0-2])$/.test(k)) return 111 + Number(k.slice(1));
    if (k.length === 1) {
      const c = k.toUpperCase().charCodeAt(0);
      if ((c >= 65 && c <= 90) || (c >= 48 && c <= 57)) return c;
    }
    return e.keyCode || 0;
  }

  async function isolate() {
    // shared memory needs the page cross-origin isolated; when the server
    // does not send the headers, a service worker (this same file) adds
    // them, once it controls the page: register, wait for it, reload once
    if (self.crossOriginIsolated) { sessionStorage.removeItem('kron_coi'); return; }
    if (!window.isSecureContext || !('serviceWorker' in navigator)) return;
    try {
      await navigator.serviceWorker.register(script);
      await navigator.serviceWorker.ready;
      if (sessionStorage.getItem('kron_coi')) return;      // reloaded once: no
      sessionStorage.setItem('kron_coi', '1');
      location.reload();
      await new Promise(() => {});
    } catch (e) { /* no service worker: run without */ }
  }

  window.KronWeb = {
    async start(opts) {
      await isolate();
      const canvas = typeof opts.canvas === 'string' ? document.querySelector(opts.canvas) : opts.canvas;
      const con = typeof opts.console === 'string' ? document.querySelector(opts.console) : opts.console;
      const say = (t) => { if (con) { con.textContent += t; con.scrollTop = con.scrollHeight; } else console.log(t); };
      if (!self.crossOriginIsolated) {
        say('(this page is not cross-origin isolated: the program runs, but it cannot wait,\n' +
            ' and a window gets no keyboard or mouse. Serve it with kron_serve, or any server\n' +
            ' that sends Cross-Origin-Opener-Policy and Cross-Origin-Embedder-Policy.)\n');
      }
      const worker = new Worker(script);
      let sab = null, ctl = null, ring = null, clip = null;
      if (self.crossOriginIsolated) {
        sab = new SharedArrayBuffer((CTL_INTS + RING_SLOTS * RING_INTS) * 4 + CLIP_BYTES);
        ctl = new Int32Array(sab, 0, CTL_INTS);
        ring = new Int32Array(sab, CTL_INTS * 4, RING_SLOTS * RING_INTS);
        clip = new Uint8Array(sab, (CTL_INTS + RING_SLOTS * RING_INTS) * 4, CLIP_BYTES);
      }
      const send = (type, a = 0, b = 0, c = 0, d = 0, e = 0) => {
        if (!ctl) return;
        const head = Atomics.load(ctl, 0), tail = Atomics.load(ctl, 1);
        if (tail - head >= RING_SLOTS) return;
        const at = (tail % RING_SLOTS) * RING_INTS;
        ring[at] = type; ring[at + 1] = a; ring[at + 2] = b; ring[at + 3] = c; ring[at + 4] = d; ring[at + 5] = e;
        Atomics.store(ctl, 1, tail + 1);
        Atomics.notify(ctl, 2);
      };
      const mods = (e) => (e.shiftKey ? 1 : 0) | (e.ctrlKey || e.metaKey ? 4 : 0) | (e.altKey ? 8 : 0);
      let ctx = null;
      if (canvas) {
        canvas.tabIndex = 0;
        ctx = canvas.getContext('2d');
        const pos = (e) => {
          const r = canvas.getBoundingClientRect();
          return [Math.floor((e.clientX - r.left) * canvas.width / r.width),
                  Math.floor((e.clientY - r.top) * canvas.height / r.height)];
        };
        canvas.addEventListener('mousemove', e => { const [x, y] = pos(e); send(EV_MOVE, x, y, mods(e)); });
        canvas.addEventListener('mousedown', e => { canvas.focus(); const [x, y] = pos(e); send(EV_DOWN, e.button, x, y, mods(e)); e.preventDefault(); });
        window.addEventListener('mouseup', e => { const [x, y] = pos(e); send(EV_UP, e.button, x, y, mods(e)); });
        canvas.addEventListener('contextmenu', e => e.preventDefault());
        canvas.addEventListener('wheel', e => { send(EV_WHEEL, e.deltaY < 0 ? 1 : -1, mods(e)); e.preventDefault(); }, { passive: false });
        let pastePending = null;
        canvas.addEventListener('keydown', e => {
          const code = keyCode(e), m = mods(e);
          if ((e.ctrlKey || e.metaKey) && code === 86) {
            // ctrl+v: the text first, through the paste event, then the key
            pastePending = setTimeout(() => { pastePending = null; send(EV_KEY_DOWN, code, m); }, 120);
            return;
          }
          send(EV_KEY_DOWN, code, m);
          if (e.key.length === 1 && !e.ctrlKey && !e.metaKey) {
            const cp = e.key.codePointAt(0);
            if (cp < 256) send(EV_CHAR, cp, m);
          }
          if (!(e.ctrlKey && (code === 67 || code === 88))) e.preventDefault();
        });
        canvas.addEventListener('keyup', e => send(EV_KEY_UP, keyCode(e), mods(e)));
        canvas.addEventListener('paste', e => {
          const t = (e.clipboardData && e.clipboardData.getData('text')) || '';
          if (clip) {
            const bytes = new TextEncoder().encode(t).subarray(0, CLIP_BYTES);
            clip.set(bytes);
            Atomics.store(ctl, 3, bytes.length);
          }
          if (pastePending) { clearTimeout(pastePending); pastePending = null; send(EV_KEY_DOWN, 86, 4); }
          e.preventDefault();
        });
        canvas.focus();
      }
      const threads = new Set();
      let ended = false;
      const onmsg = (msg) => {
        const m = msg.data;
        if (m.kind === 'thread') {
          // a thread of the program: a worker of its own, started from here
          if (ended) return;
          const tw = new Worker(script);
          threads.add(tw);
          tw.onmessage = (x) => {
            if (x.data.kind === 'thread-end') { threads.delete(tw); tw.terminate(); }
            else onmsg(x);
          };
          tw.postMessage({ kind: 'thread', t: m.t });
          return;
        }
        if (m.kind === 'exit' || m.kind === 'error') {
          ended = true;
          for (const tw of threads) tw.terminate();
          threads.clear();
        }
        if (m.kind === 'out') say(m.text);
        else if (m.kind === 'open') {
          if (m.title) document.title = m.title;
          if (canvas) { canvas.width = m.w; canvas.height = m.h; canvas.style.display = 'block'; canvas.focus(); }
        }
        else if (m.kind === 'frame') {
          if (ctx) ctx.putImageData(new ImageData(m.data, m.w, m.h), 0, 0);
          if (ctl) Atomics.store(ctl, 5, 0);
        }
        else if (m.kind === 'close') { if (canvas) canvas.style.display = 'none'; }
        else if (m.kind === 'clip') { if (navigator.clipboard) navigator.clipboard.writeText(m.text).catch(() => {}); }
        else if (m.kind === 'exit') { if (m.code) say('\n(the program ended with ' + m.code + ')\n'); if (opts.onexit) opts.onexit(m.code); }
        else if (m.kind === 'error') say('\n' + m.text + '\n');
      };
      worker.onmessage = onmsg;
      window.addEventListener('beforeunload', () => send(EV_CLOSE));
      const wasm = new URL(opts.wasm, location.href).href;
      worker.postMessage({ kind: 'start', wasm, sab, window: !!canvas });
      return worker;
    }
  };
}

})();
