.MODEL SMALL

include defines.h

DataSegment	segment para public 'data'
public		Win95?,actualHD

extrn numodrives:word
extrn ebios?:byte
extrn packet:byte
extrn transpoint:dword
extrn firstpoint:dword
extrn targetdisk:byte
extrn loader:byte
extrn HDIDs:byte

Win95?		db	?		; Win9x indicator
readint		db	?		; interrupt number of read
writeint	db	?		; interrupt number of writre
actualHD	db	?		; actual HD ID
S_noHD		db	'No available hard disk found$'
		ends

_TEXT		segment public
.386
assume cs:_TEXT, ds:DataSegment
public getsectors,getMBRs,savemenu,readint,writeint

;----------------------------------------------------------

getsectors	proc	near
;ES:DI - pointer to partition entry
;ES:BX - buffer to read
;actualHD

		push	eax
		push	cx
		push	dx
		push	si
		mov	eax,es:[di+8]
		mov	firstpoint,eax		; store firstpoint
		mov	ax,es
		shl	eax,16
		mov	ax,bx
		mov	transpoint,eax		; store transpoint
		lea	si,packet
		mov	dl,actualHD
		mov	dh,es:[di+1]
		mov	cx,es:[di+2]
		mov	al,1
		mov	ah,readint
		call	lockdrive
		int	13h			; read MBR
		call	unlockdrive
		pop	si
		pop	dx
		pop	cx
		pop	eax
		ret
		endp

;----------------------------------------------------------

lockdrive	proc
;DL - drive

		cmp	win95?,1
		jne	dontlock

		push	ax
		push	bx
		push	cx
		push	dx
		mov	ax,440dh
		mov	cx,084bh
		mov	bh,1
		mov	bl,dl
		xor	dx,dx
		int	21h
		pop	dx
		pop	cx
		pop	bx
		pop	ax
dontlock:	ret
		endp

;----------------------------------------------------------

unlockdrive	proc
;DL - drive
		pushf
		cmp	win95?,1
		jne	dontunlock

		push	ax
		push	bx
		push	cx
		mov	ax,440dh
		mov	cx,086bh
		mov	bl,dl
		int	21h
		pop	cx
		pop	bx
		pop	ax
dontunlock:	popf
		ret
		endp

;----------------------------------------------------------

getMBRs		proc
		lea	si,HDIDs
		mov	cx,numodrives
		mov	dx,80h
		xor	bx,bx
@getnextMBR:	call	checkdisktype
		jnc	@@noskipdisk
		dec	numodrives
		jmp	@@skipdisk

@@noskipdisk:	push	cx
		mov	ah,2
		mov	al,1
		mov	cx,1
		call	lockdrive
		int	13h
		call	unlockdrive
		pop	cx
		mov	[si],dl
		inc	si
		add	bx,512
@@skipdisk:	inc	dl
		loop	@getnextMBR
		ret
		endp

;----------------------------------------------------------

savemenu	proc	near

		push	es
		push	ds
		pop	es
		lea	bx,loader
		mov	dx,80h
		movzx	ax,targetdisk
		add	dx,ax
		mov	cx,1
		mov	ah,3
		mov	al,MBRsectors
		call	lockdrive
		int	13h
		call	unlockdrive
		pop	es
		ret
		endp

;----------------------------------------------------------

checknumodrives	proc	near

		cmp	numodrives,0
		ja	@@vanHD
		lea	dx,S_noHD
		mov	ah,9
		int	21h
		stc
		ret

@@vanHD:	clc
		ret
		endp

;----------------------------------------------------------
checkdisktype	proc
;DL - HD ID

		push	cx
		push	dx
		mov	ah,15h		; get disk type
		int	13h
		jc	@@endchkdp	; error
		test	ah,ah
		stc
		jz	@@endchkdp	; AH = 0 -> 'no such drive'

		clc
@@endchkdp:	pop	dx
		pop	cx
		ret

		endp

		ends
		end
