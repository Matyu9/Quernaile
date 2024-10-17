; A boot sector that prints strings with function.

mov al, 'e'  ;Use bx as a parameter to our function, so
call print_string  ;We can specify the address of a string.

mov al, 'e'
call print_string

jmp $

; Variables

HELLO_MSG:
    db 'Hello, World From an Assembly Function!', 0 ; <-- The zero on the end tells our routine

GOODBYE_MSG:
    db 'Goodbye!', 0


times 510 -( $ - $$ ) db 0
dw 0xaa55