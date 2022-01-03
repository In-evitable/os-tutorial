mov ah, 0x0e

; attempt 1
; fails because it tries to print the memory address (pointer)
; not the contents
mov al, "1"
int 0x10
mov al, the_secret
int 0x10

; attempt 2
; tries to print memory address of 'the secret' which is the correct approach
; however, BIOS places our bootsector at address 0x7c00
mov al, "2"
int 0x10
mov al, [the_secret]
int 0x10

; attempt 3
; add the BIOS starting offset 0x7c00 to the memory affress of the X
; then dereference the contents of the pointer
; we need the help of a different register 'bx' because 'mov al, [ax]' is illegal
; a register can't be used as source and destination for the same command
mov al, "3"
int 0x10
mov bx, the_secret
add bx, 0x7c00
mov al, [bx]
int 0x10

; attempt 4
; we try a shortcut since we know that the X is stored at byte 0x2d in our binary
; that's smart but ineffective, we don't want to be recounting label offsets
; every time we change the code
mov al, "4"
int 0x10
mov al, [0x7c2d]
int 0x10

jmp $

the_secret:
    db "X"

times 510-($-$$) db 0
dw 0xaa55