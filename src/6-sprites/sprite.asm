.ZILOG
.BASIC
.ORG 0xC000

CHGMOD equ 0x005F
SPR_BASE_ATTR equ  0x1B
WRITE_REG equ 0x047

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
    ld a, SPR_BASE_ATTR + 64
    out (0x99), a               ; byte superior dir + bit escritura

    ; ahora escribimos coordenadas, número y color, recordar que
    ; cuando se manda un dato al vdp, el puntero a memoria de vdp se incrementa automaticamente

    ld a, 120           ; coordenada y
    out (98h), a
    ld a, 90            ; coordenada x
    out (98h), a
    ld a, 3             ; numero de sprite
    out (98h), a
    ld a, 0x8           ; color
    out (98h), a






