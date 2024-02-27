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
;             Move sprite on X axis at 60PFS.                ;
;------------------------------------------------------------;
;
;
;
;

spritesFile:
	INCBIN "assets/sprites.spr"

	INCLUDE "_constants.asm"				; Incude contstants
	INCLUDE "api_sprite.asm"				; Incude sprites API
	INCLUDE "api_display.asm"				; Display synchronization API

SPRITE_ID			EQU $0					; ID for our sprite so we can reference it after loading to move it.                  
xpos 				BYTE 10					; 0-256px

start:										; Program execution start here - see SAVENEX at the bottom
	CALL ROM_CLS         					; Call clear screen routine from ROM.
		
	NEXTREG REG_TURBO, %00000011    		; Switch to 28MHz

	LD HL, spritesFile						; Sprites binary data
	LD BC, 16*16*5							; Copy 5 sprites, each 16x16 pixels
	CALL LoadSprites						; Load sprites to Hardware

	; Sprites are loaded into hardware, now display it
	NEXTREG SPR_SETUP, %01000011			; Sprite 0 on top, SLU, sprites visible

	NEXTREG SPR_NR, SPRITE_ID				; Use sprite with ID 0
	LD A, 80								; Set player X position
	NEXTREG SPR_X, A						

	LD A, 120								; Set player Y position
	NEXTREG SPR_Y, A						

	NEXTREG SPR_ATTR_2, %00000000 			; Palette offset, no mirror, no rotation
	NEXTREG SPR_ATTR_3, %10000000			; Visible, no byte 4, pattern 0

.loop
	; Update X position
	LD A, (xpos)	
	INC A
	LD (xpos), A

	; Update the position of sprite 0 that we've loaded above.
	NEXTREG SPR_NR, SPRITE_ID
	NEXTREG SPR_X, A

	LD H, 192								; Wait for Scanline 192 to get 60FPS
	CALL WaitOneFrame						
	
	JR .loop
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