.MODEL SMALL

include defines.h
include gui.h

DataSegment		segment para public 'data'

helpline1	db	'F1-help  -move  ENTER-add system  DEL-delete last  F10-continue  ESC-quit $'
helpline2	db	'F1-help  -move cursor  ENTER-change parameter  F10-continue  ESC-quit   $'
H_entername	db	'Enter the name of the system (16 characters max). Press ENTER when ready.   $'
H_enterpasswd	db	'Enter password for this system (16 characters max). Press ENTER when ready. $'
S_enterscan	db	'Press secret key combination (or ENTER to disable)$'
H_entermpass	db	'Enter master password (16 characters max). Press ENTER when ready.          $'
H_FAT		db	'Enter FAT/NTFS hide map. Enter 1 to hide, 0 not to hide the other system(s).$'
H_enterdelay	db	'Delay time: 1 - 98 secs. 99 or 0 for infinite without or with screensaver.  $'
H_enterdefault	db	'Enter default system number, 0 to boot the last active system.              $'

S_mrbooter	db	'   MasterBooter ', versiostr2, ' ', copyright,0dh,0ah,'$'
S_available	db	' Available partitions $'
S_available2	db	' Partition parameters $'
S_selected	db	' Selected partitions $'
S_sharereg	db	' Open Source version $'

S_typesizename	db	'HD  Partition Type      Detected Operating System  Size (MB)  Vol. Label$'
S_underline	db	'ÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄ$'
S_typesizename2	db	'No  System Names      System Passwords  Protection  FAT/NTFS hiding map$'
S_underline2	db	'ÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ$'

S_delayline	db	'Delay Time: $'
S_beepline	db	'Audible boot menu: $'
S_defline	db	'Default System: $'
S_masterpwd	db	'Master Password: $'
S_floppyboot	db	'Enable floppy boot: $'
S_hidemenu	db	'Hide boot menu: $'

S_1		db	'1: $'
		db	'2: $'
		db	'3: $'
		db	'4: $'
		db	'5: $'
		db	'6: $'
		db	'7: $'
		db	'8: $'

windowstart	dw	0
windowwidth	dw	0
upleft		dw	0
downright	dw	0
stringaddr	dw	0

oldpos		dw	0406h		; previous highlighted block pos
oldlength	dw	16
blockmatrix	dw	0406h,16,418h,16,42ah,3,436h,8
		dw	0506h,16,518h,16,52ah,3,536h,8
		dw	0606h,16,618h,16,62ah,3,636h,8
		dw	0706h,16,718h,16,72ah,3,736h,8
		dw	0806h,16,818h,16,82ah,3,836h,8
		dw	0906h,16,918h,16,92ah,3,936h,8
		dw	0a06h,16,0a18h,16,0a2ah,3,0a36h,8
		dw	0b06h,16,0b18h,16,0b2ah,3,0b36h,8
delaypos	dw	0,2		; position, field length
defaultpos	dw	0,1
floppypos	dw	0,3
beeppos		dw	0,3
masterpos	dw	0,16
hidemenupos	dw	0,3

		ends

_TEXT		segment public
.386
assume cs:_TEXT, ds:DataSegment

drawscreen1	proc
		mov	ax,3
		int	10h			; set mode

		push	es
		mov	ax,0b800h
		mov	es,ax
		mov	cx,80
		mov	di,1
		mov	al,30h
@firstrow:	stosb
		inc	di
		loop	@firstrow
		mov	cx,1840
		mov	al,1bh
@mainrows:	stosb
		inc	di
		loop	@mainrows
		mov	cx,80
		mov	al,30h
@lastrow:	stosb
		inc	di
		loop	@lastrow
		pop	es

		lea	dx,S_mrbooter
		mov	ah,9			; print copyright
		int	21h

		xor	bh,bh
		mov	ah,0eh
		mov	al,'É'
		int	10h			; draw window
		mov	cx,78
		mov	al,'Í'
@@nc1:		int	10h
		loop	@@nc1
		mov	al,'»'
		int	10h

		mov	cx,12
@@dnextl:	push	cx
		mov	al,'º'
		int	10h
		mov	cx,78
		mov	al,' '
@@nc3:		int	10h
		loop	@@nc3
		mov	al,'º'
		int	10h
		pop	cx
		loop	@@dnextl
		mov	al,'Ì'
		int	10h
		mov	cx,78
		mov	al,'Í'
@@nc4:		int	10h
		loop	@@nc4
		mov	al,'¹'
		int	10h

		mov	cx,8
