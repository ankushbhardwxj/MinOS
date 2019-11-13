#include "../drivers/screen.c"

void main() {
    clear_screen();
    print_at("This text spans multiple lines", 75,10);
    print_at("This is a line \n break",0,20);
    print_at("Ankush Bhardwaj",23,12);
}