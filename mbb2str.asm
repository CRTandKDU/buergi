;; ----------------------------------------------------------------
;; Is quotient 0?
B2ISZ	ld b,W
	ld a,0
B2ISZL	or a,(hl)
	ret nz
	inc hl
	djnz B2ISZL
	ret
;; ----------------------------------------------------------------
;; Convert binary to str in DE, HL points to binary + length also in B
B2STR	push hl
	push bc
	push de
	ld c,0
	ld e,10
	call MBPDIV 		; quotient in HL, rem in c
	pop de
	ld a,c
	add a,'0'
	ld (de),a
	call B2ISZ		; test quotient == 0 (Z flag)
	pop bc
	pop hl
	ret z			; test quotient == 0 (Z flag)
	dec de
	jr B2STR
;; Suggested call sequence:
;; START	ld hl,DIVD+3
;; 	ld b,3
;; 	ld de,BCDSTR+20
;; 	dec de
;; 	dec de
;; 	call B2STR
	
