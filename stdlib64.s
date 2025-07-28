bits 64
default rel
; globalizing all sub-routine for external use
global printf
global open
global read
global write
global close
global stat
global fstat
global lseek
global nanosleep
global waitpid
global mmap
global munmap
global unlink
global getpid
global fork
global execve
global scanf

; colour macro defined for ease of use
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
; reserving 256 bytes uninitialized space for all I/O
buffer  resb 256

section .text

printf:
    push rbp
    mov rbp, rsp

    mov rbx, rdi        ; format string
    xor r12, r12        ; args indexer

.entry_label:
    mov al, [rbx]
    test al, al
    jz .ended
    
    cmp al, '%'
    je .format
    
    ; Regular character - print it with saving arg holder
    push rsi
    push rdx
    push rax
    mov rsi,rsp
    mov rdx,1
    call write_syscall
    pop rax
    pop rdx
    pop rsi

    inc rbx
    jmp .entry_label

.format:
    inc rbx
    mov al,byte[rbx]
    ; data type parser
    cmp al, 'd'
    je .dispatch_dec
    cmp al, 'x'
    je .dispatch_hex
    cmp al, 'c'
    je .dispatch_cha
    cmp al, 's'
    je .dispatch_str
    cmp al, 'b'
    je .dispatch_bin
    cmp al, '.'
    je .len_arg
    
    ; Unknown format specifier - print as is
    push rsi
    push rdx
    push rax
    mov rsi,rsp
    mov rdx,1
    call write_syscall
    pop rax
    pop rdx
    pop rsi

    inc rbx
    jmp .entry_label

; %.Ns handler
.len_arg:
    xor r15,r15
    inc rbx
    mov al, byte[rbx]
    mov r15,1
    cmp al,'s'
    je .string_arg

    sub al,'0'
    movzx r15, al
    jmp .format

; dispatcher to handle any order of args
.dispatch_dec:
    cmp r12, 0
    je .rsi_d
    cmp r12, 1
    je .rdx_d
    cmp r12, 2
    je .rcx_d
    cmp r12, 3
    je .r8_d
    cmp r12, 4
    je .r9_d

.dispatch_hex:
    cmp r12, 0
    je .rsi_x
    cmp r12, 1
    je .rdx_x
    cmp r12, 2
    je .rcx_x
    cmp r12, 3
    je .r8_x
    cmp r12, 4
    je .r9_x

.dispatch_str:
    cmp r12, 0
    je .rsi_s
    cmp r12, 1
    je .rdx_s
    cmp r12, 2
    je .rcx_s
    cmp r12, 3
    je .r8_s
    cmp r12, 4
    je .r9_s

.dispatch_cha:
    cmp r12, 0
    je .rsi_c
    cmp r12, 1
    je .rdx_c
    cmp r12, 2
    je .rcx_c
    cmp r12, 3
    je .r8_c
    cmp r12, 4
    je .r9_c

.dispatch_bin:
    cmp r12, 0
    je .rsi_b
    cmp r12, 1
    je .rdx_b
    cmp r12, 2
    je .rcx_b
    cmp r12, 3
    je .r8_b
    cmp r12, 4
    je .r9_b
;
; resolver for dispatch
;
.rsi_d:
    inc r12
    mov rax,rsi
    jmp .decimal_arg
.rdx_d:
    inc r12
    mov rax,rdx
    jmp .decimal_arg
.rcx_d:
    inc r12
    mov rax,rcx
    jmp .decimal_arg
.r8_d:
    inc r12
    mov rax,r8
    jmp .decimal_arg
.r9_d:
    inc r12
    mov rax,r9
    jmp .decimal_arg


.rsi_x:
    inc r12
    mov rax,rsi
    jmp .hex_arg
.rdx_x:
    inc r12
    mov rax,rdx
    jmp .hex_arg
.rcx_x:
    inc r12
    mov rax,rcx
    jmp .hex_arg
.r8_x:
    inc r12
    mov rax,r8
    jmp .hex_arg
.r9_x:
    inc r12
    mov rax,r9
    jmp .hex_arg


.rsi_s:
    inc r12
    mov rax,rsi
    jmp .string_arg
.rdx_s:
    inc r12
    mov rax,rdx
    jmp .string_arg
.rcx_s:
    inc r12
    mov rax,rcx
    jmp .string_arg
.r8_s:
    inc r12
    mov rax,r8
    jmp .string_arg
.r9_s:
    inc r12
    mov rax,r9
    jmp .string_arg


.rsi_c:
    inc r12
    mov rax,rsi
    jmp .char_arg
.rdx_c:
    inc r12
    mov rax,rdx
    jmp .char_arg
.rcx_c:
    inc r12
    mov rax,rcx
    jmp .char_arg
.r8_c:
    inc r12
    mov rax,r8
    jmp .char_arg
.r9_c:
    inc r12
    mov rax,r9
    jmp .char_arg


.rsi_b:
    inc r12
    mov rax,rsi
    jmp .binary_arg
.rdx_b:
    inc r12
    mov rax,rdx
    jmp .binary_arg
.rcx_b:
    inc r12
    mov rax,rcx
    jmp .binary_arg
