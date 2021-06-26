	;; --------------------------------------------------------------------
MBLDIV	call FACTOR		; Scaling factor f in B
	push bc
	ld hl,DIVA
	ld de,REM
	ld bc,W
	ldir			; Copy DIVA to REM
	ld hl,DIVB
	ld de,DIV
	ld bc,W
	ldir			; Copy DIVB to DIV
	pop bc
	;; --------------------------------------------------------------------
	ld a,b
	cp 1
	jrz SCUP10
	ld e,b			; Prepare to scale by f != 1
	push bc
	ld b,W
	ld c,0
	or a,a
	ld hl,REM
	call PPROD		; Scale REM by f
	pop bc			; Prepare to scale by f
	ld e,b
	ld b,W
	ld c,0
	or a,a
	ld hl,DIV
	call PPROD		; Scale DIV by f
	;; --------------------------------------------------------------------
SCUP10	ld hl,REM+W		; Scale-up 10^n times
	call MBLEN		; as much as possible in W bytes
	cp W
	jrz PREPM
	ld e,10
	ld b,W
	ld c,0
	or a,a
	ld hl,REM
	call PPROD
	jr SCUP10
	;; --------------------------------------------------------------------
PREPM	ld hl, DIV+W
	call MBLEN
	ld c,a
	ld a,W
	sub c
	push af			; Keep number of iterations in A
	;; --------------------------------------------------------------------
MAIND	pop af
	cp 0
	ret z			; Exit point: return if zero
	dec a
	push af
	;; --------------------------------------------------------------------
	ld hl, DIV		; Main LDIV loop
	ld de, DIVB		; Copy DIV to DIVB
	ld bc, W
	ldir
	ld hl, DIVB		; Is REM > DIVB=DIV ?
	ld de, REM
	call MBSUB
	jr NC,TRIALD		; Jump to trial quotient
	ld b,1			; If not, quotient = 0 and shift right
	ld hl,TRIALQ
	call RSHIFT
	jr MAIND
	;; --------------------------------------------------------------------
TRIALD	ld de, REM+W		; Trial quotient 
T2REM	dec de			; Find hi 2 bytes of REM
	ld a,(de)
	cp 0
	jrz T2REM
	ld h,a
	dec de
	ld a,(de)
	ld l, a			; hi 2b in HL
	;; --------------------------------------------------------------------
	ld de, DIV+W
T1DIV	dec de			; Find hi byte of DIV
	ld a,(de)
	cp 0
	jrz T1DIV		; hi 1b in a
	;; --------------------------------------------------------------------
	ld e,a
	ld d,0
	call DIV1616		; Trial quotient in B
	;; Check if > 256?
	;; --------------------------------------------------------------------
	ld hl,TRIALQ
	ld (hl),b
DECQ	ld hl, DIV		
	ld de, DIVB		; Copy DIV to DIVB
	ld bc, W
	ldir
	ld hl,TRIALQ		; Trial B*DIVB
	ld e,(hl)
	ld b,W
	ld c,0
	or a,a
	ld hl,DIVB
	call PPROD
	;; --------------------------------------------------------------------
	ld hl, REM+W		; Difference of lengths REM-DIV
	call MBLEN
	push af
	ld hl, DIV+W
	call MBLEN
	ld c,a
	pop af
	sub a,c
	dec a
	jrz RSSKIP		; Right shift if a>0
	ld b,a
	ld hl, DIVB
	call RSHIFT
RSSKIP	or a,a
	ld hl, DIVB		; Is REM > DIVB ?
	ld de, REM
	call MBSUB
	jrnc NEXTQ
	ld hl,TRIALQ
	dec (hl)		; Check for trialq = 0 -> error
	jr DECQ
	;; --------------------------------------------------------------------
NEXTQ	ld b,1			; Keep quotient and shift right
	ld hl,TRIALQ
	call RSHIFT
	ld hl, DIVB		; Copy remainder to REM
	ld de, REM
	ld bc, W
	ldir
	jp MAIND
	;; --------------------------------------------------------------------
FACTOR	ld hl,DIVB+W		; Scale 256 // (v_{n-1} + 1)
LOOPF	dec hl
	ld a,(hl)
	cp 0
	jrz LOOPF
	inc a
	;; ld e,a
	;; ld h,1
	;; ld l,0
	;; call DIV16x8		; Result in HL
	ld e,a
	ld d,0
	ld h,1
	ld l,0
	call DIV1616		; Quotient in b
	ret
