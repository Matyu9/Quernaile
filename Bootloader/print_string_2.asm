print_string:
    pusha                ; Sauvegarder tous les registres
    mov ah, 0x0e         ; Fonction BIOS pour imprimer un caractère en mode TTY

.print_next_char:
    mov ah, [bx]         ; Charger le caractère pointé par BX dans AL
    cmp ah, 0            ; Comparer le caractère avec 0 (fin de chaîne)
    je .done             ; Si égal à 0, terminer la routine

    int 0x10             ; Interruption BIOS pour afficher le caractère
    inc bx               ; Passer au caractère suivant
    jmp .print_next_char ; Répéter jusqu'à la fin de la chaîne

.done:
    popa                 ; Restaurer tous les registres
    ret                  ; Retourner à l'appelant

