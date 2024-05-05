
; Usa OUTI:
; Reads from (HL) and writes to the (C) port. HL is then incremented, and B is decremented.
; C is preserved, N is reset, H, S, and P/V are undefined. Z is set only if B becomes zero after decrement, otherwise it's reset.

.ZILOG
.BASIC
.ORG 0xC000

CHGMOD equ 0x005F
GEN_TABLE_H equ 0x0 
NAME_TABLE_H equ 0x18 
COLOR_TABLE_H equ 0x20 
CHAR_N equ 1

ld a, 1
call CHGMOD  ; llama a funcion del bios que cambia el modo gráfico que indica el registro A

; escribimos la name table para que todos los tiles usen el mismo caracter
ld a, 0
out (0x99), a
ld a, NAME_TABLE_H + 0x40; incluimos bit de escritura
out (0x99), a       
ld a, CHAR_N ; es el pattern CHAR_N el que queremos mostrar
ld b, 0x0 ; loopear 256 veces (255+1)
di
.loop:
    out (98h), a
    nop
    out (98h), a
    nop
    out (98h), a
    nop
    djnz .loop
ei

; ahora escribimos el color de los tiles que están en el área de CHAR_N
ld a, CHAR_N/8  
out (0x99), a       
ld a, COLOR_TABLE_H + 0x40 ; incluimos bit de escritura
out (0x99), a       
ld a, 0x34
out (98h), a


; ahora escribimos la tabla de generación de caracteres para que muestre el patrón que queremos    
di
ld a, CHAR_N*8  ; fila 0, CHAR_N
out (0x99), a
ld a, GEN_TABLE_H + 0x40 
out (0x99), a       
; configuramos hl, b y c para usar outi
ld hl, tile
ld b, 8
ld c, 0x98
.loop_outi:
    outi
    jp nz, .loop_outi
ei
    
ret

tile: DB 36, 153, 66, 66, 66, 66, 153, 36