.r8_b:
    inc r12
    mov rax,r8
    jmp .binary_arg
.r9_b:
    inc r12
    mov rax,r9
    jmp .binary_arg
;
; produce aschi from various data types and print on terminal
;
.binary_arg:
    inc rbx
    mov r13,2
    mov byte[buffer+31],0
    mov r14,buffer+30
    xor r11,r11
.got_argb:
    xor rdx,rdx
    div r13
    add dl,'0'
    mov byte[r14],dl
    dec r14
    inc r11
    test rax,rax
    jnz .got_argb
    inc r14
.stdout_bin:
    push rsi
    push rdx
    mov rsi,r14
    mov rdx,r11
    call write_syscall
    pop rdx
    pop rsi
    jmp .entry_label

.char_arg:
    inc rbx
.got_argc:
    push rsi
    push rdx
    push rax
    lea rsi,[rsp]
    mov rdx, 1
    call write_syscall
    pop rax
    pop rdx
    pop rsi
    jmp .entry_label

.string_arg:
    inc rbx
    lea r11,[buffer]
    mov r14,rax
    xor r13,r13
    test r15,r15
    jnz .limited_string
    jmp .total_string
.limited_string:
    mov al, byte[r14+r13]
    test al,al
    jz .stdout_str
    mov byte[r11],al
    inc r11
    inc r13
    cmp r13,r15
    jl .limited_string
    jmp .stdout_str
.total_string:
    mov al,byte[r14+r13]
    test al,al
    jz .stdout_str
    mov byte[r11],al
    inc r11
    inc r13
    jmp .total_string
.stdout_str:
    push rsi
    push rdx
    lea rsi,[buffer]
    mov rdx,r13
    call write_syscall
    pop rdx
    pop rsi
    jmp .entry_label

.hex_arg:
    inc rbx
    mov r14,rax
    mov byte[buffer+255],0
    mov r11,buffer+254
    xor r13,r13
.bitmask:
    mov rax,r14
    and rax,0xf
    cmp al,9
    jle .numeric
    add al,55
    jmp .alpha
.numeric:
    add al,'0'
.alpha:
    mov byte[r11],al
    dec r11
    inc r13
    shr r14,4
    test r14,r14
    jnz .bitmask
    mov byte[r11],'x'
    dec r11
    mov byte[r11],'0'
    add r13,2
.stdout_hex:
    push rsi
    push rdx
    mov rsi,r11
    mov rdx,r13
    call write_syscall
    pop rdx
    pop rsi
    jmp .entry_label

.decimal_arg:
    mov r11,rax
    mov r13, 10
    mov byte[buffer+255],0
    mov r14, buffer+254
    xor r15,r15 ; set counter 
    test rax, rax
    jns .aschify
    neg rax
.aschify:
    xor rdx, rdx
    div r13
    add dl, '0'
    mov byte[r14], dl
    dec r14
    inc r15
    test rax, rax
    jnz .aschify
    test r11,r11
    js .add_sign
    inc r14
    jmp .stdout_dec
.add_sign:
    mov byte [r14], '-'
    inc r15
.stdout_dec:
    push rsi
    push rdx
    lea rsi,[r14]
    mov rdx,r15
    call write_syscall
    pop rdx
    pop rsi
    inc rbx
    jmp .entry_label

.ended:
    leave
    ret
;
; syscall for write with saving registers that gets modified
;
write_syscall:
    push rcx
    push r11
    mov rax, 1      ; syscall number for write
    mov rdi, 1      ; STDOUT fd 0x1
    syscall
    pop r11
    pop rcx
    ret
;
; some essential sub-routines to use
;
exit:
    mov rax,60
    xor rdi,rdi
    syscall

open:
    ; open(filename, flags, mode)
    ; rdi = filename (pointer)
    ; rsi = flags (O_RDONLY, O_WRONLY, etc.)
    ; rdx = mode (permissions, e.g. 0o644)
    mov rax, 257         ; syscall: openat
    mov rcx, rdx         ; mode
    mov rdx, rsi         ; flags
    mov rsi, rdi         ; filename
    mov rdi, -100        ; AT_FDCWD
    syscall
    ret

read:
    ; read(fd, buf, count)
    ; rdi = fd
    ; rsi = buf
    ; rdx = count
    mov rax, 0           ; syscall: read
    syscall
    ret

write:
    ; write(fd, buf, count)
    ; rdi = fd
    ; rsi = buf
    ; rdx = count
    mov rax, 1           ; syscall: write
    syscall
    ret

close:
    ; close(fd)
    ; rdi = fd
    mov rax, 3           ; syscall: close
    syscall
    ret

mmap:
    ; mmap(addr, length, prot, flags, fd, offset)
    ; rdi = addr (usually 0 for automatic)
    ; rsi = length
    ; rdx = prot
    ; rcx = flags
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

gettime:
    mov rdi,0
    ;lea rsi, [buffer]
    mov rax ,228
    syscall
    ret

scanf:
    ;rsi    char* buffer 
    ;rdx    size_t count 
    xor rdi,rdi
    xor rax,rax
    syscall
    ret