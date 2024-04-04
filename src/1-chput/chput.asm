;
;   Usa llamados a la función del bios CHPUT para imprimir un caracter especial.
;   Caracteres comunes no requieren la impresión de un caracter especial.
;   Ver: https://www.msx.org/wiki/MSX_Characters_and_Control_Codes#International_codes

.ZILOG
.BASIC
.ORG 0xC000
CHPUT  equ     0x00A2

start:
    ld a, 0x01          ; carga en el registro A el valor 0x01. Este es un caracter de control necesario para imprimir la carita
    call CHPUT          ; llama CHPUT, que imprime el caracter de código A

    ld a, 0x41          ; carga en el registro A el valor 0x41, que es el valor de la carita
    call CHPUT          ; llama CHPUT, que imprime el caracter de código A
    ret
