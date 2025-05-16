global _start

extern XOpenDisplay
extern XDefaultScreen
extern XRootWindow
extern XCreateSimpleWindow
extern XMapWindow
extern XFlush
extern XCloseDisplay
extern sleep
extern exit

section .data
    width  equ 640
    height equ 480

section .bss
    display resd 1
    window  resd 1

section .text
_start:
    ; display = XOpenDisplay(0)
    push 0
    call XOpenDisplay
    add esp, 4
    mov dword [display], eax

    ; screen = XDefaultScreen(display)
    push dword [display]
    call XDefaultScreen
    add esp, 4
    mov ebx, eax

    ; root = XRootWindow(display, screen)
    mov eax, dword [display]
    push ebx
    push eax
    call XRootWindow
    add esp, 8
    mov ecx, eax  ; root window

    ; XCreateSimpleWindow(display, root, 0, 0, width, height, 0, 0, 0)
    push 0          ; background_pixel
    push 0          ; border_pixel
    push 0          ; border_width
    push height
    push width
    push 0          ; y
    push 0          ; x
    push ecx        ; root window
    push dword [display]
    call XCreateSimpleWindow
    add esp, 36
    mov dword [window], eax

    ; XMapWindow(display, window)
    push dword [window]
    push dword [display]
    call XMapWindow
    add esp, 8

    ; XFlush(display)
    push dword [display]
    call XFlush
    add esp, 4

    ; sleep(100)
    push 100
    call sleep
    add esp, 4

    ; XCloseDisplay(display)
    push dword [display]
    call XCloseDisplay
    add esp, 4

    ; exit(0)
    push 0
    call exit
