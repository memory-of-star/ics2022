; Disk initialization routine for 1771/1791 type disk controllers.
; Runs on 8086 under 86-DOS

; Translated from the Z80 on 12-19-80 and subsequently upgraded to handle
; all of the following controllers. Set switch to one to select.

TARBELLSINGLE:	EQU	0	;Tarbell single density controller
TARBELLDOUBLE:	EQU	1	;Tarbell DD in single density mode
CROMEMCOLARGE:	EQU	0	;Cromemco 4FDC with PerSci drives
CROMEMCOSMALL:	EQU	0	;Cromemco 4FDC with 5" drives
DOUBLEDENS:	EQU	0	;Tarbell DD in double density mode

STPSPD:	EQU	2

;********************************************************************

TARBELL:	EQU	TARBELLSINGLE + TARBELLDOUBLE + DOUBLEDENS
CROMEMCO:	EQU	CROMEMCOLARGE + CROMEMCOSMALL

LARGE:	EQU	CROMEMCOLARGE + TARBELLSINGLE + TARBELLDOUBLE
SMALL:	EQU	CROMEMCOSMALL

	IF	TARBELL
DISK:	EQU	78H
DONEBIT:EQU	80H
	ENDIF

	IF	CROMEMCO
DISK:	EQU	30H
DONEBIT:EQU	1
	ENDIF

	IF	SMALL
SECCNT:	EQU	18
TRKCNT:	EQU	40
TRKNUM:	EQU	12
SECSIZ:	EQU	165
	ENDIF

	IF	LARGE
SECCNT:	EQU	26
TRKCNT:	EQU	77
TRKNUM:	EQU	80
SECSIZ:	EQU	186
	ENDIF

	IF	DOUBLEDENS
SECCNT:	EQU	8
TRKCNT:	EQU	77
TRKNUM:	EQU	162
SECSIZ:	EQU	1138
	ENDIF

SYSTEM:	EQU	5
SELDRV:	EQU	14
SIDNUM:	EQU	TRKNUM+1
SECNUM:	EQU	SIDNUM+1

	ORG	100H
	PUT	100H

	MOV	BX,PATTERN
	MOV	DX,PATTAB
	CALL	MAKE		;Pattern for index mark and one sector
	MOV	CL,SECCNT-1	;Repeat once for each remaining sector
MAKSEC:
	MOV	DX,SECPAT
	CALL	MAKE
	DEC	CL
	JNZ	MAKSEC
	CALL	MAKE
;Put in sequential sector numbers
	MOV	AL,1		;Start with sector number 1
	MOV	CL,AL		;Add one to each succeeding sector number
	MOV	BX,PATTERN+SECNUM
	CALL	PUTSEC
	MOV	CL,9
	MOV	DX,HEADER
	CALL	SYSTEM
EACH:
	MOV	SP,5CH
	XOR	AX,AX
	PUSH	AX
	MOV	CL,9
	MOV	DX,DRVMES
	CALL	SYSTEM
	MOV	CL,1
	CALL	SYSTEM
	CMP	AL,13
	JZ	RET
	AND	AL,5FH
	SUB	AL,'A'
	JC	EACH
;Check if valid drive
	MOV	DH,AL
	MOV	DL,-1
	MOV	AH,SELDRV
	INT	33		;Get number of drives
	CMP	DH,AL
	JNC	EACH
;Look up drive select and side number bytes
	MOV	AL,DH
	MOV	[DRIVE],AL	;Save for finish operation
	MOV	BX,SELTAB
	XLAT
	OUT	DISK+4

	IF	CROMEMCO
	OR	AL,80H
	MOV	[SELBYT],AL
	ENDIF

	MOV	BX,SIDTAB
	MOV	AL,DH
	XLAT
	MOV	BX,PATTERN+SIDNUM
	MOV	CL,0
	CALL	PUTSEC		;Put side byte in each sector
	MOV	AL,08H+STPSPD	;Restore without verify
	MOV	CH,0C0H
	CALL	DCOM
INTRK:
	MOV	AL,CL
	CALL	TRACK
	INC	CL
	MOV	AL,CL
	CMP	AL,TRKCNT
	JZ	FINI
	MOV	AL,58H+STPSPD	;Step in to next track
	MOV	CH,0C0H
	CALL	DCOM
	JP	INTRK
FINI:
	MOV	AL,08H+STPSPD	;Restore without verify
	MOV	CH,98H
	CALL	DCOM
;Do a read on track zero so that the track location counters in the I/O system
; will agree with the actual head position.
	MOV	AL,[DRIVE]
	MOV	BX,FREE
	MOV	CX,1
	MOV	DX,0
	INT	25H		;Direct BIOS call to READ
	POPF
	JMP	EACH

PUTSEC:
	MOV	CH,SECCNT
	MOV	DX,SECSIZ
SEC:
	MOV	[BX],AL
	LAHF
	ADD	BX,DX
	RCR	SI
	SAHF
	RCL	SI
	ADD	AL,CL
	DEC	CH
	JNZ	SEC
	RET

