# KRN — Kron eXecutable Format

**Version 1.0**

KRN is the native executable format for Kron systems. It is not a variant of
PE or ELF: it is designed around what a Kron system needs to know before it
runs a program — which privilege ring it belongs in, which TITAN modules it
requires, which capabilities it claims — and it carries a signature so the
loader can reject anything it was not meant to run.

All integers are little-endian. All offsets are from the start of the file.

---

## 1. FILE LAYOUT

```
+--------------------------------------+  0x000
|  HEADER                    128 bytes |
+--------------------------------------+  0x080
|  SECTION TABLE      32 bytes each    |
+--------------------------------------+
|  REQUIREMENT TABLE  32 bytes each    |
+--------------------------------------+
|  EXPORT TABLE       24 bytes each    |
+--------------------------------------+
|  STRING POOL        variable         |
+--------------------------------------+
|  SECTION DATA       variable         |
+--------------------------------------+
|  SIGNATURE BLOCK    variable         |  ends the file
+--------------------------------------+
```

---

## 2. HEADER (128 bytes)

| Offset | Size | Field | Description |
|---:|---:|---|---|
| 0x00 | 4 | `magic` | `4B 52 4E 21` — `KRN!` |
| 0x04 | 2 | `format_version` | 1 |
| 0x06 | 2 | `header_size` | 128 |
| 0x08 | 2 | `architecture` | see §2.1 |
| 0x0A | 2 | `file_kind` | see §2.2 |
| 0x0C | 2 | `ring` | privilege ring the program runs in, §2.3 |
| 0x0E | 2 | `flags` | see §2.4 |
| 0x10 | 8 | `entry_point` | virtual address of the first instruction |
| 0x18 | 8 | `image_base` | preferred load address |
| 0x20 | 8 | `image_size` | total bytes to reserve when loaded |
| 0x28 | 8 | `stack_size` | initial stack reservation |
| 0x30 | 8 | `heap_size` | initial heap reservation, 0 = none |
| 0x38 | 4 | `section_count` | number of section entries |
| 0x3C | 4 | `section_offset` | file offset of the section table |
| 0x40 | 4 | `requirement_count` | number of requirement entries |
| 0x44 | 4 | `requirement_offset` | file offset of the requirement table |
| 0x48 | 4 | `export_count` | number of export entries |
| 0x4C | 4 | `export_offset` | file offset of the export table |
| 0x50 | 4 | `string_pool_offset` | file offset of the string pool |
| 0x54 | 4 | `string_pool_size` | bytes in the string pool |
| 0x58 | 4 | `signature_offset` | file offset of the signature block, 0 = unsigned |
| 0x5C | 4 | `signature_size` | bytes in the signature block |
| 0x60 | 8 | `build_epoch` | build timestamp, seconds since 2000-01-01 UTC |
| 0x68 | 8 | `capabilities` | capability bitmask, §2.5 |
| 0x70 | 16 | `reserved` | zero |

### 2.1 architecture

| Value | Meaning |
|---:|---|
| 0x0001 | x86-64 |
| 0x0002 | ARM64 |
| 0x0003 | RISC-V 64 |
| 0x0004 | Kron ISA (as defined by an M01 module) |

### 2.2 file_kind

| Value | Meaning |
|---:|---|
| 0x0001 | kernel — loaded by a bootloader, owns the machine |
| 0x0002 | driver — runs in a privileged ring, talks to hardware |
| 0x0003 | application — runs under a Kron kernel |
| 0x0004 | library — provides symbols to other KRN files |
| 0x0005 | module — a TITAN module implementation |

### 2.3 ring

Mirrors the `securityRingContext` of the grammar.

| Value | Meaning |
|---:|---|
| 0 | hardware_ring0_supervisor |
| 1 | hardware_ring1_hypervisor |
| 2 | hardware_ring2_device_drivers |
| 3 | hardware_ring3_application |
| 4 | silicon_secure_enclave |
| 5 | virtualized_isolated_jail |

### 2.4 flags

| Bit | Meaning |
|---:|---|
| 0 | position independent |
| 1 | contains relocations |
| 2 | requires a memory management unit |
| 3 | requires floating point |
| 4 | signature is mandatory — refuse to load unsigned |
| 5 | debug information present |

### 2.5 capabilities

What the program claims it needs. A loader may refuse a program that asks for
more than the caller is allowed to grant.

| Bit | Capability |
|---:|---|
| 0 | raw I/O port access |
| 1 | physical memory mapping |
| 2 | interrupt handler installation |
| 3 | DMA programming |
| 4 | filesystem access |
| 5 | network access |
| 6 | process creation |
| 7 | direct display access |
| 8 | timer programming |
| 9 | power state control |

---

## 3. SECTION TABLE (32 bytes per entry)

| Offset | Size | Field | Description |
|---:|---:|---|---|
| 0x00 | 4 | `name_offset` | index into the string pool |
| 0x04 | 4 | `kind` | see below |
| 0x08 | 8 | `virtual_address` | where it lands once loaded |
| 0x10 | 4 | `file_offset` | where its bytes live in the file, 0 if none |
| 0x14 | 4 | `file_size` | bytes present in the file |
| 0x18 | 4 | `memory_size` | bytes to reserve; larger than `file_size` means zero-fill |
| 0x1C | 4 | `attributes` | read/write/execute bits |

**kind**

| Value | Meaning |
|---:|---|
| 1 | code |
| 2 | initialised data |
| 3 | zero-filled data |
| 4 | read-only data |
| 5 | TITAN module tables |

**attributes** — bit 0 read, bit 1 write, bit 2 execute, bit 3 cache-disabled.

---

## 4. REQUIREMENT TABLE (32 bytes per entry)

Declares what the program needs from the system before it can run. A loader
checks these first and refuses cleanly rather than faulting later.

| Offset | Size | Field | Description |
|---:|---:|---|---|
| 0x00 | 4 | `name_offset` | index into the string pool |
| 0x04 | 2 | `kind` | see below |
| 0x06 | 2 | `min_version` | minimum acceptable version |
| 0x08 | 8 | `parameter` | meaning depends on `kind` |
| 0x10 | 16 | `reserved` | zero |

**kind**

| Value | Meaning | `parameter` |
|---:|---|---|
| 1 | TITAN module | module number 1–31 |
| 2 | KRN library | 0 |
| 3 | minimum memory | bytes |
| 4 | CPU feature | feature bitmask |
| 5 | device class | device identifier |

This is the field PE and ELF have no equivalent for: a program can state that
it needs, say, M04 Hardware Interrupts and M09 Syscall Table, and the loader
verifies both are present before a single instruction runs.

---

## 5. EXPORT TABLE (24 bytes per entry)

| Offset | Size | Field | Description |
|---:|---:|---|---|
| 0x00 | 4 | `name_offset` | index into the string pool |
| 0x04 | 4 | `ordinal` | stable numeric identifier |
| 0x08 | 8 | `address` | virtual address of the symbol |
| 0x10 | 2 | `kind` | 1 function, 2 data, 3 TITAN table |
| 0x12 | 6 | `reserved` | zero |

Populated from functions marked `global_visible` or `inter_cluster_export`.

---

## 6. STRING POOL

Zero-terminated UTF-8 strings, packed end to end. Offset 0 is always a single
zero byte, so a `name_offset` of 0 means "no name".

---

## 7. SIGNATURE BLOCK

Placed last so everything before it can be hashed in one pass.

| Offset | Size | Field | Description |
|---:|---:|---|---|
| 0x00 | 4 | `sig_magic` | `4A 53 49 47` — `JSIG` |
| 0x04 | 2 | `algorithm` | see below |
| 0x06 | 2 | `key_id_size` | bytes of key identifier |
| 0x08 | 4 | `digest_size` | bytes of digest |
| 0x0C | 4 | `signature_size` | bytes of signature |
| 0x10 | 8 | `signed_length` | how many bytes from offset 0 were signed |
| 0x18 | — | `key_id` | which key signed this |
| — | — | `digest` | hash of the first `signed_length` bytes |
| — | — | `signature` | the signature over the digest |

**algorithm**

| Value | Meaning |
|---:|---|
| 1 | none — digest only, integrity without authenticity |
| 2 | ed25519 |
| 3 | lattice-based post-quantum signature |
| 4 | enclave attestation |

### Verification order

1. Read the header and confirm `magic`.
2. If `flags` bit 4 is set and `signature_offset` is 0, refuse.
3. Hash bytes `0` through `signed_length`, which excludes the signature block.
4. Compare against `digest`; mismatch means the file was altered.
5. Verify `signature` over the digest with the key named by `key_id`.
6. Only then check requirements and map sections.

A program is never mapped into memory before its signature is checked.

---

## 8. MINIMAL FILE

The smallest valid KRN is a header plus one code section: 128 bytes of header,
32 of section table, 1 of string pool, and the code itself. Unsigned, with
`signature_offset` at 0.

## 9. WHY NOT REUSE AN EXISTING FORMAT

PE and ELF both predate the problems this format is meant to solve. Neither can
express "this program needs M04 and M09", neither carries a privilege ring in
the header, and both treat signing as an afterthought bolted on by the operating
system rather than part of the file's structure.

KRN is also free to stay small: no legacy DOS stub, no section alignment rules
inherited from decades-old linkers, no duplicated tables kept for compatibility
with tools that no longer exist.
