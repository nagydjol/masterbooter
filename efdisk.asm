.MODEL SMALL
.STACK 200h
include defines.h

EFDISK=1

;ЩЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЛ
;К				Data Segment				     К
;ШЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭМ

DataSegment	segment para 'data'

;------------ Buffers ------------


MBRloader       label
DB 033h,0C0h,08Eh,0D0h,0BCh,000h,07Ch,0FBh,050h,007h,050h,01Fh,0FCh,0BEh,01Bh,07Ch
DB 0BFh,01Bh,006h,050h,057h,0B9h,0E5h,001h,0F3h,0A4h,0CBh,0BEh,0BEh,007h,0B1h,004h
DB 038h,02Ch,07Ch,009h,075h,015h,083h,0C6h,010h,0E2h,0F5h,0CDh,018h,08Bh,014h,08Bh
DB 0EEh,083h,0C6h,010h,049h,074h,016h,038h,02Ch,074h,0F6h,0BEh,010h,007h,04Eh,0ACh
DB 03Ch,000h,074h,0FAh,0BBh,007h,000h,0B4h,00Eh,0CDh,010h,0EBh,0F2h,089h,046h,025h
DB 096h,08Ah,046h,004h,0B4h,006h,03Ch,00Eh,074h,011h,0B4h,00Bh,03Ch,00Ch,074h,005h
DB 03Ah,0C4h,075h,02Bh,040h,0C6h,046h,025h,006h,075h,024h,0BBh,0AAh,055h,050h,0B4h
DB 041h,0CDh,013h,058h,072h,016h,081h,0FBh,055h,0AAh,075h,010h,0F6h,0C1h,001h,074h
DB 00Bh,08Ah,0E0h,088h,056h,024h,0C7h,006h,0A1h,006h,0EBh,01Eh,088h,066h,004h,0BFh
DB 00Ah,000h,0B8h,001h,002h,08Bh,0DCh,033h,0C9h,083h,0FFh,005h,07Fh,003h,08Bh,04Eh
DB 025h,003h,04Eh,002h,0CDh,013h,072h,029h,0BEh,046h,007h,081h,03Eh,0FEh,07Dh,055h
DB 0AAh,074h,05Ah,083h,0EFh,005h,07Fh,0DAh,085h,0F6h,075h,083h,0BEh,027h,007h,0EBh
DB 08Ah,098h,091h,052h,099h,003h,046h,008h,013h,056h,00Ah,0E8h,012h,000h,05Ah,0EBh
DB 0D5h,04Fh,074h,0E4h,033h,0C0h,0CDh,013h,0EBh,0B8h,000h,000h,000h,000h,000h,000h
DB 056h,033h,0F6h,056h,056h,052h,050h,006h,053h,051h,0BEh,010h,000h,056h,08Bh,0F4h
DB 050h,052h,0B8h,000h,042h,08Ah,056h,024h,0CDh,013h,05Ah,058h,08Dh,064h,010h,072h
DB 00Ah,040h,075h,001h,042h,080h,0C7h,002h,0E2h,0F7h,0F8h,05Eh,0C3h,0EBh,074h,049h
DB 06Eh,076h,061h,06Ch,069h,064h,020h,070h,061h,072h,074h,069h,074h,069h,06Fh,06Eh
DB 020h,074h,061h,062h,06Ch,065h,000h,045h,072h,072h,06Fh,072h,020h,06Ch,06Fh,061h
DB 064h,069h,06Eh,067h,020h,06Fh,070h,065h,072h,061h,074h,069h,06Eh,067h,020h,073h
DB 079h,073h,074h,065h,06Dh,000h,04Dh,069h,073h,073h,069h,06Eh,067h,020h,06Fh,070h
DB 065h,072h,061h,074h,069h,06Eh,067h,020h,073h,079h,073h,074h,065h,06Dh,000h,000h
DB 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
DB 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
DB 000h,000h,000h,08Bh,0FCh,01Eh,057h,08Bh,0F5h,0CBh

disksegment	dw	0			; segment of MBR buffers
commandptr	db	255 dup (0)		; command line or inputbuffer


;------------------------------ Usage strings ---------------------------

usage1		db	' - move up,  - move down, SPACE - toggle active flag$'
usage2		db	'ENTER - create partition, DEL - delete, H - hide/unhide$'
usage3		db	'ESC - quit, F10 - write new partition table$'

;---------- About info -----------

about1		db	'   EFDISK ', versiostr2,'$'
about2		db	'  by Nagy Daniel$'
about3		db	'$'
about4		db	'    Open source$'
about5		db	'      version$'
about6		db	'$'

;------ Titles and questions -----

usage           db      'EFDISK ',  versiostr2, ' ', copyright,0dh,0ah
		db	'This is the '
		db	'Open Source'
		db	' version.',0dh,0ah
                db      'Usage: efdisk command <partition number> [harddisk number]',0dh,0ah
                db      'Valid commands are:',0dh,0ah
                db      '/create <type> <start cyl> <end cyl> - create a partition',0dh,0ah
		db	'/crsize <type> <size in MB>          - create a partition',0dh,0ah
                db      '/delete                              - delete a partition',0dh,0ah
		db	'/delall                              - delete all partitions on a disk',0dh,0ah
                db      '/activate                            - activate a partition',0dh,0ah
                db      '/hidefat                             - hide a primary FAT partition',0dh,0ah
                db      '/hident                              - hide a primary HPFS/NTFS partition',0dh,0ah
		db	'/unhidefat                           - unhide a primary FAT partition',0dh,0ah
		db	'/unhident                            - unhide a primary HPFS/NTFS partition',0dh,0ah
		db	'/mbr                                 - install the standard DOS MBR loader',0dh,0ah
		db	'/?                                   - this help message',0dh,0ah
		db	'Valid partition numbers are from 1 to 4. Do not use this parameter',0dh,0ah
		db	'for delall and mbr commands. Use only one command per command line.',0dh,0ah
		db      'The disk ID is the number of the harddisk, from 1 to 4, default is 1.',0dh,0ah
		db	0dh,0ah
		db	'Example: efdisk /create 6 5 143 2 3 - will create a BIGDOS partition with',0dh,0ah
		db	'                                      starting cylinder 5, ending cylinder 143,',0dh,0ah
		db	'                                      in the 2nd entry of the 3rd harddisk$'

badpar		db      'Bad command line parameter. Use /? for help.$'
created		db	'Partition has been created successfully.$'
deleted		db	'Partition has been deleted successfully.$'
delalld		db	'All partitions have been deleted successfully.$'
alreadyact	db	'This partition is already active.$'
activated	db	'Partition has been activated successfully.$'
notFAT		db	'This partition is not FAT type or already hidden.$'
notNT		db	'This partition is not NTFS/HPFS type or already hidden.$'
hiddened	db	'Partition has been hidden successfully.$'
nothidden	db	'This partition is not hidden FAT type.$'
nothiddennt	db	'This partition is not hidden NTFS/HPFS type.$'
unhidden	db	'Partition has been unhidden successfully.$'
mbrinstalled	db	'New MBR loader has been installed successfully.$'
toobig		db	'Partition is too large to create.$'
usedmessage	db      'This partition entry is already used. If you change its parameters, all data',0dh,0ah
		db	'in that partition will be lost.',0dh,0ah,'$'


currentpt	db	' Current partition table $'
usageinfo	db	' Usage information $'
continue1	db	'Warning!!!$'
continue2	db	'Continue only if you are absolutely sure that$'
continue3	db	'the new setting are correct, and you have already$'
continue4	db	'created a rescue floppy with mrescue.com!$'
continue5	db	'Do you want to save the new partition table? (y/n)$'
rebootmsg	db	'Now your computer should reboot.$'
HDinfo1		db	'   Cyls Heads Secs$'
HDinfo2		db	' ФФФФФ- ФФФФФ ФФФ-$'
writtenmsg	db	'New partition table has been written to disk.$'
pressreboot	db	'Press any key to reboot, ESC to quit...$'
partinfo	db	'Disk   Part.  FS Type           Start    End Size/MB Act$'
underline	db	'ФФФФФФ ФФФФФФ ФФФФФФФФФФФФФФФФ ФФФФФФ ФФФФФФ ФФФФФФФ ФФФ$'
star		db	'*$'
seltype		db	'Select type (Hex):$'
enterstart	db	'Starting cylinder:$'
enterend	db	'Ending cylinder$'
max		db	'(max:       ) or$'
strsize		db	'size in megabytes$'
inMB		db	'(add ',39,'m',39,' to end)$'
S_emptyline	db	'         $'

;---------- Thanks message ---------

thank	db	'EFDISK ', versiostr2, ' ', copyright,0dh,0ah
	db	'This is the Open Source version.$'

include strings.inc

;---------- Error messages ----------

invcyl		db	'Cylinder number is too large$'
writerror	db	'Cannot write sector$'
memerror	db	'Not enough memory$'
anykey		db	'Press a key to quit$'
overCHS		db	'No EBIOS support$'
nodrive		db	'Specified harddisk not found$'

;--------- Info strings --------

first		db	'First $'
		db	'Second$'
		db	'Third $'
		db	'Fourth$'

;-------- File systems ---------

fstable	dw	offset empty,offset FAT12,offset xenix1,offset xenix2
	dw	offset FAT16,offset extend,offset bigdos,offset hpfs
	dw	offset aix1,offset aix2,offset bm,offset FAT32
	dw	offset FAT32x,offset reserv,offset LBIGDOS,offset LBAext
	dw	offset opus,offset HFAT12,offset compaq,offset reserv
	dw	offset HFAT16,offset reserv,offset HBIGDOS,offset HHPFS
	dw	offset ast,2 dup (offset reserv),offset HFAT32
	dw	offset HFAT32x,offset reserv,offset HBIGx,5 dup (offset reserv)
	dw	offset necdos,19 dup (offset reserv)
	dw	offset theos,3 dup (offset reserv),offset pmagic
	dw	3 dup (offset reserv),offset venix,offset prisc,offset sfs
	dw	12 dup (offset reserv),offset oberon,offset dmro,offset dmrw,offset cpm
	dw	offset dmwo,offset dmddo,offset reserv,offset golden
	dw	10 dup (offset reserv),offset speed,offset reserv,offset hurd
	dw	offset nov286,offset nov386,offset reserv,offset novell
	dw	offset novell,offset novell,6 dup (offset reserv)
	dw	offset dsec,4 dup (offset reserv),offset pcix
	dw	10 dup (offset reserv),offset minix1,offset linux
	dw	offset linswap,offset ext2fs,offset os2re,2 dup (offset reserv)
	dw	offset hpfsm,11 dup (offset reserv),offset amoeba
	dw	offset amobad,16 dup (offset reserv),offset freebs
	dw	17 dup (offset reserv),offset bsdi,offset bsdi2
	dw	8 dup (offset reserv),offset drfat12,2 dup (offset reserv)
	dw	offset drfat16,offset reserv,offset drbigd,offset syrinx
	dw	16 dup (offset reserv),offset cpm86,8 dup (offset reserv)
	dw	offset ssfat12,offset reserv,offset DOSro,offset ssfat16
	dw	6 dup (offset reserv),offset beos,5 dup (offset reserv),offset stord1,offset DOSsec
	dw	offset reserv,offset sstor,9 dup (offset reserv)
	dw	offset lanstep,offset xenbad

empty	db	'Empty$'		; 0
FAT12	db	'FAT12$'		; 1
xenix1	db	'XENIX root$'		; 2
xenix2	db	'XENIX /usr$'		; 3
FAT16	db	'FAT16$'		; 4
extend	db	'Extended$'		; 5
bigdos	db	'BIGDOS$'		; 6
hpfs	db	'HPFS/NTFS/QNX$'	; 7
aix1	db	'AIX/SplitDrive$'	; 8
aix2	db	'AIX/Coherent$'		; 9
bm	db	'OS/2 BM/OPUS$'		;0Ah
FAT32	db	'FAT32$'		;0Bh
FAT32x	db	'FAT32 LBA$'		;0Ch
					;0Dh	 - reserved
LBIGDOS db	'BIGDOS LBA$'		;0Eh
LBAext	db	'Extended LBA$'	 	;0Fh
opus	db	'OPUS$'			;10h
HFAT12	db	'Hidden FAT12$'		;11h
compaq	db	'Compaq diag.$'		;12h
					;13h	 - reserved
HFAT16	db	'Hidden FAT16$'		;14h
					;15h	 - reserved
HBIGDOS	db	'Hidden BIGDOS$'	;16h
HHPFS	db	'Hidden HPFS/NTFS$'	;17h
ast	db	'AST swap$'		;18h
					;19h-1Ah - reserved (2)
HFAT32	db	'Hidden FAT32$'		;1Bh
HFAT32x	db	'Hidden FAT32 LBA$'	;1ch
					;1dh	 - reserved
HBIGx	db	'Hidden BIGDOSx$'	;1eh
					;1fh-23h - reserved (5)
necdos	db	'NEC MS-DOS 3.x$'	;24h
					;25h-37h - reserved (19)
theos	db	'Theos$'		;38h
					;39h-3Bh - reserved (3)
pmagic	db	'PartitionMagic$'	;3Ch
					;3Dh-3Fh - reserved (3)
venix	db	'VENIX 80286$'		;40h
prisc	db	'Personal RISC$'	;41h
sfs	db	'SFS$'			;42h
					;43h-4Eh - reserved (12)
oberon	db	'Oberon$'		;4Fh
dmro	db	'OnTrack DM RO$'	;50h
dmrw	db	'OnTrack DM R/W$'	;51h
cpm	db	'CP/M$'			;52h
dmwo	db	'OnTrack DM WO$'	;53h
dmddo	db	'OnTrack DM DDO$'	;54h
					;55h	 - reserved
golden	db	'GoldenBow$'		;56h
					;57h-60h - reserved (10)
speed	db	'SpeedStor$'		;61h
					;62h	 - reserved
hurd	db	'SysV-FS / HURD$'	;63h
nov286	db	'NetWare 286$'		;64h
nov386	db	'NetWare 3.11$'		;65h
					;66h	 - reserved
novell	db	'Novell$'		;67h-69h
					;6Ah-6Fh - reserved (6)
dsec	db	'DiskSecure$'		;70h
					;71h-74h - reserved (4)
pcix	db	'PC/IX$'		;75h
					;76h-7fh - reserved (10)
minix1	db	'Minix$'		;80h
linux	db	'Minix$'		;81h
linswap	db	'Linux swap/UFS$'	;82h
ext2fs	db	'Linux$'		;83h
os2re	db	'OS/2-renumber$'	;84h
					;85h-86h - reserved (2)
hpfsm	db	'HPFS mirrored$'	;87h
					;88h-92h - reserved (11)
amoeba	db	'Amoeba$'		;93h
amobad	db	'Amoeba BBT$'		;94h
					;95h-A4h - reserved (16)
freebs	db	'UFS$'			;A5h
					;A6h-B6h - reserved (17)
bsdi	db	'BSDI FS$'		;B7h
bsdi2	db	'BSDI swap$'		;B8h
					;B9h-C0h - reserved (8)
drfat12 db	'DRDOS - FAT12$'	;C1h
					;C2h-C3h - reserved (2)
drfat16 db	'DRDOS - FAT16$'	;C4h
					;C5h	 - reserved
drbigd  db	'DRDOS - BIGDOS$'	;C6h
syrinx  db	'Syrinx Boot$'		;C7h
					;C8h-D7h - reserved (16)
cpm86	db	'CP/M-86 / CTOS$'	;D8h
					;D9h-E0h - reserved (8)
ssfat12	db	'SpeedStr FAT12$'	;E1h
					;E2h	 - reserved
DOSro	db	'DOS read-only$'	;E3h
ssfat16	db	'SpeedStr FAT16$'	;E4h
					;E5h-EAh - reserved (12)
beos	db	'BeFS$'			;EBh
					;ECh-F0h - reserved (12)
stord1	db	'Storage Dim.$'		;F1h
DOSsec	db	'DOS 3.3+ sec.$'	;F2h
					;F3h	 - reserved
sstor	db	'SpeedStor$'		;F4h
					;F5h-FDh - reserved (9)
lanstep	db	'LANstep$'		;FEh
xenbad	db	'Xenix BBT$'		;FFh

reserv	db	'Reserved$'


type0	db	' 0 - Empty      $'
	db	' 4 - FAT16      $'
	db	' 6 - BIGDOS     $'
	db	' 7 - HPFS/NTFS  $'
	db	' b - FAT32      $'
	db	' c - FAT32 LBA  $'
	db	'82 - Linux swap $'
	db	'83 - Linux      $'
	db	'                $'
	db	'Read the docs   $'
	db	'for more types. $'

;----- Command line parameters ----

activate	db	'activate'
delete		db	'delete'
delall		db	'delall'
create		db	'create'
crsize		db	'crsize'
hidep		db	'hidefat'
hidentp		db	'hident'
unhidefat	db	'unhidefat'
unhident	db	'unhident'
mbrsig		db	'mbr'

;----------- Variables ------------

fats            db      4,6,0bh,0ch,0eh
                db      14h,16h,1bh,1ch,1eh

numodrives	dw	0
lightpos	db	3		;highlight pos
actpos		db	0		;actual cursor pos
actpart		db	0		;currently selceted entry
ascnum		db	8 dup (0h), '$'

strlen		db	0		;string lenght
maxlen		db	0		;max srting lenght
win95?		db	0
;----

ebios?		db	0		; ebios inticator
readint		db	0		; BIOS read operation code
writeint	db	0		; BIOS write operation code
diskparams	dd	17 dup (0)	; ID, cyl, head, sector, max (17 bytes/disk)
starting	dd	0		; starting sector
ending		dd	0		; ending sector
partyp		db	0		; partition type
psize		dd	0

ebiosparams 	dw	0		; buffer size
		dw	0		; information flags
ecyls		dd	0		; number of physical cylinders on drive
eheads		dd	0		; number of physical heads on drive
esectors	dd	0		; number of physical sectors per track
etotal		dd	0		; total number of sectors on drive
		dd	0
		dw	0		; bytes per sector
		dd	0
                db      36 dup (0)

; packet for extended read/write

packet		db	10h		; reserved
		db	0		; reserved
blocks		dw	1		; number of blocks to write
transpoint	dd	0		; transfer buffer pointer
firstpoint	dd	0		; pointer to first block on disk
		dd	0


;-------

changes		dw	0		; number of changed partitions (max 16)
changeds	dw	8 dup (0)	; starting cylinders

dataend		label
		ends

;ЩЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЛ
;К				Code Segment				     К
;ШЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭЭМ

_TEXT		segment
.386

ASSUME cs:_TEXT, ds:DataSegment

;ФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФ Procedures ФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФ


;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;ллллллллллллллллллллллллллллл Set up windows ллллллллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

window		proc

		mov	ax,3
		int	10h			; clear screen

		mov	ax,0b800h
		mov	es,ax			; set ES to screen

		mov	ah,1
		mov	cx,2000h		; hide cursor
		int	10h

		xor	di,di
		mov	ah,3
		mov	al,0C9h
		stosw
		mov	cx,58
		mov	al,0CDh
		rep	stosw
		mov	al,0CBh
		stosw
		mov	cx,77-58		; second cell width
		mov	al,0CDh
		rep	stosw
		mov	al,0BBh
		stosw				

		mov	cx,16			; first cell height
		mov	al,0BAh
sides1:		stosw
		add	di,58*2
		stosw
		add	di,154-58*2
		stosw
		loop	sides1
		stosw

		add	di,58*2
		mov	al,0CCh
		stosw
		mov	cx,19
		mov	al,0CDh
		rep	stosw
		mov	al,185
		stosw

		mov	cx,2
		mov	al,0BAh
sides2:		stosw
		add	di,58*2
		stosw
		add	di,154-58*2
		stosw
		loop	sides2

		mov	al,0cch
		stosw
		mov	cx,58
		mov	al,0cdh
		rep	stosw
		mov	al,185
		stosw
		add	di,38
		mov	al,0bah
		stosw

		mov	cx,3
sides3:		stosw
		add	di,58*2
		stosw
		add	di,154-58*2
		stosw
		loop	sides3

		mov	al,0C8h
		stosw
		mov	cx,58
		mov	al,0CDh
		rep	stosw
		mov	al,0CAh
		stosw
		mov	cx,77-58
		mov	al,0CDh
		rep	stosw
		mov	al,0BCh
		stosw
		ret

		endp


;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;лллллллллллллллллллллллллллл Print all strings ллллллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
strings		proc

		xor	dh,dh
		mov	dl,58/2-11
		lea	bp,currentpt
		call	print
		mov	dh,20
		mov	dl,21
		lea	bp,usageinfo
		call	print

		mov	dh,1
		mov	dl,2
		lea	bp,partinfo
		call	print
		inc	dh
		lea	bp,underline
		call	print

		mov	dh,21
		mov	dl,2
		lea	bp,usage1
		call	print
		inc	dh
		lea	bp,usage2
		call	print
		inc	dh
		lea	bp,usage3
		call	print

		mov	dh,16+2
		mov	dl,58+3
		lea	bp,about1
		call	print
		inc	dh
		lea	bp,about2
		call	print
		inc	dh
		lea	bp,about3
		call	print
		inc	dh
		lea	bp,about4
		call	print
		inc	dh
		lea	bp,about5
		call	print
		inc	dh
		lea	bp,about6
		call	print
		ret

		endp

;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;лллллллллллллллллллллллллллллл Print string лллллллллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

print		proc

;DH - row
;DL - column
;BP - string address

		push	dx
		push	bx
		push	ax
		xor	bh,bh
		call	setpos
		mov	dx,bp
		mov	ah,9
		int	21h
endstring:	pop	ax
		pop	bx
		pop	dx
		ret

		endp



;ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;ллллллллллллллллллллллллллллл Read sector(s) лллллллллллллллллллллллллл
;ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

readsector	proc near
;EAX - firstpoint
;ES:BX - buffer
;DL - HD ID
;blocks
		push	eax
		push	si
		push	cx

		cmp	ebios?,1
		je	skipCHSr

		call	LBA2CHS
		jc	@readd

skipCHSr:	mov	firstpoint,eax
		mov	ax,es
		shl	eax,16
		mov	ax,bx
		mov	transpoint,eax
		lea	si,packet

		call	lockvolume
		mov	al,0		; no verify
		cmp	ebios?,1
		je	readbb
		mov	ax,blocks
readbb:	        mov	ah,readint
		int	13h		; write new table
		call	unlockvolume
@readd: 	pop	cx
		pop	si
		pop	eax
		ret

		endp



;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;ллллллллллллллллллллллллллллл Write sector(s) лллллллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

writesector	proc near
;EAX - firstpoint
;BX - buffer
;DL - HD ID
;blocks
		push	eax
		push	si
		push	cx

		cmp	ebios?,1
		je	skipCHSw

		call	LBA2CHS
		jc	@written

skipCHSw:	mov	firstpoint,eax
		mov	ax,es
		shl	eax,16
		mov	ax,bx
		mov	transpoint,eax
		lea	si,packet

		call	lockvolume
		mov	al,0		; no verify
		cmp	ebios?,1
		je	writebb
		mov	ax,blocks
writebb:	mov	ah,writeint
		int	13h		; write new table
		call	unlockvolume
@written:	pop	cx
		pop	si
		pop	eax
		ret

		endp


;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;ллллллллллллллллллллллл Calculate CHS from LBA ллллллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

LBA2CHS		proc near
;IN:  EAX - LBA sector
;     SI - pointer to disk parameter table
;OUT: CH - cylinder low
;     CL - sector + cylinder high
;     DH - head

		push	eax
		push	ebx
		inc	eax
		xor	ecx,ecx			; erase upper nibbles
		mov	ebx,eax
		xor	eax,eax
		mov	eax,[si+5]		; first divide the LBA value
		mul	dword ptr [si+9]	; by max sectors*max heads
		xchg	eax,ebx			; to calculate the cylinder
		div	ebx			; value
		test	edx,edx			; correct if boundary
		jnz	dontcorre
		dec	ax
		mov	edx,ebx
dontcorre:	mov	cx,ax
		cmp	cx,1023			; test if cyl is above 1023
		jbe	okcmax
		mov	cx,1023
okcmax:		xchg	ch,cl
		shl	cl,6
		mov	eax,edx			; then divide the remainder
		xor	edx,edx
		div	dword ptr [si+9]	; by the max sectors to get
		test	edx,edx
		jnz	dontcorre2
		dec	al
		mov	edx,[si+9]
dontcorre2:	mov	dh,al			; the head and the sector
		or	cl,dl

		clc
		pop	ebx
		pop	eax
		ret

		endp


;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;ллллллллллллллллллл Analyse partitions and print info лллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

analyse		proc

		mov	actpos,3
		mov	ax,disksegment
		mov	es,ax
		mov	di,1beh		; DI - pointer to partition
		mov	cx,numodrives	; number of disks
		lea	si,diskparams

@@ZIPanal:	push	cx
		mov	cx,4		; CX - 4 partitions per disk

nextpart:	call	prinfo
		inc	actpos
		add	di,16
		loop	nextpart	; next partition

		pop	cx		; next disk
		add	di,448
		add	si,17
		loop	@@ZIPanal

@@analed:	ret

		endp

;----------------------------- Print info ---------------------------------
prinfo		proc
;SI - pointer to disk parameters
;DI - pointer to partition table
;'actpos' - row to write to

		push	cx
		push	si

		xor	ah,ah
		mov	al,actpos
		sub	al,3
		mov	bl,4
		div	bl		; AL - disk nr, AH - part nr
		mov	bh,ah
		mov	bl,7		; 7 is the string lenght
		xor	ah,ah
		mul	bl		
		lea	bp,first
		add	bp,ax		; BP - pointer to number string
		mov	dh,actpos
		mov	dl,2
		call	print		; print disk no
		xor	ax,ax
		mov	al,bh
		mul	bl
		lea	bp,first
		add	bp,ax		; BP - pointer to number string
		mov	dl,9		; column
		call	print		; print partition no

;------- FS type

		xor	ah,ah
		mov	al,es:[di+4]
		shl	ax,1
		lea	bx,fstable
		add	bx,ax
		mov	bp,[bx]
		mov	dl,16		; column no
		call	print

;------- Cylinders

		xor	edx,edx
		mov	eax,es:[di+8]
		inc	eax
		div	dword ptr [si+5]
		xor	edx,edx
		div	dword ptr [si+9]	; AX - starting cylinder
		mov	dh,actpos
		mov	dl,38
		call	toascii

		xor	edx,edx
		mov	eax,es:[di+8]
		add	eax,es:[di+12]
		test	eax,eax
		je	zeroend
		dec	eax
