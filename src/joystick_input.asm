;
; Sample code
;

	; Allow the Next paging and instructions.
	DEVICE ZXSPECTRUMNEXT

	; Generate a map file for use with Cspect.
	CSPECTMAP "project.map"

	org	$8000
;
;
;
;
;----------------------------------------------------------;
;  		         Handle Joystick input.	   	               ;
;----------------------------------------------------------;
;
;
;
;
	
MoveUp
	CALL ROM_CLS         					; Call clear screen routine from ROM.
	LD A, 'U'								; Print U.
	RST ROM_PRINT							; Print char from A.
	RET

MoveDown
	CALL ROM_CLS         					; Call clear screen routine from ROM.
	LD A, 'D'								; Print D.
	RST ROM_PRINT							; Print char from A.
	RET

MoveLeft
	CALL ROM_CLS         					; Call clear screen routine from ROM.
	LD A, 'L'								; Print L.
	RST ROM_PRINT							; Print char from A.
	RET

MoveRight
	CALL ROM_CLS         					; Call clear screen routine from ROM.
	LD A, 'R'								; Print R.
	RST ROM_PRINT							; Print char from A.
	RET

PressFire
	CALL ROM_CLS         					; Call clear screen routine from ROM.
	LD A, 'F'								; Print F.
	RST ROM_PRINT							; Print char from A.
	RET			

start:										; Program execution start here - see SAVENEX at the bottom
	INCLUDE "_constants.asm"					; Incude contstants
	INCLUDE "api_joystick.asm"				; Calls methods like: MoveUp, MoveLeft,...

	call ROM_CLS         					; Call clear screen routine from ROM.
	
gameLoop:	
	call HandleJoystickInput
	JR	gameLoop
;
;
;
;
;
;
;
;
;
;

;
; Set up the Nex output
;

		; This sets the name of the project, the start address, 
		; and the initial stack pointer.
		SAVENEX OPEN "project.nex", start, $FF40

		; This asserts the minimum core version.  Set it to the core version 
		; you are developing on.
		SAVENEX CORE 2,0,0

		; This sets the border colour while loading (in this case white),
		; what to do with the file handle of the nex file when starting (0 = 
		; close file handle as we're not going to access the project.nex 
		; file after starting.  See sjasmplus documentation), whether
		; we preserve the next registers (0 = no, we set to default), and 
		; whether we require the full 2MB expansion (0 = no we don't).
		SAVENEX CFG 7,0,0,0

		; Generate the Nex file automatically based on which pages you use.
		SAVENEX AUTO

