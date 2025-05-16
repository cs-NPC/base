%define endl            0x0A, 0

%define RESET           0x1B, "[0m"
%define BLACK           0x1B, "[30m"
%define RED             0x1B, "[31m"
%define GREEN           0x1B, "[32m"
%define YELLOW          0x1B, "[33m"
%define BLUE            0x1B, "[34m"
%define MAGENTA         0x1B, "[35m"
%define CYAN            0x1B, "[36m"
%define WHITE           0x1B, "[37m"

%define BRIGHT_BLACK    0x1B, "[90m"
%define BRIGHT_RED      0x1B, "[91m"
%define BRIGHT_GREEN    0x1B, "[92m"
%define BRIGHT_YELLOW   0x1B, "[93m"
%define BRIGHT_BLUE     0x1B, "[94m"
%define BRIGHT_MAGENTA  0x1B, "[95m"
%define BRIGHT_CYAN     0x1B, "[96m"
%define BRIGHT_WHITE    0x1B, "[97m"

section .bss
    x_buffer     resb 12
    d_buffer     resb 12
    c_buffer     resb 1

section .text
global _printf

_printf:
    push ebp
    mov ebp, esp

    push eax
    push ebx
    push ecx
    push edx

    mov esi,[ebp+8]    ; format
    mov edi,0          ; args[byte %s,%c dword %x,%d]

._init:
    mov al, [esi]
    test al, al
    jz .done
    cmp al,'%'
    je ._format
    mov byte [c_buffer], al
    lea ecx, [c_buffer]
    mov edx, 1
    call ._write
    inc esi
    jmp ._init

._format:
    inc esi
    mov al, [esi]

    cmp al, 'd'
    je .d_args
    cmp al, 'x'
    je .x_args
    cmp al, 'c'
    je .c_args
    cmp al, 's'
    je .s_args

    mov byte[ecx],al
    mov edx,1
    call ._write
    inc esi
    jmp ._init

.c_args:
    mov al,[ebp+edi*4+12]
    mov byte [c_buffer], al
    mov ecx, c_buffer
    mov edx,1
    call ._write
    inc edi
    inc esi
    jmp ._init

.s_args:
    inc esi
    mov ebx,[ebp+edi*4+12]
    mov edx,0

._str_tt:
    mov al,[ebx]
    test al,al
    jz .f_sync
    mov byte[c_buffer],al
    lea ecx,[c_buffer]
    mov edx,1
    call ._write
    inc ebx
    jmp ._str_tt

.f_sync:
    inc edi
    jmp ._init

.x_args:
    mov ebx,[ebp+edi*4+12]
    mov ecx,x_buffer+10
    mov edx,8

._ini_x:
    mov eax,ebx
    and eax,0xf
    add al,'0'  
    cmp al,'9'
    jle ._sto_buff
    add al,7

._sto_buff:
    mov byte[ecx],al
    dec ecx
    dec edx
    shr ebx,4
    test edx,edx
    jnz ._ini_x
    mov byte[ecx],'x'
    dec ecx
    mov byte[ecx],'0'

._h_out:
    mov edx,x_buffer+11
    sub edx,ecx
    call ._write
    pop eax
    inc esi
    add edi,1
    jmp ._init

.d_args:
    mov eax,[ebp+edi*4+12]
    mov ecx,10
    mov byte [d_buffer+11],0
    lea ebx, [d_buffer+10]
    test eax,eax
    jns .store
    neg eax
    jmp .store

.store:
    xor edx,edx
    div ecx
    add dl,'0'
    mov [ebx],dl
    dec ebx
    test eax,eax
    jnz .store

.t_sign:
    mov eax,[ebp+edi*4+12]
    test eax,eax
    js .add_sign
    jmp .buff

.add_sign:
    mov byte [ebx],'-'
    jmp .buff

.buff:
    lea edx, [d_buffer+11]
    sub edx, ebx
    lea ecx, [ebx]
    call ._write
    pop eax
    inc esi
    inc edi
    jmp ._init

._write:
    push eax
    push ebx
    mov eax, 4
    mov ebx, 1
    int 0x80
    pop ebx
    pop eax
    ret

.done:
    pop edx
    pop ecx
    pop ebx
    pop eax

    mov esp, ebp
    pop ebp
    ret