zeroend:	div	dword ptr [si+5]
		xor	edx,edx
		div	dword ptr [si+9]	; AX - ending cylinder
		mov	dh,actpos
		mov	dl,45
		call	toascii

;------- Size

		mov	eax,es:[di+12]	; EAX - number of sectors in partition
		shr	eax,11

@prsize:	mov	dh,actpos
		mov	dl,53
		call	toascii

;----- Boot flag

		cmp	byte ptr es:[di],80h
		jne	noboot
		lea	bp,star
		mov	dl,56
		call	print

noboot:		pop	si
		pop	cx
		ret
		endp


;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;ллллллллллллллллллллллллллл Move highlight ллллллллллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
highlight	proc
;AL - direction of movement

		push	ax
		push	bx
		push	dx

		mov	dh,lightpos
		add	dh,al
		cmp	dh,3
		jb	dontmove		; at the top?
		mov	bh,byte ptr numodrives
		shl	bh,2
		add	bh,2
		cmp	dh,bh
		ja	dontmove		; at the bottom?

		mov	dl,dh			; DL - newpos
		mov	dh,lightpos		; DH - oldpos
		add	lightpos,al		; update pos
		mov	bh,7
		call	updatelight		; delete old highlight
		mov	dh,dl
		mov	bh,78h			; draw new highlight
		call	updatelight

		xor	bh,bh			; place the cursor beside
		mov	dl,58			; the highlighted item
		call	setpos			; to help blind people

dontmove:	pop	dx
		pop	bx
		pop	ax
		ret

		endp

;------ Updates attribs -----
updatelight	proc
;BH - attrib
;DH - row
;Destroys: AX, CX, DI

		push	ax
		push	cx
		push	dx
		push	di
		push	es

		mov	ax,0b800h
		mov	es,ax
		mov	al,160
		mul	dh
		add	ax,5
		mov	di,ax
		mov	cx,56		; highlight 56 chars
		mov	al,bh
lightnext:	stosb			; put new attrib to ES:DI
		inc	di
		loop	lightnext

		pop	es
		pop	di
		pop	dx
		pop	cx
		pop	ax
		ret

		endp

;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;ллллллллллллллллллллллл Modify selected partition лллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
modifypart	proc

		mov	cx,17
		lea	si,diskparams
		movzx	ax,lightpos
		sub	al,3		; AL - entry number
		mov	bx,ax
		mov	actpart,al
		shr	al,2		; AL - disk no
		push	ax
		mul	cl
		add	si,ax		; SI - disk parameters
		mov	al,[si]
		pop	ax

		and	bl,3
		shl	bl,4		; BX - pointer to partition entry
		push	bx
		mov	bx,512
		mul	bx		; AX - pointer to partition table
		pop	bx
		mov	di,1beh
		add	di,ax
		add	di,bx		; DI - partition entry to change

;---------- Type

		mov	dh,1
		mov	dl,61
		mov	ah,7
		lea	bp,seltype	; 'Select type'
		call	print

		add	dh,4
		mov	cx,11		; num of rows
		lea	bp,type0
nexttype:	call	print
		add	bp,17		; print common types
		inc	dh
		loop	nexttype

		xor	bh,bh
		mov	ah,1
		mov	cx,010fh	; show cursor
		int	10h

		push	si		; save parameter pointer
		lea	si,smc
		mov	byte ptr cs:[si+1],'f'
		pop	si
		mov	dh,2
		mov	dl,61
		mov	maxlen,2
		mov	dword ptr [offset commandptr],0
		call	query
		jnc	@@notqe1
		jmp	@@escentry

@@notqe1:	push	si
		lea	si,commandptr
		call	asci2dec
		pop	si
		cmp	es:[di+4],al	; change?
		je	@notypechange

		call	setchange
		mov	partyp,al	; store

@notypechange:	push	si
		mov	si,600
		mov	cx,14
		call	clearsw		; clear window
		pop	si

;-------- Starting

		push	si
		lea	si,smc
		mov	byte ptr cs:[si+1],'9'
		pop	si

		mov	dh,4
		mov	dl,61		; 'Enter starting...'
		lea	bp,enterstart
		call	print
		inc	dh

		mov	maxlen,5
@@badstart:	lea	bp,S_emptyline
		call	print
		mov	dword ptr [offset commandptr],0
		mov	dword ptr [offset commandptr+4],0	; clear buf
		call	query
		jnc	@@notqe2
		jmp	@@escentry

@@notqe2:	push	si
		lea	si,commandptr
		call	asci2hex
		pop	si
		call	calcstarting	; set starting sector
		jc	@@badstart

;------ Ending

		mov	maxlen,7	; 6 digits + 'm'

		mov	dh,7
		mov	dl,61		; 'Enter ending...'
		lea	bp,enterend
		call	print

		lea	bp,max
		inc	dh		; 'Max...'
		call	print

		lea	bp,strsize
		inc	dh		; 'Size in MB'
		call	print

		lea	bp,inMB
		inc	dh		; 'add...'
		call	print

		mov	eax,[si+1]
		dec	eax		; print max cyl number
		mov	dh,8
		mov	dl,72
		call	toascii

badend:		mov	dword ptr [offset commandptr],0
		mov	dword ptr [offset commandptr+4],0

		lea	bp,S_emptyline
		mov	dh,11
		mov	dl,61
		call	print		; print empty line

		xor	bh,bh
		call	query
		jnc	@@notqe3
		jmp	@@escentry

@@notqe3:	push	si			; search for 'm'
		mov	cx,7
		lea	si,commandptr+7
@@seekm:	cmp	byte ptr [si],'m'
		je	@@foundm
		cmp	byte ptr [si],'M'
		je	@@foundm
		dec	si
		loop	@@seekm
		pop	si
		jmp	@@noMB

@@foundm:	mov	byte ptr [si],0
		pop	si
		push	si
		lea	si,commandptr
		call	asci2hex
		pop	si
		shl	eax,11			; EAX - needed space in sectors
		add	eax,starting		; EAX - ending sector
		mov	ebx,eax
		mov	eax,[si+5]
		mul	dword ptr [si+9]	; EAX - sectors per 1 cylinder
		xchg	eax,ebx
		div	ebx
		jmp	@@calcedend

@@noMB:		push	si
		lea	si,commandptr
		call	asci2hex
		pop	si
@@calcedend:	call	calcending
		jc	badend
		mov	eax,ending
		cmp	eax,starting		; compare if ending is valid
		jbe	badend

		mov	ah,1
		mov	cx,2000h		; hide cursor
		int	10h

;-------- Sector nums

endent:		mov	al,partyp		; set type
		mov	es:[di+4],al
		call	fillstarting
		call	fillending
		call    sectorbefore
		call    sectorin

		mov	si,280
		mov	cx,15
		call	clearsw		; clear small window
		ret

@@escentry:	mov	si,280
		mov	cx,15
		call	clearsw		; clear small window
		mov	ah,1
		mov	cx,2000h	; hide cursor
		int	10h

		mov	ax,1
		mov	cl,actpart
		shl	ax,cl
		not	ax
		and	changes,ax	; erase changes in this entry
		ret
		endp

;------------- ASCII to hex --------------
asci2hex	proc
;SI - holds ASCII number
;Out: EAX - hexa numa

		push	edx
		xor	eax,eax
		xor	ebx,ebx
		xor	edx,edx
		mov	ecx,0ah
ndigit:		mov	bl,[si]
		inc	si
		cmp	bl,39h
		ja	convend
		sub	bl,30h
		jb	convend
		mul	ecx
		add	eax,ebx
		adc	dl,dh
		je	ndigit
convend:	pop	edx
		ret
		endp

;----------------------- ASCII to dec -------------------------

asci2dec	proc
;SI holds ASCII number
;Out: AX - hexa numa

		lodsw
		cmp	al,39h
		jna	number1
		cmp	al,90
		jb	capital1
		sub	al,20h
capital1:	sub	al,7h
number1:	sub	al,30h
		test	ah,ah
		jz	csakegy
		cmp	ah,' '
		jbe	csakegy
		cmp	ah,39h
		jna	number2
		cmp	ah,90
		jb	capital2
		sub	ah,20h
capital2:	sub	ah,7h
number2:	sub	ah,30h
		shl	al,4
		or	al,ah
csakegy:	ret

		endp

;-------------------- Get string to Inputbuffer ----------------
query		proc
;In: DX - cursor pos
;    'maxlen'
		push	ax
		push	cx
		push	dx
		push	si
		lea	si,commandptr
		mov	cx,1
		mov	strlen,0
gnchar:		call	setpos		; cursor pos

badchar:	xor	ax,ax
		int	16h
		cmp	al,0dh		; enter
		clc
		je	entpress
		cmp	al,8		; backspace
		je	bppress
		cmp	al,1bh
		je	@@escquery	; ESC
		cmp	al,'m'		; allow 'm' and 'M'
		je	@@okm
		cmp	al,'M'
		je	@@okm
		cmp	al,30h
		jb	badchar

