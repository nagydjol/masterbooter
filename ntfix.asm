.model tiny
.code
.386

		org	100h

start:		mov	ah,8
		mov	dl,80h
		int	13h		; get drive parameters

		lea	dx,loadpt
		call	print		; print message
		mov	ah,2
		mov	dl,80h
		sub	dl,4fh
		int	21h		; print HD number

		call	loadPtable	; load table and analyse

		lea	dx,done		; print exit message
		call	print

quit:		mov	ax,4c00h
		int	21h


;---------- Load partition table  --------

loadPtable	proc

		lea	bx,MBRbuffer		; load partition table
		mov	al,1
		mov	cx,1
		xor	dh,dh
		call	getsector

		mov	counter,31h
		mov	cx,4			; 4 partitions per table
		lea	si,MBRbuffer+1beh

nextboot:	lea	dx,loadbt		; print message
		call	print
		mov	ah,2
		mov	dl,counter
		int	21h

		cmp	byte ptr [si+4],6
		je	ntinst
		cmp	byte ptr [si+4],0eh
		jne	notNTinst
ntinst:		call	loadboot		; load boot sector and fix
notNTinst:	add	si,10h			;  if needed
		inc	counter
		loop	nextboot		; load next
		ret

loadPtable	endp

;--------------- Fix boot sectors ---------------

loadboot	proc
;SI - entry

		push	cx
		lea	bx,MBRbuffer+512
		mov	al,1
		mov	dh,[si+1]
		mov	dl,80h
		mov	cx,[si+2]
		call	getsector		; load sector

;-- examine bad NT

		lea     di,MBRbuffer+512+05dh
nextnt:		mov	cx,5
		push	si
		push	di
		lea	si,ntstring
		rep	cmpsb			; search NTLDR string
		pop	di
		pop	si
		jz	gotnt
		inc	di
		cmp	di,offset MBRbuffer+1024
		jb	nextnt
		jmp	dontw

gotnt:		push	si
		lea     si,MBRbuffer+512+2
		mov     cx,3ch
                lea     di,goodsect+2
                rep     movsb			; patch boot sector
		pop	si
                lea     dx,fixNT
                call    print

		mov	al,1
		mov	dh,[si+1]
		mov	cx,[si+2]
		mov	dl,80h
		lea	bx,goodsect
		call	writesector		; write new boot sector

                push    si
		lea	si,ldrstring
		mov	cx,5
		lea	di,goodsect+1dch
		rep	movsb			; copy '$LDR$'
                pop     si

                lea     dx,creating
                call    print

		mov	ah,3ch
		xor	cx,cx
		lea	dx,filename
		int	21h			; create file
		jc	fileerr

		mov	bx,ax
		mov	ah,40h			; write file
		mov	cx,512
		lea	dx,goodsect
		int	21h
		jc	fileerr

		mov	ah,3eh
		int	21h			; close file
		jc	fileerr
		jmp	dontw

fileerr:	lea	dx,errorfile
		call	print


dontw:	  	pop	cx
                ret
		endp

;------------------------ Get sectors -----------------------
getsector	proc
;AL - number of secs
;DH - head
;CX - sector
;Loads MBR to BX
;Destroys: AX, DI

		mov	dl,80h
		mov	ah,2
		int	13h		; get sectors
		jc	badsect
                ret

badsect:	lea	dx,cantload
		call	print
		mov	ax,4cffh
		int	21h

		endp

;------------------------ Write sectors -----------------------
writesector	proc
;AL - number of secs
;DX - head, disk
;CX - sector
;from BX
;Destroys: AH, DI

retry2:		mov	ah,3
		int	13h			; write sector
		jc	badwrite
		mov	ah,0dh
		int	21h
                ret

badwrite:	lea	dx,cantwrite
		call	print
		mov	ax,4cffh
		int	21h

		endp


;-----------------

print		proc

		mov	ah,9
		int	21h
		ret

		endp


;---------

cantload	db	0dh,0ah,'Cannot load sector$'
cantwrite	db	0dh,0ah,'Cannot write sector$'
errorfile	db	0dh,0ah,'Cannot create bootsect.dat$'

loadpt		db	0dh,0ah,'Examining partition table ','$'
loadbt		db	0dh,0ah,'Examining boot sector ','$'
fixNT		db	0dh,0ah,'Fixing NT boot sector','$'
creating        db      0dh,0ah,'Creating bootsect.dat file$'

done		db	0dh,0ah,'Done',0dh,0ah,'$'

write?		db	0
win95?          db      0
counter		db	0

filename	db	'bootsect.dat',0
ntstring	db	'NTLDR'
ldrstring	db	'$LDR$'

