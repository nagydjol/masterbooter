.model tiny
;.stack 200h
.code
.386

include defines.h

HEADERSIZE	equ	32


		org	100h

start:
;push cs
;pop ds

		call	checkNT
		jc	quit
		call	detectwin9x
		call	getnumodrives
		jnc	@@gotthem
		jmp	quit
@@gotthem:      call    gethdids
		call	commandline	; process command line
quit:		mov	ax,4c00h
		int	21h

;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------

detectwin9x	proc
		mov	win95?,0
		mov	ax,1600h
		int	2fh		; detect Win9x
		cmp	al,4
		jne	@@notw95
		mov	win95?,1
@@notw95:	ret
		endp

;------------------------------------------------------------------

checkNT		proc
		mov	ax,3306h
		int	21h
		cmp	bx,3205h		; NT dos box
		je	@@itsNT
		clc
		ret

@@itsNT:	mov	ah,9
		lea	dx,S_NTbox
		int	21h
		xor	ax,ax
		int	16h
		stc
		ret
		endp


;--------------------------------------------

getnumodrives	proc
		mov	ah,8
		mov	dl,80h
		int	13h		; get drive parameters
		jc	@@nodrives
		test	dl,dl
		jz	@@nodrives
		xor	dh,dh
		mov	numodrives,dx	;set 'numodrives' variable
		clc
		ret

@@nodrives:	lea	dx,noexist
		call	print
		stc
		ret		

		endp

;----------------------------------------------------------

gethdids	proc
		lea	si,HDIDs
		mov	cx,numodrives
		mov	dx,80h
@getnextMBR:	call	checkdisktype
		jnc	@@noskipdisk
		dec	numodrives
		jmp	@@skipdisk

@@noskipdisk:	mov	[si],dl
		inc	si
@@skipdisk:	inc	dl
		loop	@getnextMBR
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

;-------------------------------------------------------------

creatembrinfo	proc
; MBRname
		lea	dx,reading
		call	print			; reading HD info
		lea	dx,S_hdinfo
		call	print

		call	createheader
		lea	bx,MBRbuffer+HEADERSIZE
		call	getmaintable		; get MBR+loader infos
		jnc	@@getboots
		ret

@@getboots:	call	getbootsecs		; get extendeds and boot secs
		jnc	@@savetof
		ret

@@savetof:	lea	dx,done
		call	print

		lea	dx,writing
		call	print			; writing info to floppy
		lea	dx,S_hdinfo
		call	print

		call	savetofile
		jnc	@@allcok
		ret

@@allcok:	lea	dx,done
		call	print
		clc
		ret

		endp

;--------------------------------------------

createheader	proc
; BX - buffer
; 

		lea	di,MBRbuffer
		mov	ax,versio
		stosw				; store version number
		stosw				; reserve for file size
		mov	eax,etotal
		stosd
		mov	eax,heads
		stosd
		mov	eax,sectors
		stosd
		mov	al,ebios		; ebios
		stosb
		mov	cx,15
		xor	al,al
		rep	stosb			; zero rest
		ret
		endp

;--------------------------------------------

getmaintable	proc
;In:  BX - MBR info area
;Out: BX - boot sector area

		xor	dh,dh
		mov	dl,targetdisk
		mov	ah,2			; read
		mov	al,MBRsectors		; sectors
		mov	cx,1			; from very first
		int	13h
		jnc	@@okread
		call	readerror		; in case of error
		ret

@@okread:	add	bx,MBRsectors*512
		clc
		ret
		endp

;--------------------------------------------

getbootsecs	proc
;BX - boot sector area
		lea	si,MBRbuffer+HEADERSIZE+1beh	; first partition
		mov	cx,4			; 4 main partitions
nMBRtable:	cmp	byte ptr [si+4],5
		je	@@saveext		; extended?
		cmp	byte ptr [si+4],0fh
		jne	notext			; LBA extended?
@@saveext:	call	saveextend		; save extended and boots
		jnc	dontboot
@@bootrerr:	ret

notext:		call	getoneboot		; get a boot from SI entry
		jc	@@bootrerr
