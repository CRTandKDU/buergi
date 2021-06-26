	org 6000H
W	equ 8		
	;; ----------------------------------------------------------------
START	ld hl,NBCD
	call STR2B
FINISH	jp 06ccH
	;; ----------------------------------------------------------------
STR2B	;; Convert STR to binary
	ld a,(hl)
	cp 0
	ret z
	sub '0'
	push hl			; Keep STR pointer
	push af			; Keep A for multi-byte add
	ld hl, NBUF + W		; Preprocess partial prod
	call LENGTH
	ld b,a
	ld c,0
	ld e,10
	ld hl, NBUF
	or a,a
	push bc
	call PPROD
	pop de			; Postprocess partial prod
	ld a,W
	cp d
	jrz SSKIP
	ld (hl),c
SSKIP	pop af
	ld hl,NTMP
	ld (hl),a
	ld de,NBUF
	ex de,hl
	call ADDING
	pop hl
	inc hl
	jr STR2B
	;; ----------------------------------------------------------------
	;; Multi-byte addition HL = HL+DE
ADDING	or a,a
	ld b,W
ALOOP	ld a,(de)
	adc a,(hl)
	ld (hl),a
	inc hl
	inc de
	djnz ALOOP
	ret		       ; Forget the last carry/overflow
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
	;; ----------------------------------------------------------------
	;; Zero buffer of W bytes at HL
ZEROBUF	ld (hl),0
	ld c,W - 1
	ld b,0
	ld d,h
	ld e,l
	inc de
	ldir
	ret
	;; ----------------------------------------------------------------
	;; Multiply 8-bit values HL = H * E
MULT8	ld d,0
	ld l,d
	ld b,8
M8LOOP	add hl,hl
	jrnc M8SKIP
	add hl,de
M8SKIP	djnz M8LOOP	
	ret
	;; ----------------------------------------------------------------
	;; Length of number at HL - W returned in A
LENGTH	ld a,W - 1
	ld b,0
WHLEN	cp b
	jrz OUTLEN
	ld c,a
	dec hl
	ld a,(hl)
	cp 0
	ld a,c
	jrz NXTLEN
	ld b,a
	jr WHLEN
NXTLEN	dec a
	jr WHLEN
OUTLEN	inc a
	ret
	;; ----------------------------------------------------------------
	;; Test data
DIVD	defb	193, 210, 4, 0, 0, 0, 0, 0
NBUF	defb	0, 0, 0, 0, 0, 0, 0, 0
NTMP	defb	0, 0, 0, 0, 0, 0, 0, 0
NBCD	defb	'316097', 0	
	end START
