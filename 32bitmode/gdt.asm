gdt_start:
	;gdt starts will a null 8 byte
	dd 0x0 ;4byte
	dd 0x0 ;4byte
gdt_code: ;the code segment descriptor
;base = 0x00000000, length=0xfffff
; 1st flags: 1 (present) 00(priviledge) 1(descriptor type) -> 1001b
; type flags: 1 (code) 0(conforming) 1(readable) 0(accessed) -> 1010b
; 2nd flags: 1(granularity) 1(32-bit default) 0(64bit seg) 0(AVL)->1100b
	dw 0xffff ; LIMIT 
	dw 0x0 ;BASE(0-15bit)
	db 0x0 ;BASE(16-23bit)
	db 10011010b ;1st flags, type flags
	db 11001111b ;2nd flags, Limit(16-19)
	db 0x0 ;BASE (24-31)

gdt_data: ;the data segment descriptor
;Same as code segment except for the type flags
;type flags: 0(code) 0(expand down) 1(writable) 0(accessed) -> 0010b
	dw 0xffff
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
	
gdt_end:

;GDT descriptor
gdt_descriptor:
	dw gdt_end - gdt_start - 1 ; size of GDT is 1 less than true size
	dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start