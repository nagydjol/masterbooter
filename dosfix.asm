.model tiny
.code
.386

		org	100h

start:		lea	dx,initmsg
		call	print
		lea	dx,cont
		call	print
		xor	ax,ax
		int	16h
		and	al,5fh
		cmp	al,'Y'
		je	@@fixthem
		mov	ax,4c00h
		int	21h

@@fixthem:	mov	win95?,0
	 	mov	ax,1600h
		int	2fh		; detect Win95 box
		cmp	al,4
		jne	notw95
		mov	win95?,1

notw95:		mov	ah,8
		mov	dl,80h
		int	13h		; get number of disks
		jc	@@nodisk
		movzx	cx,dl		; cx - number of drives
		test	cx,cx
		jnz	@@vandisk
@@nodisk:	lea	dx,E_nodisk
		mov	ah,9		; error if no disks
		int	21h
		mov	ax,4c01h
		int	21h

@@vandisk:	mov	actualHD,80h	; starting harddisk

;----------------------------------------------

nextHD:		lea	dx,loadpt
		call	print		; 'examining partition table'
		mov	ah,2
		mov	dl,actualHD
		sub	dl,4fh
		int	21h		; print HD number

		call	loadPtable	; load table and analyse
		jc	@@quit

		inc	actualHD
		loop	nextHD		; proceed to next HD's table

		lea	dx,done		; print exit message
		call	print
		clc

@@quit:		mov	ax,4c00h
		adc	al,0
		int	21h

;---------- Load partition table  --------

loadPtable	proc

		push	cx			; save numodrives
		lea	bx,MBRbuffer		; load partition table
		mov	al,1
		mov	cx,1
		xor	dh,dh
		call	getsector
		jc	@@gparterr

		mov	cx,4			; 4 partitions per table
		lea	si,MBRbuffer+1beh	; SI - first entry

nextboot:	lea	dx,loadbt		; 'examining boot sector'
		call	print

		call	loadboot		; load boot sector and fix
		jc	@@gparterr
		add	si,10h
		loop	nextboot		; load next
		clc
@@gparterr:	pop	cx
		ret

loadPtable	endp

;--------------- Fix boot sectors ---------------

loadboot	proc

		push	cx			; remaining partition entries
		push	si			; SI - current table entry

		lea	bp,types
		mov	cx,8			; 8 supported types
nextID:		mov	al,[bp]
		cmp	byte ptr [si+4],al	; load only FAT and HP/NTFS
                jne     notsupp			;  partitions (and hidden)
		cmp	dword ptr [si+8],1024*256*63
		jae	notsupp			; and below 8 gigs
		call	fixit
		jmp	quitfix
notsupp:	inc	bp
		loop	nextID

quitfix:	pop	si
		pop	cx
		ret

endp

;-------------------------------

fixit           proc
;AL - type
;SI - entry

		push	cx
                mov     write?,0
		lea	bx,MBRbuffer+512
		mov	al,1
		mov	dh,[si+1]
		mov	dl,actualHD
		mov	cx,[si+2]
		call	getsector		; load boot sector
		jc	dontw

;		mov	al,[si+4]		; AL - type
;		cmp	al,0bh
;		je	FAT32
;		cmp	al,0ch
;		je	FAT32
;		cmp	al,1bh
;		je	FAT32
;		cmp	al,1ch
;		je	FAT32
;
;-- examine physical if FAT16
; 
;		cmp	[bx+24h],dl		; examine if physical unit
;		je	skipfix			; number is correct,
;		mov	[bx+24h],dl		; fix if isn't
;
;		lea	dx,fixbt
;		call	print			; print message
;		mov	write?,1
;
;-- examine bad DOS if FAT16
;
skipfix:        lea     di,MBRbuffer+512+3
		push	si
		lea	si,mssig
		mov	cx,8
		rep	cmpsb			; first check
		pop	si
		jne	dontfix

		lea	di,MBRbuffer+512+160h
                mov     ax,0c933h
                cmp	es:[di],ax		; second check
                je	dontfix

		push	si
                mov     cx,512-3eh
                lea     si,patch
		lea	di,MBRbuffer+512+3eh	; patch it!
                rep     movsb
		pop	si

                lea     dx,fixdos
                call    print
                mov     write?,1
;		jmp	dontfix

;FAT32:
;		cmp	[bx+64],dl
;		je	dontfix
;		mov	[bx+64],dl
;		lea	dx,fixbt
;		call	print			; print message
;		mov	write?,1
		
dontfix:	cmp     write?,0
                jz      dontw
		mov	al,1
		mov	dh,[si+1]
		mov	cx,[si+2]
		mov	dl,actualHD
		call	writesector		; write new boot sector
dontw:  	pop	cx
                ret
		endp

;------------------------ Get sectors -----------------------
getsector	proc
;AL - number of secs
;DH - head
;CX - sector
;Loads MBR to BX
;Destroys: AX, DI

		mov	dl,actualHD
		mov	ah,2
		int	13h		; get sectors
		jc	badsect
                ret

badsect:	lea	dx,cantload
		call	print
		stc
		ret
		endp

;------------------------ Write sectors -----------------------
writesector	proc
;AL - number of secs
;DX - head, disk
;CX - sector
;from BX
;Destroys: AH, DI

		call	lockvolume
retry2:		mov	ah,3
		int	13h			; write sector
		call	unlockvolume
		jc	badwrite
		clc
                ret

badwrite:	lea	dx,cantwrite
		call	print
		stc
		ret

		endp


;-------------------------- Lock volume under Win95 ---------------------
lockvolume	proc
;DL - disk no.
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

;------------------------- Unlock volume ------------------
unlockvolume	proc
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

;-----------------

print		proc

		mov	ah,9
		int	21h
		ret

		endp

;---------

initmsg		db	'BOOTFIX utility for MasterBooter. This utility corrects the Physical Unit',0dh,0ah
		db	'Number value in FAT and HPFS partitions',39,' boot sector and fixes DOS',0dh,0ah
		db	'boot loader error. Run this utility if you get ',39,'Invalid system disk',39,0dh,0ah
		db	'error message. Please read the FAQ for more information.',0dh,0ah,'$'
cont		db	'Do you want to continue (y/n)?',0dh,0ah,'$'

cantload	db	0dh,0ah,'Cannot load sector$'
cantwrite	db	0dh,0ah,'Cannot write sector$'
E_nodisk	db	0dh,0ah,'No fixed disk found$'

loadpt		db	0dh,0ah,'Examining partition table $'
loadbt		db	0dh,0ah,'Examining FAT boot sector...$'
;fixbt		db	0dh,0ah,'Fixing physical media value$'
fixdos		db	0dh,0ah,'Fixing DOS boot sector$'

done		db	0dh,0ah,'Done',0dh,0ah,'$'

mssig		db	'MSDOS5.0'

write?		db	0
win95?          db      0
actualHD	db	0
types		db	4,6,7,0eh
		db	14h,16h,17h,1eh
;,0bh,0ch,1bh,1ch

