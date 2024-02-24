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
;           Move and animate sprite at 60PFS.                ;
;------------------------------------------------------------;
;
;
;
;

spritesFile:
	INCBIN "assets/sprites.spr"

	INCLUDE "src/includes/constants.asm"	; Incude contstants
	INCLUDE "src/includes/sprites.asm"		; Incude sprites API
	INCLUDE "src/includes/display_sync.asm"	; Display synchronization API

SPRITE_ID			EQU $0					; ID for our sprite so we can reference it after loading to move it.   
ANIM_FR				EQU 5					; Change sprite pattern every few frames               
xpos 				BYTE 10					; 0-256px
pattern				BYTE 0					; Sprite pattern beetwen 0 and 3
animCnt				BYTE 0					; The animation counter is used to update the sprite pattern every few FP

start:										; Program execution start here - see SAVENEX at the bottom
	
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
	NEXTREG SPR_ATTR_3, %10000000			; Visible, pattern 0

loop
	LD H, 192								; Wait for Scanline 192 to get 60FPS
	CALL WaitOneFrame		

	NEXTREG SPR_NR, SPRITE_ID				; Use sprite with ID 0

	; Update X position
	LD A, (xpos)	
	INC A
	LD (xpos), A
	NEXTREG SPR_X, A

	; Should we update Sprite pattern?
	LD A, (animCnt)
	INC A
	LD (animCnt), A							

	CP ANIM_FR								; Wait for #ANIM_FR frames to update the animation pattern.
	JR C, loop

	LD A, 0									; #animCnt == #ANIM_FR -> reset counter and update the animation pattern.
	LD (animCnt), A

	; Update sprite pattern - next animation frame
	LD A, (pattern)							; Load current pattern from RAM into A
	INC A									; Next pattern

	CP 4									; Are we at pattern 4? -> reset to 0
	JR C, .afterReset
	LD A, 0
.afterReset

	LD (pattern), A							; Store current pattern into RAM

	OR %10000000							; Set bit 7 for Param 3 to keep sprite visible (see line 53)
	NEXTREG SPR_ATTR_3, A
				
	
	JR loop
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