@@ddnextl2:	push	cx
		mov	al,'º'
		int	10h
		mov	al,' '
		mov	cx,78
@@nc5:		int	10h
		loop	@@nc5
		mov	al,'º'
		int	10h
		pop	cx
		loop	@@ddnextl2
		mov	al,'È'
		int	10h
		mov	cx,78
		mov	al,'Í'
@@nc6:		int	10h
		loop	@@nc6
		mov	al,'¼'
		int	10h

		lea	dx,helpline1
		call	printhelpline

		mov	bl,1fh
		mov	cx,22
		mov	dh,1
		mov	dl,27
		lea	bp,S_available
		call	printattr

		mov	cx,21
		mov	dh,14
		mov	dl,28
		lea	bp,S_selected
		call	printattr

		mov	dh,2
		mov	dl,2
		call	gotoXY
		lea	dx,S_typesizename
		mov	ah,9
		int	21h

		mov	dh,3
		mov	dl,2
		call	gotoXY
		lea	dx,S_underline
		mov	ah,9
		int	21h

		mov	dh,23
		mov	dl,29
		call	gotoXY
		lea	dx,S_sharereg
		mov	ah,9
		int	21h

		lea	bx,S_1
		mov	cx,8
		mov	dh,15
		mov	dl,2
@@nextnum:	push	dx
		call	gotoXY
		mov	dx,bx
		mov	ah,9
		int	21h
		pop	dx
		inc	dh
		add	bx,4
		loop	@@nextnum

		call	hidecursor
		ret

		endp

;----------------------------------------------------------

drawscreen2	proc

		call	clearwindow
		mov	bl,1fh
		mov	cx,22
		mov	dh,1
		mov	dl,27
		lea	bp,S_available2
		call	printattr

		lea	dx,helpline2
		call	printhelpline

		mov	dh,2
		mov	dl,2
		call	gotoXY
		lea	dx,S_typesizename2
		mov	ah,9
		int	21h

		mov	dh,3
		mov	dl,2
		call	gotoXY
		lea	dx,S_underline2
		mov	ah,9
		int	21h

		lea	bx,S_1
		movzx	cx,numoselected
		mov	dh,4
		mov	dl,2
@@nextnum2:	push	dx
		call	gotoXY
		mov	dx,bx
		mov	ah,9
		int	21h
		pop	dx
		inc	dh
		add	bx,4
		loop	@@nextnum2

		cmp	numoselected,8
		je	@@skiponel
		inc	dh
@@skiponel:	call	gotoXY

		push	dx
		mov	ah,9
		lea	dx,S_delayline
		int	21h			; print 'delay time'
		call	getXY
		mov	delaypos,dx
		pop	dx

		add	dl,19
		call	gotoXY

		push	dx
		lea	dx,S_beepline
		int	21h
		call	getXY			; print 'audible menu'
		mov	beeppos,dx
		pop	dx

		add	dl,23
		call	gotoXY

		push	dx
		lea	dx,S_floppyboot
		int	21h
		call	getXY			; print 'enable floppy'
		mov	floppypos,dx
		pop	dx

		inc	dh
		mov	dl,2
		call	gotoXY

		push	dx
		lea	dx,S_defline
		int	21h
		call	getXY			; print 'default system'
		mov	defaultpos,dx
		pop	dx

		add	dl,19
		call	gotoXY

		push	dx
		lea	dx,S_hidemenu
		int	21h
		call	getXY			; print 'hide menu'
		mov	hidemenupos,dx
		pop	dx

		add	dl,23
		call	gotoXY

		lea	dx,S_masterpwd
		int	21h
		call	getXY			; print 'master password'
		mov	masterpos,dx

		ret
		endp

;----------------------------------------------------------

clearwindow	proc	near
		push	es
		mov	ax,0b800h
		mov	es,ax
		mov	cx,12
		mov	ax,1b20h
		mov	di,(2*80+1)*2
@clnrow:	push	cx
		mov	cx,78
		rep	stosw
		pop	cx
		add	di,4
		loop	@clnrow
		pop	es
		ret
		endp


;----------------------------------------------------------

putwindow	proc
;DX - string to write in a window

		push	es
		xor	bx,bx
		mov	si,dx
		mov	stringaddr,dx
