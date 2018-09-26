;----------------------- Resize memory block ------------------

ResizeMemory	proc

		mov	bx,200h
		shr	bx,4		; stack length / 16 + 1
		inc	bx
		mov	ax,ss
		add	bx,ax
		mov	ax,ds
		sub	bx,ax
		mov	ah,4ah			; resize memory block
		int	21h
		ret
		endp

;------------------------- Check CPU ---------------------------

checkCPU	proc
;Checks for at least a 386. Bombs out if not found.

		pushf			; push original FLAGS
		pop	ax 		; get original FLAGS
		mov	cx,ax		; save original FLAGS
		and	ax,0fffh	; clear bits 12-15 in FLAGS
		push    ax              ; save new FLAGS value on stack
		popf                    ; replace current FLAGS value
		pushf                   ; get new FLAGS
		pop     ax              ; store new FLAGS in AX
		and     ax, 0f000h      ; if bits 12-15 are set, then CPU
		cmp     ax, 0f000h      ;   is an 8086/8088
		mov	al,1		; turn on 8086/8088 flag
		jne	short check_80286 ; jump if CPU is not 8086/8088

@@no386:        push    cs              ; point ds to cs to correctly
                pop     ds              ; print error message
        	mov	ah,9
		lea	dx,S_no386      ; print string
		int	21h
		mov     ax,4c01h        ; dirty exit
		int	21h

;       Intel 286 CPU check
;       Bits 12-15 of the FLAGS register are always clear on the
;       Intel 286 processor in real-address mode.
;
check_80286:	or      cx, 0f000h      ; try to set bits 12-15
		push    cx              ; save new FLAGS value on stack
		popf                    ; replace current FLAGS value
		pushf                   ; get new FLAGS
		pop     ax              ; store new FLAGS in AX
		and     ax, 0f000h      ; if bits 12-15 clear, CPU=80286
		mov     al,2		; turn on 80286 flag
		jz      @@no386         ; if no bits set, CPU is 80286
		ret

		endp

S_no386		db	'Error: 386+ CPU required$'

;------------------------- Check NT DOS box -------------------------

CheckNT		proc
		mov	ax,3306h
		int	21h
		cmp	bx,3205h		; NT dos box
		je	@@itsNT
		ret

@@itsNT:	mov	ah,9
		lea	dx,S_NTbox              ; print string
		int	21h
		xor	ax,ax                   ; wait for a keypress
		int	16h
		mov	ax,4c01h                ; dirty exit
		int	21h
		endp

;----------------------- Detect Win9x ---------------------

DetectWin9x	proc
		mov	Win95?,0
		mov	ax,1600h
		int	2fh		; detect Win95
		cmp	al,4
		jb	@@notw95
		mov	Win95?,1
@@notw95:	ret
		endp

;------------------------- Check EBIOS -------------------------
CheckEbios	proc
;Checks for Ebios presence
		mov	ebios?,0

		mov	writeint,3
		mov	readint,2

		mov	ah,41h
		mov	bx,55aah
		mov	dl,80h
		int	13h			; installation check
		jnc	@@okEB
		ret

@@okEB:         cmp     bx,0aa55h		; check 1
                jne     @@qebios
                and     cx,1			; check 2
                jz      @@qebios
		mov	ebios?,1
		mov	writeint,43h
		mov	readint,42h
@@qebios:	ret

		endp

;---------------------------- Check VGA ----------------------------
checkVGA	proc

		mov	ax,1a00h
		int	10h
		and	al,8
		jnz	vgaok
		mov	ah,9
		lea	dx,S_novga
		int	21h
		stc
		ret

vgaok:		clc
		ret
		endp

;--------------------- Get number of drives --------------------
getnumodrives	proc
;Stores number of drives to 'numodrives' variable

		mov	ah,8
		mov	dl,80h		; get drive params
		int	13h
		test	dl,dl		; is there a HD?
                jnz     @@vanHD		; jump if yes

		mov	ah,9
		lea	dx,S_nodrive	; else eror and exit
		int	21h
		mov	ax,4c01h
		int	21h

@@vanHD:	xor	dh,dh
		cmp	dl,4
		jbe	oknum
		mov	dl,4		; max is 4
oknum:		mov	numodrives,dx
		ret

		endp

;---------------------- Set cursor position ---------------------
;DX - pos
setpos		proc

		push	ax
		mov	ah,2
		int	10h
		pop	ax
		ret

setpos		endp

;------------------ Convert to ASCII and print ---------------------
;Numbers are right justified, so row must be specified accordingly!
;EAX - number
;DX - cursor position

toascii		proc

		push	eax
		push	ebx
		push	cx
		push	edx
		push	si

		mov	ebx,10		; div by 10
		lea	si,ascnum+7	; jump to last pos in buffer
		xor	cx,cx		; calc length

		push	dx		; store pos
zz4:		xor	edx,edx
		div	ebx		; div by 10 until zero
		add	dl,30h
		mov	[si],dl
		dec	si
		inc	cl		; inc string size
		or	eax,eax		; remainder?
		jne	zz4
		pop	dx		; get pos

		dec	cx
		sub	dl,cl		; correct pos for right alignment
		call	setpos
		lea	dx,ascnum+7
		sub	dx,cx
		mov	ah,9
		int	21h

		pop	si
		pop	edx
		pop	cx
		pop	ebx
		pop	eax
		ret

		endp	toascii
