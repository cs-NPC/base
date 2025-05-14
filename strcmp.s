%include 'stdio32.asm'

section .data
    my_string db 'This is a simple example of main string',0
    sstr      db 'substring',0

    success   db GREEN,'Sub-string is found at offset %d of the main string',endl
    failed    db RED,'Sub-string is not found',RESET,endl

section .bss
    var_offs resd 1

section .text
global _start

_start:
    push sstr
    push my_string
    call strcmp
    add esp,8

    mov eax,1
    mov ebx,0
    int 0x80

strcmp:
    push ebp
    mov ebp,esp
    push eax
    push ebx
    push ecx
    push edx

    mov esi,[ebp+8]  ;main string
    mov edi,[ebp+12] ;substring
    mov ecx,0

.search:
    mov al,[esi]
    mov bl,[edi]

    cmp bl,0
    je .found
    cmp al,0
    je .not_found
    cmp al,bl
    je .match

    inc esi
    inc ecx
    jmp .search

.match:
    inc esi
    inc edi
    jmp .search

.found:
    mov dword[var_offs],ecx
    
    push var_offs
    push success
    call _printf
    add esp,8

    jmp .done

.not_found:
    push failed
    call _printf
    add esp,4
    jmp .done

.done:
    pop edx
    pop ecx
    pop ebx
    pop eax

    mov esp,ebp
    pop ebp
    ret  
