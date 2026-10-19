; ============================================================================
; kron_all.asm - the whole compiler as one translation unit, which its own
; kasm assembles and its own pe_writer writes out:
;
;   kronc.exe kron_all.asm --assemble --pe
;
; lexer/lexer_kr.asm, parser/parser_kr.asm, semantic/semantic_kr.asm and
; codegen/codegen_kr.asm are not written by hand: kronc --module makes them
; from lexer/lexer.kr, parser/parser.kr, semantic/semantic.kr and
; codegen/codegen.kr, the parts of the compiler written in Kron. BUILD.bat
; and BOOTSTRAP.bat make them again with every compiler they build
; (KRONPARTS.bat).
;
; Every module includes the same headers, so the constants and the macros
; arrive once per module; the preprocessor keeps the first of each and skips
; the rest. A label, though, may be defined only once in the whole: kasm
; reports a second one.
; ============================================================================

%include "main.asm"
%include "lexer/lexer.asm"
%include "lexer/lexer_kr.asm"
%include "parser/parser.asm"
%include "parser/parser_kr.asm"
%include "semantic/semantic.asm"
%include "semantic/semantic_kr.asm"
%include "codegen/codegen.asm"
%include "codegen/codegen_kr.asm"
%include "runtime/runtime.asm"
%include "linker/linker.asm"
%include "kasm.asm"
%include "krn.asm"
%include "karm.asm"
%include "xarm.asm"
%include "xwasm.asm"
%include "macho.asm"
%include "pe_writer.asm"
