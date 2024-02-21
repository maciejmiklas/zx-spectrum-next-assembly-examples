;
; Sample code
;

		; Allow the Next paging and instructions.
		DEVICE ZXSPECTRUMNEXT

		; Generate a map file for use with Cspect.
		CSPECTMAP "project.map"

		org	$8000










; Blinking character
start:										; Program execution start here - see SAVENEX at the bottom
	CALL ROM_CLS         					; Call clear screen routine from ROM.

	LD	A, 'X'								; Load "X" into A and print it on the screen.
	RST ROM_PRINT

	LD	A, COL_GREEN | %10000000			; Take a green color and set the first bit to enable blinking. 
	LD	($5800), A							; Store value from register into first byte of video RAM.

	LD	A, COL_RED | %10000000				; Take a red color and set the first bit to enable blinking. 
	LD	($5804), A							; Store value from register into 4-th byte of video RAM.	
	
	JR	$									; Loop forever!










	INCLUDE "src/constants.asm"
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

