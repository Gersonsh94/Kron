; ============================================================================
; kron_all.asm - the whole compiler as one translation unit, which its own
; kasm assembles and its own pe_writer writes out:
;
;   kronc.exe kron_all.asm --assemble --pe
;
; The NAME_kr.asm files are not written by hand and are not kept in the
; repository: kronc --module makes each from NAME.kr, the parts of the
; compiler written in Kron. BUILD.bat and BOOTSTRAP.bat make them first with
; the compiler they start from, then again with every compiler they build
; (KRONPARTS.bat).
;
; Every module includes the same headers, so the constants and the macros
; arrive once per module; the preprocessor keeps the first of each and skips
; the rest. A label, though, may be defined only once in the whole: kasm
; reports a second one.
; ============================================================================

%include "main.asm"
%include "lexer/lexer_kr.asm"
%include "parser/parser_kr.asm"
%include "semantic/semantic_kr.asm"
%include "codegen/codegen_kr.asm"
%include "kasm_kr.asm"
%include "imports_kr.asm"
%include "krn_writer_kr.asm"
%include "karm_core_kr.asm"
%include "karm_alu_kr.asm"
%include "karm_mem_kr.asm"
%include "xarm_kr.asm"
%include "xarm_tails_kr.asm"
%include "xwasm_kr.asm"
%include "macho_writer_kr.asm"
%include "pe_writer_kr.asm"
%include "elf_writer_kr.asm"
%include "web_writer_kr.asm"
%include "main_pp_kr.asm"
%include "main_io_kr.asm"
%include "main_cli_kr.asm"
%include "main_drv_kr.asm"
%include "main_out_kr.asm"
