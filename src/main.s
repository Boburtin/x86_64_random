format PE64 Console 6.0
entry start
include "mainmacros.inc"

section ".text" code readable executable
convert_to_str:
    GET_RSP_STR charBuf
    PRINT_BUF hStdout, charBuf, nCharsWritten
ret

start:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    GET_STD_HANDLE -11
    GET_STD_HANDLE -10
    call convert_to_str
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
