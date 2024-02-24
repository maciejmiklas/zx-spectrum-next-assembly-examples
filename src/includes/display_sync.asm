;----------------------------------------------------------;
;                Display Synchronization                   ;
;----------------------------------------------------------;
; Based on: https://github.com/robgmoran/DougieDoSource


; Pauses executing for single frame, 1/60 or 1/50 of a second.
;
; The code waits for the given scanline (192) in the first loop, and then in the second loop, it waits again for the same scanline (192). 
; This method pauses for the whole frame or a bit more, depending on which scanline display is when calling "WaitOneFrame".
; 
; Method Parameters:
; - H: Scanline to synch to. 192 for 60FPS, value above/below changes pause time.
WaitOneFrame:
     
; Read NextReg $1F - LSB of current raster line.
	LD BC, REG_SELECT       				; TBBlue Register Select.
	LD A, REG_VL          					; Port to access - Active Video Line LSB Register.
	OUT (C), A           					; Select NextReg $1F.
	INC B               					; TBBlue Register Access.
	LD A, H									; Set Scanline to wait for.
	LD D, A

; Wait for Scanline given by param H, i.e. 192
.waitForScanline:
	IN A, (C)       						; Read the raster line LSB into A.
	CP D
	JR Z, .waitForScanline				; Keep looping until Scanline changes from given to next, 192->193

; Now we are past 192 -> on 193

; Wait the whole frame again for given Scanline (192)
.waitAgainForScanline:
	IN A, (C)       						; Read the raster line LSB into A.
	CP D
	JR NZ, .waitAgainForScanline
	RET