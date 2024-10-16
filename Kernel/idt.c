//
// Created by mathieu Degueurce on 16/10/2024.
//


void init_idt() {
    // Ajouter l'entrée pour l'IRQ1 (clavier)
    idt_set_gate(33, (uint32_t)keyboard_interrupt_handler, 0x08, 0x8E);
}