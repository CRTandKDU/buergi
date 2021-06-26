	;; See: TRS-80 Assembly Language Programming, p.144-145
	;; Entry: HL = 16b dividend; D = 8b divisor
	;; Exit:  IX = 16b quotient; H = 8b remainder
	;; Used:  L, D, E, A
DIV16	ld a,l
	ld l,h
	ld h,0
	ld e,0
	ld b,16
	ld ix,0
D16LP 	add hl,hl
	rla
	jrnc D16LP1
	inc l
D16LP1 	add ix,ix
	inc ix
	or a
	sbc hl,de
	jrnc D16CT
	add hl,de
	dec ix
D16CT	djnz D16LP
	ret
