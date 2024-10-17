; Boot sector program that loops forever

loop: ; Just a loop who loop to himself
    jmp loop  ; Jump to loop

times 510-($-$$) db 0  ; Go to the 510 bytes of the boot sectore

dw 0xaa55  ; Add the magic number
