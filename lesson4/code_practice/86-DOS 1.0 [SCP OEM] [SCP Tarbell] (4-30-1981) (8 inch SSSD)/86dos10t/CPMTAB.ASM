;Source code for drive tables used by RDCPM

	ORG	0
	PUT	100H

	DW	END		;Address of first free byte

;Table of addresses of the parameter block for each of 16 drives.
;Note that 16 entries are ALWAYS required, with unused drives 0.

	DW	IBM,IBM,IBM,IBM	;Four standard drives
	DW	0,0,0,0
	DW	0,0,0,0
	DW	0,0,0,0

;Below is the definition for standard single-density 8" drives

IBM:
	DW	26	;Sectors per track
	DB	3	;Block shift
	DB	7	;Block mask
	DS	1
	DW	242	;Disk size - 1
	DW	63	;Directory entries - 1
	DS	4
	DW	2	;Tracks to skip
	DW	MOD6	;Modulo-6 sector translate table

MOD6:
	DB	0,6,12,18,24
	DB	4,10,16,22
	DB	2,8,14,20
	DB	1,7,13,19,25
	DB	5,11,17,23
	DB	3,9,15,21

END:
