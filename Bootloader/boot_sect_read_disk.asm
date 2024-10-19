; A boot sector that prints strings with function.

BITS 16
[ org 0x7c00 ]

; Initialisation des segments
xor ax, ax
mov ds, ax
mov es, ax

mov [BOOT_DRIVE], dl ; Store boot drive un dl for later

mov bp, 0x8000 ; Move the stack out of the way
mov sp, bp     ; At 0x8000

mov bx, LOAD_MSG
call print_string

; Préparation des paramètres de lecture du disque
mov ax, 0x0900         ; Segment value
mov es, ax             ; ES = 0x0900
xor bx, bx             ; BX = 0, donc ES:BX pointe sur 0x90000
mov dh, 2              ; Nombre de secteurs à lire
mov dl, [BOOT_DRIVE]   ; Disque source
mov ch, 0              ; Cylindre 0
mov cl, 2              ; Commencer au secteur 2 (après le boot sector)
mov al, dh             ; Nombre de secteurs dans AL aussi
mov ah, 0x02           ; Fonction de lecture BIOS

call disk_load

mov dx, [es:bx] ; Print the first word stored at 0x9000 (0xdada)
call print_hex

mov dx, [es:bx + 512] ; Print the first word of the 2nd sector (0xface)
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