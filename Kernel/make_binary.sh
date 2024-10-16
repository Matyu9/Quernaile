export PATH="$HOME/opt/cross/bin:$PATH"

BINARY_NAME="quernaile-ERR-ERR.bin"

# Show help
function show_help() {
    echo "Usage: ./build.sh [-n binary_name]"
    echo
    echo "Options:"
    echo "  -n BINARY_NAME     Nom du fichier binaire (par défaut: quernaile-ERR-ERR.bin)"
    echo "  -h                 Afficher cette aide"
}

# Get Args from commands
while getopts "n:h" opt; do
    case $opt in
        n) BINARY_NAME=$OPTARG ;;
        h) show_help
           exit 0 ;;
        *) echo "Option invalide"
           show_help
           exit 1 ;;
    esac
done


# Create the boot.o from boot.s (ASM)
i686-elf-as boot.s -o boot.o

# Create the kernel.o from kernel.c (C)
i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

# Create the link between kernel.o and boot.o with linker.ld (Create the binary)
i686-elf-gcc -T linker.ld -o "Binary/"$BINARY_NAME -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc