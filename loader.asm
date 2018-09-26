.MODEL TINY
.CODE
.386

include defines.h

MBRBUF		equ	1000h
BOOTBUF		equ	2000h
windowleft	equ	1bh
windowtop	equ	5h
wide		equ	1dh

start:		jmp	start2

		db	'MREG'
		dw	versiostr
		db	versio

start2:
		xor	di,di		; DI = 0000
		cli
		mov	ss,di		; SS = 0000
		mov	sp,7C00h	; Set SS:SP
		sti

		cld
		mov	ds,di		; DS = 0000
		mov	si,sp		; SI = 7C00
		mov	ax,60h
		mov	es,ax		; ES = 0060
		mov	cx,100h		; move loader to 0060:0000
		rep	movsw

		push	es
		push	offset Loader
		retf			; start loader code

;-------------------------- Loader Code -----------------------------
Loader:		push	cs
		pop	ds		; CS = DS = ES = 0060

;----- read sectors ------

		mov	bx,200h
		mov	cl,2		; load CHS=0,0,2 sectors to
		mov	dx,80h		; 0060:0200
		mov	al,MBRsectors-1
		call	loadCHS		; now all sectors are loaded

		mov	ah,8
		int	13h		; get number of drives
		mov	al,dl
		cbw
		cmp	ax,numodrives
		jae	@@dontc
		mov	numodrives,ax

@@dontc:	mov	dx,80h
		mov	al,defchoi
		mov	actualsys,al	; copy default to variable

		mov	ax,[hidemenu?+2]
		mov	hidemenu?,ax
		cmp	hidemenu?,0
		jne	@@skipsec	; skip key flushing and drawing

;----- flush key buffer -----

flushnext:	mov	ah,1
		int	16h
		jz	nokey
		xor	ah,ah
		int	16h
		jmp	flushnext
nokey:
                call    setdisplay
                call    printwindow
		call	printnames		; DX holds cursor position

@@skipsec:	call	loadMBRs
;-------Ring beeper -------

		cmp	beeper?,0
		jz	nobeep

		mov	ax,0e07h
		mov	bh,1
		int	10h

;---------------

nobeep:		call	keycheck	; return: AL - selected OS number
		cmp	floppy?,1
		jne	@@kfln
		cmp	al,'a'		; floppy?
		je	@@floppy
@@kfln:		call	passchk		; password check

		call	getboot		; load boot sector
        	call	activate
		push	dx		; save HD ID
		call	hider
		call	writeback		
		call	rescursdriv     ; restore cursor, reset drive
		pop	dx		; HD ID

		xor	ax,ax
		mov	ds,ax
		mov	es,ax
		add	si,600h		; fixup SI by 0060: * 16
		mov	di,7c00h

		cmp	es:[di+37h],'61TA'	; examine FAT16
		jne	@@skf16
		mov	es:[di+24h],dl
		jmp	@@execboot
@@skf16:	cmp	es:[di+53h],'23TA'	; examine FAT32
		jne	@@execboot
		mov	es:[di+40h],dl
@@execboot:	push	es
		push	di
		retf			; JMP boot loader (0000:7C00)

@@floppy:	call	rescursdriv
		xor	ax,ax
		mov	es,ax
		mov	di,4		; try 4 times
		mov	bx,7c00h
		mov	cx,1
		xor	dx,dx
@@nextfl:	mov	ax,0201h
		int	13h
		jnc	@floadok
		xor	ah,ah		; if error
		int	13h		; reset drive
		dec	di		; and next try
		jnz	@@nextfl
		push	cs
		pop	es
		jmp	loaderr

@floadok:	mov	ax,40h
                mov     ds,ax
		jmp	@@execboot

;----------- Print error and halt if read error -----------

loaderr:	mov	bp,offset cantload	; print error message
		mov	cx,19			; and halt
		mov	dx,1800h
		mov	bx,0007h		; must write to page 0
		mov	ax,1300h
		int	10h
halt3:		jmp	halt3


;----------- Load CHS sector(s) -----------
;ES:BX - buffer
;CX - cylinder, sector
;DX - head, drive no
;AL - number of sectors
;Destroys: AX, DI

loadCHS		proc

tryread:	mov	ah,2
		int	13h
		jc	@@readerror
		ret

@@readerror:	mov	bp,offset cantload
		mov	dx,1800h
		mov	cx,19
		mov	bl,7
		call	string
halt1:		jmp	halt1

cantload	db	'Cannot read sector!'

		endp

;----------- Print String --------
;ES:BP - string address
;   CX - char number
;DH,DL - cursor pos
;BL    - color


string		proc

		push	ax
		push	bx
		mov	ax,1300h
		mov	bh,1
		int	10h
		pop	bx
		pop	ax

		ret

		endp


;----------- Load Master Boot Records ---------
loadMBRs	proc

		lea	si,HDIDs
		xor	dh,dh
		mov	bx,MBRBUF
		mov	cx,numodrives
nextMBR:	push	cx
		mov	dl,[si]
		mov	cx,1
		mov	al,1
		call	loadCHS
		pop	cx
		add	bx,200h
		inc	si
		loop	nextMBR

		mov	cx,4*16		 ; save original table of 1st HD
		mov	si,MBRBUF + 1beh ; we'll use it to check changes
		lea	di,dummy	 ; to decide in Writeback
		rep	movsb
		ret

		endp


;--------------- Set second display page and clear ----------

setdisplay	proc
		mov	ax,0501h                ; set active page
		int	10h

		mov	ax,0600h
		mov	bh,7
		xor	cx,cx                   ; clear screen
		mov	dx,244Fh
		int	10h

		mov	ah,1
		mov	cx,2000h		; hide cursor
		int	10h
                ret
                endp


		db	0ffh			; end of loader

;------------- Original Partition Table -----------------

		org	1beh


		db	16 dup (11h)
		db	16 dup (22h)
		db	16 dup (33h)
		db	16 dup (44h)

		db	55h,0AAh

;====================== This part goes to 0060:0200 ==========================
;                               Procedures

db 8 dup (0) ; shitty controller !!!

;----------- Restore cursor, reset drive -----------

rescursdriv	proc
		cmp	hidemenu?,0
		jne	@@skiprest
		mov	ax,0500h
		int	10h			; set active page
		mov	dh,numoselected
		add	dh,windowtop+8
		xor	dl,dl
		call	setcursor

		mov	ah,1
		mov	cx,0d0eh		; show cursor
		int	10h

@@skiprest:
;		xor	ax,ax
;		mov	dl,80h
;		int	13h		; reset drives

		ret
		endp

;-------- Set cursor pos ----------

setcursor	proc
;DX - position
		mov	ah,2
		mov	bh,1
		int	10h
		ret

		endp

;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;ллллллллллллллллллллллллллллл  Read sector(s) лллллллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

getboot		proc near
;AL - number of selected system
;OUT: DS:SI - selected partition's params
;     DL - selected system's HD number

		push	eax
		push	cx
		mov	si,offset B_selparams
		mov	ah,5
		mul	ah
		add	si,ax		; SI - selected partition parameters
		push	es
		push	si
                mov     dl,[si]

		xor	ax,ax
		mov	es,ax
		mov	bx,7c00h		; ES:BX = 0000:7C00

		cmp	EBIOS?,1
		jne	getCHS

		mov	ax,es			; get via EBIOS
		shl	eax,16
		mov	ax,bx
		mov	transpoint,eax
		mov	eax,[si+1]
		mov	firstpoint,eax
		mov	si,offset packet
		mov	ax,4200h
		jmp	getitnow

getCHS:		mov	ax,0201h		; get via BIOS
		mov	dh,[si+1]
		mov	cx,[si+2]
getitnow:	int	13h			; read sector
		jc	loaderr

		mov	ax,0aa55h
		mov	di,7dfeh		; fix boot sector signature
		mov	es:[di],ax
@@runboot:	pop	si

		mov	di,7c00h
		cmp	es:[di+36h],'SFPH'	; examine HPFS
		jne	@@skhpfs
		mov	es:[di+24h],dl		; fix disk ID
		mov	eax,[si+1]
		mov	es:[di+1ch],eax		; fix reserved sectors

@@skhpfs:	pop     es
		pop	cx
		pop	eax

		ret

		endp

