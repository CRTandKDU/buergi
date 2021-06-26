;; ----------------------------------------------------------------
;; 16b by 8b division HL = HL / E, remainder in A
DIV16x8	xor a
	ld b,16
D16x8L	add hl,hl
	rla
	cp e
	jr c,D16x8N
	sub e
	inc l
D16x8N	djnz D16x8L
	ret
;; ----------------------------------------------------------------
;; Multi-byte division by E, carry in C, of number at HL-B, len in B
MBPDIV	dec hl
	ld a,(hl)
	push hl
	ld l,a
	ld h,c
	ld c,e
	push bc
	call DIV16x8
	pop bc
	ld e,c
	ld c,a
	ld a,l
	pop hl
	ld (hl),a
	djnz MBPDIV
	ret
	
;; Expected prolologue			
;; START	ld hl,DIVD + 3
;; 		ld b,3
;; 		ld c,0
;; 		ld e,10
;; 		call MBPDIV
