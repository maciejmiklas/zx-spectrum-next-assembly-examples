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

;----------------------------------------------------------;
;                     Input processing                     ;
;----------------------------------------------------------;
HandleJoystickInput:
	; Key Up pressed ?
	LD A, KB_6_TO_0							; $EF -> A (6...0)
	IN A, (KB_REG) 							; Read keyboard input into A
	BIT 3, A								; Bit 3 reset -> Up pessed
	CALL Z, MoveUp	

	; Key Down pressed ?
	LD A, KB_6_TO_0							; $EF -> A (6...0)
	IN A, (KB_REG) 							; Read keyboard input into A
	BIT 4, A								; Bit 4 reset -> Down pessed
	CALL Z, MoveDown				

	; Key Rright pressed ?
	LD A, KB_6_TO_0							; $EF -> A (6...0)
	IN A, (KB_REG) 							; Read keyboard input into A
	BIT 2, A								; Bit 2 reset -> Rright pessed
	CALL Z, MoveRight

	; Key Left pressed ?
	LD A, KB_5_TO_1							; $FD -> A (5...1)
	IN A, (KB_REG) 							; Read keyboard input into A
	BIT 4, A								; Bit 4 reset -> Left pessed
	CALL Z, MoveLeft		

	; Key Fire (Z) pressed ?
	LD A, KB_V_TO_Z							; $FD -> A (5...1)
	IN A, (KB_REG) 							; Read keyboard input into A
	BIT 1, A								; Bit 1 reset -> Z pessed
	CALL Z, PressFire

	; Joystick up pressed ?
	LD A, JOY_MASK							; Activete joystick register
	IN A, (JOY_REG) 						; Read joystick input into A
	BIT 3, A								; Bit 3 set -> Up pessed
	CALL NZ, MoveUp

	; Joystick down pressed ?
	LD A, JOY_MASK							; Activete joystick register
	IN A, (JOY_REG) 						; Read joystick input into A
	BIT 2, A								; Bit 2 set -> Down pessed
	CALL NZ, MoveDown

	; Joystick right pressed ?
	LD A, JOY_MASK							; Activete joystick register
	IN A, (JOY_REG) 						; Read joystick input into A
	BIT 0, A								; Bit 0 set -> Right pessed
	CALL NZ, MoveRight			

	; Joystick left pressed ?
	LD A, JOY_MASK							; Activete joystick register
	IN A, (JOY_REG) 						; Read joystick input into A
	BIT 1, A								; Bit 1 set -> Left pessed
	CALL NZ, MoveLeft	

	; Joystick fire pressed ?
	LD A, JOY_MASK							; Activete joystick register
	IN A, (JOY_REG) 						; Read joystick input into A
	AND %01110000							; Any of three fires pressed?
	CALL NZ, PressFire	

	RET
	
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
	INCLUDE "src/includes/constants.asm"	; Incude contstants

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

