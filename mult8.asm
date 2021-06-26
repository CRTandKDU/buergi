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