dontboot:	add	si,16
		loop	nMBRtable

		clc
		ret
		endp

;--------------------------------------------

savetofile	proc

		mov	ah,3ch
		xor	cx,cx
		lea	dx,MBRname
		int	21h			; create file
		jnc	@@crmbrs
		lea	dx,S_create
		jmp	@@badfile

@@crmbrs:	mov	bx,ax
		mov	ax,MBRsectors*512
		mov	cx,bootsecs
		shl	cx,9
		add	ax,cx			; add bytes for bootsecs
		add	ax,HEADERSIZE		; add header size
		mov	cx,ax			; calc total length in CX
		lea	di,MBRbuffer+2
		stosw				; save size to MBRINFO

		mov	ah,40h
		lea	dx,MBRbuffer		; Write file
		int	21h
		jnc	@@mbrclo
		lea	dx,S_write
		jmp	@@badfile

@@mbrclo:	mov	ah,3eh			; Close file
		int	21h
		clc
		ret

@@badfile:	call	MBRfileerror
		ret
		endp



;-------------------- Save extended and boots ---------------------
saveextend	proc
;IN:  BX - buffer
;     SI - entry to main extended
;OUT: BX - new buffer

		push	si
		push	cx
		mov	eax,[si+8]
		mov	startmainext,eax	; save sectors before
		mov	startext,eax
		mov	blocks,1
nnext:		call	getsector		; get extended table
		jnc	goodmain
		jmp	errmain

goodmain:	mov	si,bx
		add	si,1beh			; point SI to first logical
		add	bx,512			; point BX to next free area
		inc	bootsecs		; inc counter

		mov	cx,4
getnext:	cmp	byte ptr [si+4],05h
		je	nextext
		cmp	byte ptr [si+4],0fh
		jne	nonextext

nextext:	mov	eax,[si+8]		; embedded extended
		add	eax,startmainext
		mov	startext,eax		; save absolute position
		jmp	nnext

nonextext:	mov	logi?,1
		call	getoneboot		; get logical boot sector
		mov	logi?,0
		jnc	@@okoneb
		jmp	errmain

@@okoneb:	add	si,16			; next entry in embedded
		loop	getnext
		clc
errmain:	pop	cx
		pop	si
		ret
		endp

;-------------------------------------------------------------
;-------------------------------------------------------------
;-------------------------------------------------------------

restorembrinfo	proc

		mov	ax,3
		int	10h
		lea	dx,restoring
		call	print
		lea	dx,S_hdinfo
		call	print

		mov	ax,3d00h
		lea	dx,MBRname		; check if MBR info exists
		int	21h
		jnc	@@foundmbr
		lea	dx,S_find
		jmp	@@resterr

@@foundmbr:	mov	bx,ax			; read MBR info
		mov	ah,3fh
		mov	cx,0ffffh
		lea	dx,MBRbuffer
		int	21h
		jnc	@@readmb
		lea	dx,S_read
		jmp	@@resterr

@@readmb:	mov	cx,ax			; save number of bytes read
		mov	ah,3eh			; close file
		int	21h

		call	checkMBRinfo
		jnc	@@validfile
		ret

@@validfile:	call	restoreMBR
		jnc	@@wrboots
		ret

@@wrboots:	call	restoreboots
		jnc	@@allrok
		ret

@@allrok:	lea	dx,done
		call	print
		clc
		ret

@@resterr:	call	MBRfileerror
		ret
		endp


;-------------------- Restore extended and boots ---------------------
restoreextended	proc
;IN:  BX - buffer
;OUT: BX - new buffer

		push	si
		push	cx
		mov	eax,[si+8]
		mov	startmainext,eax
		mov	startext,eax
		mov	blocks,1
wnnext:		call	writesector
		jc	werrmain

wgoodmain:	mov	si,bx
		add	si,1beh
		add	bx,512
		inc	bootsecs
		mov	cx,4

wgetnext:	cmp	byte ptr [si+4],05h
		je	wnextext
		cmp	byte ptr [si+4],0fh
		jne	wnonextext

wnextext:	mov	eax,[si+8]
		add	eax,startmainext
		mov	startext,eax
		jmp	wnnext