;----------------------------------------------------

printnames	proc

		mov	bp,offset B_names	; name buffer
		mov	si,offset B_scancodes
		mov	dh,windowtop+3
		mov	dl,windowleft+2
		mov	al,actualsys
		sub	al,31h-(windowtop+3)
		mov	bh,31h			; system counter
		movzx	cx,numoselected

@@nextpart:	push	cx
		cmp	word ptr [si],0		; jump if protected system
		jne	@@protsys
		mov	ds:[bp],dh
		add	byte ptr ds:[bp],29h	; correct sys no
		mov	cx,19			; name is max 16 chars with no
		mov	bl,menucolor		; color
		cmp	dh,al			; highlight it?
		jne	@@nothigh

		mov	bl,highcolor		; highlight
		push	bp
		mov	cx,3			; calculate length of name
		add	bp,3
notzero:	inc	cx
		cmp	cx,19
		je	notmore
		inc	bp
		cmp	byte ptr ds:[bp],0
		jne	notzero
notmore:	pop	bp

@@nothigh:	call	string			; print string
		inc	dh			; step to next row
@@protsys:	add	bp,19			; point to next name
		inc	bh			; dec number of systems
		add	si,2			; point to next scancode value
		pop	cx
		loop	@@nextpart		; print choices

		cmp	floppy?,1
		jne	@@notflsh
		inc	dh
		mov	cx,19			; print floppy if enabled
		mov	bp,offset floppystr
		mov	bl,menucolor		; color
		call	string
@@notflsh:	ret

		endp


;----------- Write MBRs and data sector ----------
writeback	proc

		push	si
		mov	changed,0
		mov	cx,4*16			; check if anything is changed
		lea	si,dummy		; on the 1st disk's table
		mov	di,MBRBUF + 1beh	; we won't write if not
		rep	cmpsb
		jz	@@1stno
		mov	changed,1

@@1stno:	lea	si,HDIDs
		mov	cx,numodrives
		mov	bx,MBRBUF
		xor	dh,dh
@@nextwrite:	mov	dl,[si]
		push	cx
		mov	ax,0301h
		mov	cx,1
		cmp	changed,1
		jne	written
		int	13h
		jnc	written
		mov	bp,offset cantwrite	; print error message
		mov	cx,54			; and halt
		jmp	@@error

written:	mov	changed,1		; always write rest
		pop	cx
		inc	si
		add	bx,200h
		loop	@@nextwrite

		mov	ax,0301h
		lea	bx,MBR_data
		mov	cx,MBRsectors
		mov	dx,80h
		int	13h
		pop	si
		ret

		endp

;------ Seek current entry -------------
;DS:SI - pointer to params
;OUT: DS:SI - pointer to partition entry
seekcurrent	proc

		push	ax
		push	cx
		push	dx
		mov	dx,[si]
		mov	cx,[si+2]
		cmp	EBIOS?,1
		jne	seekCHS
		mov	ecx,[si+1]

seekCHS:	mov	si,MBRBUF + 1beh
		mov	ax,dx
		xor	ah,ah
		sub	al,80h
		shl	ax,9
		add	si,ax

		cmp	EBIOS?,1
		jne	seekCHS2
		mov	eax,ecx
		mov	cx,4
notLBA:		cmp	dword ptr ds:[si+8],eax
		je	foundit
		add	si,16
		loop	notLBA
		jmp	seeklogi

seekCHS2:	mov	ax,cx
		mov	cx,4
notthis:	cmp	word ptr ds:[si+2],ax
		jne	loopnx
		cmp	byte ptr ds:[si+1],dh
		je	foundit
loopnx:		add	si,16
		loop	notthis			; if not found, then logical

seeklogi:	sub	si,4*16
		mov	cx,4
logif:		cmp	byte ptr [si+4],5	; seek extended
		je	foundit
		cmp	byte ptr [si+4],0fh
		je	foundit
		add	si,16
		loop	logif

foundit:	pop	dx
		pop	cx
		pop	ax
		ret

		endp

;------------ Alter boot sector for true hiding --------
AlterBoot	proc
;DL - disk
;DS:SI - entry
;AL=1 to hide

		push	si
		push	ax
		mov	ax,es			; get via EBIOS
		shl	eax,16
		mov	ax,BOOTBUF
		mov	transpoint,eax
		mov	eax,[si+8]
		mov	firstpoint,eax
		mov	si,offset packet
		mov	ax,4200h
		int	13h
		pop	ax
		jc	loaderr
		mov	di,BOOTBUF + 510
		test	al,al
		jz	@@unhidebs
		cmp	word ptr es:[di],0	; already hidden?
		je	@@altered
		mov	word ptr es:[di],0	; hide
		jmp	@@writeboot

@@unhidebs:	cmp	word ptr es:[di],0aa55h	; already unhidden?
		je	@@altered
		mov	word ptr es:[di],0aa55h	; unhide

@@writeboot:	mov	si,offset packet
		mov	ax,4300h
		int	13h

@@altered:	pop	si
	 	ret
AlterBoot	endp

;----------- Hider/Unhider ---------
hider		proc
;AL - chosen system
                push    si			; pointer to entry
		mov	si,offset B_FATmap
		xor	ah,ah
		add	si,ax
		lodsb				; AL - FAT map
		movzx	cx,numoselected
		ror	al,cl
		mov	si,offset B_selparams

@@hnext:	push	si
		call	seekcurrent		; search a system to (un)hide
		rcl	al,1
		push	ax			; save map
		mov	al,[si+4]
		jc	@@hideit
		call	unhideit
@@okh:		pop	ax			; restore map
		pop	si
		add	si,5			; point to next selected system
		loop	@@hnext
                pop     si
                mov     al,[si+4]		; unhide current
                call    unhideit
		ret

@@hideit:	cmp	al,4
		je	@@okhide
		cmp	al,6
		je	@@okhide
		cmp	al,7
		je	@@okhide
		cmp	al,0bh
		je	@@okhide
		cmp	al,0ch
		je	@@okhide
		cmp	al,0eh
		je	@@okhide
		jmp	@@okh
@@okhide:	add	byte ptr ds:[si+4],10h
		mov	al,1
		call	AlterBoot
		jmp	@@okh

unhideit:	cmp	al,14h
		je	@@okunhide
		cmp	al,16h
		je	@@okunhide
		cmp	al,17h
		je	@@okunhide
		cmp	al,1bh
		je	@@okunhide
		cmp	al,1ch
		je	@@okunhide
		cmp	al,1eh
		jne	@@noun
@@okunhide:	sub	byte ptr ds:[si+4],10h
		mov	al,0
		call	AlterBoot
@@noun:		ret

hider		endp

;------- Get keystroke and examine it ---------
;return: AL - selected OS

keycheck	proc

		xor	ah,ah
		mov	al,delay
		test	al,al		; check if infinite delay
		jz	@@saverget	; jump screensaver
		cmp	al,99		; jump if infinite with no saver
		je	@@getkey

		call	insttimer	; install timer handler
		cmp	hidemenu?,0
		jne	@@skiptimer
		mov	cx,13
		mov	bp,offset timeleft
		mov	dh,numoselected
		sub	dh,numoprotted
		add	dh,windowtop+4
		add	dh,floppy?
		add	dh,floppy?
		mov	dl,windowleft+7
		mov	bl,menucolor
		call	string

@@skiptimer:	mov	ah,18
		mul	ah		; set delay
		call	waitkey		; wait for a keystroke
		jc	clexa		; if pressed, examine it

		xor	ah,ah
		mov	al,defchoi
					; set default if no key available
		jmp	@@examkey

;-----------
clexa:		cmp	hidemenu?,0
		jne	@@examkey
		mov	bp,offset empty
		mov	cx,16
		mov	dh,numoselected
		sub	dh,numoprotted
		add	dh,windowtop+4
		add	dh,floppy?
		add	dh,floppy?
		mov	dl,windowleft+7
		call	string		; clear 'time left' message
		jmp	@@examkey

;-----------

@@saverget:	mov	scrsaver?,1
		call	insttimer
		mov	ax,60*18	; 60 seconds
		call	waitkey
		jc	@@examkey	; examine if pressed
		call	panner		; else start saver
		jmp	@@saverget

@@testsaver:	cmp	scrsaver?,1
		je	@@saverget

@@getkey:	mov	ah,10h
		int	16h		; get key in AX

@@examkey:	cmp	hidemenu?,0
		je	@@menushown
		test	al,al
		je	@@specs
		cmp	al,0e0h
		je	@@specs
		cmp	byte ptr [hidemenu?],al
		je	@@showm
		jmp	@@enter
@@specs:	mov	al,ah
		mov	ah,1
		cmp	hidemenu?,ax
		jne	@@enter
@@showm:	mov	hidemenu?,0
		call	setdisplay
		call	printwindow
		call	printnames
		jmp	@@getkey

@@menushown:	cmp	floppy?,1
		jne	@@disflop
		cmp	al,'a'			; floppy?
		je	@@adrive
@@disflop:	mov	bh,numoselected
		sub	bh,numoprotted
		add	bh,30h		; BH - max number
		cmp	al,0dh
		je	@@enter		; enter
		test	al,al
		je	@@make1k	; if AL = 00 or E0, swap them and
		cmp	al,0e0h		;  let AH=1 to indicate special
		je	@@make1k	; else AH=0
		xor	ah,ah
		jmp	@@dont1k
@@make1k:	mov	al,ah
		mov	ah,1
@@dont1k:	cmp	ax,150h 	; down
		je	exadown
		cmp	ax,148h	        ; up
		je	exaup

		cmp	enableFx?,1	; function keys allowed?
		jne	@@notf4

		cmp	ax,13bh 	; F1 - original screen
		jne	@@notf1
		mov	ax,500h
@@chap:		int	10h
		jmp	@@testsaver

@@notf1:	cmp	ax,13ch 	; F2 - loader screen
		jne	@@notf2
		mov	ax,501h
		jmp	@@chap

@@notf2:	cmp	ax,13dh		; F3 - menu color
		jne	@@notf3
		mov	al,menucolor
		inc	al
		and	al,07fh
		mov	menucolor,al
		jmp	@@rewin

@@notf3:	cmp	ax,13eh		; F4 - highcolor
		jne	@@notf4
		mov	al,highcolor
		inc	al
		and	al,07fh
		mov	highcolor,al
@@rewin:	call	printwindow
		call	printnames
		jmp	@@testsaver

@@notf4:	call    searchprotted
		jnc	@@okkey

		cmp	al,bh		; is it above the max?
		ja	@@testsaver	; get new if yes
		cmp	al,'1'		; is it below 1?
		jnb	@@oknp		; jump if not
		jmp	@@testsaver

@@oknp:		call	setnoprotdef
		jmp	@@okkey

exadown:	cmp	actualsys,bh
		je	@@testsaver
		inc	actualsys
highl:		call	printnames
		jmp	@@testsaver

exaup:		cmp	actualsys,31h
		je	@@testsaver
		dec	actualsys
		jmp	highl

@@enter:	mov	al,actualsys
		call	setnoprotdef
@@okkey:	sub	al,31h
@@adrive:	ret

		endp

;---------------------------------

searchprotted	proc	near
;-- search for protted systems --

@@dontz:	xor	cl,cl
		mov	si,offset B_scancodes
@@seekforp:	cmp	[si],ax
		jne	@@notthisprot
		mov	al,cl
		add	al,31h
		jmp	@@gotprot
@@notthisprot:	inc	cl
		add	si,2
		cmp	cl,numoselected
		jb	@@seekforp
		stc
		ret

@@gotprot:	clc
		ret
                endp

;-----------------------------------

setnoprotdef	proc	near
		cmp	lastboot?,1
		jne	@@nosavedef		; save the actual as default?
		mov	defchoi,al

@@nosavedef:	movzx	cx,numoselected
		push	cx
		mov	ah,31h
		mov	si,offset B_scancodes
@@seeknzer:	cmp	word ptr [si],0
		jne	@@notunp
		cmp	ah,al
		je	@@gotthatzer
		inc	ah
@@notunp:	add	si,2
		loop	@@seeknzer
@@gotthatzer:	pop	bx
		sub	cl,bl
		neg	cl
		mov	al,cl
		add	al,31h
		ret
		endp

;----------- Password Check ----------
passchk		proc
;AX - selected (0-7)

		cmp	hidemenu?,0
		je	@@chkp
		ret

@@chkp:		push	ax
		mov	di,offset B_passwd
		xor	ah,ah
		shl	al,4
		add	di,ax		; DI - pointer to password entry

		cmp	byte ptr ds:[di],0
		jz	gdpass		; jump if no password given

		call	printwindow
		mov	dh,windowtop+1
		mov	dl,windowleft+2
		call	setcursor

		mov	bp,offset enterpas
		mov	cx,24
		mov	bl,menucolor
		call	string		; print 'Enter password: '

		mov	cx,3		; 3 retries
newtry:		push	cx
		inc	dh
		call	getpass		; get password
		mov	cx,16
		mov	si,offset B_passbuff
		push	di
		rep	cmpsb		; compare
		pop	di
		pop	cx
		jz	gdpass		; jump if good
		push	cx
		mov	bp,offset badpass
		dec	dh
		mov	cx,15
		call	string		; try again message
		pop	cx
		loop	newtry
		inc	dh
		mov	bp,offset sorry
		mov	cx,21		; imposter message
		call	string
hlt2:		jmp	hlt2

gdpass:		pop	ax
		ret

		endp

;-----------------------------
getpass		proc

		push	di
		mov	dl,windowleft+2		; set column
		call	setcursor
		mov	bp,offset empty
		mov	cx,16
		call	string
		mov	di,offset B_passbuff
		xor	al,al
		rep	stosb			; clear buffer
		sub	di,16
		mov	cx,16
nextchar:	xor	ah,ah
		int	16h
		cmp	al,13
		je	endinput
		cmp	al,' '
		jb	nextchar
		mov	byte ptr ds:[di],al
		mov	ah,0eh
		mov	al,'*'
		mov	bh,1
		int	10h
		inc	di
		loop	nextchar

endinput:	mov	dl,windowleft+2		; restore column
		pop	di
		ret

		endp


;------ Activate a partition ------
activate	proc
;OUT: SI - current entry

		call	seekcurrent
		cmp	byte ptr [si+4],5	; don't activate extended
		je	endact
		cmp	byte ptr [si+4],0fh
		je	endact
		cmp	byte ptr [si],80h	; don't write if already
		jne	activeit		; active, and is on the
		cmp	dl,80h			; first disk
		je	endact
activeit:	call	clearactives
		mov	byte ptr [si],80h
endact:		ret

		endp

;-------- Clear active flags on active HD -------
clearactives	proc

		push	si
		mov	si,11beh	; SI - type in partition table

		mov	cl,dl
		sub	cl,80h
		shl	cx,9
		add	si,cx
		mov	cx,4

clrnext:	mov	byte ptr [si],0
		add	si,16
		loop	clrnext
		pop	si
		ret

		endp

;---------- Set new timeout handler -----------

insttimer	proc

		push	ds		; install the timeout handler
		push	ax
		xor	ax,ax
		mov	ds,ax
		cli			; no interrupts
		mov	ax,ds:[1ch*4]	; get the old vector
		mov	cs:int1c_low,ax
		mov	ax,ds:[1ch*4+2]
		mov	cs:int1c_high,ax
		mov	word ptr ds:[1ch*4],offset tick	; install new vect.
		mov	ds:[1ch*4+2],cs
		sti				; done
		pop	ax
		pop	ds
		ret

		endp


;------------ Restore old handler -------------

removetimer	proc

		push	ds		; remove the interrupt handler
		push	ax
		xor	ax,ax
		mov	ds,ax
		cli
		mov	ax,cs:int1c_low		; restore the
		mov	ds:[1ch*4],ax		; old vector
		mov	ax,cs:int1c_high
		mov	ds:[1ch*4+2],ax
		sti				; done
		pop	ax
		pop	ds
		ret

		endp


;---------- Wait for a keystroke -----------

waitkey		proc

		cli			; set timeout value
		mov	cntdown,ax
		mov	timeout,0	; clear timed-out
		sti			; flag, done

actlp:		cmp	hidemenu?,0
		jne	@@skipct
		cmp	delay,0
		je	@@skipct			; skip if eternal
		cmp	scrsaver?,1
		je	@@skipct			; skip if screensaver
		mov	ax,cntdown
		mov	bh,18
		div	bh
		add	al,1
		xor	ah,ah
		call	toascii

@@skipct:	mov	ah,11h		; check keys
		int	16h
		jnz	shpress		; yes -> return with CY set
		test	timeout,1	; timed out ?
		jz	actlp		; no -> wait
		call	removetimer
		clc			; clear carry
		jmp	keyavail	; done

shpress:	call	removetimer
		mov	ah,10h
		int	16h		; get keystroke
		stc
keyavail:	pushf
		cmp	hidemenu?,0
		jne	@@skipct2
		cmp	delay,0
		je	@@skipct2
		cmp	scrsaver?,1
		je	@@skipct2
		push	ax
		xor	ax,ax
		call	toascii
		pop	ax
@@skipct2:	popf
		ret			; done

		endp

;------------------

tick		proc

		pushf			; save flags
		dec	cs:cntdown	; decrement counter
		jnz	notzro		; not zero -> go on
		mov	cs:timeout,0ffh ; set timeout
notzro:		popf			; flag, done
;		jmp	far cs:[int1c_low] ; continue with old interrupt
		db	2eh,0ffh,2eh
		dw	offset int1c_low

		endp

;------- Convert to ASCII and print -----
;AX - number

toascii		proc

		push	bx
		push	ax
		mov	dh,numoselected
		sub	dh,numoprotted
		add	dh,windowtop+4
		add	dh,floppy?
		add	dh,floppy?
		mov	dl,windowleft+18
		call	setcursor
		pop	ax

		mov	bl,0ah
		div	bl
		xchg	ah,al
		add	ah,30h
		add	al,30h
		cmp	ah,30h
		jnz	nospace
		mov	ah,20h
nospace:	push	ax
		mov	al,ah
		mov	ah,0eh
		mov	bh,1
		int	10h
		pop	ax
		mov	ah,0eh
		int	10h
		pop	bx
		ret
		endp	toascii

;--------- Print empty window -----

printwindow     proc
		mov	bp,offset nagyd
		mov	cx,wide
		mov	dh,windowtop
		mov	dl,windowleft
		mov	bl,menucolor
		call	string		; print 'MasterBoot... '

		mov	bp,offset message
		inc	dh
		call	string		; print 'Choose...'

		inc	dh
		xor	ch,ch
		mov	cl,numoselected
		sub	cl,numoprotted
		add	cx,3		; print window sides
		add	cl,floppy?
		add	cl,floppy?
		mov	bp,offset windowwall
walls:		push	cx
		mov	cx,wide
		call	string
		pop	cx
		inc	dh
		loop	walls

		mov	cx,wide
		mov	bp,offset windowbottom
		call	string
                ret

                endp

;------ Horizontal pan ------

panner          proc
		mov	ax,0502h		; set 3rd page active
		int	10h

		mov	ax,0600h
		mov	bh,7
		xor	cx,cx                   ; clear screen
		mov	dx,244Fh
		int	10h

;--print strings

		mov	ax,1301h
		mov	bh,2			; page number
		mov	bl,7
		mov	cx,20			; length
		mov	dh,12			; row
		mov	dl,62			; column
		mov	bp,offset str1
		int	10h			; display string 1
		mov	ax,1301h
		mov	bh,2
		mov	bl,7
		mov	cx,16
		mov	dh,13
		mov	dl,64
		mov	bp,offset str2
		int	10h

		mov	dx,3dah
		in	al,dx			; clear flip-flop

		mov	dx,3d4h
		mov	al,0dh
		out	dx,al			; select "start address low"
		inc	dx
		mov	al,30
		out	dx,al

@@nsc:		mov	cx,8
@@again:	mov	dx,3c0h
		mov	al,33h			; horizontal panning
		out	dx,al
		mov	al,pan
		out	dx,al
label	smc1 byte
		inc	pan
		je	@@end
		loop	@@again

