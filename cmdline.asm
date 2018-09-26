.MODEL SMALL

include defines.h

DataSegment	segment para public 'data'
extrn beeper?:byte
extrn floppy?:byte
extrn enableFX?:byte
extrn macro?:byte
extrn numoselected:byte
extrn lastboot?:byte
extrn defchoi:byte
extrn delay:byte
extrn highcolor:byte
extrn menucolor:byte
extrn targetdisk:byte
public B_commandline

C_beep		db	'beep'
C_floppy	db	'floppy'
C_default	db	'default'
C_delay		db	'delay'
C_highcolor	db	'highcolor'
C_menucolor	db	'menucolor'
C_macro		db	'macro'
C_fkeys		db	'funckeys'

S_beepset	db	'Beeping$'
S_floppy	db	'Floppy support$'
S_func  	db	'Function keys support$'
S_defset	db	'Default system$'
S_delayset	db	'Delay time$'
S_color		db	'Color$'
S_endcomm	db	' has been set successfully',0dh,0ah,'$'
S_written	db	'New settings have been written successfully$'

S_badcommand	db	'Error: Bad command line option. Use ? for help$'

S_commandhelp	db	'MasterBooter ', versiostr2, ' ', copyright,0dh,0ah
		db	'Usage: mrbooter [disk | commands]',0dh,0ah
		db	'/beep:<1|0>          - set beeping on/off',0dh,0ah
		db	'/floppy:<1|0>        - set floppy boot support on/off',0dh,0ah
		db	'/funckeys:<1|0>      - set boot time function keys support on/off',0dh,0ah
		db	'/default:<n>         - set n-th system default (0 for the last active)',0dh,0ah
		db	'/delay:<n>           - set delay time (1-99 secs, 0 for infinite)',0dh,0ah
		db	'/highcolor:<n>:<m>   - set highlight color in menu (check documentation)',0dh,0ah
		db	'/menucolor:<n>:<m>   - set boot menu color (check documentation)',0dh,0ah
		db	'/macro               - saves the keystrokes to macro.mbr for later use',0dh,0ah
                db      '/?                   - show this help$'

B_commandline	db	255 dup (0)
ends


_TEXT		segment public
.386
assume cs:_TEXT, ds:DataSegment
public checkcmdline,commandline
extrn correctdefault:near
extrn savemenu:near
;------------------------------------------------------------------

checkcmdline	proc
		push	ds
		push	es

		push	ds
		pop	es
		mov	ax,cs
		sub	ax,10h
		mov	ds,ax
		mov	si,80h
		mov	cl,[si]
		xor	ch,ch
		test	cl,cl
		jz	@@nocm
		inc	si
		call	skipspace
		cmp	byte ptr [si],'9'
		ja	@@nocm
		cmp	byte ptr [si],'1'
		jb	@@notargethd
		lodsb
		sub	al,'1'
		mov	es:targetdisk,al
		jmp	@@nocm
@@notargethd:	cmp	byte ptr [si],'/'
		jne	@@nocm
		lea	di,B_commandline
@@nco:		lodsb
		cmp	al,20h
		jb	@@endccopy
		stosb
		jmp	@@nco

@@endccopy:	pop	es
		pop	ds
		call	tolower			; lowercase command line
		lea	si,B_commandline+1	; skip '/'
		lea	di,C_macro
		mov	cx,5
		call	checkcmd
		jne	@@nomcr
		mov	macro?,1
@@nomcr:	clc
		ret

@@nocm:		stc
		pop	es
		pop	ds
		ret
		endp

;--------------

skipspace	proc	near
@@sksp:		cmp	byte ptr [si],20h
		jne	@@skipped
		inc	si
		jmp	@@sksp
@@skipped:	ret
		endp

;--------------

tolower		proc	near

		lea	si,B_commandline-1
@@nextchar:	inc	si
		mov	al,[si]
		cmp	al,' '
		jb	@@endline
		cmp	al,'Z'
		ja	@@nextchar
		cmp	al,'A'
		jb	@@nextchar
		add	al,'a'-'A'
		mov	[si],al
		jmp	@@nextchar
@@endline:	ret
		endp

;------------------------------------------------------------------

commandline	proc	near

        	lea	si,B_commandline

@@nextcommand:	cmp	byte ptr [si],'/'
		jne	@@badcommand
		inc	si

		cmp	byte ptr [si],'?'
		je	@@printhelp

		lea	di,C_beep
		mov	cx,4
		call	checkcmd
		jne	@@nobeep
		add	si,4
		call	beep
		jc	@@badcommand
		jmp	@@endcommand

@@nobeep:	lea	di,C_floppy
		mov	cx,6
		call	checkcmd
		jne	@@nofloppy
		add	si,6
		call	floppys
		jc	@@badcommand
		jmp	@@endcommand

@@nofloppy:	lea	di,C_default
		mov	cx,7
		call	checkcmd
		jne	@@nodef
		add	si,7
		call	default
		jc	@@badcommand
		jmp	@@endcommand

@@nodef:	lea	di,C_delay
		mov	cx,5
		call	checkcmd
		jne	@@nodela
		add	si,5
		call	delayit
		jc	@@badcommand
		jmp	@@endcommand

@@nodela:	lea	di,C_fkeys
		mov	cx,8
		call	checkcmd
		jne	@@nofkeys
		add	si,8
		call	funckeyit
		jc	@@badcommand
		jmp	@@endcommand

@@nofkeys:	lea	di,C_highcolor
		mov	cx,9
		call	checkcmd
		jne	@@nohigh
		add	si,9
		call	highcolorit
		jc	@@badcommand
		jmp	@@endcommand

@@nohigh:	lea	di,C_menucolor
		mov	cx,9
		call	checkcmd
		jne	@@badcommand
		add	si,9
		call	menucolorit
		jc	@@badcommand
		jmp	@@endcommand

@@badcommand:	lea	dx,S_badcommand
		mov	ah,9
		int	21h
		stc
		ret

@@printhelp:	lea	dx,S_commandhelp
		mov	ah,9
		int	21h
		clc
		ret

@@endcommand:	call	skipspace
		cmp	byte ptr [si],' '
		jae	@@nextcommand
		call	savemenu
		mov	ah,9
		lea	dx,S_written
		int	21h
@@macquit:	clc
		ret

		endp

;------------------------------------------------------------------

checkcmd	proc	near
		push	si
		push	es

		push	ds
		pop	es
		rep	cmpsb

		pop	es
		pop	si
		ret
		endp

;------------------------------------------------------------------
beep		proc	near
		call	getparam
		jc	@@badbeep
		cmp	al,1
		je	@@enabeep
		test	al,al
		je	@@disabeep
@@badbeep:	stc
		ret

@@enabeep:	mov	beeper?,1
		jmp	@@beepok

@@disabeep:	mov	beeper?,0
@@beepok:	mov	ah,9
		lea	dx,S_beepset
		int	21h
		lea	dx,S_endcomm
		int	21h
		clc
		ret
		endp
;------------------------------------------------------------------
floppys		proc	near
		call	getparam
		jc	@@badflop
		cmp	al,1
		je	@@enaflop
		test	al,al
		je	@@disaflop
@@badflop:	stc
		ret

@@enaflop:	mov	floppy?,1
		jmp	@@flopok

@@disaflop:	mov	floppy?,0
@@flopok:	mov	ah,9
		lea	dx,S_floppy
		int	21h
		lea	dx,S_endcomm
		int	21h
		clc
		ret
		endp
;------------------------------------------------------------------
default		proc	near
		call	getparam
		jc	@@baddef
		cmp	al,numoselected
		ja	@@baddef
		test	al,al
		jne	@@defspec
		mov	lastboot?,1
		mov	defchoi,'1'
		jmp	@@defset

@@defspec:	add	al,30h
		mov	lastboot?,0
		mov	defchoi,al
		call	correctdefault
@@defset:	mov	ah,9
		lea	dx,S_defset
		int	21h
		lea	dx,S_endcomm
		int	21h
		clc
		ret

@@baddef:	stc
		ret
		endp
;------------------------------------------------------------------
delayit		proc	near
		call	getparam
		jc	@@baddel
		cmp	al,99
		ja	@@baddel
		mov	delay,al
		mov	ah,9
		lea	dx,S_delayset
		int	21h
		lea	dx,S_endcomm
		int	21h
		clc
		ret

@@baddel:	stc
		ret
		endp

;------------------------------------------------------------------
funckeyit	proc	near
		call	getparam
		jc	@@badfunc
		cmp	al,1
		je	@@enafunc
		test	al,al
		je	@@disafunc
@@badfunc:	stc
		ret

@@enafunc:	mov	enableFX?,1
		jmp	@@funcok

@@disafunc:	mov	enableFX?,0
@@funcok:	mov	ah,9
		lea	dx,S_func
		int	21h
		lea	dx,S_endcomm
		int	21h
		clc
		ret
		endp

;------------------------------------------------------------------
highcolorit	proc	near
		call	getparam
		jc	@@badcol
		mov	cl,al
		call	getparam
		jc	@@badcol
		shl	cl,4
		or	al,cl
		mov	highcolor,al
		jmp	@@colok

@@badcol:	stc
		ret
		endp
;------------------------------------------------------------------
menucolorit	proc	near
		call	getparam
		jc	@@badcol
		mov	cl,al
		call	getparam
		jc	@@badcol
		shl	cl,4
		or	al,cl
		mov	menucolor,al
@@colok:	mov	ah,9
		lea	dx,S_color
		int	21h
		lea	dx,S_endcomm
		int	21h
		clc
		ret
		endp
;------------------------------------------------------------------

getparam	proc	near

;SI - ASCII buffer
;Out: AX - hexa numa

		lodsb
		cmp	al,':'
		jne	@@badopt
		xor	bx,bx
@@nextvalu:	lodsb
		cmp	al,':'
		je	@@secg
		cmp	al,20h		; end if space or below
		jbe	okopt
		cmp	al,30h		; bad if less than zero
		jb	@@badopt
		cmp	al,39h		; bad if larger than 9
		ja	@@badopt
		sub	al,30h
		xchg	al,bl
		mov	ah,0ah
		mul	ah
		add	al,bl
		xchg	al,bl
		jmp	@@nextvalu

@@secg:		dec	si
okopt:		mov	ax,bx
		clc
		ret

@@badopt:	stc
		ret
		endp

		ends
		end
