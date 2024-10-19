disk_load:
    push dx        ; Store DX on stack to know how many sector we want if we want to

    mov ah , 0x02  ; BIOS read sector function
    mov al, dh     ; Read DH sectors
    mov ch, 0x00   ; Select cylinder 0
    mov dh, 0x00   ; Select head 0
    mov cl, 0x02   ; Select sector 2 (after boot sector)

    int 0x13       ; BIOS Interrupt



    jc disk_error  ; jump if error (if carry flag set)

    pop dx         ; Restore DX
    cmp dh, al     ; If sectors read (AL) != sectors expected (DH)
    jne disk_error ; Error message

disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

; Variables
DISK_ERROR_MSG:
    db "Disk read error!", 0
