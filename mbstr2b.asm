;; ----------------------------------------------------------------
;; Convert STR to binary, HL points to str, uses NBUF, NTMP
STR2B	ld de,NTMP
	ld a,(hl)
	cp 0
	ret z			; Exit with value in NBUF
	sub '0'
	ld (de),a
	push hl			; Keep STR pointer
	ld hl,NBUF
	ld b, W
	ld c, 0
	or a, a
	call MBMUL10
	ld hl,NBUF
	ld de,NTMP
	call MBADD
	pop hl
	inc hl
	jr STR2B
