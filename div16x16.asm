	;; See: TRS-80 Assembly Language Programming, p.143
	;; Entry: HL = dividend, DE = divisor
	;; Exit:  B = max(255,quotient); HL = remainder
	;; Used:  A, C
DIV1616	ld bc,0
D1616LP	or a,a
	sbc hl,de
	jr C, D1616X
	inc bc
	ld a,b
	cp 0
	jrz D1616LP
	ld c,255
D1616X	ld b,c
	add hl,de
	ret
	
