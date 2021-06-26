;; ----------------------------------------------------------------
;; Length of number at HL - W returned in A
MBLEN	ld a,W - 1
	ld b,0
WHLEN	cp b
	jrz OUTLEN
	ld c,a
	dec hl
	ld a,(hl)
	cp 0
	ld a,c
	jrz NXTLEN
	ld b,a
	jr WHLEN
NXTLEN	dec a
	jr WHLEN
OUTLEN	inc a
	ret
