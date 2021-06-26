	org 6000H
W	equ 8
VIDEO	equ 3c00H
CURSOR	equ 4020H
CURCOL1	equ 3c00H - 64	
CURCOL2	equ 3c00H - 64 + 20
CURCOL3	equ 3c00H - 64 + 40
START	ld a,0
	ld (409cH),a		; Output to video
	;; --------------------------------------------------------------------
	;; Initialize DIVA, DIVB
	;; Zero BCDSTR, TRIALQ (REM, DIV?)
	call MBLDIV
	;; --------------------------------------------------------------------
EPILOG	ld b,W-1
	ld ix,TRIALQ
LSHIFT	ld a,(ix+1)
	ld (ix),a
	inc ix
	djnz LSHIFT
	ld a,0
	ld (ix),a
	;; --------------------------------------------------------------------
	ld hl,TRIALQ+W-1
	ld b,W-1
	ld de, BCDSTR+18
	call B2STR
	push de
	pop hl
	call 2f0aH		; Output string
	ld hl,INFO		; Print command menu
	call 2f0aH
	call 049H		; Wait for key press
	cp 'N'
FINISH	jp 06ccH		; Returns to BASIC
;; ----------------------------------------------------------------
;; Includes
include 'mbldiv.asm'	
include 'mbdiv10.asm'
include 'div16x16.asm'
include 'mult8.asm'
include 'shift8.asm'
include 'mbpprod.asm'
include 'mbsub.asm'	
include 'mblen.asm'	
include 'mbb2str.asm'	
INFO	defb	10,'Press <N> to iterate, <Q> to quit.',0
DIVA	defb	0x9f, 0x53, 0xe2, 0x01, 0x0, 0x0, 0x0, 0x0
DIVB	defb	0x0c, 0x1e, 0x00, 0x00, 0x0, 0x0, 0x0, 0x0
REM	dc	W,0
DIV	dc	W,0
TRIALQ	dc	W,0
BCDSTR	dc	20,0	
	end START
