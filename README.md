# msx-asm
Ejemplos para assembler de Z80 para MSX. Escritos para asmsx. PRs son bienvenidos.

## Ejemplos:

### chput

Usa la rutina de bios CHPUT para imprimir un caracter especial.

<img src="img/chput.png" width="35%"/>

### print

Usa llamadas a la rutina del bios CHPUT para imprimir una cadena de caracteres.

<img src="img/print.png" width="35%"/>

### chputvdp

Escribe la NAME TABLE para dibujar un asterisco en la pantalla en modo 0 utilizando llamados al VDP.

<img src="img/chputvdp.png" width="35%"/>

### printvdp

Escribe la NAME TABLE para escribir un string en pantalla utilizando un loop.

<img src="img/printvdp.png" width="35%"/>

### h_timi 

Atiende a la interrupción de VBlank, H.TIMI

<img src="img/h_timi.png" width="35%"/>

### write_register

Escribe un registro del VDP para cambiar el color de fondo y frente.

<img src="img/writereg.png" width="35%"/>

### chmod

Inicializa un modo gráfico utilizando una llamada a la función CHMOD del bios.

<img src="img/chmod.png" width="35%"/>

### sprites

Escribe la tabla de atributos de sprites, y registros del VDP para mostar un sprite en screen 1.

<img src="https://github.com/rpelorosso/msx-asm/assets/6107574/a3ef9b42-a830-4c35-b790-6103e25a5f32" width="35%"/>

### dump_to_vram 

Escribe una imagen guardada en RAM a VRAM.

<img src="img/dump_to_vram.png" width="35%"/>


## Demos

Programitas que usan funciones de los ejemplos pequeños para hacer cosas más complejas.

### demo 0 

Modifica un tile y lo muestra en toda la pantalla.

<img src="img/demo.png" width="35%"/>

### demo 1

Modifica un tile y lo muestra en toda la pantalla, pero también lo anima en cada VBlank, desplazandolo a la izquierda.

<img src="img/demo1.gif" width="35%"/>

### demo 2

Muestra un sprite y lo mueve en cada VBlank

<img src="img/demo2.gif" width="35%"/>


