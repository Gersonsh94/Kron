; ============================================================================
; kron_all.asm - the whole compiler as one translation unit.
;
; The fourteen modules are normally assembled separately and joined by a linker.
; Splicing them here instead lets the compiler build itself with nothing but
; its own tools:
;
;   kronc.exe kron_all.asm --assemble --pe
;
; Every module includes the same headers, so the constants and the macros
; arrive fourteen times over; the preprocessor keeps the first of each and skips
; the rest.
;
; Adjust the paths below if your layout differs.
; ============================================================================

%include "main.asm"
%include "lexer/lexer.asm"
%include "parser/parser.asm"
%include "semantic/semantic.asm"
%include "codegen/codegen.asm"
%include "runtime/runtime.asm"
%include "linker/linker.asm"
%include "kasm.asm"
%include "krn.asm"
%include "karm.asm"
%include "xarm.asm"
%include "xwasm.asm"
%include "macho.asm"
%include "pe_writer.asm"