MAKE:
	MOV	SI,DX
	LODB
	LAHF
	INC	DX
	SAHF
	OR	AL,AL
	JZ	RET
	MOV	CH,AL
	MOV	SI,DX
	LODB
	LAHF
	INC	DX
	SAHF
PUTPAT:
	MOV	[BX],AL
	LAHF
	INC	BX
	SAHF
	DEC	CH
	JNZ	PUTPAT
	JP	MAKE

TRACK:
	MOV	BX,PATTERN+TRKNUM
	MOV	CL,0
	CALL	PUTSEC		;Add track numbers
	MOV	CL,AL
;Perform WRITE TRACK

	IF	CROMEMCO
	MOV	AL,[SELBYT]
	OUT	DISK+4
	ENDIF

	MOV	AL,0F4H
	OUT	DISK
	MOV	SI,PATTERN
	MOV	CH,0E4H
	AAM			;Delay 10 microseconds
WRTLP:
	IN	DISK+4
	TEST	AL,DONEBIT

	IF	TARBELL
	JZ	WAIT
	ENDIF

	IF	CROMEMCO
	JNZ	WAIT
	ENDIF

	LODB
	OUT	DISK+3
	JP	WRTLP

DCOM:
	OUTB	DISK
	AAM			;10 Microsecond delay
WAIT:
	INB	DISK+4
	TEST	AL,001H
	JZ	WAIT
	IN	DISK
	AND	AL,CH
	JZ	RET
	MOV	CL,9
	MOV	DX,ERRMES
	CALL	SYSTEM
	JMP	EACH


HEADER:	DB	13,10,"Diskette Initialization Routine",13,10
	DB	"Completely re-formats any bad disk--"
	DB	"destroying its contents, of course!",13,10,"$"
DRVMES:	DB	13,10,"Initialize disk in which drive? $"
ERRMES:	DB	13,10,13,10,"ERROR - Not ready or write protected",13,10,"$"

DRIVE:	DS	1

	IF	TARBELLDOUBLE
SELTAB:	DB	0,40H,10H,50H
SIDTAB:	DB	0,1,0,1
	ENDIF

	IF	TARBELLSINGLE
SELTAB:	DB	0F2H,0E2H,0D2H,0C0H
SIDTAB:	DB	0,0,0,0
	ENDIF

	IF	DOUBLEDENS
SELTAB:	DB	8,48H,18H,58H
SIDTAB:	DB	0,1,0,1
	ENDIF

	IF	CROMEMCOLARGE
SELTAB:	DB	31H,32H,34H,38H
SIDTAB:	DB	0,0,0,0
SELBYT:	DS	1
	ENDIF

	IF	CROMEMCOSMALL
SELTAB:	DB	21H,22H,24H,28H
SIDTAB:	DB	0,0,0,0
SELBYT:	DS	1
	ENDIF

	IF	DOUBLEDENS
PATTAB:
	DB	80,4EH
	DB	12,0
	DB	3,0F6H
	DB	1,0FCH
	DB	50,4EH
SECPAT:
	DB	12,0
	DB	3,0F5H
	DB	1,0FEH
	DB	3,0		;Track, side, and sector
	DB	1,3		;Sector size=1024
	DB	1,0F7H
	DB	22,4EH
	DB	12,0
	DB	3,0F5H
	DB	1,0FBH
	DB	255,0E5H
	DB	255,0E5H
	DB	255,0E5H
	DB	255,0E5H
	DB	4,0E5H
	DB	1,0F7H
	DB	54,4EH
	DB	0

	DB	255,4EH
	DB	255,4EH
	DB	255,4EH
	DB	0
	ENDIF

	IF	TARBELLDOUBLE
PATTAB:
	DB	40,-1
	DB	6,0
	DB	1,0FCH
	DB	26,-1
SECPAT:
	DB	6,0
	DB	1,0FEH
	DB	4,0
	DB	1,0F7H
	DB	11,-1
	DB	6,0
	DB	1,0FBH
	DB	128,0E5H
	DB	1,0F7H
	DB	27,-1
	DB	0

	DB	255,-1
	DB	255,-1
	DB	0
	ENDIF

	IF	TARBELLSINGLE + CROMEMCOLARGE
PATTAB:
	DB	46,0
	DB	1,0FCH
	DB	26,0
SECPAT:
	DB	6,0
	DB	1,0FEH
	DB	4,0
	DB	1,0F7H
	DB	17,0
	DB	1,0FBH
	DB	128,0E5H
	DB	1,0F7H
	DB	27,0
	DB	0

	DB	255,0
	DB	255,0
	DB	0
	ENDIF

	IF	SMALL
PATTAB:				;No index mark on small disk
SECPAT:
	DB	7,-1
	DB	4,0
	DB	1,0FEH
	DB	4,0
	DB	1,0F7H
	DB	11,-1
	DB	6,0
	DB	1,0FBH
	DB	128,0E5H
	DB	1,0F7H
	DB	1,-1
	DB	0

	DB	255,0
	DB	255,0
	DB	0
	ENDIF

FREE:	DS	80H

PATTERN:
