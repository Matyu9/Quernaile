disk_load:
    push ax
    push bx
    push cx
    push dx ; Sauvegarder DX qui contient DH (nb secteurs) et DL (drive number)

    mov ah, 0x02
    mov al, dh
    mov ch, 0
    mov cl, 2
    mov es, bx
    xor bx, bx

    int 0x13             ; BIOS Interrupt
    jc disk_error        ; jump if error (if carry flag set)

    pop dx               ; Restaurer DX pour avoir le nombre de secteurs dans DH
    cmp dh, al           ; Comparer avec le nombre de secteurs lus (DH contient le nombre voulu)
    jne sectors_error    ; Error message si différent

    pop dx
    pop cx
    pop bx
    pop ax
    ret

disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string

    mov dx, ax           ; Afficher le code d'erreur
    call print_hex
    jmp $                ; Ou hlt (c'est mieu en Real mode)

sectors_error:
    mov bx, SECTORS_ERROR_MSG
    call print_string
    mov dx, ax           ; Afficher le code d'erreur
    call print_hex
    jmp $                ; Ou hlt (c'est mieu en Real mode)


DISK_ERROR_MSG:
    db "Disk read error!", 13, 10, 0

SECTORS_ERROR_MSG:
    db "Incorrect number of sectors read!", 13, 10, 0