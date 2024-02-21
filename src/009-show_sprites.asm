; Based on: http://map.grauw.nl/sources/external/z80bits.html

	; Allow the Next paging and instructions
	DEVICE ZXSPECTRUMNEXT

	; Generate a map file for use with Cspect
	CSPECTMAP "project.map"

	ORG $8000


dmaProgram:
	DB %10000011							; WR6 - Disable DMA
	DB %01111101							; WR0 - append length + port A address, A->B

dmaSource:
	DW 0									; WR0 par 1&2 - port A start address

dmaStartConfig:									; https://wiki.specnext.dev/DMA



page 43!



	; WR0 ($0xxxxx01): Direction, operation and port A configuration
	DW 0									; WR0 par 3&4 - transfer length

	; WR1 ($0xxxx100): Port A configuration.
	;   - D3 = 0 -> Port A is memory
	;   - D5,D4 = 01 -> Port A address increments
	DB %00010100

	; WR2 ($0xxxx000): Port B configuration.
	;   - D3 = 1 -> Port B is IO (FPGA Sprite Hardware)
	;   - D5 = 0 -> Port B address is fixed
	DB %00101000							; WR2 - B fixed, B=I/O

	; WR3 ($1xxxxx00): Activation
	DB %10101101							; WR3 - continuous, append port B address
	DW $005B								; WR4 par 1&2 - port B address

	; WR4 (1xxxxx01): Port B, timing and interrupt configuration
	; ???

	; WR5 (1xxxxx01): Ready and stop configuration
	;   - D4 = 0 ->  CE only (the only option anyway)
	;   - D5 = 0 -> Stop operation on end of block
	DB %10000010							

	; WR6 (1xxxxx11): Command register
	;   - D6,D5,D4,D3,D2 = 10011 -> LOAD command, to start copy from A to B
	DB %11001111

	; WR6 (Command Register):
	DB %10000111							; WR6 - enable DMA

dmaProgramLength = $-dmaProgram

; Loads sprites from file into hardware using DMA (https://wiki.specnext.dev/DMA).
; IN: 
;    - HL - RAM address containing sprite binary data.
;    - BC - Number of bytes to copy, i.e. 4 sprites 16x16: "LD BC, 16*16*4".
LoadSprites:
	LD (dmaSource), HL						; Copy sprite sheet address from HL
	LD (dmaStartConfig), BC					; Copy sprite file lenght into WR0
	LD BC, $303B							; Prepare port for sprite index
	OUT (C), A								; Load index of first sprite
	LD HL, dmaProgram						; Setup source for OTIR
	LD B, dmaProgramLength 					; Setup length for OTIR
	LD C, SPR_DMA_PORT						; Setup DMA port
	OTIR									; Invoke DMA code
	RET

sprites:
	INCBIN "assets/sprites.spr"

start:										; Program execution start here - see SAVENEX at the bottom

	LD HL, sprites							; Sprites data source
	LD BC, 16*16*5							; Copy 5 sprites, each 16x16 pixels
	LD A, 0									; Start with first sprite
	CALL LoadSprites						; Load sprites to Hardware

	NEXTREG SPR_SETUP, %01000011			; Sprite 0 on top, SLU, sprites visible

	NEXTREG SPR_NR, SPR_JETMAN_ID			; Player

	LD A, 80								; Set player X position
	NEXTREG SPR_X, A						

	LD A, 120								; Set player Y position
	NEXTREG SPR_Y, A						

	NEXTREG SPR_ATTR_2, %00000000 			; Palette offset, no mirror, no rotation
	NEXTREG SPR_ATTR_3, %10000000			; Visible, no byte 4, pattern 0







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