; A boot sector that prints strings with function.
; This code doesn't work I don't know why but nevermind...

BITS 16
ORG 0x7C00

mov bx, LOAD_MSG
call print_string

mov [BOOT_DRIVE], dl

mov bp, 0x8000
mov sp, bp

mov bx, 0x9000
mov dh, 2
mov dl, [BOOT_DRIVE]
call disk_load

mov dx, [0x9000]
call print_hex

mov dx, [0x9000 + 512]
call print_hex

mov bx, GOODBYE_MSG
call print_string

jmp $


; Variables
LOAD_MSG:
    db 'Loading the disk...', 13, 10, 0

GOODBYE_MSG:
    db 'Goodbye!', 13, 10, "All is good I think" , 13, 10, 0

BOOT_DRIVE:
    db 0

%include "../func/print_asm/print_string.asm"
%include "../func/print_asm/print_char.asm"
%include "../func/print_asm/print_hex.asm"
%include "../func/disk_asm/read_disk.asm"

times 510 -( $ - $$ ) db 0
dw 0xaa55

; Load data outside of the 512 byte boot sector
times 256 dw 0xdada
times 256 dw 0xface