## Interrupciones

LLamados a interrupciones deshabilitan interrupciones, así que hay que llamar a `ei` al finalizar.  

También pushean y popean registros automátimcamente, salvo en el caso de H.TIMI, donde hay que restaurar A.

### H.TIMI

```
H_TIMI:      equ 0xFD9F		; Hook memory adress
```

Al finalizar el barrido de pantalla. Hay que restaurar el registro A al finalizar.


### H.KEYI

```
H_KEYI:      equ 0xFD9A		; Hook memory adress
```

