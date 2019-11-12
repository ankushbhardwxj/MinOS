C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJ = ${C_SOURCES:.c=.o}


CFLAGS = -g

os-image.bin: bootsect.bin kernel.bin
	cat $^ > os-image.bin

kernel.bin: kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary
kernel.elf: kernel_entry.o ${OBJ}
	ld -o $@ -Ttext 0x1000 $^
run: os-image.bin
	qemu-system-x86_64 -fda os-image.bin --curses
debug: os-image.bin kernel.elf
	qemu-system-x86_64 -s -fda os-image.bin &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -ffreestanding -c %< -o $@

%.o: %.asm
	nasm $< -f -elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@
clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf
