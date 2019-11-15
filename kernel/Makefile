#Default make target
all: os-image
#Run bochs to simulate booting
run: all
	qemu-system-x86_64 -fda os-image --curses
#This is the actual disk image that the computer loads,
#which is the combination of our compiled bootsector and kernel
os-image : bootsect.bin kernel.bin
	cat $^ > os-image
#Build the kernel binary
kernel.bin : kernel_entry.o kernel.o
	ld -o kernel.bin -Ttext 0x1000 $^ --oformat binary
#Build the kernel object file
kernel.o : kernel.c
	gcc -ffreestanding -c $< -o  $@
#Build the kernel entry object file
kernel_entry.o : kernel_entry.asm
	nasm $< -f elf64 -o $@
#Assemble the bootsector to raw machine code
bootsect.bin : bootsect.asm
	nasm $< -f bin -I './' -o $@ 
clean :
	rm  -rf *.bin *.o os-image *.map
kernel.dis : kernel.bin
	ndisasm -b 32 $< > $@
