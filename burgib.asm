;; ----------------------------------------------------------------
;; Second step of the Bürgi transform
BURGIB	ld de,XSEQ
	ld hl,XSEQ + W
	ld b,14
BURBN	push bc
	push hl
	push de
	call MBADD
	pop hl
	ld b,0
	ld c,W
	add hl,bc
	ex de,hl
	pop hl
	add hl,bc
	pop bc
	djnz BURBN
	ret
