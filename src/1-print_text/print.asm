;
;   Usa llamados a la función del bios CHPUT para imprimir una cadena de caracteres
;

.ZILOG
.BASIC
.ORG 0xC000
CHPUT  equ     0x00A2

start:
    ld hl, texto             ; hl apunta a la dirección del string
    loop:                   ; comienza el loop
        ld a, (hl)          ; carga en el registro A el byte apuntado por hl
        call CHPUT          ; llama CHPUT, que imprime el caracter de código A
        inc hl              ; mueve el puntero hl a la posición siguiente
        and a               ; setea el flag z si a = 0
        ret z               ; si z=0 (o sea a=0) termina
        jr loop             ; sino vuelve a comenzar el loop

texto: 
    db  "Hola!!!! esto es una prueba :)", 0    ; el string a mostrar, que termina en 0
