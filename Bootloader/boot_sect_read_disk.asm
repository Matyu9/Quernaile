; A boot sector that prints strings with function.

[ org 0x7c00 ]
mov bx, HELLO_MSG
call print_string

mov bx, GOODBYE_MSG
call print_string

mov dx, 0xFFFF
call print_hex

jmp $

; Variables
HELLO_MSG:
    db 'Hello, World From an Assembly Function!', 13, 10, 0

GOODBYE_MSG:
    db 'Goodbye!', 13, 10, 0

%include "../func/print_asm/print_string.asm"
%include "../func/print_asm/print_hex.asm"

times 510 -( $ - $$ ) db 0
dw 0xaa55