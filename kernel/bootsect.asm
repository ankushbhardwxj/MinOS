[org 0x7c00]
KERNEL_OFFSET equ 0x1000
	mov [BOOT_DRIVE], dl
	mov bp, 0x9000
	mov sp, bp

	mov bx, MSG_REAL_MODE
	call print

	call print_n1

	call load_kernel
	call switch_to_pm
	jmp $

%include "../boot_sector/print_string.asm"
%include "../boot_sector/print_hex.asm"
%include "../boot_sector/boot_sect_disk.asm"
%include "../32bitmode/gdt.asm"
%include "../32bitmode/32bitprint.asm"
%include "../32bitmode/gdt_switchreg.asm"

[bits 16]
load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print

	call print_n1

	mov bx, KERNEL_OFFSET
	mov dh, 16
	mov dl, [BOOT_DRIVE]
	call disk_load
	ret

[bits 32]
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm
	call KERNEL_OFFSET
	jmp $

BOOT_DRIVE db 0
MSG_REAL_MODE db "Started in 16 bit Real Mode",0
MSG_PROT_MODE db "Landed in 32 bit Protected Mode",0
MSG_LOAD_KERNEL db "Loaded kernel into memory",0

;padding
times 510-($-$$) db 0
dw 0xaa55
