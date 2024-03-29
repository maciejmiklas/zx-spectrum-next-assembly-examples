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
;----------------------------------------------------------------;
; Print text message at given position by calling a ROM routine. ;
;----------------------------------------------------------------;
;
;
;
;
; 
message:
	db "This is a text message!",CH_ENTER

MSG_LEN = $ - message						; Message length = [current address in RAM] - [beginning of the message].
	
start:										; Program execution start here - see SAVENEX at the bottom
	INCLUDE "_constants.asm"	; Incude contstants

	call ROM_CLS         					; Call clear screen routine from ROM.

	LD A, PR_AT								; AT control character
	RST ROM_PRINT

	LD A, 8									; Y text coordinate (row)
	RST ROM_PRINT

	LD A, 4									; X text coordinate (collumn)
	RST ROM_PRINT


	; ROM routine expects two parameters: 
	; - DE: points to the RAM address containing the text to be printed
	; - BC: contains the number of characters to be printed.
	LD DE, message							
	LD BC, MSG_LEN							
	CALL ROM_PRINT_TEXT


	JR	$									; Loop forever!
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

