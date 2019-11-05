[org 0x7c00]

	mov bp, 0x8000  ;stored stack safely out of way
	mov sp,bp

	mov bx, 0x9000 ; es : bx = 0x0000:0x9000 = 0x09000
	mov dh, 2 ;read 2 sectors to es:bx from boot_disk
	;bios sets dl for our boot disk number
	call disk_load ;load the sectors

	mov dx, [0x9000] ;retrieve the first loaded word, 0xdada  
					 ;from the first loaded sector
					 ;0xdada - 56026
	call print_hex

	call print_n1

	mov dx, [0x9000 + 512] ;retrieve the first loaded word, 0xface
						   ;from the second loaded sector
						   ;0xface - 64206
	call print_hex

	jmp $

%include "print_hex.asm"
%include "print_string.asm"
%include "boot_sect_disk.asm"

	BOOT_DRIVE: db 0

times 510-($-$$) db 0
dw 0xaa55 ;dw - initialise memory with one or more word


;ADDITIONAL SECTORS FROM DISK
;boot sector = sector 1 of cyl 0 of head 0 of hdd 0
;from now on = sector 2 ...
;two extra sectors added after 512 byte first sector
times 256 dw 0xdada ;sector 2 = 512 bytes
times 257 dw 0xface ;sector 3 = 512 bytes