label smc
		cmp	al,'f'
		ja	badchar
@@okm:		mov	ah,strlen	; check if buffer is full
		cmp	ah,maxlen
		jz	badchar

		mov	[si],al
		inc	strlen
		inc	si
		inc	dl
		mov	ah,0ah
		int	10h		
		jmp	gnchar

bppress:	cmp	strlen,0
		jz	badchar
		dec	si
		dec	dl
		dec	strlen
		mov	byte ptr [si],0
		call	setpos
		mov	ah,0ah
		mov	al,20h
		int	10h
		jmp	badchar

@@escquery:	stc
entpress:	pop	si
		pop	dx
		pop	cx
		pop	ax
		ret
		endp

;----- Indicate change
setchange	proc

		push	ax
		mov	ax,1
		mov	cl,actpart
		shl	ax,cl
		or	changes,ax	; indicate change
		pop	ax

		ret
		endp

;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;лллллллллллллллллллллл  Delete a partition entry  лллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
delpart		proc

		call	calcHD&offset
		add	di,bx
		mov	cx,8
		xor	bx,bx
clrentry:	mov	word ptr es:[di+bx],0
		add	bx,2
		loop	clrentry		

		ret
		endp

;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;лллллллллллллллллллллл Write new partition tables лллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
writeMBR	proc

;-------- Are you sure

		call	clearwin
		mov	ah,8fh
		mov	dx,0305h
		lea	bp,continue1
		call	print		; 'Wanna continue?'
		add	dh,2
		lea	bp,continue2
		call	print
		inc	dh
		lea	bp,continue3
		call	print
		inc	dh
		lea	bp,continue4
		call	print
		add	dh,2
		lea	bp,continue5
		call	print

@@newkey:	xor	ax,ax
		int	16h
		and	al,0dfh		; convert to uppercase
		cmp	al,'Y'
		je	writem
		cmp	al,'N'
		jne	@@newkey
		pop	ax
		call	clearwin
		call	strings
		jmp	restart

;------ write boot sectors

writem:		cmp	changes,0
		jz	@nowwriteMBR

		mov	cx,numodrives
		mov	ax,32
		mul	cx
		shl	ax,4
		mov	bx,ax			; ES:BX - F6 buffer

		mov	di,1beh			; DI - points to first table
		lea	si,diskparams
@@checkZIP:	mov	dl,[si]			; get disk ID
@countdsk:	push	cx
		mov	cx,4			; max changes on a disk

@countch:	shr	changes,1		; have to write?
		jnc	@no1			; jump if not

		cmp	byte ptr es:[di+4],0	; did we clear a partition?
		jz	@no1			; then don't alter boot rec.

		push	cx
		mov	eax,es:[di+8]		; get boot sector place
		cmp	byte ptr es:[di+4],0bh	; write 1 sectors if
		je	@fat32			; not FAT32
		cmp	byte ptr es:[di+4],0ch
		je	@fat32
		jmp	@notfat32

@fat32:		mov	cx,8			; else write 9
@fat32b:	call	writesector
		jc	@wer
		inc	eax
		loop	@fat32b

@notfat32:	call	writesector
@wer:		pop	cx
		jc	@wer2

@no1:		add	di,16		; DI - next entry
		loop	@countch
		clc
@wer2:		pop	cx
		jc	@wer3
		add	di,448		; DI - next disks partition tbl
		add	si,17
		loop	@@checkZIP

@wer3:		jnc	@nowwriteMBR
mbrwerror:	lea	bp,writerror
		call	error
		ret

;----------- Write new MBRs ----------

@nowwriteMBR:	mov	cx,numodrives	; number of disks
		xor	bx,bx

		xor	dh,dh
		lea	si,diskparams
@@checkwZIP:	mov	dl,[si]		; DL - disk ID

		push	cx
		mov	ax,0301h
		mov	cx,1
		mov	word ptr es:[bx+510],0aa55h
		call	lockvolume
		int	13h		; write MBR
		call	unlockvolume
		pop	cx
		jnc	MBRwritten	; jump if OK
		jmp	mbrwerror

MBRwritten:	add	bx,512
		add	si,17
		loop	@@checkwZIP

;-------- Print messages

@@MBRwr:	call	clearwin
		lea	bp,writtenmsg
		mov	dx,0308h
		call	print

		mov	dx,0610h
		lea	bp,rebootmsg
		call	print

		mov	dh,09

		cmp	win95?,1	; exit message depends on the
		jne	notwexit	; currently running OS

		mov	dl,21
		lea	bp,anykey
		call	print		; print this if in DOS box
		mov	ah,1		; under Win95
		int	21h
		clc
		ret

notwexit:	mov	dl,12
		lea	bp,pressreboot	; 'Press any key to reboot'
		call	print

		xor	ax,ax
		int	16h		; get key

		cmp	al,1bh
		jne	notquit
		clc
		ret

notquit:	call	freemem
		mov	ax,40h
		mov	es,ax
		mov	di,72h
		mov	ax,1234h
		stosw			; cold reboot

		db	0eah
		dw	0, 0ffffh

		endp

;------------------- Clear big window --------------------
clearwin	proc

		push	ax
		push	cx
		push	di
		push	es

		mov	ax,0b800h
		mov	es,ax
		mov	di,162
		mov	cx,18
		mov	ax,0720h
cnextrow:	push	cx
		mov	cx,58
		rep	stosw
		pop	cx
		add	di,160-58*2
		loop	cnextrow

		pop	es
		pop	di
		pop	cx
		pop	ax
		ret

		endp

;------------------ Clear small window -------------------
clearsw		proc
;SI - start address
;CX - height

		push	ax
		push	di
		push	es

		mov	ax,0b800h
		mov	es,ax

		mov	di,si
		mov	ax,720h
csnext:		push	cx
		mov	cx,19
		rep	stosw
		pop	cx
		add	di,122
		loop	csnext

		pop	es
		pop	di
		pop	ax
		ret

		endp

;-------------------------- Lock volume under Win95 ---------------------
lockvolume	proc
;DL - HD to lock
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

;------------------------- Unlock volume ---------------------------
unlockvolume	proc
;DL - HD to lock

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


;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;лллллллллллллллллллллллллл    Hide / Unhide     лллллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
hide		proc

		push	ax
		push	bx
		push	cx
		push	di

		call	calcHD&offset
		add	di,bx
		add	di,4
		mov	al,es:[di]		; AL - type
		push	di
		lea	di,fats
		xor	bx,bx
		mov	cx,10
nextexh:	cmp	al,ds:[di+bx]
		je	addsub10h
		inc	bx
		loop	nextexh
		cmp	al,7
		je	addsub10h
		cmp	al,17h
		je	addsub10h
		stc				; not FAT, no update needed
		pop	di
		jmp	exhider2

addsub10h:	pop	di
                sub     di,4
		cmp	al,10h
		ja	sub10h
		add	byte ptr es:[di+4],10h
                mov     cl,1
		call	AlterBoot
		jmp	exhider
sub10h:		sub	byte ptr es:[di+4],10h
                mov     cl,0
		call	AlterBoot
exhider:	clc
exhider2:	pop	di
		pop	cx
		pop	bx
		pop	ax

		ret

		endp

;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;лллллллллллллллл    Alter boot sector for (un)hiding  лллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

;------------ Alter boot sector for true hiding --------
AlterBoot	proc
;DL - disk
;ES:DI - entry
;CL=1 to hide

                push    si
                push    di
        	mov	bx,numodrives
		shl	bx,9			; BX -> bootbuffer
		mov	eax,es:[di+8]           ; firstpoint
                mov     blocks,1
                call    readsector
		mov	di,bx
		add	di,510
		test	cl,cl
		jz	@@unhidebs
		cmp	word ptr es:[di],0	; already hidden?
		je	@@altered
		mov	word ptr es:[di],0	; hide
		jmp	@@writeboot

@@unhidebs:	cmp	word ptr es:[di],0aa55h	; already unhidden?
		je	@@altered
		mov	word ptr es:[di],0aa55h	; unhide

@@writeboot:    call    writesector

@@altered:      mov     di,bx
                mov     cx,512
                mov     al,0F6h
                rep     stosb
                pop     di
                pop     si
	 	ret
AlterBoot	endp


;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;лллллллллллллллллллллллллл Set bootability flag лллллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
setboot		proc

		push	bx
		push	cx
		push	di

		call	calcHD&offset
		cmp	byte ptr es:[di+bx],80h
		jne	notoggle	; set an other active

		mov	byte ptr es:[di+bx],0
		jmp	exitsb

notoggle:	push	di
		mov	cx,4
		xor	al,al
clrnextb:	mov	es:[di],al
		add	di,16		; clear all active flags
		loop	clrnextb
		pop	di

		mov	byte ptr es:[di+bx],80h	; set this active
exitsb:		pop	di
		pop	cx
		pop	bx
		ret

setboot		endp	

;---------------------- Calculate HD number and offset ------------------

