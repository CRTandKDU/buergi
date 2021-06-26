;; ----------------------------------------------------------------
;; Partial product of number at HL by E
;; Range/Length in B, Carry = 0 in C, F with carry flag at 0
;; Zeroed W-byte buffer at NBUF
;; Result in buffer at NBUF
PPROD	push de
	push hl
	ld a,(hl)
	ld h,a
	push af
	push bc
	call MULT8
	pop bc
	pop af
	ld a,c
	adc a,l
	ld d,a
	ld a,0
	adc a,h
	ld c,a
	pop hl
	ld (hl),d
	inc hl
	pop de
	djnz PPROD
	ret
