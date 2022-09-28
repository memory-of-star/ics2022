; I/O System for 86-DOS version 0.60 and later. Revised 04/28/81.

; Assumes a CPU Support card at F0 hex for character I/O,
; with disk drivers for Tarbell, Cromemco, or North Star controllers.

; Select whether the auxiliary port is the Support Card parallel port
; or on channel 1 of a Multiport Serial card addressed at 10H.
PARALLELAUX:	EQU	1
SERIALAUX:	EQU	0

; Select whether the printer is connected to the Support card parallel
; output port (standard) or channel 0 of a Multiport Serial card
; addressed at 10H.
PARALLELPRN:	EQU	1
SERIALPRN:	EQU	0

; If the Multiport Serial was chosen for either the auxiliary or the printer,
; select the baud rate here. Refer to Multiport Serial manual page 11 to
; pick the correct value for a given baud rate.
PRNBAUD:EQU	7		;1200 baud
AUXBAUD:EQU	0FH		;19200 baud

; Select disk controller here
TARBELL:EQU	1
CROMEMCO:EQU	0
NORTHSTAR:EQU	0

; If North Star controller is selected, stop here. If Cromemco or Tarbell
; controllers are selected, a configuration must also be selected below:

	IF	TARBELL+CROMEMCO

; For either disk controller, a custom drive table may be defined
CUSTOM:	EQU	0

; If Tarbell disk controller, select one-sided or two-sided drives
; and single or double density controller
DOUB1SIDE:EQU	0
DOUB2SIDE:EQU	1
SNGL1SIDE:EQU	0

; If Cromemco disk controller, select drive configuration
SMALLCRO:EQU	0		;3 small drives
COMBCRO:EQU	0		;2 large drives and 1 small one
LARGECRO:EQU	0		;4 large drives

;Use table below to select head step speed. Step times for 5" drives are double
;that shown in the table. Times for Fast Seek mode (Cromemco controller with
;PerSci drives) is very small - 200-400 microseconds.

; Step value	1771	1791

;     0		 6ms	 3ms
;     1		 6ms	 6ms
;     2		10ms	10ms
;     3		20ms	15ms

STPSPD:	EQU	2

	ENDIF		;End of selections for 1771/1791 controllers

;****************************************************************************

DOSSEG:	EQU	80H

	ORG	0
	PUT	100H

BASE:	EQU	0F0H
SIOBASE:EQU	10H
STAT:	EQU	BASE+7
DATA:	EQU	BASE+6
DAV:	EQU	2
TBMT:	EQU	1
SERIAL:	EQU	SERIALPRN+SERIALAUX

	IF	SERIALAUX
AUXSTAT:EQU	SIOBASE+3
AUXDATA:EQU	SIOBASE+2
	ENDIF

	IF	PARALLELAUX
AUXSTAT:EQU	BASE+13
AUXDATA:EQU	BASE+12
	ENDIF

	IF	SERIALPRN
PRNSTAT:EQU	SIOBASE+1
PRNDATA:EQU	SIOBASE+0
	ENDIF

	IF	PARALLELPRN
PRNSTAT:EQU	BASE+13
PRNDATA:EQU	BASE+12
	ENDIF

	JMP	INIT
	JMP	STATUS
	JMP	INP
	JMP	OUTP
	JMP	PRINT
	JMP	AUXIN
	JMP	AUXOUT
	JMP	READ
	JMP	WRITE
	JMP	DSKCHG

INIT:
	MOV	AL,0FFH		;Mask all interrupts
	OUT	BASE+3		;Send mask to slave
	XOR	AX,AX
	MOV	SS,AX
	MOV	SP,400H		;Set stack just below I/O system
	PUSH	CS
	POP	DS

	IF	SERIAL
	MOV	SI,SERTAB
	MOV	CX,4
SERINIT:
	LODB
	OUT	SIOBASE+1
	OUT	SIOBASE+3
	LOOP	SERINIT
	LODB			;Baud rate for channel 0
	OUT	SIOBASE+8
	LODB			;Baud rate for channel 1
	OUT	SIOBASE+9
	ENDIF

	MOV	SI,INITTAB
	CALL	0,DOSSEG
	MOV	DX,100H
	MOV	AH,26		;Set DMA address
	INT	21H
	MOV	CX,[6]		;Get size of segment
	MOV	BX,DS		;Save segment for later
;DS must be set to CS so we can point to the FCB
	MOV	AX,CS
	MOV	DS,AX
	MOV	DX,FCB		;File Control Block for COMMAND.COM
	MOV	AH,15
	INT	21H		;Open COMMAND.COM
	OR	AL,AL
	JNZ	COMERR		;Error if file not found
	XOR	AX,AX
	MOV	[FCB+33],AX	;Set 4-byte Random Record field to
	MOV	[FCB+35],AX	;   beginning of file
	INC	AX
	MOV	[FCB+14],AX	;Set record length field
	MOV	AH,39		;Block read (CX already set)
	INT	21H
	JCXZ	COMERR		;Error if no records read
	TEST	AL,1
	JZ	COMERR		;Error if not end-of-file
;Make all segment registers the same
	MOV	DS,BX
	MOV	ES,BX
	MOV	SS,BX
	MOV	SP,5CH		;Set stack to standard value
	XOR	AX,AX
	PUSH	AX		;Put zero on top of stack for return
	MOV	DX,80H
	MOV	AH,26
	INT	21H		;Set default transfer address (DS:0080)
	PUSH	BX		;Put segment on stack
	MOV	AX,100H
	PUSH	AX		;Put address to execute within segment on stack
	RET	L		;Jump to COMMAND

COMERR:
	MOV	DX,BADCOM
	MOV	AH,9		;Print string
	INT	21H
	EI
STALL:	JP	STALL

	IF	SERIAL
SERTAB:	DB	0B7H, 77H, 4EH, 37H, PRNBAUD, AUXBAUD
	ENDIF

BADCOM:	DB	13,10,"Error in loading Command Interpreter",13,10,"$"
FCB:	DB	1,"COMMAND COM"
	DS	25

STATUS:
	IN	STAT
	AND	AL,DAV
	RET	L

INP:
	IN	STAT
	AND	AL,DAV
	JZ	INP
	IN	DATA
	AND	AL,7FH
	RET	L

OUTP:
	PUSH	AX
OUTLP:
	IN	STAT
	AND	AL,TBMT
	JZ	OUTLP
	POP	AX
	OUT	DATA
	RET	L

PRINT:
	PUSH	AX
PRINLP:
	IN	PRNSTAT
	AND	AL,TBMT
	JZ	PRINLP
	POP	AX
	OUT	PRNDATA
	RET	L

AUXIN:
	IN	AUXSTAT
	AND	AL,DAV
	JZ	AUXIN
	IN	AUXDATA
	RET	L

AUXOUT:
	PUSH	AX
AUXLP:
	IN	AUXSTAT
	AND	AL,TBMT
	JZ	AUXLP
	POP	AX
	OUT	AUXDATA
	RET	L

;* * * * * * * * * * * * * * * * * * * * * * * * * * * *

	IF	CROMEMCO+TARBELL

WD1791:	EQU	DOUB1SIDE+DOUB2SIDE
WD1771:	EQU	CROMEMCO+SNGL1SIDE

	IF	WD1791
READCOM:EQU	80H
WRITECOM:EQU	0A0H
	ENDIF

	IF	WD1771
READCOM:EQU	88H
WRITECOM:EQU	0A8H
	ENDIF

	IF	TARBELL
DONEBIT:EQU	80H
DISK:	EQU	78H
DLYTIM:	EQU	10		;24 usec delay after force interrupt
	ENDIF

	IF	CROMEMCO
DONEBIT:EQU	1
DISK:	EQU	30H
DLYTIM:	EQU	22		;52 usec delay after force interrupt
	ENDIF

DSKCHG:
	MOV	AH,0
	SEG	CS
	CMP	AL,[CURDRV]
	JNZ	RETL
	IN	DISK
	AND	AL,20H		;Look at head load bit
	JZ	RETL
	MOV	AH,1
RETL:	RET	L

READ:
	CALL	SEEK		;Position head
	JC	ERROR
RDLP:
	PUSH	CX
	CALL	READSECT	;Perform sector read
	POP	CX
	JC	ERROR
	INC	DH		;Next sector number
	LOOP	RDLP		;Read each sector requested
	OR	AL,AL
	RET	L

WRITE:
	CALL	SEEK		;Position head
	JC	ERROR
WRTLP:
	PUSH	CX
	CALL	WRITESECT	;Perform sector write
	POP	CX
	JC	ERROR
	INC	DH		;Bump sector counter
	LOOP	WRTLP		;Write CX sectors
	OR	AL,AL
	RET	L

ERROR:
	SEG	CS
	MOV	B,[DI],-1
	RET	L

SEEK:

; Inputs:
;	AL = Drive number
;	BX = Disk transfer address in DS
;	CX = Number of sectors to transfer
;	DX = Logical record number of transfer
; Function:
;	Seeks to proper track.
; Outputs:
;	AH = Drive select byte
;	DL = Track number
;	DH = Sector number
;	SI = Disk transfer address in DS
;	DI = pointer to drive's track counter in CS
; CX unchanged.

	MOV	AH,AL
	SEG	CS
	XCHG	AL,[CURDRV]
	CMP	AL,AH		;Changing drives?
	JZ	SAMDRV
;If changing drives, unload head so the head load delay one-shot
;will fire again. Do it by seeking to same track the H bit reset.
	IN	DISK+1		;Get current track number
	OUT	DISK+3		;Make it the track to seek to
	MOV	AL,10H		;Seek and unload head
	CALL	DCOM
	MOV	AL,AH		;Restore current drive number
SAMDRV:
	MOV	SI,BX		; Save transfer address
	CBW
	MOV	BX,AX		; Prepare to index on drive number
	SEG	CS
	MOV	AL,[BX+DRVTAB]
	OUT	DISK+4		; Select drive

	IF	CROMEMCO
	OR	AL,80H		;Set auto-wait bit
	ENDIF

	MOV	AH,AL		;Save for later
	XCHG	AX,DX
	MOV	DL,26		;26 sectors per track

	IF	CROMEMCO
	TEST	DH,10H		;Check if small disk
	JNZ	BIGONE
	MOV	DL,18		;18 sectors on small disk track
BIGONE:
	ENDIF

	IF	DOUB1SIDE
	TEST	DH,8		;Check for double density
	JZ	SMALSECT
	MOV	DL,8		;8 sectors on double density tracks
SMALSECT:
	ENDIF

	IF	DOUB2SIDE
	TEST	DH,8		;Check for double density
	JZ	SMALSECT
	MOV	DL,8		;8 sectors on double density tracks
	DIV	AL,DL		;AL=track (2 tracks per cylinder)
	SHR	AL		;AL=cylinder, CY=side
	XCHG	AX,DX
	JNC	HAVPOS
	OR	AH,40H		;Select back side
	MOV	AL,AH
	OUT	DISK+4		;Send to drive select port
	JP	HAVPOS
SMALSECT:
	ENDIF

	DIV	AL,DL		;Compute track and sector
	XCHG	AX,DX
HAVPOS:
	INC	DH		;Sectors start at one, not zero
	SEG	CS
	MOV	BL,[BX+TRKPT]	;Get this drive's displacement into track table
	ADD	BX,TRKTAB	;BX now points to track counter for this drive
	MOV	DI,BX
	MOV	AL,DL
	SEG	CS
	XCHG	AL,[DI]		;Xchange current track with desired track
	OUT	DISK+1		;Inform controller chip of current track
	CMP	AL,DL
	JZ	ONTRK
	MOV	BH,3		;Seek retry count
	CMP	AL,-1		;Head position known?
	JNZ	NOHOME		;If not, home head
TRYSK:
	CALL	HOME
NOHOME:
	MOV	AL,DL
	OUT	DISK+3
	MOV	AL,1CH+STPSPD
	CALL	MOVHEAD
	AND	AL,98H
	JZ	ONTRK
	DEC	BH
	JNZ	TRYSK
	STC
ONTRK:
	RET

SETUP:
	IF	CROMEMCO
	TEST	AH,10H		;Check for small disk
	JNZ	CHKSTP
	CMP	DH,18		;Only 18 sectors/track on small ones
	JA	STEP
	ENDIF

	IF	DOUB1SIDE
	TEST	AH,8		;Check for double density
	JZ	CHKSTP
	CMP	DH,8		;Only 8 sectors/track on DD disks
	JA	STEP
	ENDIF

	IF	DOUB2SIDE
	TEST	AH,8		;Check for double density
	JZ	CHKSTP
	CMP	DH,8
	JBE	PUTSEC
	XOR	AH,40H		;Flip side number
	MOV	AL,AH
	OUT	DISK+4		;And send to drive select port
	TEST	AL,40H		;See if step is necessary
	JZ	STEP		;If now on side 0, we must step
	JP	FIRSEC
	ENDIF

CHKSTP:
	CMP	DH,26		;Check for overflow onto next track
	JBE	PUTSEC
STEP:
	INC	DL
	MOV	AL,58H		;Step in with update
	CALL	DCOM
	SEG	CS
	INC	B,[DI]		;Update track counter
FIRSEC:
	MOV	DH,1		;First sector on track
PUTSEC:
	MOV	AL,DH
	OUT	DISK+2

	IF	CROMEMCO
	MOV	AL,AH
	OUT	DISK+4		;Turn on auto-wait
	ENDIF

	DI			;Interrupts not allowed until I/O done
	IN	DISK		;Get head load bit
	NOT	AL
	AND	AL,20H		;Check head load status
	JZ	RET
	MOV	AL,4
	RET

READSECT:
	CALL	SETUP
	MOV	BL,10
RDAGN:
	OR	AL,READCOM
	OUT	DISK
	MOV	BP,SI
RLOOP:
	IN	DISK+4

	IF	TARBELL
	SHL	AL
	JNC	RDONE
	ENDIF

	IF	CROMEMCO
	SHR	AL
	JC	RDONE
	ENDIF

	IN	DISK+3
	MOV	[SI],AL
	INC	SI
	JP	RLOOP
RDONE:
	EI			;Interrupts OK now
	CALL	GETSTAT
	AND	AL,9CH
	JZ	FORCINT
	MOV	SI,BP
	MOV	AL,0
	DEC	BL
	JNZ	RDAGN
	STC
FORCINT:
	MOV	AL,0D0H		;Force Interrupt command for type I status
	OUT	DISK
	MOV	AL,DLYTIM
INTDLY:
	DEC	AL		;Does not affect carry
	JNZ	INTDLY		;Minimum loop time (19 clocks)=2.375 usec
	RET

WRITESECT:
	CALL	SETUP
	MOV	BL,10
WRTAGN:
	OR	AL,WRITECOM
	OUT	DISK
	MOV	BP,SI
WRLOOP:
	IN	DISK+4
	
	IF	TARBELL
	SHL	AL
	JNC	WRDONE
	ENDIF

	IF	CROMEMCO
	SHR	AL
	JC	WRDONE
	ENDIF

	LODB
	OUT	DISK+3
	JP	WRLOOP
WRDONE:
	EI
	CALL	GETSTAT
	AND	AL,0FCH
	JZ	FORCINT
	MOV	SI,BP
	MOV	AL,0
	DEC	BL
	JNZ	WRTAGN
	STC
	JP	FORCINT

HOME:
	IF	CROMEMCO
	TEST	AH,40H		;Check seek speed bit
	JNZ	RESTORE
	ENDIF

	MOV	BL,3
TRYHOM:
	MOV	AL,0CH+STPSPD
	CALL	DCOM
	AND	AL,98H
	JZ	RET
	MOV	AL,58H+STPSPD	;Step in with update
	CALL	DCOM
	DEC	BL
	JNZ	TRYHOM
	RET

MOVHEAD:
	IF	CROMEMCO
	TEST	AH,40H		;Check seek speed bit
	JNZ	FASTSK
	ENDIF

DCOM:
	OUT	DISK
	PUSH	AX
	AAM			;Delay 10 microseconds
	POP	AX
GETSTAT:
	IN	DISK+4
	TEST	AL,DONEBIT

	IF	TARBELL
	JNZ	GETSTAT
	ENDIF

	IF	CROMEMCO
	JZ	GETSTAT
	ENDIF

	IN	DISK
	RET

	IF	CROMEMCO
RESTORE:
	MOV	AL,0C4H		;READ ADDRESS command to keep head loaded
	OUT	DISK
	MOV	AL,77H
	OUT	4
CHKRES:
	IN	4
	AND	AL,40H
	JZ	RESDONE
	IN	DISK+4
	TEST	AL,DONEBIT
	JZ	CHKRES
	IN	DISK
	JP	RESTORE		;Reload head
RESDONE:
	MOV	AL,7FH
	OUT	4
	CALL	GETSTAT
	MOV	AL,0
	OUT	DISK+1		;Tell 1771 we're now on track 0
	RET

FASTSK:
	MOV	AL,6FH
	OUT	4
	MOV	AL,18H
	CALL	DCOM
SKWAIT:
	IN	4
	TEST	AL,40H
	JNZ	SKWAIT
	MOV	AL,7FH
	OUT	4
	MOV	AL,0
	RET
	ENDIF

CURDRV:	DS	1

	IF	SMALLCRO-1	;Don't need if only small drives
LDRIVE:
	DW	128	;Size of physical sector
	DB	4	;Sectors per allocation unit
	DW	52	;Reserved sectors
	DB	2	;Number of file allocation tables
	DW	64	;Number of directory entries
	DW	2002	;Number of physical sectors on disk
	ENDIF

	IF	SMALLCRO+COMBCRO
SDRIVE:
	DW	128
	DB	2
	DW	54
	DB	2
	DW	64
	DW	720
	ENDIF

	IF	DOUB1SIDE
;Drive A is drive 0, single density
;Drive B is drive 1, single density
;Drives C to F are drive 0 to 3, double density
DRVTAB:	DB	0,10H,8,18H,28H,38H
TRKPT:	DB	0,1,0,1,2,3
TRKTAB:	DB	-1,-1,-1,-1
INITTAB:DB	6
	DW	LDRIVE
	DW	LDRIVE
	DW	DDRIVE
	DW	DDRIVE
	DW	DDRIVE
	DW	DDRIVE
	DW	0
	DW	30

DDRIVE:
	DW	1024
	DB	1
	DW	1
	DB	2
	DW	96
	DW	616
	ENDIF

	IF	DOUB2SIDE
;Drive A is drive 0, side 0, single density
;Drive B is drive 0, side 1, single density
;Drive C is drive 1, side 0, single density
;Drive D is drive 1, side 1, single density
;Drive E is drive 0, both sides, double density
;Drive F is drive 1, both sides, double density
DRVTAB:	DB	0,40H,10H,50H,8H,18H
TRKPT:	DB	0,0,1,1,0,1
TRKTAB:	DB	-1,-1
INITTAB:DB	6
	DW	LDRIVE
	DW	LDRIVE
	DW	LDRIVE
	DW	LDRIVE
	DW	D2DRIVE
	DW	D2DRIVE
	DW	0
	DW	30

D2DRIVE:
	DW	1024
	DB	1
	DW	1
	DB	2
	DW	128
	DW	1232
	ENDIF

	IF	SNGL1SIDE
DRVTAB:	DB	0F2H,0E2H,0D2H,0C0H
TRKPT:	DB	0,1,2,3
TRKTAB:	DB	-1,-1,-1,-1
INITTAB:DB	4		;Number of drives
	DW	LDRIVE
	DW	LDRIVE
	DW	LDRIVE
	DW	LDRIVE
	DW	0		;Minimum buffer space
	DW	30		;Stack space
	ENDIF

; Cromemco drive select byte is derived as follows:
;	Bit 7 = 0
;	Bit 6 = 1 if fast seek (PerSci)
;	Bit 5 = 1 (motor on)
;	Bit 4 = 0 for 5", 1 for 8" drives
;	Bit 3 = 1 for drive 3
;	Bit 2 = 1 for drive 2
;	Bit 1 = 1 for drive 1
;	Bit 0 = 1 for drive 0

	IF	LARGECRO
; Table for four large drives
DRVTAB:	DB	71H,72H,74H,78H
TRKPT:	DB	0,0,1,1
TRKTAB:	DB	-1,-1
INITTAB:DB	4	;Number of drives
	DW	LDRIVE
	DW	LDRIVE
	DW	LDRIVE
	DW	LDRIVE
	DW	0
	DW	30
	ENDIF

	IF	COMBCRO
; Table for two large drives and one small one
DRVTAB:	DB	71H,72H,24H
TRKPT:	DB	0,0,1
TRKTAB:	DB	-1,-1
INITTAB:DB	3	;Number of drives
	DW	LDRIVE
	DW	LDRIVE
	DW	SDRIVE
	DW	0
	DW	30
	ENDIF

	IF	SMALLCRO
; Table for 3 small drives
DRVTAB:	DB	21H,22H,24H
TRKPT:	DB	0,1,2
TRKTAB:	DB	-1,-1,-1
INITTAB:DB	3
	DW	SDRIVE
	DW	SDRIVE
	DW	SDRIVE
	DW	0
	DW	30
	ENDIF

	IF	CUSTOM
; Table for 2 large drives without fast seek
DRVTAB:	DB	31H,32H
TRKPT:	DB	0,1
TRKTAB:	DB	-1,-1

INITTAB:DB	2
	DW	LDRIVE
	DW	LDRIVE
	DW	0
	DW	30
	ENDIF

	ENDIF			;End of 1771/1791 disk drivers

; * * * * * * * * * * * * * * * * * * * * * * *

	IF	NORTHSTAR

; North Star disk controller addresses.
;
DSKSEG:	EQU	0FE80H		; `F' is for extended address modification.
WRTADR:	EQU	200H
CMMND:	EQU	300H
DRVSEL:	EQU	1H
WRTSEC:	EQU	4H
STPOFF:	EQU	8H
STPON:	EQU	9H
NOP:	EQU	10H
RSETSF:	EQU	14H
STPOUT:	EQU	1CH
STPIN:	EQU	1DH
BSTAT:	EQU	20H
RDBYTE:	EQU	40H
MOTOR:	EQU	80H
;
; Status bits.
;
TK0:	EQU	01H		; Track 0 bit.
WP:	EQU	02H		; Write protect bit.
BDY:	EQU	04H		; Data body (sync byte) found.
WRT:	EQU	08H		; Write bytes status flag.
MO:	EQU	10H		; Motor on.
SF:	EQU	80H		; Indicates sector hole was detected.
;
; Delay times in sectors for various disk functions.
;
MOTORD:	EQU	31		; Motor up-to-speed time (1 second).
HEADD:	EQU	14		; Head-load settle time.  Actually, the head
				;  doesn't require this much time to settle,
				;  but this much time is required to
				;  synchronize the sector counter.
STEPD:	EQU	2		; Step time.  One or two only.
				;  1 -> 20mS, 2 -> 40mS.
;
; Various numbers of things.
;
NSECT:	EQU	10		; 10 North Star sectors per track.
NTRACK:	EQU	35		; 35 tracks on standard SA-400 drive.
ERRLIM:	EQU	10		; Number of soft errors.
;
; READ and WRITE functions.
; AL = drive number.
; CX = Number of sectors to transfer.
; DX = Logical record number.
; DS:BX = Transfer address.
;
READ:	
	MOV	AH,1		; AH = 1 to read.
	JP	READWRITE
WRITE:
	MOV	AH,0		; AH = 0 to write.
READWRITE:
	CMP	DX,350		; See if too large a sector number is requested
	JB	SECTOROK	; Jump if OK.
	STC			; Set CY flag to indicate error.
	RET	L		; Quit immediatly.
SECTOROK:
	MOV	SI,BX		; Transfer address to SI & DI.
	MOV	DI,BX
	UP			; Set direction flag for autoincrement.
	PUSH	ES		; Store extra segment.
	MOV	BX,DS		; Put data segment in extra segment.
	MOV	ES,BX
	PUSH	DS		; Save data segment.
	MOV	BX,DSKSEG	; DS is North Star controller segment.
	MOV	DS,BX
	PUSH	AX		; Store read/write flag.
	CBW			; Drive number is sixteen bits.
	MOV	BX,AX		; Put in BX.
	MOV	AX,DX		; Compute track & sector.
	MOV	DL,NSECT	; Ten sectors/track.
	DIV	AL,DL		; AL = track number, AH = sector number.
	MOV	CH,AH		; Sector number to CH.
	PUSH	CX		; Save sector number & number of sectors.
	MOV	DH,AL		; Put track number in DH.
	SEG	CS		; TRACKTAB is in the code segment.
	MOV	AH,[BX+TRACKTAB]	; Find out what the current track is.
	SEG	CS
	MOV	[BX+TRACKTAB],DH	; Update TRACKTAB.
	MOV	BP,CMMND+MOTOR+STPIN	; Assume step direction is in.
	MOV	CL,DH		; Put track number in CL.
	SUB	CL,AH		; Calculate how many steps required.
	JAE	DIRECTION	; Direction is correct if >= 0.
	DEC	BP		; Direction is out (STPOUT = STPIN-1).
	NEG	CL		; Make number of steps positive.
DIRECTION:
	IF	STEPD-1		; Multiply number of steps by two if step delay
	SAL	CL		;  is 40mS per step.
	ENDIF
	TEST	B,[CMMND+MOTOR+NOP],MO	; Turn motors on & check MO status.
	JZ	MOTORS		; If motors were off, wait for them to start.
	SEG	CS		; OLDDRIVE is in the code segment.
	CMP	BL,[OLDDRIVE]	; See if the correct drive is selected.
	JNZ	SELECT		; If wrong drive is selected, select right one.
	JP	SEEK		; Motors on, drive selected, go and step.
MOTORS:
	MOV	DL,MOTORD	; Wait for motors to come up to speed.
	CALL	WSECTOR
SELECT:
	CALL	ONESECT		; Wait for write gate to go off.
	MOV	AL,[BX+CMMND+MOTOR+DRVSEL]	; Select new drive.
	SEG	CS		; OLDDRIVE is in code segment.
	MOV	[OLDDRIVE],BL	; Update OLDDRIVE.
	MOV	DL,HEADD-1	; Full head load delay (-1 because waiting for
				;  the correct sector delays at least one more)
	MOV	AL,CL		; See if we've ever used the drive before.
	IF	STEPD-1		; Compute the actual number of steps if 40mS
	SAR	AL		;  step delay is used.
	ENDIF
	CMP	AL,NTRACK	; If the number of steps is >= NTRACK, we can't
	JAE	HEADDELAY	;  count on step time for head load delay.
	SUB	DL,CL		; Subtract stepping time.
	JB	SEEK		; Don't wait if we'll step long enough for the
				;  head to settle & the sector counter to sync.
HEADDELAY:
	CALL	WSECTOR
SEEK:
	IF	STEPD-1		; Convert back to the actual number of steps
	SAR	CL		;  rather than step time if the step time
	ENDIF			;  is 40mS per step.
	XOR	CH,CH		; CX = CL.
	JCXZ	SEEKCOMPLETE	; Jump if we're already there.
	SEG	DS		; BP normally uses stack segment.
	MOV	AL,[BP]		; Set the step direction.
	CALL	ONESECT		; Wait for the write gate to turn off.
;
; Step routine.  Step direction has already been given to the disk
; controller.  DH has destination track number.
; CX has number of sectors to step, >= 1.
; If track zero is ever reached, the head position is recalibrated using DH.
;
STEP:
	MOV	AL,[CMMND+MOTOR+NOP]	; Get `A' status.
	ROR	AL		; Track 0 bit to CF.
	JNC	STEPOK		; Recalibrate if track zero.
	MOV	CL,DH		; Track # to step count.
	JCXZ	SEEKCOMPLETE	; If destinination = 0, we're there.
	MOV	AL,[CMMND+MOTOR+STPIN]	; Set direction.
STEPOK:
	MOV	AL,[CMMND+MOTOR+STPON]
	AAM			; Waste time for > 10 uS.
	MOV	AL,[CMMND+MOTOR+STPOFF]
	MOV	DL,STEPD	; Step time (sectors).
	CALL	WSECTOR
	LOOP	STEP		; Loop till we get there.
SEEKCOMPLETE:
	POP	CX		; Restore sector number & number of sectors.
	MOV	BP,BX		; Put drive number in BP.
SECTORLOOP:
	MOV	DH,ERRLIM	; Soft error limit.
ERRORRETRY:
	DI			; Interrupts illegal till after read, write,
WAITSECTOR:			;  or error.
	CALL	ONESECT		; Wait for next sector to come by.
	MOV	AL,[CMMND+MOTOR+BSTAT+NOP]	; Get `B' status.
	AND	AL,0FH		; Mask to sector number.
	CMP	AL,CH
	JNE	WAITSECTOR	; Wait till the one we want comes by.
	POP	AX		; Get function.
	PUSH	AX		; Back on the stack for next time.
	AND	AH,AH		; AH = 1 -> read, AH = 0 -> write.
	JZ	WRITESECTOR	; Jump if write.
;
READSECTOR:
	MOV	SI,CMMND+MOTOR+RDBYTE+NOP
	PUSH	CX		; Save sector number and number of sectors.
	MOV	CX,352		; Time limit for sync byte.  352 passes through
				;  the loop @ 35 clocks/pass = 24 byte times.
RSYNCLP:
	TEST	B,[CMMND+MOTOR+NOP],BDY
	LOOPZ	RSYNCLP		; Test for sync byte. Loop till sync or timeout
	JZ	ERROR		; Didn't find sync byte.  Jump to error return.
READSECT:
	MOV	CX,256		; Byte count.
	MOV	DL,CL		; CRC = 0.
READLOOP:
	AAD			; Waste time >= 7.5 uS.
	MOV	AL,[SI]		; Read a byte.
	STOB			; Store byte.
	XOR	DL,AL		; Compute CRC.
	ROL	DL
	LOOP	READLOOP	; Loop for 256 bytes.
	AAD			; Waste time >= 7.5 uS.
	MOV	AL,[SI]		; Get CRC from disk.
	CMP	AL,DL		; Same as computed?
	JE	NEXTSECTOR	; Jump if sucessful read.
ERROR:
	EI			; Intrrupts OK now.
	POP	CX		; Get sector number & number of sectors.
	SUB	DI,256		; Fix-up the index for retry.
	DEC	DH		; Decrement error count.
	JNZ	ERRORRETRY	; Wait for the sector to come by again.
	POP	AX		; Pop junk off the stack.
	POP	DS
	POP	ES
	XOR	CH,CH		; CX is number of sectors left to read.
	STC			; Set CY flag to indicate error.
	RET	L		; Return.
;
WRITESECTOR:
	TEST	B,[CMMND+MOTOR+NOP],WP
	JZ	NOTPROT		; Jump if not protected.
	EI			; Interrupts OK now.
	POP	AX		; Pop junk off the stack.
	POP	DS
	POP	ES
	XOR	CH,CH		; CX = number of sectors left to write.
	STC			; Set CY flag to indicate error.
	RET	L
NOTPROT:
	PUSH	CX		; Save sector number and number of sectors.
	MOV	AL,[CMMND+MOTOR+WRTSEC]
WWRT:
	TEST	B,[CMMND+MOTOR+NOP],WRT
	JZ	WWRT		; Loop till WRT bit goes high.
	MOV	CX,15		; Number of zeros to write.
	MOV	BX,WRTADR	; Address to write zeros.
WRTZERO:
	MOV	AL,[BX]		; Write a zero.
	AAD			; Waste time for >= 7.5 uS.
	LOOP	WRTZERO		; Write 15 of them.
	MOV	BL,0FBH		; Sync byte.
	MOV	AL,[BX]		; Write sync byte.
	AAD			; Waste time for >= 7.5 uS.
	MOV	CX,256		; Byte count.
	MOV	DL,CL		; CRC = 0.
WRTBYTE:
	SEG	ES		; Data is in extra segment.
	LODB			; Get write data.
	MOV	BL,AL		; Data to BL to write.
	MOV	AL,[BX]		; Write it.
	AAD			; Waste time for >= 7.5 uS.
	XOR	DL,BL		; Compute CRC.
	ROL	DL
	LOOP	WRTBYTE		; Write 256 bytes.
	MOV	BL,DL		; Write CRC byte.
	MOV	AL,[BX]
;
NEXTSECTOR:
	EI			; Interrupts OK now.
	POP	CX		; Get sector count.
	DEC	CL		; Decrement sector count.
	JZ	OKRETURN	; Return if done.
	INC	CH		; Increment sector number.
	CMP	CH,10		; Compare with number of sectors on track.
	JAE	NEEDSTEP
	JMP	SECTORLOOP	; Read another sector from same track.
NEEDSTEP:
	MOV	CH,0		; Reset sector number.
	CALL	ONESECT		; Wait for write gate to go off.
	MOV	AL,[CMMND+MOTOR+STPIN]
	MOV	AL,[CMMND+MOTOR+STPON]
	AAM			; Wait > 10 uS for step pulse width.
	MOV	AL,[CMMND+MOTOR+STPOFF]
	SEG	CS		; BP normally uses stack segment.
	INC	B,[BP+TRACKTAB]	; Increment the track table.
				; We don't have to wait for STEPD because
				;  waiting for the write gate to go off caused
				;  us to blow the sector and we have to wait
				;  a whole revolution anyway.
	JMP	SECTORLOOP	; Read a sector from the new track.
OKRETURN:
	POP	AX		; Get function, AH=0 -> write, AH=1 -> read.
	POP	DS		; Get original data & extra segments.
	POP	ES
	CLC			; No errors.
	RET	L
;
; Wait for sector routine.  ONESECT waits for the next sector.
; WSECTOR waits the number of sectors given by DL.
;
ONESECT:
	MOV	DL,1		; Wait for next sector.
WSECTOR:
	MOV	AL,[CMMND+MOTOR+RSETSF]
SECTLOOP:
	MOV	AL,[CMMND+MOTOR+NOP]
	TEST	AL,SF		; Check sector flag.
	JZ	SECTLOOP	; Loop till new sector.
	DEC	DL		; Decrement sector count.
	JNZ	WSECTOR		; Loop till zero.
	RET
;
DSKCHG:
	MOV	AH,0		; AH = 0 in case we don't know.
	SEG	CS
	CMP	AL,[OLDDRIVE]	; See if that's the last drive used.
	JNE	RETL		; Return if not.
	PUSH	DS		; See if the motors are still on.
	PUSH	BX
	MOV	BX,DSKSEG
	MOV	DS,BX
	TEST	B,[CMMND+NOP],MO	
	POP	BX
	POP	DS
	JZ	RETL		; Motors off, disk could be changed.
	MOV	AH,1		; If motors on, assume disk not changed.
RETL:
	RET	L
;
; Disk initialization tables.
;
INITTAB:
	DB	3		; Three drives.
	DW	DPT,DPT,DPT	; Address of disk parameter tables.
	DW	0		; Minimum buffer space
	DW	30		; Stack space
;
DPT:
	DW	256		; Sector size.
	DB	1		; One sector per allocation unit.
	DW	30		; Number of sectors allocated to system.
	DB	2		; Two allocation tables.
	DW	64		; Number of directory entries.
	DW	350		; Number of sectors on the disk.
;
; Storage locations for the disk drivers.
;
OLDDRIVE:
	DB	0		; Old drive will be number 0 after boot.
TRACKTAB:
	DB	2		; Drive 0 will be on track 2 after boot.
	DB	NTRACK-1+NTRACK-1+24	; Number of steps to restore the head
	DB	NTRACK-1+NTRACK-1+24	;  if never used before.

	ENDIF			; End North Star disk drivers
