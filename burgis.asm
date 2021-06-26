	;; --------------------------------------------------------------------
	;; Exit from program printing sines at current approximation
SINES	call 01c9H		; Clear screen
	ld a,0			; Init angle counter to 0 deg.
	ld (PREDEG),a
	call PTITLE		; Center 1st line title
	ld de,64		; Init cursor for printing sines
	ld hl,CURCOL1
	add hl,de
	ld (CURSOR),hl
	ld (NCURSOR),hl
	ld hl,XSEQE
	call MBLEN
	ld (NLENDEN),a		; Keep track of precision required
	ld hl,XSEQE		; Last in series is divisor
	ld de,DIVB
	ld bc,W
	ldir
	ld hl,XSEQ		; Init dividend with 1st in series
	push hl
	ld de,DIVA
	ld bc,W
	ldir
	ld c,0
	ld b,14			; Main sine line loop
OUTDCOL	push bc
	ld hl,(NCURSOR)
	ld de,64
	add hl,de
	ld (CURSOR),hl
	ld (NCURSOR),hl
	ld hl,(PREDEG)
	ld de,6
	add hl,de
	ld (PREDEG),hl
	;; --------------------------------------------------------------------
	;; Initialized DIVA, DIVB
	call MBLDIV		; Perform mb long divide
	call PDEG		; Print angle in deg.
	ld hl,PREFIX
	call 2f0aH
	call EPILOG		; Print sine first limb
	ld a,(NLENDEN)		; Adjust iterations for precision
	ld e,a
	ld d,0
	ld hl, NDENARR
	add hl,de
	ld b,(hl)
NDENLP	push bc	
	call ZDIVBUF
	call SCUP10		; Perform mb ldiv on remainder
	call EPILOG		; Print next limb
	pop bc
	djnz NDENLP
	;; --------------------------------------------------------------------
	ld hl,XSEQE		; Re-init dividend and divisor
	ld de,DIVB
	ld bc,W
	ldir
	pop bc
	pop hl
	ld de,W
	add hl,de
	push hl
	push bc
	ld de,DIVA
	ld bc,W
	ldir
	pop bc
	djnz OUTDCOL
	;; --------------------------------------------------------------------
	ld hl,QINFO		; Print command menu
	call 2f0aH
	call 049H		; Wait for key press
	jp FINISH		; Return to BASIC
	;; ----------------------------------------------------------------
ZDIVBUF	ld b,W			; Zero BCDSTR, TRIALQ (REM, DIV?)
	ld hl,TRIALQ
	ld a,0
ZLOOP1	ld (hl),a
	inc hl
	djnz ZLOOP1
ZBCDSTR	ld b,20
	ld hl,BCDSTR
ZLOOP2	ld (hl),a	
	inc hl
	djnz ZLOOP2
	ret
	;; ----------------------------------------------------------------
	;; Print angle
PDEG	ld hl,(PREDEG)
	ld a,l
	cp 6
	jr nz,PDEG1
	ld a,32			; Print space
	call 032aH
PDEG1	ld hl,(PREDEG)
	call 0a9aH		; HL to ACC
	ld hl,PREBUF
	call 0fbdH		; Convert to string
	call 2f0aH		; Print
	ld a,32			; Print space
	call 032aH
	ret
	;; ----------------------------------------------------------------
	;; Print centered title
PTITLE	ld hl,STITLE
	ld bc,64
	ld a,0
	cpir
	srl c
	ld hl,VIDEO
	ld d,0
	ld e,c
	add hl,de
	ld (CURSOR),hl
	ld hl,STITLE
	call 2f0aH
	ret
	;; ----------------------------------------------------------------
	;; Print result
EPILOG	ld b,W-1
	ld ix,TRIALQ
LSHIFT	ld a,(ix+1)
	ld (ix),a
	inc ix
	djnz LSHIFT
	ld a,0
	ld (ix),a
	;; --------------------------------------------------------------------
	call ZBCDSTR
	ld hl,TRIALQ+W-1
	ld b,W-1
	ld de, BCDSTR+18
	call B2STR
	push de
	pop hl
	call 2f0aH		; Output string
	ret

