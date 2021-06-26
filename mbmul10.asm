;; ----------------------------------------------------------------
;; Multi-byte multiplication by 10, carry in C, B is size (W)
MBMUL10	ld a,(hl)
	push hl
	ld h,0
	rla
	ld l,a
	ld e,a
	ld a,h
	rla
	ld h,a
	ld d,a
	ld a,l
	rla
	ld l,a
	ld a,h
	rla
	ld h,a
	ld a,l
	rla
	ld l,a
	ld a,h
	rla
	ld h,a
	add hl,de
	ld a,c
	add a,l
	pop de
	ld (de),a
	ld a,h
	adc a,0
	ld c,a
	ex de,hl
	inc hl
	djnz MBMUL10
	ret
;; Usage:
;; 	ld hl,NBUF
;; 	ld b, W
;; 	ld c, 0
;; 	or a, a
;; 	call MBMUL10
	