wnonextext:	mov	logi?,1
		call	writeboot
		mov	logi?,0
		jc	werrmain
		add	si,16
		loop	wgetnext
		clc
werrmain:	pop	cx
		pop	si
		ret
		endp


;-----------------------------------------------------------------
;-----------------------------------------------------------------

MBRfileerror	proc
		push	dx
		lea	dx,cannot
		call	print
		pop	dx
		call	print
		lea	dx,mbrfile
		call	print
		stc
		ret
		endp

;--------------------------------------------------

print		proc
;DX=pointer
		mov	ah,9
		int	21h
		ret

		endp

;-------------------------- Lock volume under Win95 ---------------------
lockvolume	proc
		cmp	win95?,1
		jne	dontlock

		push	ax
		push	bx
		push	cx
		push	dx
		mov	ax,440dh
		mov	cx,084bh
		mov	bh,1
		mov	bl,targetdisk
		xor	dx,dx
		int	21h
		pop	dx
		pop	cx
		pop	bx
		pop	ax
dontlock:	ret

		endp

;------------------------- Unlock volume ------------------
unlockvolume	proc

                pushf
		cmp	win95?,1
		jne	dontunlock

		push	ax
		push	bx
		push	cx
		mov	ax,440dh
		mov	cx,086bh
		mov	bl,targetdisk
		int	21h
		pop	cx
		pop	bx
		pop	ax
dontunlock:     popf
        	ret

		endp

;----------------------------- Command line -----------------------

commandline	proc

                mov     si,80h
		mov	cl,[si]
		xor	ch,ch
		test	cl,cl
		jz	@@usage                 ; empty -> usage
		inc	si
		call	skipwhite
        	call	tolower
		xor	ax,ax			; default target disk
		cmp	byte ptr [si],'8'
		ja	@@usage                 ; bigger than disk 8 -> usage
		cmp	byte ptr [si],'1'
		jb	@@notargethd            ; disk omitted
		lodsb
		sub	al,'1'
@@notargethd:	mov	cx,numodrives
		cmp	al,cl			; disk exists?
		jb	@@okspecdisk
		lea	dx,baddisk
		call	print
		jmp	@@cmdquit

@@okspecdisk:	push	si
		lea	si,HDIDs
		add	si,ax
		mov	bl,[si]
		mov	targetdisk,bl
		pop	si

         	call	ebios_check
        	call	getparams
                call    skipwhite
		lodsb
		cmp	al,'/'
		jne	@@usage 		; command?
        	cmp	byte ptr [si],'?'
		jne	@@nousage
@@usage:	lea	dx,usage		; usage
		call	print
@@cmdquit:	mov	al,1
		ret

@@nousage:	mov	cx,6
		lea	di,create
		call	examcom			; create?
		jc	notcreate
		add	si,6
		call	skipwhite
		lea	di,MBRname
		call	copyname
		call	creatembrinfo
		jmp	quitcmnd

notcreate:	mov	cx,7
		lea	di,restore
		call	examcom			; restore?
		jc	@@usage
		add	si,7
		call	skipwhite
		lea	di,MBRname
		call	copyname
		call	restorembrinfo
quitcmnd:	clc
		ret

		endp

;---------------------------------------
examcom:	push	si
		push	es

		push	ds
		pop	es
		rep	cmpsb
		je	paramok
		stc
		jmp	notthis
paramok:	clc

notthis:	pop	es
		pop	si
		ret

;------------- skips spaces and returns first non-whitespace ------------
skipwhite	proc near

		push	ax
skipitw:	mov	al,byte ptr [si]
		cmp	al,' '
		jne	exskip
		inc	si
		jmp	skipitw
exskip:		pop	ax
		ret

skipwhite	endp


;-----------------------------------

tolower		proc

		push	si
		dec	si
nextchar:	inc	si
		mov	al,[si]
		cmp	al,' '
		jb	endline
		cmp	al,'Z'
		ja	nextchar
		cmp	al,'A'
		jb	nextchar
		add	al,'a'-'A'
		mov	[si],al
		jmp	nextchar

