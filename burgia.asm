;; ----------------------------------------------------------------
;; First step of the Bürgi transform
BURGIA	ld hl,XSEQE + W
	ld b,W
	or a,a
BURAL	dec hl
	ld a,(hl)
	rra
	ld (hl),a
	djnz BURAL
	ld b,14
	ld hl,XSEQE - W
	ld de,XSEQE
BURAN	push bc
	push hl
	push de
	call MBADD
	pop hl
	ld b,0
	ld c,W
	sbc hl,bc
	ex de,hl
	pop hl
	sbc hl,bc
	pop bc
	djnz BURAN
	ret
