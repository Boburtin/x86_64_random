format PE64 Console 6.0
entry start
include "mainmacros.s"

section ".text" code readable executable

start:
    push rbp

    GET_STD_HANDLE -11
    GET_STD_HANDLE -10

    ITR_LOOP_PRINTS 10
exit:
    pop rbp
    EXIT_CALL 0

section ".bss" data readable writeable

hStdout:        rq 1
hStdin:         rq 1
nCharsWritten:  rd 1
charBuf:        rb 128
bufLen:         rb 1


