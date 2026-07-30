format PE64 Console 6.0
entry start
include "mainmacros.s"

section ".text" code readable executable

test_fn:

    push rbp
    mov rbp, rsp
    ITR_LOOP_PRINTS 1
    pop rbp
    ret

start:

    push rbp

    GET_STD_HANDLE -11
    GET_STD_HANDLE -10
    
    mov edx, 5

.loopstrt:

    call test_fn
    dec edx
    test edx, edx
    jnz .loopstrt

exit:

    pop rbp
    xor eax, eax
    ret

section ".bss" data readable writeable

hStdout:        rq 1
hStdin:         rq 1
nCharsWritten:  rd 1
charBuf:        rb 128

