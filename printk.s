;-------------------------printf for kernel-----------------------
; Designed for 16-bit real-mode
; Take a quick read
; A bit overwhelming due to shortage of GPR, hence stack's utilised


printk:
    push bp
    mov bp,sp

    push ax
    push bx
    push cx
    push dx
    push di
    push si

    xor di,di
    xor cx,cx
    mov si,[bp+4]
    mov di,bp
    add di,4

.init:
    mov al,byte[si]
    cmp al,'%'
    je .frmt
    cmp al,0
    je .done
    call .write
    inc si
    jmp .init

.frmt:
    inc si
    mov al,byte[si]
    cmp al,'s'
    je .s_args
    cmp al,'d'
    je .d_args
    cmp al,'x'
    je .x_args
    cmp al,'c'
    je .c_args
    jmp .init
;------------------------decimal-------------------------
.d_args:
    inc si
    add di,2
    push ax
    push si
    mov ax,word[di]
    mov bx,10
    xor cx,cx
    test ax,ax
    jns .stod
    pushf
    pop si
    shr si,7
    and si,1
    neg ax
.stod:
    xor dx,dx
    div bx
    add dx,'0'
    push dx
    inc cx
    test ax,ax
    jnz .stod
    cmp si,1
    je .adsign
    jmp .putd
.adsign:
    mov al,'-'
    call .write
.putd:
    pop dx
    mov al,dl
    call .write
    loop .putd
    pop si
    pop ax
    jmp .init
;------------------------string-------------------------
.s_args:
    inc si
    add di,2
    push bx
    mov bx,word[di]
.puts:
    mov al,byte[bx]
    call .write
    inc bx
    cmp al,0
    jne .puts
    pop bx
    jmp .init
;----------------------hexadecimal-----------------------
.x_args:
    inc si    
    add di,2
    push dx
    mov dx,word[di]
    mov al,'0'
    call .write
    mov al,'x'
    call .write
    xor ax,ax
    xor bx,bx
.stox:
    mov cx,dx
    and cx,0xf
    cmp cl,9
    jle .prtx
    add cl,87
    jmp .putx
.prtx:
    add cl,'0'
.putx:
    mov al,cl
    push ax
    inc bx
    shr dx,4
    test dx,dx
    jnz .stox
.allign:
    pop ax
    call .write
    dec bx
    test bx,bx
    jnz .allign
    pop dx
    jmp .init
;------------------------character----------------------- 
.c_args:
    inc si
    add di,2
    mov al,byte[di]
    call .write
    jmp .init

.write:
    mov ah,0x0e
    int 0x10
    ret

.done:
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax

    mov sp,bp
    pop bp
    ret
;------------------------clear screen-----------------------
set_display:
    push ax
    mov ah,0x00
    mov al,0x03           ;80x25 text mode
    int 0x10
    pop ax
    ret
