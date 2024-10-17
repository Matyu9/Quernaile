export PATH="$HOME/opt/cross/bin:$PATH"

INPUT_FILE="boot_sect_foreever_loop.asm"
BINARY_NAME="bootloader-00-00.bin"

# Show help
function show_help() {
    echo "Usage: ./make_binary_bootloader.sh [-n binary_name]"
    echo
    echo "Options:"
    echo "  -i INPUT_FILE      Nom du fichier ASM (par défaut: boot_sect_foreever_loop.asm)"
    echo "  -n BINARY_NAME     Nom du fichier binaire (par défaut: bootloader-00-00.bin)"
    echo "  -h                 Afficher cette aide"
}

# Get Args from commands
while getopts "i:n:h" opt; do
    case $opt in
        i) INPUT_FILE=$OPTARG ;;
        n) BINARY_NAME=$OPTARG ;;
        h) show_help
           exit 0 ;;
        *) echo "Option invalide"
           show_help
           exit 1 ;;
    esac
done

nasm $INPUT_FILE -f bin -o $BINARY_NAME
