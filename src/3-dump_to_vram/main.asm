;
;   Loads an image encoded to match the structure of the video ram in mode 2.
;   Compile with asmsx.   
;

.ZILOG
.BASIC
.ORG 0xC000

CHGMOD equ 0x005F
NAME_TABLE equ 0x58                ; upper byte, includes bit to write
PATTERN_GENERATOR equ 0x40         ; upper byte, includes bit to write
PATTERN_COLOR equ 0x60             ; upper byte, includes bit to write

start:
    ld a, 2
    call CHGMOD  ; set screen 2

change_chars:
	ld hl, image                ; hd to store the address of the image
	xor a                       ; a = 0
	di                          
	out (99h), a                ; write lower byte 
	ld a, PATTERN_GENERATOR     
	out (99h), a                ; ouput upper byte
	ld a, 0xFF                   
    ld b, 0xFF
.loopb:
    ld c, 0x8 * 3
    .loopc:
        dec c
        ld a, (hl)
    	out (98h), a            
        inc hl
        jp nz, .loopc
    djnz .loopb


set_colors:
    ; now write color       
    ld a, 0
    out (0x99), a           ; ourput lower byte 00
	ld a, PATTERN_COLOR               
	out (0x99), a           ; output upper byte 
    di
	ld a, 0x1F              ; color to use foreground = 1, background = 15
    ld b, 0xFF              ; 255 positions per screen portion
.loopb:
    ld c, 0x8 * 3           ; loop 8*3 bytes 
    .loopc:
        dec c               ; decreace c
    	out (98h), a        ; output the color value
        inc hl              ; increase pointer to video memory
        jp nz, .loopc       
    djnz .loopb
    ei


; loop so we can see the image
loop_still:
    jp loop_still
ret

; include the image file data
include "image.asm"
ret