endline:	pop	si
		ret

		endp

;--------------------------------------------
copyname	proc
;SI - from
;DI - to

		mov	cx,12		; max 12 chars
nextcha:	lodsb
		cmp	al,' '
		jbe	endcopy
		stosb
		loop	nextcha

endcopy:	xor	al,al
		stosb
		ret

		endp


;ллллллллллллллллллллллллллллл Get one sector ллллллллллллллллллллллллллл
getsector	proc near

;EAX - firstpoint for EBIOS
;BX - buffer
;blocks
		push	eax
		push	cx
		push	si

		cmp	ebios,1
		je	skiptrans

		call	LBA2CHS			; calc CHS if no EBIOS
		jc	@noerror		; jump if trans error

skiptrans:	mov	firstpoint,eax		; store firstpoint
		mov	ax,es
		shl	eax,16
		mov	ax,bx
		mov	transpoint,eax		; store transpoint
		mov	ax,blocks
		lea	si,packet

		mov	dl,targetdisk

		mov	ah,readint
		int	13h			; read MBR
		jnc	@noerror
		call	readerror
@noerror:	pop	si
		pop	cx
		pop	eax
		ret

getsector	endp

;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;ллллллллллллллллллллллллллллл Write sector(s) лллллллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

writesector	proc
;EAX - firstpoint
;BX - buffer
;blocks
		push	eax
		push	si
		push	cx

		cmp	ebios,1
		je	skipCHSw

		call	LBA2CHS
		jc	@written

skipCHSw:	mov	firstpoint,eax
		mov	ax,es
		shl	eax,16
		mov	ax,bx
		mov	transpoint,eax
		lea	si,packet

		mov	dl,targetdisk

@nexttry:	mov	al,0		; no verify
		cmp	ebios,1
		je	writebb
		mov	ax,blocks
writebb:	mov	ah,writeint
		call	lockvolume
		int	13h		; write new table
		call	unlockvolume
		jnc	@written
		call	writeerror
@written:	pop	cx
		pop	si
		pop	eax
		ret

writesector	endp


;---------------------- Get boot sector and inc BX -----------

getoneboot	proc
;IN:  SI - points to partition entry
;     BX - ES:BX points to buffer
;OUT: ES:BX - new empty buffer
		push	eax
		cmp	byte ptr [si+4],0	; empty entry
		jz	rexit
		mov	eax,[si+8]		; EAX - starting sect
		cmp	logi?,1
		jne	notlogi
		add	eax,startext		; correct if logical
notlogi:	cmp	byte ptr [si+4],0bh
		je	fat32
		cmp	byte ptr [si+4],0ch
		je	fat32
		cmp	byte ptr [si+4],1bh
		je	fat32
		cmp	byte ptr [si+4],1ch
		jne	notfat32

fat32:		mov	blocks,3		; in case of FAT32
		call	getsector		; we have to save 3 boot
		jc	rexit			; sectors
		add	bootsecs,3
		add	bx,512*3
		clc
		jmp	rexit

notfat32:	mov	blocks,1
		call	getsector
		jc	rexit
		inc	bootsecs
		add	bx,512

rexit:		pop	eax
		ret

		endp

;---------------------- Write boot sector and inc BX --------------

writeboot	proc
		push	eax
		cmp	byte ptr [si+4],0
		jz	wexit
		mov	eax,[si+8]		; EAX - starting sect
		cmp	logi?,1
		jne	wnotlogi
		add	eax,startext
wnotlogi:	cmp	byte ptr [si+4],0bh
		je	wfat32
		cmp	byte ptr [si+4],0ch
		je	wfat32
		cmp	byte ptr [si+4],1bh
		je	wfat32
		cmp	byte ptr [si+4],1ch
		jne	notwfat32

wfat32:		mov	blocks,3		; in case of FAT32
		call	writesector		; we have to save 3 boot
		jc	wexit			; sectors
		add	bootsecs,3
		add	bx,512*3
		clc
		jmp	wexit

notwfat32:	mov	blocks,1
		call	writesector
		jc	wexit
		inc	bootsecs
		add	bx,512

wexit:		pop	eax
		ret
                endp

;ллллллллллллллллллллллл Calculate CHS from LBA ллллллллллллллллллллллллл

LBA2CHS		proc near
;IN:  EAX - LBA sector
;OUT: CH - cylinder low
;     CL - sector + cylinder high
;     DH - head

		cmp	eax,maxBIOS		; check size
		jbe	noaboveCHS		; jump if below BIOS limit

		cmp	ebios,1			; check if ebios available
		je	noaboveCHS		; jump if yes

		lea	dx,noebios		; else print error
		call	print
		stc
		jmp	errorconv

noaboveCHS:	push	eax
		push	ebx
		push	si

		xor	ecx,ecx			; erase upper nibbles
		mov	ebx,eax

		mov	eax,heads		; (head) first divide the LBA value
		mul	sectors			; (sector) by max sectors*max heads
		xchg	eax,ebx			; to calculate the cylinder
		div	ebx			; value
        	mov	cx,ax			; CX - cylinder
		cmp	cx,1023			; correct if above
		jbe	dontccyl		;  1023 cyls
        	mov	cx,1023
dontccyl:	xchg	ch,cl
		shl	cl,6
		mov	eax,edx			; then divide the remainder
		xor	edx,edx
		div	sectors			; by the max sectors to get
        	mov	dh,al			; the head and the sector
		or	cl,dl
                inc     cl

		clc
errorconv:	pop	si
		pop	ebx
		pop	eax
		ret

		endp

;---------------------------- Check EBIOS ----------------------------

ebios_check	proc near

		push	si
                mov     ebios,0
		mov	writeint,3
		mov	readint,2

		mov	ah,41h
		mov	bx,55aah
		mov	dl,targetdisk
		int	13h			; installation check
		jc	@@noebios

@@checkit:	cmp	bx,0aa55h		; check 1
		jne	@@noebios
                and     cx,1			; check 2
                jz      @@noebios

		mov	ah,48h
		mov	dl,targetdisk
		lea	si,ebiosparams
                mov     word ptr [si],1ah
		int	13h
		jc	@@noebios

		mov	ebios,1			; ok, turn these on
		mov	readint,42h
		mov	writeint,43h
@@noebios:	pop	si
		ret

		endp

;------------------------------------------------------------
getparams	proc near

;Reads parameter of disk

		push	si
		mov	ah,8
		mov	dl,targetdisk
		int	13h			; get parameters
		movzx	ebx,cx
		xchg	bh,bl
		shr	bh,6
		inc	bx
		mov	cyls,ebx		; number of cylinders
		and	ecx,3fh
		mov	sectors,ecx		; number of sectors
		movzx	edx,dh
		inc	edx
		mov	heads,edx		; number of heads

		mov	eax,cyls
		mul	heads
		mul	sectors
		dec	eax			; calc max BIOS
		mov	maxBIOS,eax

		cmp	ebios,1
		jne	nocylcorr

		mov	eax,heads
		mul	sectors
		mov	ebx,eax			; EBX - sectors*heads
		mov	eax,etotal
		div	ebx			;  proper cylinder number
		mov	cyls,eax
nocylcorr:	pop	si

		ret

		endp


;--------------------------------------------

readerror	proc
		lea	dx,cannot
		call	print
		lea	dx,S_read
		call	print
		lea	dx,S_sector
		call	print
		stc
		ret
		endp

;--------------------------------------------

writeerror	proc
		lea	dx,cannot
		call	print
		lea	dx,S_write
		call	print
		lea	dx,S_sector
		call	print
		stc
		ret
		endp


;--------------------------------------------

checkMBRinfo	proc
; CX - file size
		lea	si,MBRbuffer		; SI - MBRbuffer
		lodsw
		cmp	ax,versio		; check version ID
		jne	@@badversion
		lodsw
		cmp	ax,cx			; check size
		jne	@@badcorrupt
		lodsd
		cmp	eax,etotal
		jne	@@badchar
		lodsd
		cmp	eax,heads
		jne	@@badchar
		lodsd
		cmp	eax,sectors
		jne	@@badchar
		clc
		ret

@@badchar:	lea	dx,badchar
		jmp	@@pMBRerr

@@badversion:	lea	dx,badversion		; bad version
		jmp	@@pMBRerr

@@badcorrupt:	lea	dx,badcorrupt		; invalid size
@@pMBRerr:	call	print
		stc
		ret
		endp

;--------------------------------------------

restoreMBR	proc
		lea	bx,MBRbuffer+HEADERSIZE
		xor	dx,dx
		call	lockvolume
		mov	ah,3
		mov	al,MBRsectors
		mov	cx,1
		mov	dl,targetdisk
		int	13h			; restore MBRs
		call	unlockvolume
		jnc	writtenmbr
		call	writeerror
		ret

writtenmbr:	add	bx,MBRsectors*512
		clc
		ret
		endp

;--------------------------------------------

restoreboots	proc
		lea	si,MBRbuffer+HEADERSIZE+1beh
		mov	cx,4
nwMBRtable:	cmp	byte ptr [si+4],5
                je      wext
                cmp     byte ptr [si+4],0fh
                jne     notwext
wext:		call	restoreextended
		jnc	nextwr
writerr:	pop	cx
		ret

notwext:        call    writeboot
		jc	writerr
nextwr:		add	si,16
		loop	nwMBRtable

		clc
		ret
		endp

;----------------------------------------------------------
;----------------------------------------------------------
;----------------------------------------------------------


usage		db	'mrescue 3.7. Author: Nagy Daniel.',0dh,0ah
		db	'Usage: mrescue [disk] <command> <filename>',0dh,0ah
		db	'Commands:',0dh,0ah
		db	'/create     - save partition table and boot sectors to a file',0dh,0ah
		db	'/restore    - restore partition table and boot sectors from a file',0dh,0ah,0dh,0ah
		db	'Default disk is 1$'


cannot		db	0dh,0ah,'Cannot $'
S_find		db	'find$'
S_read		db	'read$'
S_create	db	'create$'
S_write		db	'write$'
S_sector	db	' disk sector!$'
mbrfile		db	' rescue file!$'

noexist		db	0dh,0ah,'No harddisk found$'
noebios		db	0dh,0ah,'EBIOS is needed above 1023 cylinders!$'

baddisk		db	'Specified disk does not exist$'
badchar		db	0dh,0ah,'Disk characteristics doesn',"'",'t match!$'
badversion	db	0dh,0ah,'Bad MBRINFO file version!$'
badcorrupt	db	0dh,0ah,'Corrupt MBRINFO file!$'

S_NTbox		db	'Cannot run in WinNT/2k/XP DOS box. Run from DOS or Win9x/ME',0dh,0ah
		db	'Press a key...$'

reading		db	'Reading$'
writing		db	'Writing$'
restoring	db	'Restoring$'
S_hdinfo	db	' hard disk information...$'
done		db	' Done',0dh,0ah,'$'

MBRname		db	13 dup (0)
create		db	'create'
restore		db	'restore'

win95?          db      0
logi?		db	0

startmainext	dd	0		; start of main extended
startext	dd	0		; start of extended

readint		db	2		; interrupt no for disk sector read
writeint	db	3
ebios		db	0		; EBIOS indicator
maxBIOS		dd	0

;-------- ebios packet --------
ebiosparams 	dw	0		; buffer size
		dw	0		; information flags
cyls		dd	0		; number of physical cylinders on drive
heads		dd	0		; number of physical heads on drive
sectors		dd	0		; number of physical sectors per track
etotal	        dd	0		; total number of sectors on drive
		dd	0
		dw	0		; bytes per sector
		dd	0
                db      36 dup (0)
;-------- ebios packet end -------

; packet for extended read/write

packet		db	10h		; reserved
		db	0		; reserved
blocks		dw	0		; blocks
transpoint	dd	0		; transfer buffer pointer
firstpoint	dd	0		; pointer to first block on disk
		dd	0


bootsecs	dw	0
numodrives	dw	0
targetdisk      db      80h

HDIDs           db      8 dup (0)

MBRbuffer	label	byte

		ends
		end	start
