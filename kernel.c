//
// Created by mathieu Degueurce on 14/10/2024.
// With a small help from wiki.osdev.org
//

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

/* Using cross-compiler ? */
#if defined(__linux__)
#error "Il faut utiliser le cross-compiler !!!!"
#endif

/* Good target ? */
#if !defined(__i386__)
#error "Il faut compiler avec un compilateur pour 32-bit ix86"
#endif

/* Colors. */
enum vga_color {
    VGA_COLOR_BLACK = 0,
    VGA_COLOR_BLUE = 1,
    VGA_COLOR_GREEN = 2,
    VGA_COLOR_CYAN = 3,
    VGA_COLOR_RED = 4,
    VGA_COLOR_MAGENTA = 5,
    VGA_COLOR_BROWN = 6,
    VGA_COLOR_LIGHT_GREY = 7,
    VGA_COLOR_DARK_GREY = 8,
    VGA_COLOR_LIGHT_BLUE = 9,
    VGA_COLOR_LIGHT_GREEN = 10,
    VGA_COLOR_LIGHT_CYAN = 11,
    VGA_COLOR_LIGHT_RED = 12,
    VGA_COLOR_LIGHT_MAGENTA = 13,
    VGA_COLOR_LIGHT_BROWN = 14,
    VGA_COLOR_WHITE = 15,
};

/* Prends 2 entrées de couleur VGA pour en faire une valeur pour la couleur fond et de la police */
static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg) {
    return fg | bg << 4;
}

/* Écris la valeur `uc` avec les couleurs de uint8_t dans la mémoire VGA  */
static inline uint16_t vga_entry(unsigned char uc, uint8_t color) {
    return (uint16_t) uc | (uint16_t) color << 8;
}

/* Fonction qui calcule la longueur d'une chaine de caractères */
size_t strlen(const char* str) {
    size_t len = 0;
    while (str[len])
        len++;
    return len;
}

// Définition de la taille de l'écran
static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t* terminal_buffer;

/* Création d'un écran vide */
void terminal_initialize(void) {
    terminal_row = 0;
    terminal_column = 0;
    // Écriture noir sur fond blanc
    terminal_color = vga_entry_color(VGA_COLOR_BLACK, VGA_COLOR_WHITE);
    terminal_buffer = (uint16_t*) 0xB8000;
    for (size_t y = 0; y < VGA_HEIGHT; y++) {
        for (size_t x = 0; x < VGA_WIDTH; x++) {
            const size_t index = y * VGA_WIDTH + x;
            terminal_buffer[index] = vga_entry(' ', terminal_color);
        }
    }
}

/* Couleur du terminal */
void terminal_setcolor(uint8_t color) {
    terminal_color = color;
}

/* Ajout d'un caractère à une position précise */
void terminal_putentryat(char c, uint8_t color, size_t x, size_t y) {
    const size_t index = y * VGA_WIDTH + x;
    terminal_buffer[index] = vga_entry(c, color);
}

/* Ajout d'un caractère à la position courante du curseur */
void terminal_putchar(char c) {
    terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
    if (++terminal_column == VGA_WIDTH) {
        terminal_column = 0;
        if (++terminal_row == VGA_HEIGHT)
            terminal_row = 0;
    }
}

/* Écris une chaine de caractère en fonction de la taille de la chaine */
void terminal_write(const char* data, size_t size) {
    for (size_t i = 0; i < size; i++)
        terminal_putchar(data[i]);
}

/* Écris une chaine de caractère  */
void terminal_writestring(const char* data) {
    terminal_write(data, strlen(data));
}

/* Lancement du kernel */
void kernel_main(void) {
    /* Création de l'interface du terminal */
    terminal_initialize();

    /* Ajout de Hello World à l'écran. */
    terminal_writestring("Hello, kernel World!\n");
}

