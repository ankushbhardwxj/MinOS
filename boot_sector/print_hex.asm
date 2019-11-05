; data is in register dx
; let dx=0x1234
print_hex:
	pusha
	mov cx, 0 ;index variable - loop initialisation

;strategy : get last digit of 'dx' and convert to ASCII
;if(bit is numeric) bit+0x30 ;ASCII for 0 is 0x30
;if(bit is alphabetic) bit+0x40 ;ASCII for 'A' is 0x41
;move ASCII byte to correct position on resulting string.

hex_loop:
	cmp cx, 4 ; - loop condition, loop 4 times
	je end 

	;Convert last digit of dx to ASCII
	mov ax,dx
	and ax, 0x000f ;bitmasking : 0x000f & 0x1234 -> 0x0004
	add al, 0x30 
	cmp al, 0x39 ;if(al<=9) then use step2
	jle step2
	add al, 7 ; 'else add 7 to al , 'A' in ASCII is 65 instead of 58, 65-58 = 7


step2:
	;get the correct position to place converted char 
	;correct address = base address + string length - index of char
	;string length : 5

	mov bx, HEX_OUT + 5 
	sub bx, cx

	mov [bx], al ;move contents of al to correct position ie bx. 
	
	ror dx, 4 ;****why this?

	add cx, 1  ;- increment the loop
	jmp hex_loop

end:
	mov bx, HEX_OUT
	call print
	popa
	ret

;BASE ADDRESS
HEX_OUT:
	db '0x0000',0

