%include 'stdio32.asm'

section .data
    format  db BRIGHT_YELLOW,'string: %s, decimal: %d hex: %x char: %c, 100%%',RESET,endl
    args    db 'Koushik',0

section .text
    global _start

_start:
    push 'f'
    push 0xa5
    push -30
    push args
    push format
    call _printf
    add esp,20

done:
    mov eax, 1
    xor ebx, ebx
    int 0x80