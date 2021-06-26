;; ---------------------------------------------------------------- 
;; Multi-byte subtraction HL = DE - HL
MBSUB	or a,a
	ld b,W
MBSUBL	ld a,(de)
	sbc a,(hl)
	ld (hl),a
	inc hl
	inc de
	djnz MBSUBL
	ret		       ; Forget the last carry when underflow
