format PE64 Console 6.0
entry start
include "mainmacros.inc"

section ".text" code readable executable

macro ITR_LOOP_PRINTS n {
    local lp, lp2

    push r15
    mov r15, n

    lp:
    push rbp

    GET_RSP_STR charBuf
    PRINT_BUF hStdout, charBuf, nCharsWritten
    CLEAR_BUF charBuf, nCharsWritten

    dec r15
    test r15, r15
    jnz lp

    mov r15, n

    lp2:
    pop rbp
    dec r15
    test r15, r15
    jnz lp2

    pop r15
}

start:
    push rbp
    mov rbp, rsp
    sub rsp, 48

    GET_STD_HANDLE -11
    GET_STD_HANDLE -10

    ITR_LOOP_PRINTS 10
exit:
    add rsp, 48
    pop rbp
    sub rsp, 8
    invoke ExitProcess, 0

section ".bss" data readable writeable

hStdout:        rq 1
hStdin:         rq 1
nCharsWritten:  rd 1
charBuf:        rb 128
bufLen:         rb 1

section ".idata" import data readable writeable

library kernel32, "kernel32.dll"
import  kernel32, ExitProcess, "ExitProcess",\
                  GetStdHandle, "GetStdHandle",\
                  WriteConsoleA, "WriteConsoleA",\
                  ReadConsoleA, "ReadConsoleA",\
                  Sleep, "Sleep"
