;
;   Escribe el 7mo registro para cambiar el color de fondo y frente
;

.ZILOG
.BASIC
.ORG 0xC000

start:

    ld a, 0x20          ; color 2 para foreground y 0 para background
    out (99h), a        ; escribimos valor a 0x99

    ld a, 0x7 + 128     ; registro 7 y +128 para poner el 7mo bit en 1
    out (99h), a        ; escribimos número de registro y 7mo bit encendido
