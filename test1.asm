	org 6000H
W	equ 8
VIDEO	equ 3c00H
CURSOR	equ 4020H
CURCOL1	equ 3c00H - 64	
CURCOL2	equ 3c00H - 64 + 20
CURCOL3	equ 3c00H - 64 + 40
START	ld a,0
	ld (409cH),a		; Output to video
NEXT	call OUTSCR
	ld hl,ICOUNT		; Set iteration
	inc (hl)
	ld a,(hl)
	add a,'0'
	ld ix,INFO
	ld (ix+2),a
	ld hl,INFO		; Print command menu
	call 2f0aH
	call 049H		; Wait for key press
	cp 'N'
	jrz NEXT
	cp 'S'
	jp z, SINES
FINISH	jp 06ccH		; Returns to BASIC
;; ----------------------------------------------------------------
;; Output a screenful of 3 columns
OUTSCR	call 01c9H		; Clear screen
	ld hl,CURCOL1
	ld (CURSOR),hl
	call OUTCOL
	call BURGIA
	ld hl,CURCOL2
	ld (CURSOR),hl
	call OUTCOL
	call BURGIB
	ld hl,CURCOL3
	ld (CURSOR),hl
	call OUTCOL
	ret
;; ----------------------------------------------------------------
;; Output one column
OUTCOL	ld b,15
	ld hl,XSEQ
MLOOP	push bc
	push hl
	call FILTMP		; Keep HL
	ld de,TMPBUF		; Copy X to buffer
	ld b,0
	ld c,W
	ldir
	ld hl,TMPBUF + W - 1	; Size = W 
	ld b,W - 1
	ld de,BCDSTR + 20
	dec de
	dec de
	call B2STR
	;; push de
	;; pop hl
	ld hl,(CURSOR)
	ld d,0
	ld e,64
	add hl,de		; Skip to next line
	ld (CURSOR),hl
	push hl
	ld hl,BCDSTR
	call 2f0aH		; Output string
	pop hl			; Readjust cursor
	ld (CURSOR),hl
	pop hl
	ld d,0
	ld e,W
	add hl,de
	pop bc
	djnz MLOOP
	ret
;; ----------------------------------------------------------------
;; Includes
include 'mbdiv10.asm'
include 'mbb2str.asm'
include	'mbadd.asm'
include 'burgia.asm'
include 'burgib.asm'
include 'burgis.asm'	
include 'mbldiv.asm'	
include 'div16x16.asm'
include 'mult8.asm'
include 'shift8.asm'
include 'mbpprod.asm'
include 'mbsub.asm'	
include 'mblen.asm'	
FILTMP	push hl
	ld hl,BCDSTR
	ld a,' '
	ld (hl),a
	ld de,BCDSTR
	inc de
	ld b,0
	ld c,19
	ldir
	ld a,0
	dec de
	ld (de),a
	pop hl
	ret
;; ----------------------------------------------------------------
;; Test data
XSEQ	defb	1,0,0,0,0,0,0,0
	defb	2,0,0,0,0,0,0,0
	defb	3,0,0,0,0,0,0,0
	defb	4,0,0,0,0,0,0,0
	defb	5,0,0,0,0,0,0,0
	defb	6,0,0,0,0,0,0,0
	defb	7,0,0,0,0,0,0,0
	defb	8,0,0,0,0,0,0,0
	defb	9,0,0,0,0,0,0,0
	defb	10,0,0,0,0,0,0,0
	defb	11,0,0,0,0,0,0,0
	defb	12,0,0,0,0,0,0,0
	defb	13,0,0,0,0,0,0,0
	defb	14,0,0,0,0,0,0,0
XSEQE	defb	16,0,0,0,0,0,0,0
TMPBUF	dc	W,0
BCDSTR	dc	20,0
	;; ----------------------------------------------------------------
ICOUNT	defb 	0	
INFO	defb	10,'( ) Press <N> to iterate, <S> for sines, <Q> to quit.',0	
QINFO	defb	10,'Press key to quit.',0
	;; ----------------------------------------------------------------
DIVA	dc	W,0
DIVB	dc	W,0
REM	dc	W,0
DIV	dc	W,0
TRIALQ	dc	W,0
NITER	defb	0	
	;; ----------------------------------------------------------------
NCURSOR	dw	0
NLENDEN	defb	0
PREFIX	defb	' 0.',0
PREDEG	dw	0
PREBUF	dc	4,0	
STITLE	defb	"====// Buergi's Kunstweg: Table of Sines //====",0
NDENARR defb	2,2,2,2,2,2,4,12,12	
	end START
