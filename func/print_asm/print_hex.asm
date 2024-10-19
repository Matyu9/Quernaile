print_hex:
    pusha                  ; Sauvegarde tous les registres

    ; Affiche "0x" d'abord
    mov ah, 0x0e
    mov al, '0'
    int 0x10
    mov al, 'x'
    int 0x10

    mov cx, 4              ; Il y a 4 digits à traiter (16 bits / 4 = 4 nibbles)

.next_digit:
    mov bx, dx             ; Copie dx dans bx pour manipuler sans modifier dx
    shr bx, 12             ; Décale de 12 bits pour obtenir le nibble le plus à gauche

    and bx, 0x0F           ; Garde uniquement les 4 bits de poids faible

    cmp bx, 0xA            ; Si le digit est >= 10, c'est une lettre
    jl .number
    add bx, 'A' - 10       ; Convertit en caractère alphabétique (A-F)
    jmp .display_char

.number:
    add bx, '0'            ; Convertit en caractère numérique (0-9)

.display_char:
    mov ah, 0x0e
    mov al, bl             ; Affiche le caractère correspondant
    int 0x10

    rol dx, 4              ; Décale dx de 4 bits pour obtenir le prochain nibble

    dec cx                 ; Décrémente le compteur de digits
    jnz .next_digit        ; Continue tant qu'il reste des digits à traiter

.done:
    popa                   ; Restaure tous les registres
    ret                    ; Retour à l'appelant
