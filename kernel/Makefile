.PHONY: all run next1 next2 next3 next4 next5
all: run next1 next2 next3 next4 next5

run: gcc -ffreestanding -c kernel.c -o kernel.o

next1: nasm kernel_entry.asm -f elf64 -o kernel_entry.o

next2: ld -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary
next3: nasm bootsect.asm -f bin -o bootsect.bin
next4: cat bootsect.bin kernel.bin > os-image.bin
next5: qemu-system-x86_64 -fda os-image.bin --curses


clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf
