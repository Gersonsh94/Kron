; ==============================================================================
; KRON COMPILER - WINDOWS API MACROS
; The Windows API calls that stand in for the Linux system calls
; Convention: Windows x64 - shadow space 32 bytes, rcx/rdx/r8/r9
; ==============================================================================

; What is imported from kernel32.dll
extern GetStdHandle
extern WriteFile
extern ReadFile
extern ExitProcess
extern CreateFileA
extern CloseHandle
extern GetFileSize
extern SetFilePointer
extern HeapAlloc
extern HeapFree
extern GetProcessHeap
extern GetCommandLineA

; STD handles
%define STD_INPUT_HANDLE    -10
%define STD_OUTPUT_HANDLE   -11
%define STD_ERROR_HANDLE    -12

; Flags CreateFile
%define GENERIC_READ        0x80000000
%define GENERIC_WRITE       0x40000000
%define OPEN_EXISTING       3
%define CREATE_ALWAYS       2
%define FILE_SHARE_READ     1
%define FILE_ATTRIBUTE_NORMAL 0x80
%define INVALID_HANDLE      -1

; Heap flags
%define HEAP_ZERO_MEMORY    0x08

; ==============================================================================
; MACRO: win_write_stdout  text, length
; Writes to stdout with WriteFile (Windows)
; ==============================================================================
%macro win_write_stdout 2
    sub  rsp, 40            ; shadow space (32) + alignment (8)
    mov  rcx, STD_OUTPUT_HANDLE
    call GetStdHandle
    mov  rcx, rax           ; handle stdout
    mov  rdx, %1            ; pointer to the text
    mov  r8,  %2            ; length
    lea  r9,  [rsp+32]      ; bytes written (scratch on the stack)
    mov  qword [rsp+32], 0
    push 0                  ; lpOverlapped = NULL
    call WriteFile
    add  rsp, 48
%endmacro

; ==============================================================================
; MACRO: win_exit  code
; Ends the process
; ==============================================================================
%macro win_exit 1
    sub  rsp, 32
    mov  rcx, %1
    call ExitProcess
%endmacro

; ==============================================================================
; MACRO: win_alloc  size -> rax
; Allocates memory on the process heap
; ==============================================================================
%macro win_alloc 1
    sub  rsp, 32
    call GetProcessHeap
    add  rsp, 32
    sub  rsp, 32
    mov  rcx, rax
    mov  rdx, HEAP_ZERO_MEMORY
    mov  r8,  %1
    call HeapAlloc
    add  rsp, 32
%endmacro

; ==============================================================================
; MACRO: win_free  handle_heap, ptr
; Frees heap memory
; ==============================================================================
%macro win_free 2
    sub  rsp, 32
    call GetProcessHeap
    add  rsp, 32
    sub  rsp, 32
    mov  rcx, rax
    xor  rdx, rdx
    mov  r8,  %2
    call HeapFree
    add  rsp, 32
%endmacro

; ==============================================================================
; MACRO: win_strlen  ptr -> rax
; Length of a zero-terminated text
; ==============================================================================
%macro win_strlen 1
    mov  rdi, %1
    xor  rcx, rcx
    not  rcx
    xor  al, al
    repne scasb
    not  rcx
    dec  rcx
    mov  rax, rcx
%endmacro

; ==============================================================================
; MACRO: shadow_call  (reserves the shadow space of a WinAPI call)
; ==============================================================================
%macro shadow_call 0
    sub rsp, 32
%endmacro

%macro shadow_end 0
    add rsp, 32
%endmacro
