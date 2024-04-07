;
;   
;   Una adaptación de print que reemplaza el llamado al BIOS por escrituras directas a la memoria de video 
;   Es una extensión de chputvdp, donde se imprime una cadena de caracteres utilizando un loop
;

.ZILOG
.BASIC
.ORG 0xC000

NAME_TABLE equ 0x40 ; byte superior, incluye bit de escritura

ld a, 0x0
out (0x99), a       ; escribe el byte inferior (0) al puerto 0x99
ld a, NAME_TABLE + 3    ; desplazado para que aparezca más abajo y más o menos centrado
out (0x99), a       ; escribe el byte superior (grabado en A) al puerto 0x99

start:
    ld hl, texto             ; hl apunta a la dirección del string
    loop:                   ; comienza el loop
        ld a, (hl)          ; carga en el registro A el byte apuntado por hl
        out (98h), a        ; escribe el valor de A en el puerto 0x98
        inc hl              ; mueve el puntero hl a la posición siguiente
        and a               ; setea el flag z si a = 0
        ret z               ; si z=0 (o sea a=0) termina
        jp loop             ; sino vuelve a comenzar el loop

texto: 
    db  "Hola!!!! esto es una prueba :)", 0    ; el string a mostrar, que termina en 0