calcHD&offset	proc
;Out: DI - partition table of current HD
;     BX - offset to current entry
;     DL - disk
		push	ax

		mov	bl,lightpos
		sub	bl,3		; BL - entry number
		mov	bh,bl
		and	bl,3		; BL - part no
		shl	bl,4
		shr	bh,2		; BH - disk no
		push	bx
		mov	bl,bh
		xor	bh,bh
		mov	ax,512
		mul	bx
		pop	bx
		mov	dl,bh
		add	dl,80h
		xor	bh,bh
		mov	di,1beh
		add	di,ax

		pop	ax
		ret

		endp


;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;лллллллллллллллллллллллллллл Print HD info  лллллллллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

printinfo	proc
		mov	dx,013ch	; position
		lea	bp,HDinfo1
		call	print
		inc	dh		; inc
		lea	bp,HDinfo2	; print headlines
		call	print

		mov	cx,numodrives	; number of drives
		lea	bx,diskparams	; BX - pointer to params
		inc	dh		; inc row
nextinfo:	mov	dl,42h		; set col
		mov	eax,[bx+1]
		call	toascii		; print number of cylinders
		mov	dl,48h
		xor	ah,ah
		mov	eax,[bx+5]
		call	toascii		; heads
		mov	dl,4dh
		xor	ah,ah
		mov	eax,[bx+9]
		call	toascii		; sectors
@@prskZIP:	add	bx,17
		inc	dh
		loop	nextinfo	; print next HD info
		ret
		endp


;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;ллллллллллллллллллллллллллллл Command line  лллллллллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

;---- skips spaces and returns first non-whitespace ----
skipwhite	proc

skipit:		lodsb
		cmp	al,' '
		jne	exskip
		jmp	skipit
exskip:		ret

skipwhite	endp


;----------- examine command line ------------

commandline	proc
;IN -	DS: data segment
;	ES: MBRs and F6buffer

		lea	si,commandptr
		inc	si
		call	skipwhite
		cmp	al,'/'
		je	examcommand
		cmp	al,'-'
		je	examcommand
		cmp	al,'?'
		je	prusage
		jmp	badparam

prusage:	lea	dx,usage	; print usage info
		mov	ah,9
		int	21h
		clc
		ret

examcommand:	cmp	byte ptr [si],'?'
		je	prusage
		
		mov	cx,6
		lea	di,create
		call	examcom		; create?
		jc	notcreate
		call	createpart
		ret

notcreate:	mov	cx,6
		lea	di,crsize
		call	examcom		; crsize?
		jc	notcrsize
		call	crsizepart
		ret

notcrsize:	mov	cx,6
		lea	di,delete
		call	examcom		; delete?
		jc	notdelete
		call	deletepart
		ret

notdelete:	mov	cx,6
		lea	di,delall
		call	examcom
		jc	notdelall	; delall?
		call	delallpart
		ret

;-------- Bad parameter ---------

badparam:	lea	dx,badpar
		mov	ah,9
		int	21h
		stc
quitparse:	ret

;-------------------------------

notdelall:	mov	cx,8
		lea	di,activate
		call	examcom
		jc	notactivate	; activate?
		call	activatepart
		ret

notactivate:	mov	cx,7
		lea	di,hidep
		call	examcom		; hide FAT?
		jc	nothidefat
		call	hidefatpart
		ret

nothidefat:	mov	cx,6
		lea	di,hidentp
		call	examcom		; hide NTFS
		jc	nothident
		call	hidentpart
		ret

nothident:	mov	cx,9
		lea	di,unhidefat
		call	examcom
		jc	nounfat		; unhide FAT?
		call	unhidefatpart
		ret

nounfat:	mov	cx,8
		lea	di,unhident
		call	examcom
		jc	instmbr
		call	unhidentpart
		ret

instmbr:	mov	cx,3
		lea	di,mbrsig
		call	examcom
		jc	badparam
		call	installMBR
		ret

		endp

;-------- Set DI to partition entry, SI to disk params --------------
GetPartPTR:

;IN:  DL - HD number
;     AH - partition number
;OUT: DI - points to selected partition entry

		push	ax
		push	dx
		mov	dh,ah		; store partition no in DH
		mov	ax,17
		sub	dl,80h
		mul	dl
		lea	si,diskparams
		add	si,ax		; SI points to disk parameters

		movzx	ax,dh
		shl	dx,9		; DL * 512
		add	dx,1beh		; DX points to first part. entry
		shl	ax,4
		mov	di,ax
		add	di,dx		; DI - points to selected partition
		pop	dx
		pop	ax
		ret

;------------
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

;------------------------- Write MBR in command line mode ------------------
writeMBRc       proc
;IN:  DI - point to partition entry
;     SI - HD parameters
;OUT: c flag

		xor	eax,eax
		mov	bx,di
		and	bx,0fe00h
		mov	dl,[si]
		call	writesector	; write new partition table
                ret
                endp

;------------------- Get options of commands -------------------

getopts		proc
;OUT: AH - partition no
;     DL - HD ID
		xor	bl,bl
		call	skipwhite
		sub	al,31h
		cmp	al,3
		ja	badopt

		mov	bh,al
getnext:	call	skipwhite
		cmp	al,1fh
		jbe	quitopt
		sub	al,30h
		cmp	al,4
		ja	badopt
		cmp	al,0
		je	badopt
		dec	al
		mov	bl,al

quitopt:	mov	ax,bx
		add	al,80h
		mov	dl,al
		clc
		ret

badopt:		mov	ah,9
		lea	dx,badpar
		int	21h
		stc
		ret
		endp

;--------- Get only harddisk no for delall, mbr and print --------------

nopars		proc
;OUT: AH - zero
;     DL - HD no

		call	skipwhite
		cmp	al,0dh
		je	alis0
		test	al,al
		je	alis0
		jmp	moreexam
alis0:		xor	al,al
		jmp	stillok
moreexam:	sub	al,31h
		cmp	al,4
		jb	nowok
		stc
		ret
nowok:		cmp	al,0
		jae	stillok
		stc
		ret
stillok:	xor	ah,ah
		add	al,80h
		mov	ah,byte ptr numodrives
		add	ah,80h
		cmp	al,ah
		jae	@@badspec
		xor	ah,ah
		mov	dl,al
		clc
		ret

@@badspec:	mov	ah,9
		lea	dx,nodrive
		int	21h
		stc
		ret

		endp

;------------------- Create -------------------

createpart	proc
		add	si,7
		call	skipwhite
		dec	si
		call	asci2dec
		mov	partyp,al		; save partition type
		call	skipwhite

		cmp	al,'*'			; wildcard?
		jne	notwild			; jump of not
		call	skipwhite
		cmp	al,'*'			; then the ending cylinder
		jne	badwild			; must be also a '*'
		call	getopts			; get partition and
		call	GetPartPTR		; calculate proper SI and DI
		cmp	word ptr es:[di+4*16],0aa55h
		jne	not1stpart		; is it the first entry?
fixstart:	mov	eax,[si+9]
		mov	starting,eax
		jmp	nowend

not1stpart:	mov	eax,es:[di-8]	; the previous ending+1
		add	eax,es:[di-4]
                test    eax,eax
		jz	fixstart
		mov	starting,eax

nowend:		mov	eax,[si+13]
		dec	eax
		mov	ending,eax	; ending cylinder
		jmp	okwild

notwild:	dec	si			; SI fixup
		push	si
		call	asci2hex		; get starting
		mov	starting,eax
		call	skipwhite
		dec	si
		call	asci2hex		; and ending
		mov	ending,eax
		call	getopts			; AH - prtition no, AL - disk no
		pop	si
		jnc	oknowild		; jump if good parameter
badwild:	stc
		ret

oknowild:	call	GetPartPTR		; calculate proper SI and DI
		mov	eax,starting
		call	calcstarting
		jc	badcyls
		mov	eax,ending
		call	calcending
		jc	badcyls
		jmp	okwild

badcyls:	lea	dx,invcyl
		jmp	ercex

okwild:		mov	byte ptr es:[di],0	; active flag is 0
                call    fillstarting
		mov	al,partyp
		mov	byte ptr es:[di+4],al	; set type
                call    fillending
                call    sectorbefore
		call    sectorin
		call	writeMBRc
		jnc	writeok1
writeerror:	lea	dx,writerror
ercex:		mov	ah,9
		int	21h
		stc
		ret

writeok1:	mov	bx,numodrives
		shl	bx,9			; BX -> F6buffer
		mov	eax,es:[di+8]
		mov	cx,3
		cmp	byte ptr es:[di+4],0bh
		je	fat32w
		cmp	byte ptr es:[di+4],0ch
		je	fat32w
		mov	cx,1
fat32w:		call	writesector
		jc	writeerror
		inc	eax			; write to next sector
		loop	fat32w

		mov	ah,9
		lea	dx,created
		int	21h
		clc
		ret
		endp

;-------------------- Delete -----------------------

deletepart	proc

		add	si,7
		call	getopts
		jnc	okopt2
		ret