goodsect	label
DB 0EBh,03Ch,090h,04Dh,053h,057h,049h,04Eh,034h,02Eh,031h,000h,002h,008h,001h,000h
DB 002h,000h,002h,000h,000h,0F8h,0FCh,000h,03Fh,000h,080h,000h,000h,09Ch,057h,000h
DB 000h,0E0h,007h,000h,080h,000h,029h,0D4h,015h,03Ah,02Bh,044h,04Fh,053h,020h,020h
DB 020h,020h,020h,020h,020h,020h,046h,041h,054h,031h,036h,020h,020h,020h,033h,0C0h
DB 08Eh,0D0h,0BCh,000h,07Ch,068h,0C0h,007h,01Fh,0A0h,010h,000h,0F7h,026h,016h,000h
DB 003h,006h,00Eh,000h,050h,091h,0B8h,020h,000h,0F7h,026h,011h,000h,08Bh,01Eh,00Bh
DB 000h,003h,0C3h,048h,0F7h,0F3h,003h,0C8h,089h,00Eh,008h,002h,068h,000h,010h,007h
DB 033h,0DBh,08Fh,006h,013h,002h,089h,01Eh,015h,002h,00Eh,0E8h,090h,000h,072h,057h
DB 033h,0DBh,08Bh,00Eh,011h,000h,08Bh,0FBh,051h,0B9h,00Bh,000h,0BEh,0DCh,001h,0F3h
DB 0A6h,059h,074h,005h,083h,0C3h,020h,0E2h,0EDh,0E3h,037h,026h,08Bh,057h,01Ah,052h
DB 0B8h,001h,000h,068h,000h,020h,007h,033h,0DBh,00Eh,0E8h,048h,000h,072h,028h,05Bh
DB 08Dh,036h,00Bh,000h,08Dh,03Eh,00Bh,002h,01Eh,08Fh,045h,002h,0C7h,005h,0F5h,000h
DB 01Eh,08Fh,045h,006h,0C7h,045h,004h,00Eh,001h,08Ah,016h,024h,000h,0EAh,003h,000h
DB 000h,020h,0BEh,095h,001h,0EBh,003h,0BEh,0ABh,001h,0E8h,009h,000h,0BEh,0C8h,001h
DB 0E8h,003h,000h,0FBh,0EBh,0FEh,0ACh,00Ah,0C0h,074h,009h,0B4h,00Eh,0BBh,007h,000h
DB 0CDh,010h,0EBh,0F2h,0C3h,050h,04Ah,04Ah,0A0h,00Dh,000h,032h,0E4h,0F7h,0E2h,003h
DB 006h,008h,002h,083h,0D2h,000h,0A3h,013h,002h,089h,016h,015h,002h,058h,0A2h,007h
DB 002h,0A1h,013h,002h,08Bh,016h,015h,002h,003h,006h,01Ch,000h,013h,016h,01Eh,000h
DB 033h,0C9h,03Bh,016h,018h,000h,073h,066h,0F7h,036h,018h,000h,0FEh,0C2h,088h,016h
DB 006h,002h,08Bh,0D1h,0F7h,036h,01Ah,000h,088h,016h,025h,000h,0A3h,004h,002h,0A1h
DB 018h,000h,02Ah,006h,006h,002h,040h,03Ah,006h,007h,002h,076h,005h,0A0h,007h,002h
DB 032h,0E4h,050h,0B4h,002h,08Bh,00Eh,004h,002h,0C0h,0E5h,006h,00Ah,02Eh,006h,002h
DB 086h,0E9h,08Bh,016h,024h,000h,0CDh,013h,00Fh,083h,005h,000h,083h,0C4h,002h,0F9h
DB 0CBh,058h,028h,006h,007h,002h,076h,011h,001h,006h,013h,002h,083h,016h,015h,002h
DB 000h,0F7h,026h,00Bh,000h,003h,0D8h,0EBh,088h,0A2h,007h,002h,0F8h,0CBh,02Bh,016h
DB 018h,000h,041h,0EBh,08Dh,04Eh,054h,04Ch,044h,052h,020h,06Eh,06Fh,074h,020h,066h
DB 06Fh,075h,06Eh,064h,02Eh,020h,020h,020h,00Dh,00Ah,000h,043h,061h,06Eh,06Eh,06Fh
DB 074h,020h,072h,065h,061h,064h,020h,066h,06Ch,06Fh,070h,070h,079h,020h,064h,069h
DB 073h,06Bh,02Eh,020h,020h,00Dh,00Ah,000h,049h,06Eh,073h,065h,072h,074h,020h,061h
DB 06Eh,06Fh,074h,068h,065h,072h,020h,064h,069h,073h,06Bh,000h,04Eh,054h,04Ch,044h
DB 052h,020h,020h,020h,020h,020h,020h,000h,000h,000h,000h,000h,000h,000h,000h,000h
DB 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,055h,0AAh

MBRbuffer	label	byte
		ends
		end	start
