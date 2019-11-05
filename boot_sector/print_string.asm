;push the register that contains the string to the stack
print:
	pusha

;move contents of bx to al
;if(al==0) pop register and exit
;else 
start:
	mov al, [bx]
	cmp al, 0
	je done
	;initialisation
	mov ah, 0x0e ;shift out
	int 0x10	; interrupt data link escape

	;move each bit of bx register to al and increment it by 1
	add bx,1
	jmp start

done:
	popa
	ret

;print a newline character '\n'
print_n1:
	pusha
	mov ah, 0x0e ; 0x0e - shift out
	mov al,0x0a	; 0x0a - newline - move cursor down to next line
	int 0x10
	mov al, 0x0d ;carriage return - move cursor to beginning of line
	int 0x10

	popa
	ret


