.MODEL SMALL

DataSegment	segment para public 'data'
extrn numodrives:word
seg_program	dw	0
		ends

_TEXT		segment public
.386
assume cs:_TEXT, ds:DataSegment
public Allocate,freemem,ResizeMemory

;----------------------------------------------------------

Allocate	proc
		mov	bx,numodrives
		mov	ax,512
		mul	bx
		add	ax,1024			; +2, for extended and boot
		shr	ax,4
		inc	ax
		mov	bx,ax
		mov	ah,48h
		int	21h			; allocate
		mov	seg_program,ax
		mov	es,ax
		ret
		endp

;----------------------------------------------------------

freemem		proc
		pushf
		mov	ax,seg_program
		mov	es,ax
		mov	ah,49h
		int	21h
		popf
		ret
		endp

;----------------------------------------------------------

ResizeMemory	proc
		mov	ax,ss
		mov	bx,200h
		shr	bx,4		; (stack lenght / 16) + 1
		inc	bx
		add	bx,ax
		mov	ax,ds
		sub	ax,10h
		sub	bx,ax
		mov	es,ax
		mov	seg_program,ax
		mov	ah,4ah		; resize memory block
		int	21h
		ret
		endp

		ends
		end