@@strlenc:	lodsb
		inc	bx			; BX - string length
		cmp	al,'$'
		jne	@@strlenc
		add	bx,4
		mov	cx,80
		sub	cx,bx
		shr	cx,1
		mov	ch,5
		xchg	bx,cx			; BX - upper left corner
		mov	upleft,bx		; save upper left pos
		mov	windowwidth,cx		; CX - width
		mov	ax,160
		mov	bx,upleft
		shl	bl,1
		mul	bh
		xor	bh,bh
		add	ax,bx
		mov	si,ax			; SI - vidmem start
		mov	windowstart,si

		mov	ax,0b800h
		mov	es,ax
		mov	di,windowstart
		push	di
		mov	ah,40h
		mov	al,'Ú'
		stosw
		mov	cx,windowwidth
		sub	cx,2
		mov	al,'Ä'
		rep	stosw
		mov	al,'¿'
		stosw
		pop	di
		add	di,160
		push	di
		mov	al,'³'
		stosw
		mov	cx,windowwidth
		sub	cx,2
		mov	al,' '
		rep	stosw
		mov	al,'³'
		stosw
		pop	di
		add	di,160
		mov	al,'À'
		stosw
		mov	cx,windowwidth
		sub	cx,2
		mov	al,'Ä'
		rep	stosw
		mov	al,'Ù'
		stosw

		mov	dx,upleft
		inc	dh
		add	dl,2
		call	gotoXY
		mov	dx,stringaddr
		mov	ah,9
		int	21h
		pop	es
		ret
		endp

;----------------------------------------------------------

gotoXY		proc	near
;IN  -	DH = row
;     	DL = column

		push	ax
		push	bx
		mov	ah,0fh
		int	10h
		mov	ah,2
		int	10h
		pop	bx
		pop	ax
		ret
		endp

;----------------------------------------------------------

getXY		proc	near
;OUT  - DX = cursor pos

		push	ax
		push	bx
		push	cx
		mov	ah,3
		xor	bh,bh
		int	10h
		pop	cx
		pop	bx
		pop	ax
		ret
		endp

;----------------------------------------------------------
printattr	proc	near
;BL - attribbute
;CX - characters in string
;DX - position
;BP - string

		push	ax
		push	es
		push	ds
		pop	es

		mov	ah,2
		xor	bh,bh
		int	10h		; set cursor position

		mov	ah,13h
		mov	al,1
		xor	bh,bh
		int	10h		; write string

		pop	es
		pop	ax
		ret
		endp


;----------------------------------------

getpos		proc
		mov	ah,3
		xor	bh,bh
		int	10h
		ret
		endp

;----------------------------------------------------------

highlight	proc	near
;AL - direction of movement

		mov	dh,actualpart
		add	dh,al
		js	@dontmove		; at the top?
		cmp	dh,numosystems
		jae	@dontmove		; at the bottom?

		mov	dl,dh			; DL - newpos
		mov	dh,actualpart		; DH - oldpos
		mov	actualpart,dl		; update pos
		add	dx,0404h
		mov	bh,1bh
		call	updatelight		; delete old highlight
		mov	dh,dl
		mov	bh,70h			; draw new highlight
		call	updatelight

@dontmove:	ret
		endp

;------ Updates attribs -----
updatelight	proc	near
;BH - attrib
;DH - row
;Destroys: CX, DI

		push	ax
		push	es

		push	bx
		push	dx
		mov	ah,2
		xor	bh,bh
		mov	dl,2
		int	10h			; set cursor position
		pop	dx
		pop	bx

		mov	ax,0b800h
		mov	es,ax
		mov	al,160
		mul	dh
		add	ax,5
		mov	di,ax
		mov	cx,73			; highlight 73 chars
		mov	al,bh
lightnext:	stosb				; put new attrib to ES:DI
		inc	di
		loop	lightnext
		pop	es
		pop	ax
		ret
		endp


;----------------------------------------------------------

hidecursor	proc	near
		push	ax
		push	cx
		mov	ah,1
		mov	cx,2000h
		int	10h
		pop	cx
		pop	ax
		ret
		endp

;----------------------------------------------------------

showcursor	proc	near
		push	ax
		push	cx
		mov	ah,1
		mov	cx,010fh
		int	10h
		pop	cx
		pop	ax
		ret
		endp

;----------------------------------------------------------

moveblock	proc	near
;St_oldpos
;AX - movement
		push	es

		mov	dx,oldpos		; DX - oldpos
	
		lea	si,blockmatrix
		mov	di,si
		movzx	cx,numoselected
		shl	cx,4
		add	di,cx			; DI - max pos in matrix
		shr	cx,2

