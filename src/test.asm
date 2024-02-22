	; Allow the Next paging and instructions
	DEVICE ZXSPECTRUMNEXT

	; Generate a map file for use with Cspect
	CSPECTMAP "project.map"

	ORG $8000

; ROM routines
ROM_CLS     = $0DAF
ROM_PRINT   = $10


; Charactes codes
CH_ENTER	= $0D			; Character code for Enter key

; define single byte of RAM
CH_TMP
	DEFB 'A'

start:
	call ROM_CLS         	; Call clear screen routine from ROM (extended immediate)

	; Load into A the value and print it
	LD A, (CH_TMP)
	RST ROM_PRINT

	; store into CH_TMP value B
	LD A, 'B'
	LD (CH_TMP), A

	; print current value from CH_TMP
	LD A, (CH_TMP)
	RST ROM_PRINT	
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