patch	label
DB 0FAh,033h
DB 0C0h,08Eh,0D0h,0BCh,000h,07Ch,016h,007h,0BBh,078h,000h,036h,0C5h,037h,01Eh,056h
DB 016h,053h,0BFh,03Eh,07Ch,0B9h,00Bh,000h,0FCh,0F3h,0A4h,006h,01Fh,0C6h,045h,0FEh
DB 00Fh,08Bh,00Eh,018h,07Ch,088h,04Dh,0F9h,089h,047h,002h,0C7h,007h,03Eh,07Ch,0FBh
DB 0CDh,013h,072h,079h,033h,0C0h,039h,006h,013h,07Ch,074h,008h,08Bh,00Eh,013h,07Ch
DB 089h,00Eh,020h,07Ch,0A0h,010h,07Ch,0F7h,026h,016h,07Ch,003h,006h,01Ch,07Ch,013h
DB 016h,01Eh,07Ch,003h,006h,00Eh,07Ch,083h,0D2h,000h,0A3h,050h,07Ch,089h,016h,052h
DB 07Ch,0A3h,049h,07Ch,089h,016h,04Bh,07Ch,0B8h,020h,000h,0F7h,026h,011h,07Ch,08Bh
DB 01Eh,00Bh,07Ch,003h,0C3h,048h,0F7h,0F3h,001h,006h,049h,07Ch,083h,016h,04Bh,07Ch
DB 000h,0BBh,000h,005h,08Bh,016h,052h,07Ch,0A1h,050h,07Ch,0E8h,092h,000h,072h,01Dh
DB 0B0h,001h,0E8h,0ACh,000h,072h,016h,08Bh,0FBh,0B9h,00Bh,000h,0BEh,0E6h,07Dh,0F3h
DB 0A6h,075h,00Ah,08Dh,07Fh,020h,0B9h,00Bh,000h,0F3h,0A6h,074h,018h,0BEh,09Eh,07Dh
DB 0E8h,05Fh,000h,033h,0C0h,0CDh,016h,05Eh,01Fh,08Fh,004h,08Fh,044h,002h,0CDh,019h
DB 058h,058h,058h,0EBh,0E8h,08Bh,047h,01Ah,048h,048h,08Ah,01Eh,00Dh,07Ch,032h,0FFh
DB 0F7h,0E3h,003h,006h,049h,07Ch,013h,016h,04Bh,07Ch,0BBh,000h,007h,0B9h,003h,000h
DB 050h,052h,051h,0E8h,03Ah,000h,072h,0D8h,0B0h,001h,0E8h,054h,000h,059h,05Ah,058h
DB 072h,0BBh,005h,001h,000h,083h,0D2h,000h,003h,01Eh,00Bh,07Ch,0E2h,0E2h,08Ah,02Eh
DB 015h,07Ch,08Ah,016h,024h,07Ch,08Bh,01Eh,049h,07Ch,0A1h,04Bh,07Ch,0EAh,000h,000h
DB 070h,000h,0ACh,00Ah,0C0h,074h,029h,0B4h,00Eh,0BBh,007h,000h,0CDh,010h,0EBh,0F2h
DB 033h,0C9h,03Bh,016h,018h,07Ch,073h,073h,0F7h,036h,018h,07Ch,0FEh,0C2h,088h,016h
DB 04Fh,07Ch,08Bh,0D1h,0F7h,036h,01Ah,07Ch,088h,016h,025h,07Ch,0A3h,04Dh,07Ch,0F8h
DB 0C3h,0B4h,002h,08Bh,016h,04Dh,07Ch,0B1h,006h,0D2h,0E6h,00Ah,036h,04Fh,07Ch,08Bh
DB 0CAh,086h,0E9h,08Ah,016h,024h,07Ch,08Ah,036h,025h,07Ch,0CDh,013h,0C3h,00Dh,00Ah
DB 04Eh,06Fh,06Eh,02Dh,053h,079h,073h,074h,065h,06Dh,020h,064h,069h,073h,06Bh,020h
DB 06Fh,072h,020h,064h,069h,073h,06Bh,020h,065h,072h,072h,06Fh,072h,00Dh,00Ah,052h
DB 065h,070h,06Ch,061h,063h,065h,020h,061h,06Eh,064h,020h,070h,072h,065h,073h,073h
DB 020h,061h,06Eh,079h,020h,06Bh,065h,079h,00Dh,00Ah,000h,02Bh,016h,018h,07Ch,041h
DB 0EBh,080h,090h,090h,090h,090h,049h,04Fh,020h,020h,020h,020h,020h,020h,053h,059h
DB 053h,04Dh,053h,044h,04Fh,053h,020h,020h,020h,053h,059h,053h,000h,000h,055h,0AAh

MBRbuffer	label	byte
		ends
		end	start

