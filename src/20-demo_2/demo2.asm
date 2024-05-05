.ZILOG
.BASIC
.ORG 0xC000

CHGMOD equ 0x005F
SPR_BASE_ATTR equ  0x1B
WRITE_REG equ 0x047
H_TIMI  equ 0xFD9F

;HKEYI:	equ $fd9a ; Called at the beginning of the KEYINT interrupt routine
;HTIMI:	equ $fd9f ; Called by the KEYINT interrupt routine when Vblank interrupt occurs

start:
    ld a, 1
    call CHGMOD  ; screen 1, asi podemos salir

    ; escribimos el registro 6 para que la tabla de patrones de sprites 
    ; apunte a la tabla de patrones de tiles, asi podemos mostrar caracteres
    ; como sprites. En lugar de hacer llamados a out, podemos usar WRITE_REG
    ;
    ; 0x47
    ; in: Registro en C,  data en B
    ; out: Modifica AF,BC

    ld c, 6     ; registro
    ld b, 0     ; dato
    call WRITE_REG

    ; ahora hacemos que esten magnificados

    ld c, 1         ; registro
    ld b, 0x61      ; 0x60 es el valor por defecto. 
                    ; +1 para encender el bit de magnificacion de sprites
    call WRITE_REG

    ; mostramos un sprite
    ; mandamos al VDP la direccion del sprite en la tabla de atributos

    ld a, 0x00
    out (0x99), a               ; byte inferior dir
    ld a, SPR_BASE_ATTR + 0x40  ; byte superior dir + bit escritura
    out (0x99), a               

    ; ahora escribimos coordenadas, número y color, recordar que
    ; cuando se manda un dato al vdp, el puntero a memoria de vdp se incrementa automaticamente

    ld a, 30           ; coordenada y
    out (98h), a
    ld a, 90            ; coordenada x
    out (98h), a
    ld a, 3             ; numero de sprite
    out (98h), a
    ld a, 0x2          ; color
    out (98h), a

    call set_hook

ret

set_hook: 
    di                  ; deshabilitamos interrupciones
    ld a, 0xc3		    ; guardamos el opcode de la instrucción jp en A
	ld (H_TIMI), a      ; escribimos el valor de a (el opcode) en la dirección H_TIMI
    ld hl, animar         ; guardamos en hl la posicion de memoria de hook
    ld (H_TIMI+1), hl   ; escribimos en H_TIMI+1 el valor de hl
    ei                  ; habilita interrupciones
ret

animar:
    push af
    ld a, (posicion_x)
    inc a                       ; incrementamos la posicion
    ld (posicion_x), a
    ld b, a                     ; guardamos nueva posicion en b
    ; escribimos la nueva posicion del sprite
    ld a, 0x00 
    out (0x99), a               ; byte inferior dir
    ld a, SPR_BASE_ATTR + 0x40  ; byte superior dir + bit escritura
    out (0x99), a  
    ld a, b
    out (0x98), a  
    pop af
    ei
ret

posicion_x: DB 0


