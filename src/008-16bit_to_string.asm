; Based on: http://map.grauw.nl/sources/external/z80bits.html

	; Allow the Next paging and instructions
	DEVICE ZXSPECTRUMNEXT

	; Generate a map file for use with Cspect
	CSPECTMAP "project.map"

	ORG $8000











formattedOut:
	db "00000"								; Contains a number formatted into a string, RAM Address $8000

start:										; Program execution start here - see SAVENEX at the bottom
	CALL ROM_CLS         					; Call clear screen routine from ROM.

	LD DE, formattedOut						; Point to output buffor.
	LD HL, 54321							; Numnber to be formatted.
	CALL num16ToString						; Format 54321 into string and store it at $8000.


	; Text is formatted and stored at the Label: "formaformattedOuttted", now it's time to show it on the monitor.

	; Move cursor to: (10,12)
	LD A, PR_AT								; AT control character
	RST ROM_PRINT
	LD A, 10								; Y text coordinate (row)
	RST ROM_PRINT
	LD A, 12								; X text coordinate (collumn)
	RST ROM_PRINT

	; Print label: "formattedOut"
	LD DE, formattedOut						; The RAM address containing the text to be printed.
	LD BC, 5								; Contains the number of characters to be printed.
	CALL ROM_PRINT_TEXT

	JR $									; Loop indefinieally, to preserve RAM values

; Converts a given 16-bit number into a 5-character string with padding zeros.
; IN:  HL = 16-bit number to convert.
; OUT: ASCII string at DE, 5-charactes long, 0 padded.
num16ToString

	; Each line prints one digit into DE, starting with the most significant. 
	ld	BC, -10000						
	CALL .format

	LD	BC, -1000
	CALL .format

	LD	BC, -100
	call .format

	LD	C, -10
	call .format

	LD	C, B							; Last, the rightmost digit.

.format
	LD	A, '0'-1						; Load ASCI code for 0.
.loop 
	INC A
	ADD	HL, BC							; Substract (add negative) given number from input number

	; Keep looping and subtracting until the carry bit is set. 
	; It happens when subtracting resets the most significant number, i.e., 1234 -> 0123.
	JR	C, .loop
	
	SUB	HL, BC							; ADD above caused an overflow. Subsctract will turn the value one step back, ie: 59857 -> 4321 for input: 54321
	LD (DE), A							; A contains the ASCII value of the most significant number, store it in DE.
	INC DE								; Move DE offset to the next position to store next number
	RET










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