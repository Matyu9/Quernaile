print_string:
    mov al, [bx] ; Un symbole du string
    cmp al, 0  ; Si = 0 on retourne au code de base
    je done

    mov ah, 0x0E
    int 0x10
    add bx, 1

    jmp print_string

done:
    ret