; next chunk

		mov	pan,0
		mov	dx,3d5h
		mov	al,pos
		cmp	al,59
		je	@@eee
		cmp	al,2
		ja	@@oksor
		mov	smc1+1,06h
		mov	smc2+1,0c0h
		jmp	@@oksor

@@eee:		mov	smc1+1,0eh
		mov	smc2+1,0c8h

@@oksor:
label	smc2 byte
		inc	al
		mov	pos,al
		call	vrt
        	out	dx,al

		mov	dx,3c0h
		mov	al,33h
		out	dx,al
		mov	al,8
		out	dx,al

		mov	ah,1
		int	16h
		jnz	@@end

		jmp	@@nsc

@@end:		mov	dx,3c0h
		mov	al,33h		; reset video states
		out	dx,al
		mov	al,8
		out	dx,al
		mov	dx,3d5h
                xor     al,al
		out	dx,al
		mov	ax,0501h	; switch to menu
		int	10h
                xor     ax,ax		; flush key
                int     16h
		ret

vrt:		push    ax
                push    dx
@@z1:		mov	dx,3dah
		in	al,dx
		test	al,8
		jne	@@z1
@@z2:		in	al,dx
		test	al,8
		je	@@z2
                pop     dx
                pop     ax
		ret

		endp

;------------------ Print error ---------------------
;DS:BP
;CX
@@error:	mov	dx,1800h
		mov	bl,7
		call	string
halt2:		jmp	halt2


db 2a5h dup(0FFh)


;------------------------------ DATA ---------------------------------

		org	0c00h

nagyd		db	'ЩЭЭЭЭ MasterBooter v3.7 ЭЭЭЭЛ'
message		db	'К      Choose a system:     К'
windowwall	db	'К                           К'
windowbottom	db	'ШЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭМ'
floppystr	db	'a: boot from floppy'
enterpas	db	'Enter password:         '
badpass		db	'Bad. Try again:'
sorry		db	'Sorry, access denied!'
cantwrite	db	'Cannot write sector! Disable virus protection in BIOS.'
timeleft	db	'Time left:   '
empty		db	'                '

;-- overall parameters --

numodrives	dw	0
EBIOS?		db	0		; ebios inticator
HDIDs		db	4 dup(0)

; packet for extended read/write

packet		db	10h		; reserved
		db	0		; reserved
blocks		dw	1		; number of blocks to read
transpoint	dd	0		; transfer buffer pointer
firstpoint	dd	0		; pointer to first block on disk
		dd	0

timeout		db	0		; timeout indicator
cntdown		dw	0
int1c_low	dw	0		; old timer interrupt
int1c_high	dw	0

;--- run time variables ---
scrsaver?	db	0
pan		db	0
pos		db	0
actualsys	db	0

str1		db	'I love MasterBooter!'
str2		db	'Press any key...'


;-------------------- Parameters set by installer -------------------------

		org	0e00h
MBR_data	label

B_names		db	'1: '
		db	16 dup (0)
		db	'2: '
		db	16 dup (0)
		db	'3: '
		db	16 dup (0)
		db	'4: '
		db	16 dup (0)
		db	'5: '
		db	16 dup (0)
		db	'6: '
		db	16 dup (0)
		db	'7: '
		db	16 dup (0)
		db	'8: '
		db	16 dup (0)

B_selparams	db	40 dup (0)	; system params (8*5: HD, LBA sector)

B_passwd	db	16 dup (0)
		db	16 dup (0)
		db	16 dup (0)
		db	80 dup(0)	; password buffers (8*16)
B_passbuff	db	16 dup (0)	; for password query
B_masterpass	db	16 dup (0)

B_FATmap	db	8 dup (0)	; hiding bitmap for every system
B_scancodes	dw	8 dup (0)

menucolor	db	17h		; back and foreground color
highcolor	db	3fh
defchoi		db	31h

numoselected	db	0		; number of used entries
numoprotted	db	0		; number of protected entries
delay		db	5		; wait for keypress
lastboot?	db	0
beeper?		db	0
floppy?		db	1

hidemenu?	dw	0,0		; zero or scancode and backup
enableFx?	db	1		; disable Function keys?

dummy		db	121 dup (099h)
changed		db	0FFh
		ends
		end	start
