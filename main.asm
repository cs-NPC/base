%include 'stdio32.asm'

section .data
    format:
        db BRIGHT_YELLOW,'string: %s, decimal: %d hex: %x char: %c, 100%%',RESET,endl
    args:
        db 'test string',0
        dd -30
        dd 0xa0050    
        db 'f'

section .text
    global _start

_start:
    push args
    push format
    call _printf
    add esp,8

    mov eax, 1
    xor ebx, ebx
    int 0x80
