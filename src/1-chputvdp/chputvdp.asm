;
;   Escribe un asterisco en la posición (0,0) escribiendo la NAME TABlE en la memoria de video
;   Primero manda la dirección en dos partes, byte inferior y byte superior. 
;   Hay que mandar 01000000 00000000, el 1 para indicar escritura, mientras que la posición de memoria a escribir será 0
;   Entonces escribe 0, y luego 01000000 (0x40)
;   Luego envía el dato a escribir, 0x24, que corresponde al asterisco
;

.ZILOG
.BASIC
.ORG 0xC000

NAME_TABLE equ 0x40 ; byte superior, incluye bit de escritura

ld a, 0
out (0x99), a       ; escribe el byte inferior (0) al puerto 0x99

ld a, NAME_TABLE
out (0x99), a       ; escribe el byte superior (NAME_TABLE) al puerto 0x99

ld a, 0x2A           
out (98h), a        ; escribe el valor 0x2A (caracter asterisco) en el puerto 0x98

