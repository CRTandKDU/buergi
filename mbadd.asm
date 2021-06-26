;; ---------------------------------------------------------------- 
;; Multi-byte addition HL = HL+DE
MBADD	or a,a
	ld b,W
MBADDL	ld a,(de)
	adc a,(hl)
	ld (hl),a
	inc hl
	inc de
	djnz MBADDL
	ret		       ; Forget the last carry when overflow