okopt2:		call	GetPartPTR	; calculate SI and DI
		mov	cx,16
		xor	al,al
		rep	stosb

		call	writeMBRc
		jnc	writtenok2
		jmp	writeerror

writtenok2:	mov	ah,9
		lea	dx,deleted	; 'sucessfully deleted'
		int	21h
		clc
		ret
		endp

;---------------------- Delall --------------------------

delallpart	proc
		add	si,6
		call	nopars			; get HD number
		jnc	yodelall
		ret
yodelall:	call	GetPartPTR
		mov	cx,16*4
		xor	al,al
		rep	stosb
		call	writeMBRc
		jnc	writtenok2b
		jmp	writeerror

writtenok2b:	mov	ah,9
		lea	dx,delalld
		int	21h
		clc
		ret
		endp

;-------------------- Activate --------------------

activatepart	proc
		add	si,9
		call	getopts
		jnc	okopt3
		ret
okopt3:		call	GetPartPTR
		cmp	byte ptr es:[di],80h	; check if already active
		jne	ok2act
		mov	ah,9
		lea	dx,alreadyact		; error if yes
		int	21h
		stc
		ret

ok2act:		push	di
		and	di,0fe00h
		add	di,1beh
		mov	cx,4
		xor	al,al			; clear all active flags
clrnext:	mov	es:[di],al
		add	di,16
		loop	clrnext
		pop	di
		mov	byte ptr es:[di],80h	; activate the selected

		call	writeMBRc
		jnc	writtenok3
		jmp	writeerror

writtenok3:	mov	ah,9
		lea	dx,activated
		int	21h
		clc
		ret
		endp

;----------------------- Hide FAT -----------------------

hidefatpart	proc
		add	si,8
		call	getopts
		jnc	yohide
		ret
yohide:		call	GetPartPTR
		mov	al,es:[di+4]		; AL - type
		push	di
		lea	di,fats
		xor	bx,bx
		mov	cx,5
nexthf:		cmp	al,ds:[di+bx]
		je	ok2hide			; jump if FAT
		inc	bx
		loop	nexthf
		pop	di
		mov	ah,9
		lea	dx,notFAT		; error if not FAT
		int	21h
		stc
		ret

ok2hide:	pop	di
		add	byte ptr es:[di+4],10h
                mov     cl,1
                mov     dl,[si]
		call	AlterBoot
		call	writeMBRc
		jnc	writtenok4
		jmp	writeerror

writtenok4:	mov	ah,9
		lea	dx,hiddened
		int	21h
		clc
		ret
		endp

;----------------------- Hide NTFS -----------------------

hidentpart	proc
		add	si,7
		call	getopts
		jnc	yohident
		ret
yohident:	call	GetPartPTR
		mov	al,es:[di+4]		; examine if the
		cmp	al,7			; selected is some NTFS
		je	ok2hident

		mov	ah,9
		lea	dx,notNT        	; error if not NTFS
		int	21h
		stc
		ret

ok2hident:	add	byte ptr es:[di+4],10h
                mov     cl,1
                mov     dl,[si]
		call	AlterBoot
		call	writeMBRc
		jnc	writtenok4b
		jmp	writeerror

writtenok4b:	mov	ah,9
		lea	dx,hiddened
		int	21h
		clc
		ret
		endp

;-------------------- Unhide FAT ----------------------

unhidefatpart	proc
		add	si,10
		call	getopts
		jnc	younhide
		ret
younhide:	call	GetPartPTR
		call    checkhidden
                jc      ok2unh

		mov	ah,9		; error if not
		lea	dx,nothidden
		int	21h
		stc
		ret

ok2unh: 	sub	byte ptr es:[di+4],10h
                mov     cl,0
                mov     dl,[si]
		call	AlterBoot
		call	writeMBRc
		jnc	writtenok5
		jmp	writeerror

writtenok5:	mov	ah,9
		lea	dx,unhidden
		int	21h
		clc
		ret
		endp

;-------------------- Unhide NTFS ----------------------

unhidentpart	proc
		add	si,9
		call	getopts
		jnc	younhident
		ret
younhident:	call	GetPartPTR
		mov	al,es:[di+4]
		cmp	al,17h		; examine if hidden HPFS/NTFS
		je	ok2unhident

		mov	ah,9		; error if not
		lea	dx,nothiddennt
		int	21h
		stc
		ret

ok2unhident:	sub	byte ptr es:[di+4],10h
                mov     cl,0
                mov     dl,[si]
		call	AlterBoot
		call	writeMBRc
		jnc	writtenok5b
		jmp	writeerror

writtenok5b:	mov	ah,9
		lea	dx,unhidden
		int	21h
		clc
		ret
		endp

;-------------------- Install MBR loader -------------------

installMBR	proc

		add	si,3
		call	nopars			; get HD number in AL
		jnc	yombr
		ret
yombr:		call	GetPartPTR		; calculate SI and DI
		push	si
		push	di
		sub	di,1beh			; DI - MBR of selected HD
		lea	si,MBRloader
		mov	cx,24*16+10
		rep	movsb			; copy standard loader
		pop	di
		pop	si
                mov     dl,[si]
		mov	cx,4
chknh:		call	checkhidden		; unhide all hidden
		jnc	nounh
subbit:		sub	byte ptr es:[di+4],10h
                push    cx
                mov     cl,0
		call	AlterBoot
                pop     cx
nounh:		cmp	byte ptr es:[di+4],17h	; even NTFS
		je	subbit
		add	di,16
		loop	chknh
		mov	ax,0aa55h
		stosw				; store MBR signature
		dec	di
		call	writeMBRc		; write back
		jnc	writtenok6
		jmp	writeerror

writtenok6:	mov	ah,9
		lea	dx,mbrinstalled
		int	21h
		clc
		ret

		endp

;---------------- Check if hidden FAT ------------------

checkhidden     proc
;IN: DI - entry
;OUT: C=1 if hidden

		push	ax cx di
		add	di,4
		mov	al,es:[di]		; AL - type
		lea	di,fats
                add     di,6
		xor	bx,bx
		mov	cx,5
nextuhf:	cmp	al,ds:[di+bx]
		je	ok2unhide
		inc	bx
		loop	nextuhf

                clc
                jmp	chke

ok2unhide:      stc
chke:		pop	di cx ax
                ret
                endp


;------------------------ Create by size -------------------

crsizepart	proc
		add	si,7
		call	skipwhite
		dec	si
		call	asci2dec
		mov	partyp,al		; push partition type
		call	skipwhite
		dec	si
		xor	eax,eax
		call	asci2hex
		shl	eax,11
		mov	psize,eax	; store size in sectors
		call	getopts		; AH - prtition no, AL - disk no
		jnc	okopt6		; jump if bad parameter
		stc
		ret

okopt6:		call	GetPartPTR	; ES:DI - pointer to selected part.
		cmp	word ptr es:[di+4*16],0aa55h ; is it the first?
		jne	notfirst
firstit:	mov	eax,[si+9]
		jmp	firsted

notfirst:	mov	eax,es:[di-8]
		add	eax,es:[di-4]
		test	eax,eax
		jz	firstit
firsted:	mov	starting,eax
		mov	byte ptr es:[di],0	; active flag is 0

                call    fillstarting
		mov	al,partyp
		mov	byte ptr es:[di+4],al	; set type

		xor	edx,edx
		mov	eax,[si+5]
		mov	ebx,[si+9]
		mul	bx
		mov	bx,ax			; BX - heads * sectors
		mov	eax,starting
		add	eax,psize		; correct it to a value
		div	ebx			; which doesn't give a
		sub	ebx,edx			; remainder
		add	psize,ebx

		mov	eax,starting
		add	eax,psize
		dec	eax
		cmp	eax,[si+13]
		jb	oklarge

		mov	ah,9
		lea	dx,toobig
		int	21h
		ret

oklarge:	mov	ending,eax
                call    fillending
                call    sectorbefore
		call    sectorin
		call	writeMBRc	; write new partition table
		jnc	writeok6
		jmp	writeerror

writeok6:	mov	bx,numodrives
		shl	bx,9			; BX -> F6buffer
		mov	eax,es:[di+8]
		mov	cx,3
		cmp	byte ptr es:[di+4],0bh
		je	fat32ws
		cmp	byte ptr es:[di+4],0ch
		je	fat32ws
		mov	cx,1
fat32ws:	call	writesector
		jc	writeerror
		inc	eax			; write to next sector
		loop	fat32ws

		mov	ah,9
		lea	dx,created
		int	21h
		clc
		ret
		endp

;----------------------- Calculate starting info -----------------------------

calcstarting	proc
;EAX - cyl nr
; IN - SI: pointer to disk parameter table
;OUT - 'starting' holds starting LBA sector number
		push	eax
		push	edx
;		movzx	eax,ax
		cmp	eax,[si+1]		; check if above max
		jb	okst
		stc
		jmp	badst

okst:		mul	dword ptr [si+5]
		mul	dword ptr [si+9]
		test	eax,eax			; if zero, then head 1 sector 1
		jnz	@@oks
		mov	eax,dword ptr [si+9]
