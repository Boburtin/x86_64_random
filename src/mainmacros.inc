include "../inc/WIN64A.INC"

macro DEC_STACK_ADDR n {
    local lp

    push r15
    mov r15, n
    lp:
    push rbp
    dec r15
    test r15, r15
    jnz lp
    pop r15
}

macro INC_STACK_ADDR n {
    local lp

    push r15
    mov r15, n
    lp:
    pop rbp
    dec r15
    test r15, r15
    jnz lp

    pop r15
}

macro GET_STD_HANDLE op_code {
    local hptr

    if op_code = -10
        hptr = hStdin
    else if op_code = -11
        hptr = hStdout
    end if

    if hptr
        invoke GetStdHandle, op_code
        mov [hptr], rax
    end if
}

macro GET_RSP_STR b {
    local loop_start

; save registers the macro uses

    push rbp rax rdi rdx

; load pointer to end of buffer

    lea rdi, [b + 127]  ; move ptr to b[len - 1]
    mov byte [rdi], 0x0 ; null char
    dec rdi             ; move ptr to b[126]
    mov byte [rdi], 0xA ; lf char
    dec rdi             ; move ptr to b[125]

    mov r14, 10         ; load the divisor immediate into reg

    mov rbp, rsp        ; set up stack frame
    mov rax, rsp        ; set up rax with the address of the stack ptr

    loop_start:         ; begin write loop from right to left

    xor rdx, rdx        ; clear upper 64 of the 128 of rdx:rax for div
    div r14
    or rdx, 0x30        ; convert integer to ASCII code
    dec rdi
    mov [rdi], dl       ; lower byte of dx (16-bit slice of rdx)

    test rax, rax       ; if ZF then done

    jnz loop_start

; restore registers

    pop rdx rdi rax rbp
}

macro CLEAR_BUF b, n {
    push rax rdi rcx

    std
    lea rdi, [b + 127]
    xor al, al
    mov rcx, [n]
    rep stosb
    cld

    mov dword [n], 0

    pop rcx rdi rax
}

macro PRINT_BUF a, b, d {
    push rcx rdx r8 r9 r12

    mov r12, rsp
    and r12, 8
    sub rsp, 32         ; Windows calling convention shadow space
    sub rsp, r12

    mov rcx, [a]
    mov rdx, b
    lea r8, [b + 127]
    sub r8, rdx
    lea r9, [d]
    mov qword [rsp + 32], 0
    call [WriteConsoleA]

    add rsp, 32
    add rsp, r12
    pop r12 r9 r8 rdx rcx
}