@@tnextelem:	cmp	[si],dx
		jne	@@nfoundelem		; search in matrix
		jmp	@@foundelement
@@nfoundelem:	add	si,4			; jump if found
		loop	@@tnextelem		; else check globals

		cmp	dx,delaypos
		jne	@@nodelpos		; on delay?
		lea	si,delaypos
		test	ah,ah
		js	@@backtom		; UP
		jnz	@@gotodef		; DOWN
		test	al,al
		js	@@backtom		; LEFT
		jnz	@@gotobeep		; RIGHT
		jmp	@@dolight
@@backtom:	mov	si,di
		sub	si,16
		jmp	@@dolight

@@nodelpos:	cmp	dx,beeppos
		jne	@@nobeeppos		; on beep?
		lea	si,beeppos
		test	ah,ah
		js	@@backtom		; UP
		jnz	@@gotohidemenu		; DOWN
		test	al,al
		js	@@gotodelay		; LEFT
		jnz	@@gotofloppy		; RIGHT
		jmp	@@dolight

@@nobeeppos:	cmp	dx,floppypos
		jne	@@nofloppos		; on floppy?
		lea	si,floppypos
		test	ah,ah
		js	@@backtom		; UP
		jnz	@@gotomaster		; DOWN
		test	al,al
		js	@@gotobeep		; LEFT
		jnz	@@gotodef		; RIGHT
		jmp	@@dolight

@@nofloppos:	cmp	dx,defaultpos
		jne	@@nodefpos		; on default?
		lea	si,defaultpos
		test	ah,ah
		js	@@gotodelay		; UP
		jnz	@@gotomaster		; DOWN
		test	al,al
		js	@@gotofloppy		; LEFT
		jnz	@@gotohidemenu		; RIGHT
		jmp	@@dolight

@@nodefpos:	cmp	dx,hidemenupos
		jne	@@nohidepos
        	lea	si,hidemenupos          ; on hide menu?
		test	ah,ah
		js	@@gotobeep		; UP
		jnz	@@gotomaster		; DOWN
		test	al,al
		js	@@gotodef		; LEFT
		jnz	@@gotomaster		; RIGHT
		jmp	@@dolight

@@nohidepos:	lea	si,masterpos
		test	ah,ah			; on master
		js	@@gotofloppy		; UP
		test	al,al
		js	@@gotohidemenu		; LEFT
		jz	@@dolight
		jmp	@@noblockup

@@gotohidemenu:	lea	si,hidemenupos
		jmp	@@dolight

@@gotodelay:	lea	si,delaypos
		jmp	@@dolight
@@gotodef:	lea	si,defaultpos
		jmp	@@dolight
@@gotofloppy:	lea	si,floppypos
		jmp	@@dolight
@@gotobeep:	lea	si,beeppos
		jmp	@@dolight		
@@gotomaster:	lea	si,masterpos
		jmp	@@dolight

;-- if in matrix

@@foundelement:	shl	ah,4
		shl	al,2
		or	al,ah
		xor	ah,ah
		cbw				; AX - movement in matrix
		add	si,ax			; SI - pointer to new pos

		cmp	si,offset blockmatrix
		jb	@@noblockup		; jump if below range
		cmp	si,di
		jb	@@dolight		; jump if in range
		lea	si,delaypos		; else point to delay

;oldlength
;DX - oldpos
;[SI] - newpos
;[SI+2] - newlength

@@dolight:	mov	ax,0b800h
		mov	es,ax
		call	pos2vidmem
		mov	al,1bh
		mov	cx,oldlength
@@deloldblock:	stosb
		inc	di
		loop	@@deloldblock

		mov	dx,[si]
		mov	oldpos,dx
		call	pos2vidmem
		mov	al,70h
		mov	cx,[si+2]
		mov	oldlength,cx
@@drawblock:	stosb
		inc	di
		loop	@@drawblock
		call	gotoXY

@@noblockup:	pop	es
		ret
		endp

;----------------------------------------------------------

pos2vidmem	proc	near
;In DX - pos
;Out DI - vidmem
		push	dx
		mov	al,80
		mul	dh
		xor	dh,dh
		add	ax,dx
		shl	ax,1
		inc	ax
		mov	di,ax
		pop	dx
		ret
		endp

;----------------------------------------------------------

printhelpline	proc	near
		push	ax
		push	dx
		mov	dx,1800h
		call	gotoXY
		pop	dx
		mov	ah,9
		int	21h
		pop	ax
		ret
		endp

;----------------------------------------------------------

		ends
		end

