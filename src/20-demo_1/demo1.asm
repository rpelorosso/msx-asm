
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
H_TIMI  equ 0xFD9F
TIMER_MAX  equ 5

; seteamos el screen 1
ld a, 1
call CHGMOD  

; seteamos el hook para H.TIMI
call colgar_hook

; escribimos la name table para que todas las posiciones muestre el mismo char
ld a, 0
out (0x99), a       
ld a, NAME_TABLE_H + 0x40; incluimos bit de escritura
out (0x99), a       
ld a, CHAR_N ; es el pattern CHAR_N el que queremos mostrar
ld b, 0x0 ; loopear 256 veces (255+1)
di
.loop_name:
    out (98h), a
    nop
    out (98h), a
    nop
    out (98h), a
    nop
    djnz .loop_name
ei


; configuramos el color del CHAR_N
ld a, CHAR_N/8  ; coloreamos el bloque de 8 caracteres donde está CHAR_N
out (0x99), a       
ld a, COLOR_TABLE_H + 0x40 ; incluimos bit de escritura
out (0x99), a       
ld a, 0xb5
out (98h), a

; volvemos a basic
ret


; tile: DB 36, 153, 66, 66, 66, 66, 153, 36
tile: DB 0, 48, 72, 72, 132, 3, 0, 0

copiar_char:
    di
    ld a, CHAR_N*8  ; fila 0, CHAR_N
    out (0x99), a
    ld a, GEN_TABLE_H + 0x40 
    out (0x99), a       
    ld hl, tile
    ld b, 8
    ld c, 0x98
    .loop:
      outi
      jp nz, .loop
    ei
ret

shift_char: 
    ld b, 8
    ld hl, tile
    .loop:
        rlc (hl)
        rlc (hl)
        rlc (hl)
        inc hl
        djnz .loop
ret

colgar_hook:
    di                  ; deshabilitamos interrupciones
    ld a, 0xc3		    ; guardamos el opcode de la instrucción jp en A
	ld (H_TIMI), a      ; escribimos el valor de a (el opcode) en la dirección H_TIMI
    ld hl, animar         ; guardamos en hl la posicion de memoria de hook
    ld (H_TIMI+1), hl   ; escribimos en H_TIMI+1 el valor de hl
    ei                  ; habilita interrupciones
ret

animar:
    push af             ; guarda A y F, porque A será modificado
    ld a, (timer)       ; guarda en A el valor del timer
    dec a               ; decrementa A
    ld (timer), a       ; regraba el valor del timer en memoria
    jp nz, finish_hook  ; si Z != 0, termina la atencion, no queremos imprimir nada
   
    ld a, TIMER_MAX     ; como Z == 0, A = 0, entonces reiniciamos el timer. Setea A = TIMER_MAX
    ld (timer), a       ; guarda A en memoria

    call shift_char
    call copiar_char

    finish_hook:    
    pop af          ; reestablece A y F
ret                 

timer: db TIMER_MAX