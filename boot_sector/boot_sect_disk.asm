;load dh sectors from drive dl to ES:BX
disk_load:
	pusha
	; we will overwrite our input parameters on dx
	; lets push it to the stack for later use
	push dx

	mov ah, 0x02  ;0x02-denotes start of text
				  ;read to ah<-int 0x13  
	mov al,dh  ;sectors in dh moved to al
	mov cl, 0x02 ;start reading from second sector after 
				 ; the bootsector
				 ; 0x01 is the boot sector, 0x02 is the first
				 ; 'available' sector
	mov ch, 0x00 ; ch points to cylinder (0x0 ... 0x3FF)
				 ; Our caller sets it as a parameter and gets it 
				 ; from BIOS (0=floppy, 1=floppy, 0x80==hdd, 0x81=hdd2)
	mov dh, 0x00 ; dh points to head number (0x0 ...0xF)
	
	int 0x13
	jc disk_error

	pop dx
	cmp al, dh ; if(al!=dh) sector error 
			   ; number of sectors read into al from dh 
	jne sectors_error
	popa 
	;makes stack empty
	ret

disk_error:
	mov bx, DISK_ERROR
	call print
	call print_n1
	mov dh, ah
	call print_hex
	jmp disk_loop

sectors_error:
	mov bx, SECTORS_ERROR
	call print

disk_loop:
	jmp $
	
DISK_ERROR: db "Disk read error",0
SECTORS_ERROR: db "Incorrect number of sectors read",0
