;
;   Se cuelga de la interrupción de VBlank del VDP, e imprime un caracter en cada llamado.
;   Lo que hace es escribir la instrucción <JP hook> a partir de la posición de memoria que corresponde
;   a la rutina de atención de la interrupción (guardada en la constante H_TIMI). hook es la direccion donde 
;   comienza el código que queremos ejecutar para atender la interrupción.
;
;   Hay que escribir entonces 2 posiciones, 
;   H_TIMI y H_TIMI+1, para que quede:
;
;   H_TIMI      jp
;   H_TIMI+1    hook
;

.ZILOG
.BASIC
.ORG 0xC000

H_TIMI  equ 0xFD9A
CHPUT   equ 0x00A2

start:
    di                  ; deshabilitamos interrupciones
    ld a, 0xc3		    ; guardamos el opcode de la instrucción jp en A
	ld (H_TIMI), a      ; escribimos el valor de a (el opcode) en la dirección H_TIMI
    ld hl, hook         ; guardamos en hl la posicion de memoria de hook
    ld (H_TIMI+1), hl   ; escribimos en H_TIMI+1 el valor de hl
    ei                  ; habilita interrupciones
ret

hook:
    push af             ; guarda A y F, porque A será modificado
    ld a, (timer)       ; guarda en A el valor del timer
    dec a               ; decrementa A
    ld (timer), a       ; regraba el valor del timer en memoria
    jp nz, finish_hook  ; si Z != 0, termina la atencion, no queremos imprimir nada
   
    ld a, 0xA          ; como Z == 0, A = 0, entonces reiniciamos el timer. Setea A = 10
    ld (timer), a       ; guarda A en memoria

    ld a, 0x2A          ; setea A = <codigo del asterisco>, para ser usada por CHPUT
    call CHPUT          ; imprime el caracter asterisco
finish_hook:    
    pop af              ; reestablece A y F
    ret                 ; termina

timer: db 0x10

