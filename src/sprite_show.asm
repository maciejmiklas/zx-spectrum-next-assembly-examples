; Based on: 


	; Allow the Next paging and instructions
	DEVICE ZXSPECTRUMNEXT

	; Generate a map file for use with Cspect
	CSPECTMAP "project.map"

	ORG $8000
;
;
;
;
;------------------------------------------------------------;
;     Load sprites from file using DMA and shows few.        ;
;------------------------------------------------------------;
;
;
;
;

spritesFile:
	INCBIN "assets/sprites.spr"

	INCLUDE "_constants.asm"				; Incude contstants
	INCLUDE "api_sprite.asm"				; Incude sprites API

start:										; Program execution start here - see SAVENEX at the bottom
	LD HL, spritesFile						; Sprites binary data
	LD BC, 16*16*63							; Copy 63 sprites, each 16x16 pixels
	CALL LoadSprites						; Load sprites to Hardware

	; Sprites are loaded into hardware, now display them
	NEXTREG SPR_SETUP, %01000011			; Setups sprites: sprites visible, over border


	;
	; Display sprite 0 with pattern 0 at: (80, 120)	
	NEXTREG SPR_NR, 0						; Setup Sprite with ID 0
	LD A, 80								; Set X position
	NEXTREG SPR_X, A						

	LD A, 120								; Set Y position
	NEXTREG SPR_Y, A						

	NEXTREG SPR_ATTR_2, %00000000 			; Palette offset, no mirror, no rotation

	; bit 7 = Visible flag (1 = displayed)
	; bits 5-0 = Pattern used by sprite (0-63), we will use pattern 0
	NEXTREG SPR_ATTR_3, %10000000
	
	;
	; Display sprite 1 with pattern 35 at: (120, 120)		
	NEXTREG SPR_NR, 1						; Setup Sprite with ID 0
	LD A, 120								; Set X position
	NEXTREG SPR_X, A						

	LD A, 120								; Set Y position
	NEXTREG SPR_Y, A						

	NEXTREG SPR_ATTR_2, %00000000 			; Palette offset, no mirror, no rotation	

	; bit 7 = Visible flag (1 = displayed)
	; bits 5-0 = Pattern used by sprite (0-63), we will use pattern 35
	NEXTREG SPR_ATTR_3, %10000000 | 35

		
	;
	; Display sprite 2 with pattern 38 at: (160, 120)		
	NEXTREG SPR_NR, 2						; Setup Sprite with ID 0
	LD A, 160								; Set X position
	NEXTREG SPR_X, A						

	LD A, 120								; Set Y position
	NEXTREG SPR_Y, A						

	NEXTREG SPR_ATTR_2, %00000000 			; Palette offset, no mirror, no rotation	

	; bit 7 = Visible flag (1 = displayed)
	; bits 5-0 = Pattern used by sprite (0-63), we will use pattern 38
	NEXTREG SPR_ATTR_3, %10000000 | 38


	JR $									; Loop indefinieally, to preserve RAM values
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