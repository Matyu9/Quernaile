disk_load:
    pusha
    push dx              ; Sauvegarder DX qui contient DH (nb secteurs) et DL (drive number)

    int 0x13             ; BIOS Interrupt
    jc disk_error        ; jump if error (if carry flag set)

    pop dx               ; Restaurer DX pour avoir le nombre de secteurs dans DH
    cmp al, dh           ; Comparer avec le nombre de secteurs lus (DH contient le nombre voulu)
    jne sectors_error    ; Error message si différent

    popa
    clc                  ; Clear carry flag (pas d'erreur)
    ret

disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string

    mov dx, ax           ; Afficher le code d'erreur
    call print_hex
    jmp $

sectors_error:
    mov bx, SECTORS_ERROR_MSG
    call print_string
    jmp $

; Variables
DISK_ERROR_MSG:
    db "Disk read error!", 13, 10, 0

SECTORS_ERROR_MSG:
    db "Incorrect number of sectors read!", 13, 10, 0