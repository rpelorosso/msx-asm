.ZILOG
.BASIC
.ORG 0xC000

start:

    ld a, 0x2F
    out (0x99), a

    ld a, 7
    out (99h), a
