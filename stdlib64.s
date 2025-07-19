bits 64
global printf

default rel
%define endl            0x0A, 0x00
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
    buffer  resb 32
    argc    resb 32

section .text

printf:
    ;push arg1
    ;push arg2
    ;push arg3
    ;push arg4
    ;push ...
    ;push format
    ;call printf

    ;64bit but follows cdecl,weired but easy to handle 
    push rbp
    mov rbp,rsp

    xor r12, r12
    mov rbx,[rbp+r12*8+16]

._init:
    mov al, [rbx]
    test al, al
    jz .done
    cmp al, '%'
    je ._format
    mov byte [argc], al
    lea rsi, [argc]
    mov rdx, 1
    call write_syscall
    inc rbx
    jmp ._init

._format:
    inc rbx
    mov al, [rbx]
    cmp al, 'd'
    je .d_args
    cmp al, 'x'
    je .xargs
    cmp al, 'c'
    je .cargs
    cmp al, 's'
    je .s_args
    cmp al,'b'
    je .b_args

    ; Unknown format, print as is
    mov byte [argc], al
    lea rsi, [argc]
    mov rdx, 1
    call write_syscall
    inc rbx
    jmp ._init

.b_args:
    inc rbx
    inc r12
    mov r9,[rbp+r12*8+16]
    mov rax,r9
    mov rcx,2
    mov r15,buffer+31
    xor r8,r8
.got_b:
    xor rdx,rdx
    div rcx
    add dl,'0'
    mov byte[r15],dl
    dec r15
    inc r8
    test rax,rax
    jnz .got_b
    inc r15
.out_b:
    lea rsi,[r15]
    mov rdx,r8
    call write_syscall
    jmp ._init

.cargs:
    inc rbx
    inc r12
    mov r8,[rbp+r12*8+16]
.got_c:
    mov rax,r8
    mov byte [argc], al
    lea rsi, [argc]
    mov rdx, 1
    call write_syscall
    jmp ._init

.s_args:
    inc rbx
    inc r12
    mov r14,[rbp+r12*8+16]
    mov rdi,argc
    xor r8,r8
.sto_s:
    mov al, byte[r14]
    test al, al
    jz .out_s
    inc r8
    mov byte [rdi], al
    inc rdi
    inc r14
    jmp .sto_s
.out_s:
    mov rdx,r8
    lea rsi, [argc]
    call write_syscall
    jmp ._init

.xargs:
    inc r12
    mov r10,[rbp+r12*8+16]
.got_x:
    mov rdx,buffer+31
    xor rcx,rcx
.sto_x:
    mov rax,r10
    and rax,0xf
    cmp al,9
    jle .numeric
    add al,55
    jmp .alpha
.numeric:
    add al,'0'
.alpha:
    mov byte[rdx],al
    dec rdx
    inc rcx
    shr r10,4
    test r10,r10
    jnz .sto_x
    mov byte[rdx],'x'
    dec rdx
    mov byte[rdx],'0'
    add rcx,2
.buff_x:
    mov rsi,rdx
    mov rdx,rcx
    call write_syscall
    inc rbx
    jmp ._init

.d_args:
    inc r12
    mov r11,[rbp+r12*8+16]
    mov rax,r11
    mov rcx, 10
    mov r14, buffer+31
    xor r8,r8
    test rax, rax
    jns ._d_store
    neg rax
._d_store:
    xor rdx, rdx
    div rcx
    add dl, '0'
    mov [r14], dl
    dec r14
    inc r8
    test rax, rax
    jnz ._d_store
    test r11,r11
    js ._add_sign
    inc r14
    jmp ._out
._add_sign:
    mov byte [r14], '-'
    inc r8
._out:
    lea rsi,[r14]
    mov rdx,r8
    call write_syscall
    inc rbx
    jmp ._init

.done:
    leave
    ret

write_syscall:
    push rax
    push rdi
    push rdx
    mov rax, 1
    mov rdi, 1
    syscall
    pop rdx
    pop rdi
    pop rax
    ret

exit:
    mov rax,60
    xor rdi,rdi
    syscall

fopen:
    ; fopen(filename, flags, mode)
    ; rdi = filename (pointer)
    ; rsi = flags (O_RDONLY, O_WRONLY, etc.)
    ; rdx = mode (permissions, e.g. 0o644)
    mov rax, 257         ; syscall: openat
    mov r10, rdx         ; mode
    mov rdx, rsi         ; flags
    mov rsi, rdi         ; filename
    mov rdi, -100        ; AT_FDCWD
    syscall
    ret

fread:
    ; fread(fd, buf, count)
    ; rdi = fd
    ; rsi = buf
    ; rdx = count
    mov rax, 0           ; syscall: read
    syscall
    ret

fwrite:
    ; fwrite(fd, buf, count)
    ; rdi = fd
    ; rsi = buf
    ; rdx = count
    mov rax, 1           ; syscall: write
    syscall
    ret
        
fclose:
    ; fclose(fd)
    ; rdi = fd
    mov rax, 3           ; syscall: close
    syscall
    ret

mmap:
    ; mmap(addr, length, prot, flags, fd, offset)
    ; rdi = addr (usually 0 for automatic)
    ; rsi = length
    ; rdx = prot
    ; r10 = flags
    ; r8  = fd
    ; r9  = offset
    mov rax, 9           ; syscall: mmap
    syscall
    ret
    
munmap:
    ; munmap(addr, length)
    ; rdi = addr
    ; rsi = length
    ; return: rax = 0 on success, -errno on error
    mov rax, 11
    syscall
    ret

lseek:
    ; lseek(fd, offset, whence)
    ; rdi = fd
    ; rsi = offset
    ; rdx = whence
    ; return: rax = resulting offset, -errno on error
    mov rax, 8
    syscall
    ret

unlink:
    ; unlink(pathname)
    ; rdi = pathname
    ; return: rax = 0 on success, -errno on error
    mov rax, 87
    syscall
    ret

stat:
    ; stat(pathname, statbuf)
    ; rdi = pathname
    ; rsi = statbuf
    ; return: rax = 0 on success, -errno on error
    mov rax, 4
    syscall
    ret

fstat:
    ; fstat(fd, statbuf)
    ; rdi = fd
    ; rsi = statbuf
    ; return: rax = 0 on success, -errno on error
    mov rax, 5
    syscall
    ret

getpid:
    ; return: rax = process ID
    mov rax, 39
    syscall
    ret

fork:
    ; return: rax = 0 in child, child's PID in parent, -errno on error
    mov rax, 57
    syscall
    ret

execve:
    ; execve(filename, argv, envp)
    ; rdi = filename
    ; rsi = argv
    ; rdx = envp
    ; return: rax = only returns on error, -errno
    mov rax, 59
    syscall
    ret

waitpid:
    ; waitpid(pid, status, options)
    ; rdi = pid
    ; rsi = status
    ; rdx = options
    ; return: rax = PID of child, -errno on error
    mov rax, 61
    syscall
    ret

nanosleep:
    ; nanosleep(req, rem)
    ; rdi = req
    ; rsi = rem
    ; return: rax = 0 on success, -errno on error
    mov rax, 35
    syscall
    ret