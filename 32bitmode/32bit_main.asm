[org 0x7c00]
    mov bp, 0x9000 ;set the stack
    mov sp, bp
   
    mov bx, MSG_REAL_MODE
    call print

    call switch_to_pm 
    jmp $

%include "print_string.asm"
%include "gdt.asm"
%include "32bitprint.asm"
%include "gdt_switchreg.asm"

[bits 32]
BEGIN_PM:
    mov ebx , MSG_PROT_MODE
    call print_string_pm
    jmp $

MSG_REAL_MODE db "Started real mode",0
MSG_PROT_MODE db "Loaded protected mode",0

times 510-($-$$) db 0
dw 0xaa55