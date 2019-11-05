[bits 32]
;define constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f ;color byte for each char

print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY

print_string_pm_loop:
    mov al, [ebx] ;ebx is the addr of our char
    mov ah, WHITE_ON_BLACK

    cmp al, 0
    je print_string_pm_done

    ;placing each char in each memory address of VGA
    ;ebx - for character
    ;edx - for memory address
    mov [edx], ax ;store char + attr in video memory
    add ebx, 1
    add edx, 2

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret