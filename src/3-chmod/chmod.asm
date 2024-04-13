;
;   Utiliza la función del bios CHMOD para iniciar el modo 1 de pantalla
;   No hace falta hacer un loop para que no salga el programa, porque modo 1 soporta texto
;

.ZILOG
.BASIC
.ORG 0xC000

CHGMOD equ 0x005F

ld a, 1      ; a = 1
call CHGMOD  ; llama a funcion del bios que cambia el modo gráfico que indica el registro A
ret