@@oks:		mov	starting,eax
		clc
badst:		pop	edx
		pop	eax
		ret
		endp

;----------------------- Calculate ending info -----------------------------

calcending	proc
;EAX - cyl no
; IN - SI: pointer to disk parameter table
;OUT - 'ending' holds ending LBA sector number

                push    eax
		push	edx


		inc	eax		; ending + 1 cyls - 1 sector
;		movzx	eax,ax

		cmp	eax,[si+1]	; bigger than max allowed?
		jbe	oken
		stc
		jmp	baden

oken:		mul	dword ptr [si+5]
		mul	dword ptr [si+9]
		dec	eax
		mov	ending,eax
		clc
baden:		pop	edx
                pop     eax
                ret
                endp

;----------------------- Fill starting info -----------------------------

fillstarting	proc near
;IN - starting
		mov	eax,starting
		call	LBA2CHS
		jnc	nonz
		ret

nonz:		mov	byte ptr es:[di+1],dh	; set starting head
		mov	byte ptr es:[di+2],cl	; sector and
		mov	byte ptr es:[di+3],ch	; cylinder
		clc
                ret
                endp

;------------------------- Fill ending info -------------------------

fillending      proc
;IN - ending
		mov	eax,ending
		call	LBA2CHS
		jnc	zeroeend
		ret

zeroeend:	mov	byte ptr es:[di+6],cl	; sector
		mov	byte ptr es:[di+7],ch
		mov	es:[di+5],dh
		clc
		ret

                endp

;-------------------------- Fill sectors before ------------------------

sectorbefore    proc

		mov	eax,starting	; EAX - starting cylinder
		mov	es:[di+8],eax	; setting preceeding sector number
                ret

                endp

;---------------------- Calculate sectors in partition -----------------
sectorin        proc

		mov	eax,ending
		sub	eax,starting
		inc	eax
		mov	es:[di+0ch],eax	; setting num of sectors entry
		ret

                endp


;--------------- Free memory ---------------

freemem         proc
;IN ES
		pushf
		push	ax
		mov	ah,49h
		int	21h			; free ES segment
		mov	ax,ds
		mov	es,ax			; restore ES
		pop	ax
		popf
		ret

                endp

;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;ллллллллллллллллллллллллллллл Error handler лллллллллллллллллллллллллллл
;лллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
;BP - pointer to error

error		proc

		mov	si,280
		mov	cx,15
		call	clearsw		; clear small window

		mov	dh,8
		mov	dl,60
		call	print		; print error message
		lea	bp,anykey
		inc	dh
		inc	dh		; print 'Press a...'
		call	print
		xor	ax,ax		; wait for a key
		int	16h
		stc
		ret			; exit program

		endp


;-------------------- Include common routines --------------------

include common.inc

;----------------------- Check command line ---------------------

CheckCMDLine	proc

		push	ds
		mov	ax,cs
		sub	ax,10h
		mov	ds,ax
		mov	si,80h
		movzx	cx,byte ptr [si]	; get command length
		add	cx,2
		lea	di,commandptr
		rep	movsb			; copy command line to data
		pop	ds
		ret
		endp

;---------------------- Allocate memory ---------------------

Allocate	proc
;OUT ES:BX

              	mov	ax,32
		mul	numodrives		; allocate memory for MBRs...
		mov	bx,ax
		add	bx,32			; an F6buffer
		mov	ah,48h
		int	21h
		jnc	okmem			; jump if mem OK
		mov	ah,9
		lea	dx,memerror
		int	21h			; else error and exit
		mov	ax,4c01h
		int	21h

okmem:		mov	es,ax
	       	mov	disksegment,ax
		xor	di,di
		mov	al,0f6h
		shl	bx,4			; generate F6 buffer
		mov	cx,bx
		rep	stosb
		xor	bx,bx
		ret

                endp

;---------------------- Get Master Boot Records ---------------------
getMBRs		proc
;Loads MBRs to 'MBRbuffer'

		mov	cx,numodrives
		xor	bx,bx

		mov	dx,80h			; start with the first HD
		lea	si,diskparams
@@checkgZIP:	call	getMBR			; load MBR
		jc	@badmbr			; it's a ZIP without disk (?)
		mov	[si],dl			; save HD ID if success
		inc	dl			; point to next HD
		add	bx,200h			; mext MBR buffer
		add	si,17			; and next disk parameter table
		loop	@@checkgZIP		; load next
		jmp	@okMBR

@badmbr:	inc	dl
		dec	numodrives
		loop	@@checkgZIP

@okMBR:		ret

		endp

;----------------------- Get one MBR --------------------------
getMBR		proc
;DL - harddisk ID
;ES:BX - buffer

		push	cx
		mov	di,4		; 4 retries
		mov	cx,1
@retryread:	mov	ax,201h
		int	13h		; read MBR
		jnc	norerror	; jump if OK

		mov	ah,0dh
		int	13h		; try again after reset
		dec	di
		jnz	@retryread
		stc

norerror:	pop	cx
		ret

		endp

;-------------------- Get hard disk parameters -------------------
getparams	proc

;Reads parameters of each disk, fills parameter tables

		mov	cx,numodrives
		lea	si,diskparams		; buffer to store params

@nparam:	mov	dl,[si]			; start with first HD
		push	cx
		mov	ah,8
		int	13h			; get parameters

		movzx	ebx,cx
		xchg	bh,bl
		shr	bh,6
                inc     bx
		mov	[si+1],ebx		; cylinder no
		and	ecx,3fh
		mov	[si+9],ecx		; sector no
                movzx   edx,dh
		inc	edx
		mov	[si+5],edx		; head no
		cmp	ebios?,1
		jne	nomaxb

		mov	ah,48h
		mov	dl,[si]			; get EBIOS params if supported
		push	si
		lea	si,ebiosparams
                mov     word ptr [si],1ah
		int	13h
		pop	si
		mov	eax,[si+5]		; get head nr
		mul	dword ptr [si+9]	; mul by sector nr
		mov	ebx,eax
		mov	eax,etotal		; fix cyl no
		div	ebx
		mov	[si+1],eax		; store cyl nr

nomaxb:		mov     eax,[si+1]
                mul     dword ptr [si+5]
                mul     dword ptr [si+9]
                mov     [si+13],eax		; aligned total sectors on HD
		add	si,17			; point to next disk params

@@zip1:		pop	cx
		loop	@nparam
		ret

		endp

;***************************************************************************
;ФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФ Main Code ФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФФ
;***************************************************************************

main:		cld
		call	ResizeMemory		; resize memory block
		call	CheckCPU		; check for 386+
		mov	ax,DataSegment
		mov	ds,ax
		mov	es,ax
                call    CheckNT			; don't run under NT
		call	DetectWin9x		; detect Win9x DOS box
		call	CheckEbios		; check if EBIOS available
		call	CheckCMDLine		; check command line
		call	getnumodrives		; how many drives are there
		call	Allocate
		call	getMBRs			; read MBRs
		call	getparams		; get parameters

		lea	si,commandptr+1
		call	skipwhite		; is there a command line opt?
		cmp	al,0dh
		je	nocommandline		; jump if no

		call	commandline		; else process command line
		jmp	freeexit

nocommandline:	call	checkVGA
		jnc	@vgaok
		jmp	freeexit

@vgaok:		call	window		; draw screen
		call	strings		; display strings

;Disk init Done
;-------------------
;Examine partitions

restart:	call	printinfo
		call	analyse		; analyse partition, print info

		xor	ax,ax
		call	highlight

;--------------- Main Loop ----------------

newstroke:	xor	ax,ax		; wait for keystroke
		int	16h

		cmp	ah,48h
		jne	noup
		mov	al,-1		; up
		call	highlight
		jmp	newstroke

noup:		cmp	ah,50h
		jne	nodown
		mov	al,1		; down
		call	highlight
		jmp	newstroke

nodown:		cmp	al,1bh
		jne	noesc
		jmp	exit		; ESC

noesc:		cmp	al,0dh
		jne	noenter
		mov	si,280
		mov	cx,15
		call	clearsw
		call	modifypart	; ENTER
res2:		call	clearwin
		call	strings
		jmp	restart

noenter:	cmp	ah,44h
		jne	nof10
		call	writeMBR	; F10
		jc	freeexit
		jmp	exit

nof10:		cmp	al,20h		; SPACE
		jne	nospace
		call	setboot
		jmp	res2

nospace:	cmp	ah,53h
		jne	nodel		; DEL
		call	delpart
		jmp	res2

nodel:		cmp	al,'h'
		jne	newstroke	; 'h'
		call	hide
		jc	newstroke
		jmp	res2

;------------------

exit:		mov	ax,3			; clear screen
		int	10h
		mov	ah,9
		lea	dx,thank		; print string
		int	21h
		
		clc
freeexit:	call	freemem			; free memory
		mov	ax,4c00h
		adc	al,0
		int	21h

		ends


		end	main

;===============================End of program================================
