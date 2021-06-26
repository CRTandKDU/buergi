	org 6000H
W	equ 8		
;; START	ld hl,DIVD + W
;; 	call MBLEN
;; 	add a, '0'
;; 	call 0033H
;; 	ld a,10
;; 	call 0033H
;; START	ld hl,DIVD + W
;; 	call MBLEN
;; 	ld b,a
;; 	ld c,0
;; 	ld e,10
;; 	ld hl,DIVD
;; 	or a,a
;; 	push bc			; Keep length in B
;; 	call PPROD
;; 	pop de			; Pops length in D
;; 	ld a,W
;; 	cp d
;; 	jrz FINISH		; Assumes D <= W
;; 	ld (hl),c 		; Last carry in C
;; START	ld hl,DIVD + 3
;; 	ld b,3
;; 	ld c,0
;; 	ld e,10
;; 	call MBPDIV
;; START	ld hl,DIVD
;; 	ld b,W
;; 	ld c,0
;; 	or a,a
;; 	call MBMUL10
START	ld hl,DIVD+3
	ld b,3
	ld de,BCDSTR+20
	dec de
	dec de
	call B2STR
	push de
	ld a,0
	ld (409cH),a
	pop hl
	call 2f0aH
FINISH	jp 06ccH
include 'mbdiv10.asm'
include 'mbb2str.asm'	
; ----------------------------------------------------------------
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
;; Test data
DIVD	defb	193, 210, 4, 0, 0, 0, 0, 0
NBUF	dc	W, 0
NTMP	dc	W, 0
NBCD	defb	'316097', 0
BCDSTR	dc	20,0	
	end START
