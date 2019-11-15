#include "../drivers/screen.c"
void main() {
    clear_screen();
    print_at("X", 1, 6);
    print_at("This text spans multiple lines", 75, 10);
    print_at("There is a line\nbreak", 0, 20);
    print("There is a line\nbreak");
    print_at("What happens when we run out of space?", 45, 24);
}

