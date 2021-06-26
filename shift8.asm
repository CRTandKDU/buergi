RSHIFT	push hl
	push bc
	ld c,W-1
	ld b,0
	add hl,bc
	ld b,W-1
RSLOOP	dec hl
	ld a,(hl)
	inc hl
	ld (hl),a
	dec hl
	djnz RSLOOP
	ld (hl),0
	pop bc
	pop hl
	djnz RSHIFT
	ret
