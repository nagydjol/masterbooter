.MODEL SMALL
.STACK 200h

include defines.h
include main.h

MRBOOTER=1

DataSegment	segment	para public 'data'

loader label byte
DB 0EBh,007h
db 'MREG'
dw versiostr
db versio
DB 033h, 0FFh, 0FAh, 08Eh, 0D7h, 0BCh, 000h
DB 07Ch, 0FBh, 0FCh, 08Eh, 0DFh, 08Bh, 0F4h, 0B8h, 060h, 000h, 08Eh, 0C0h, 0B9h, 000h, 001h, 0F3h
DB 0A5h, 006h, 068h, 026h, 000h, 0CBh, 00Eh, 01Fh, 0BBh, 000h, 002h, 0B1h, 002h, 0BAh, 080h, 000h
DB 0B0h, 007h, 0E8h, 0DCh, 000h, 0B4h, 008h, 0CDh, 013h, 08Ah, 0C2h, 098h, 03Bh, 006h, 016h, 00Dh
DB 073h, 003h, 0A3h, 016h, 00Dh, 0BAh, 080h, 000h, 0A0h, 07Ah, 00Fh, 0A2h, 037h, 00Dh, 0A1h, 083h
DB 00Fh, 0A3h, 081h, 00Fh, 083h, 03Eh, 081h, 00Fh, 000h, 075h, 015h, 0B4h, 001h, 0CDh, 016h, 074h
DB 006h, 032h, 0E4h, 0CDh, 016h, 0EBh, 0F4h, 0E8h, 008h, 001h, 0E8h, 0D3h, 007h, 0E8h, 032h, 002h
DB 0E8h, 0D4h, 000h, 080h, 03Eh, 07Fh, 00Fh, 000h, 074h, 007h, 0B8h, 007h, 00Eh, 0B7h, 001h, 0CDh
DB 010h, 0E8h, 01Dh, 004h, 080h, 03Eh, 080h, 00Fh, 001h, 075h, 004h, 03Ch, 061h, 074h, 044h, 0E8h
DB 0E3h, 005h, 0E8h, 09Ah, 001h, 0E8h, 079h, 006h, 052h, 0E8h, 08Dh, 003h, 0E8h, 074h, 002h, 0E8h
DB 066h, 001h, 05Ah, 033h, 0C0h, 08Eh, 0D8h, 08Eh, 0C0h, 081h, 0C6h, 000h, 006h, 0BFh, 000h, 07Ch
DB 066h, 026h, 081h, 07Dh, 037h, 041h, 054h, 031h, 036h, 075h, 006h, 026h, 088h, 055h, 024h, 0EBh
DB 00Fh, 066h, 026h, 081h, 07Dh, 053h, 041h, 054h, 033h, 032h, 075h, 004h, 026h, 088h, 055h, 040h
DB 006h, 057h, 0CBh, 0E8h, 032h, 001h, 033h, 0C0h, 08Eh, 0C0h, 0BFh, 004h, 000h, 0BBh, 000h, 07Ch
DB 0B9h, 001h, 000h, 033h, 0D2h, 0B8h, 001h, 002h, 0CDh, 013h, 073h, 00Bh, 032h, 0E4h, 0CDh, 013h
DB 04Fh, 075h, 0F2h, 00Eh, 007h, 0EBh, 007h, 0B8h, 040h, 000h, 08Eh, 0D8h, 0EBh, 0D2h, 0BDh, 028h
DB 001h, 0B9h, 013h, 000h, 0BAh, 000h, 018h, 0BBh, 007h, 000h, 0B8h, 000h, 013h, 0CDh, 010h, 0EBh
DB 0FEh, 0B4h, 002h, 0CDh, 013h, 072h, 001h, 0C3h, 0BDh, 028h, 001h, 0BAh, 000h, 018h, 0B9h, 013h
DB 000h, 0B3h, 007h, 0E8h, 015h, 000h, 0EBh, 0FEh, 043h, 061h, 06Eh, 06Eh, 06Fh, 074h, 020h, 072h
DB 065h, 061h, 064h, 020h, 073h, 065h, 063h, 074h, 06Fh, 072h, 021h, 050h, 053h, 0B8h, 000h, 013h
DB 0B7h, 001h, 0CDh, 010h, 05Bh, 058h, 0C3h, 0BEh, 019h, 00Dh, 032h, 0F6h, 0BBh, 000h, 010h, 08Bh
DB 00Eh, 016h, 00Dh, 051h, 08Ah, 014h, 0B9h, 001h, 000h, 0B0h, 001h, 0E8h, 0B3h, 0FFh, 059h, 081h
DB 0C3h, 000h, 002h, 046h, 0E2h, 0EDh, 0B9h, 040h, 000h, 0BEh, 0BEh, 011h, 0BFh, 086h, 00Fh, 0F3h
DB 0A4h, 0C3h, 0B8h, 001h, 005h, 0CDh, 010h, 0B8h, 000h, 006h, 0B7h, 007h, 033h, 0C9h, 0BAh, 04Fh
DB 024h, 0CDh, 010h, 0B4h, 001h, 0B9h, 000h, 020h, 0CDh, 010h, 0C3h, 0FFh
loaderend label
DB 000h, 000h, 000h, 000h
DB 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
DB 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h
DB 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h

origpart	db	16 dup (1)
		db	16 dup (2)
		db	16 dup (3)
		db	16 dup (4)
		db	055h,0AAh

;---- procedures ----

DB 000h, 000h, 000h, 000h, 000h, 000h, 000h, 000h, 083h, 03Eh, 081h, 00Fh, 000h, 075h, 018h, 0B8h
DB 000h, 005h, 0CDh, 010h, 08Ah, 036h, 07Bh, 00Fh, 080h, 0C6h, 00Dh, 032h, 0D2h, 0E8h, 008h, 000h
DB 0B4h, 001h, 0B9h, 00Eh, 00Dh, 0CDh, 010h, 0C3h, 0B4h, 002h, 0B7h, 001h, 0CDh, 010h, 0C3h, 066h
DB 050h, 051h, 0BEh, 098h, 00Eh, 0B4h, 005h, 0F6h, 0E4h, 003h, 0F0h, 006h, 056h, 08Ah, 014h, 033h
DB 0C0h, 08Eh, 0C0h, 0BBh, 000h, 07Ch, 080h, 03Eh, 018h, 00Dh, 001h, 075h, 01Ch, 08Ch, 0C0h, 066h
DB 0C1h, 0E0h, 010h, 08Bh, 0C3h, 066h, 0A3h, 021h, 00Dh, 066h, 08Bh, 044h, 001h, 066h, 0A3h, 025h
DB 00Dh, 0BEh, 01Dh, 00Dh, 0B8h, 000h, 042h, 0EBh, 009h, 0B8h, 001h, 002h, 08Ah, 074h, 001h, 08Bh
DB 04Ch, 002h, 0CDh, 013h, 00Fh, 082h, 086h, 0FEh, 0B8h, 055h, 0AAh, 0BFh, 0FEh, 07Dh, 026h, 089h
DB 005h, 05Eh, 0BFh, 000h, 07Ch, 066h, 026h, 081h, 07Dh, 036h, 048h, 050h, 046h, 053h, 075h, 00Dh
DB 026h, 088h, 055h, 024h, 066h, 08Bh, 044h, 001h, 066h, 026h, 089h, 045h, 01Ch, 007h, 059h, 066h
DB 058h, 0C3h, 0BDh, 000h, 00Eh, 0BEh, 068h, 00Fh, 0B6h, 008h, 0B2h, 01Dh, 0A0h, 037h, 00Dh, 02Ch
DB 029h, 0B7h, 031h, 00Fh, 0B6h, 00Eh, 07Bh, 00Fh, 051h, 083h, 03Ch, 000h, 075h, 033h, 03Eh, 088h
DB 076h, 000h, 03Eh, 080h, 046h, 000h, 029h, 0B9h, 013h, 000h, 08Ah, 01Eh, 078h, 00Fh, 03Ah, 0F0h
DB 075h, 01Ah, 08Ah, 01Eh, 079h, 00Fh, 055h, 0B9h, 003h, 000h, 083h, 0C5h, 003h, 041h, 083h, 0F9h
DB 013h, 074h, 008h, 045h, 03Eh, 080h, 07Eh, 000h, 000h, 075h, 0F2h, 05Dh, 0E8h, 04Ch, 0FEh, 0FEh
DB 0C6h, 083h, 0C5h, 013h, 0FEh, 0C7h, 083h, 0C6h, 002h, 059h, 0E2h, 0BCh, 080h, 03Eh, 080h, 00Fh
DB 001h, 075h, 00Fh, 0FEh, 0C6h, 0B9h, 013h, 000h, 0BDh, 074h, 00Ch, 08Ah, 01Eh, 078h, 00Fh, 0E8h
DB 029h, 0FEh, 0C3h, 056h, 0C6h, 006h, 0FFh, 00Fh, 000h, 0B9h, 040h, 000h, 0BEh, 086h, 00Fh, 0BFh
DB 0BEh, 011h, 0F3h, 0A6h, 074h, 005h, 0C6h, 006h, 0FFh, 00Fh, 001h, 0BEh, 019h, 00Dh, 08Bh, 00Eh
DB 016h, 00Dh, 0BBh, 000h, 010h, 032h, 0F6h, 08Ah, 014h, 051h, 0B8h, 001h, 003h, 0B9h, 001h, 000h
DB 080h, 03Eh, 0FFh, 00Fh, 001h, 075h, 00Dh, 0CDh, 013h, 073h, 009h, 0BDh, 0C3h, 00Ch, 0B9h, 036h
DB 000h, 0E9h, 0FDh, 005h, 0C6h, 006h, 0FFh, 00Fh, 001h, 059h, 046h, 081h, 0C3h, 000h, 002h, 0E2h
DB 0D6h, 0B8h, 001h, 003h, 0BBh, 000h, 00Eh, 0B9h, 008h, 000h, 0BAh, 080h, 000h, 0CDh, 013h, 05Eh
DB 0C3h, 050h, 051h, 052h, 08Bh, 014h, 08Bh, 04Ch, 002h, 080h, 03Eh, 018h, 00Dh, 001h, 075h, 004h
DB 066h, 08Bh, 04Ch, 001h, 0BEh, 0BEh, 011h, 08Bh, 0C2h, 032h, 0E4h, 02Ch, 080h, 0C1h, 0E0h, 009h
DB 003h, 0F0h, 080h, 03Eh, 018h, 00Dh, 001h, 075h, 013h, 066h, 08Bh, 0C1h, 0B9h, 004h, 000h, 066h
DB 039h, 044h, 008h, 074h, 032h, 083h, 0C6h, 010h, 0E2h, 0F5h, 0EBh, 014h, 08Bh, 0C1h, 0B9h, 004h
DB 000h, 039h, 044h, 002h, 075h, 005h, 038h, 074h, 001h, 074h, 01Ch, 083h, 0C6h, 010h, 0E2h, 0F1h
DB 083h, 0EEh, 040h, 0B9h, 004h, 000h, 080h, 07Ch, 004h, 005h, 074h, 00Bh, 080h, 07Ch, 004h, 00Fh
DB 074h, 005h, 083h, 0C6h, 010h, 0E2h, 0EFh, 05Ah, 059h, 058h, 0C3h, 056h, 050h, 08Ch, 0C0h, 066h
DB 0C1h, 0E0h, 010h, 0B8h, 000h, 020h, 066h, 0A3h, 021h, 00Dh, 066h, 08Bh, 044h, 008h, 066h, 0A3h
DB 025h, 00Dh, 0BEh, 01Dh, 00Dh, 0B8h, 000h, 042h, 0CDh, 013h, 058h, 00Fh, 082h, 0FFh, 0FCh, 0BFh
DB 0FEh, 021h, 084h, 0C0h, 074h, 00Dh, 026h, 083h, 03Dh, 000h, 074h, 01Bh, 026h, 0C7h, 005h, 000h
DB 000h, 0EBh, 00Ch, 026h, 081h, 03Dh, 055h, 0AAh, 074h, 00Dh, 026h, 0C7h, 005h, 055h, 0AAh, 0BEh
DB 01Dh, 00Dh, 0B8h, 000h, 043h, 0CDh, 013h, 05Eh, 0C3h, 056h, 0BEh, 060h, 00Fh, 032h, 0E4h, 003h
DB 0F0h, 0ACh, 00Fh, 0B6h, 00Eh, 07Bh, 00Fh, 0D2h, 0C8h, 0BEh, 098h, 00Eh, 056h, 0E8h, 031h, 0FFh
DB 0D0h, 0D0h, 050h, 08Ah, 044h, 004h, 072h, 012h, 0E8h, 034h, 000h, 058h, 05Eh, 083h, 0C6h, 005h
DB 0E2h, 0EAh, 05Eh, 08Ah, 044h, 004h, 0E8h, 026h, 000h, 0C3h, 03Ch, 004h, 074h, 016h, 03Ch, 006h
DB 074h, 012h, 03Ch, 007h, 074h, 00Eh, 03Ch, 00Bh, 074h, 00Ah, 03Ch, 00Ch, 074h, 006h, 03Ch, 00Eh
DB 074h, 002h, 0EBh, 0D7h, 080h, 044h, 004h, 010h, 0B0h, 001h, 0E8h, 05Eh, 0FFh, 0EBh, 0CCh, 03Ch
DB 014h, 074h, 014h, 03Ch, 016h, 074h, 010h, 03Ch, 017h, 074h, 00Ch, 03Ch, 01Bh, 074h, 008h, 03Ch
DB 01Ch, 074h, 004h, 03Ch, 01Eh, 075h, 009h, 080h, 06Ch, 004h, 010h, 0B0h, 000h, 0E8h, 03Bh, 0FFh
DB 0C3h, 032h, 0E4h, 0A0h, 07Dh, 00Fh, 084h, 0C0h, 074h, 069h, 03Ch, 063h, 00Fh, 084h, 07Fh, 000h
DB 0E8h, 099h, 002h, 083h, 03Eh, 081h, 00Fh, 000h, 075h, 022h, 0B9h, 00Dh, 000h, 0BDh, 0F9h, 00Ch
DB 08Ah, 036h, 07Bh, 00Fh, 02Ah, 036h, 07Ch, 00Fh, 080h, 0C6h, 009h, 002h, 036h, 080h, 00Fh, 002h
DB 036h, 080h, 00Fh, 0B2h, 022h, 08Ah, 01Eh, 078h, 00Fh, 0E8h, 05Fh, 0FCh, 0B4h, 012h, 0F6h, 0E4h
DB 0E8h, 0A5h, 002h, 072h, 007h, 032h, 0E4h, 0A0h, 07Ah, 00Fh, 0EBh, 047h, 083h, 03Eh, 081h, 00Fh
DB 000h, 075h, 040h, 0BDh, 006h, 00Dh, 0B9h, 010h, 000h, 08Ah, 036h, 07Bh, 00Fh, 02Ah, 036h, 07Ch
DB 00Fh, 080h, 0C6h, 009h, 002h, 036h, 080h, 00Fh, 002h, 036h, 080h, 00Fh, 0B2h, 022h, 0E8h, 02Ah
DB 0FCh, 0EBh, 020h, 0C6h, 006h, 034h, 00Dh, 001h, 0E8h, 031h, 002h, 0B8h, 038h, 004h, 0E8h, 067h
DB 002h, 072h, 010h, 0E8h, 063h, 003h, 0EBh, 0EBh, 080h, 03Eh, 034h, 00Dh, 001h, 074h, 0E4h, 0B4h
DB 010h, 0CDh, 016h, 083h, 03Eh, 081h, 00Fh, 000h, 074h, 02Eh, 084h, 0C0h, 074h, 00Dh, 03Ch, 0E0h
DB 074h, 009h, 038h, 006h, 081h, 00Fh, 074h, 00Fh, 0E9h, 0D4h, 000h, 08Ah, 0C4h, 0B4h, 001h, 039h
DB 006h, 081h, 00Fh, 00Fh, 085h, 0C8h, 000h, 0C7h, 006h, 081h, 00Fh, 000h, 000h, 0E8h, 012h, 0FCh
DB 0E8h, 0DDh, 002h, 0E8h, 03Ch, 0FDh, 0EBh, 0C7h, 080h, 03Eh, 080h, 00Fh, 001h, 075h, 006h, 03Ch
DB 061h, 00Fh, 084h, 0B2h, 000h, 08Ah, 03Eh, 07Bh, 00Fh, 02Ah, 03Eh, 07Ch, 00Fh, 080h, 0C7h, 030h
DB 03Ch, 00Dh, 00Fh, 084h, 099h, 000h, 084h, 0C0h, 074h, 008h, 03Ch, 0E0h, 074h, 004h, 032h, 0E4h
DB 0EBh, 004h, 08Ah, 0C4h, 0B4h, 001h, 03Dh, 050h, 001h, 074h, 063h, 03Dh, 048h, 001h, 074h, 070h
DB 080h, 03Eh, 085h, 00Fh, 001h, 075h, 040h, 03Dh, 03Bh, 001h, 075h, 008h, 0B8h, 000h, 005h, 0CDh
DB 010h, 0E9h, 074h, 0FFh, 03Dh, 03Ch, 001h, 075h, 005h, 0B8h, 001h, 005h, 0EBh, 0F1h, 03Dh, 03Dh
DB 001h, 075h, 00Ch, 0A0h, 078h, 00Fh, 0FEh, 0C0h, 024h, 07Fh, 0A2h, 078h, 00Fh, 0EBh, 00Fh, 03Dh
DB 03Eh, 001h, 075h, 013h, 0A0h, 079h, 00Fh, 0FEh, 0C0h, 024h, 07Fh, 0A2h, 079h, 00Fh, 0E8h, 05Fh
DB 002h, 0E8h, 0BEh, 0FCh, 0E9h, 041h, 0FFh, 0E8h, 03Eh, 000h, 073h, 039h, 03Ah, 0C7h, 00Fh, 087h
DB 036h, 0FFh, 03Ch, 031h, 073h, 003h, 0E9h, 02Fh, 0FFh, 0E8h, 04Ah, 000h, 0EBh, 027h, 038h, 03Eh
DB 037h, 00Dh, 00Fh, 084h, 022h, 0FFh, 0FEh, 006h, 037h, 00Dh, 0E8h, 095h, 0FCh, 0E9h, 018h, 0FFh
DB 080h, 03Eh, 037h, 00Dh, 031h, 00Fh, 084h, 00Fh, 0FFh, 0FEh, 00Eh, 037h, 00Dh, 0EBh, 0EBh, 0A0h
DB 037h, 00Dh, 0E8h, 021h, 000h, 02Ch, 031h, 0C3h, 032h, 0C9h, 0BEh, 068h, 00Fh, 039h, 004h, 075h
DB 006h, 08Ah, 0C1h, 004h, 031h, 0EBh, 00Dh, 0FEh, 0C1h, 083h, 0C6h, 002h, 03Ah, 00Eh, 07Bh, 00Fh
DB 072h, 0EBh, 0F9h, 0C3h, 0F8h, 0C3h, 080h, 03Eh, 07Eh, 00Fh, 001h, 075h, 003h, 0A2h, 07Ah, 00Fh
DB 00Fh, 0B6h, 00Eh, 07Bh, 00Fh, 051h, 0B4h, 031h, 0BEh, 068h, 00Fh, 083h, 03Ch, 000h, 075h, 006h
DB 03Ah, 0E0h, 074h, 007h, 0FEh, 0C4h, 083h, 0C6h, 002h, 0E2h, 0F0h, 05Bh, 02Ah, 0CBh, 0F6h, 0D9h
DB 08Ah, 0C1h, 004h, 031h, 0C3h, 083h, 03Eh, 081h, 00Fh, 000h, 074h, 001h, 0C3h, 050h, 0BFh, 0C0h
DB 00Eh, 032h, 0E4h, 0C0h, 0E0h, 004h, 003h, 0F8h, 080h, 03Dh, 000h, 074h, 049h, 0E8h, 0B0h, 001h
DB 0B6h, 006h, 0B2h, 01Dh, 0E8h, 091h, 0FBh, 0BDh, 087h, 00Ch, 0B9h, 018h, 000h, 08Ah, 01Eh, 078h
DB 00Fh, 0E8h, 097h, 0FAh, 0B9h, 003h, 000h, 051h, 0FEh, 0C6h, 0E8h, 02Bh, 000h, 0B9h, 010h, 000h
DB 0BEh, 040h, 00Fh, 057h, 0F3h, 0A6h, 05Fh, 059h, 074h, 01Ch, 051h, 0BDh, 09Fh, 00Ch, 0FEh, 0CEh
DB 0B9h, 00Fh, 000h, 0E8h, 075h, 0FAh, 059h, 0E2h, 0DEh, 0FEh, 0C6h, 0BDh, 0AEh, 00Ch, 0B9h, 015h
DB 000h, 0E8h, 067h, 0FAh, 0EBh, 0FEh, 058h, 0C3h, 057h, 0B2h, 01Dh, 0E8h, 04Ah, 0FBh, 0BDh, 006h
DB 00Dh, 0B9h, 010h, 000h, 0E8h, 054h, 0FAh, 0BFh, 040h, 00Fh, 032h, 0C0h, 0F3h, 0AAh, 083h, 0EFh
DB 010h, 0B9h, 010h, 000h, 032h, 0E4h, 0CDh, 016h, 03Ch, 00Dh, 074h, 011h, 03Ch, 020h, 072h, 0F4h
DB 088h, 005h, 0B4h, 00Eh, 0B0h, 02Ah, 0B7h, 001h, 0CDh, 010h, 047h, 0E2h, 0E7h, 0B2h, 01Dh, 05Fh
DB 0C3h, 0E8h, 05Dh, 0FCh, 080h, 07Ch, 004h, 005h, 074h, 016h, 080h, 07Ch, 004h, 00Fh, 074h, 010h
DB 080h, 03Ch, 080h, 075h, 005h, 080h, 0FAh, 080h, 074h, 006h, 0E8h, 004h, 000h, 0C6h, 004h, 080h
DB 0C3h, 056h, 0BEh, 0BEh, 011h, 08Ah, 0CAh, 080h, 0E9h, 080h, 0C1h, 0E1h, 009h, 003h, 0F1h, 0B9h
DB 004h, 000h, 0C6h, 004h, 000h, 083h, 0C6h, 010h, 0E2h, 0F8h, 05Eh, 0C3h, 01Eh, 050h, 033h, 0C0h
DB 08Eh, 0D8h, 0FAh, 0A1h, 070h, 000h, 02Eh, 0A3h, 030h, 00Dh, 0A1h, 072h, 000h, 02Eh, 0A3h, 032h
DB 00Dh, 0C7h, 006h, 070h, 000h, 0EFh, 007h, 08Ch, 00Eh, 072h, 000h, 0FBh, 058h, 01Fh, 0C3h, 01Eh
DB 050h, 033h, 0C0h, 08Eh, 0D8h, 0FAh, 02Eh, 0A1h, 030h, 00Dh, 0A3h, 070h, 000h, 02Eh, 0A1h, 032h
DB 00Dh, 0A3h, 072h, 000h, 0FBh, 058h, 01Fh, 0C3h, 0FAh, 0A3h, 02Eh, 00Dh, 0C6h, 006h, 02Dh, 00Dh
DB 000h, 0FBh, 083h, 03Eh, 081h, 00Fh, 000h, 075h, 01Ch, 080h, 03Eh, 07Dh, 00Fh, 000h, 074h, 015h
DB 080h, 03Eh, 034h, 00Dh, 001h, 074h, 00Eh, 0A1h, 02Eh, 00Dh, 0B7h, 012h, 0F6h, 0F7h, 004h, 001h
DB 032h, 0E4h, 0E8h, 04Eh, 000h, 0B4h, 011h, 0CDh, 016h, 075h, 00Dh, 0F6h, 006h, 02Dh, 00Dh, 001h
DB 074h, 0D0h, 0E8h, 0AAh, 0FFh, 0F8h, 0EBh, 008h, 0E8h, 0A4h, 0FFh, 0B4h, 010h, 0CDh, 016h, 0F9h
DB 09Ch, 083h, 03Eh, 081h, 00Fh, 000h, 075h, 015h, 080h, 03Eh, 07Dh, 00Fh, 000h, 074h, 00Eh, 080h
DB 03Eh, 034h, 00Dh, 001h, 074h, 007h, 050h, 033h, 0C0h, 0E8h, 017h, 000h, 058h, 09Dh, 0C3h, 09Ch
DB 02Eh, 0FFh, 00Eh, 02Eh, 00Dh, 075h, 006h, 02Eh, 0C6h, 006h, 02Dh, 00Dh, 0FFh, 09Dh, 02Eh, 0FFh
DB 02Eh, 030h, 00Dh, 053h, 050h, 08Ah, 036h, 07Bh, 00Fh, 02Ah, 036h, 07Ch, 00Fh, 080h, 0C6h, 009h
DB 002h, 036h, 080h, 00Fh, 002h, 036h, 080h, 00Fh, 0B2h, 02Dh, 0E8h, 00Bh, 0FAh, 058h, 0B3h, 00Ah
DB 0F6h, 0F3h, 086h, 0E0h, 080h, 0C4h, 030h, 004h, 030h, 080h, 0FCh, 030h, 075h, 002h, 0B4h, 020h
DB 050h, 08Ah, 0C4h, 0B4h, 00Eh, 0B7h, 001h, 0CDh, 010h, 058h, 0B4h, 00Eh, 0CDh, 010h, 05Bh, 0C3h
DB 0BDh, 000h, 00Ch, 0B9h, 01Dh, 000h, 0B6h, 005h, 0B2h, 01Bh, 08Ah, 01Eh, 078h, 00Fh, 0E8h, 0EAh
DB 0F8h, 0BDh, 01Dh, 00Ch, 0FEh, 0C6h, 0E8h, 0E2h, 0F8h, 0FEh, 0C6h, 032h, 0EDh, 08Ah, 00Eh, 07Bh
DB 00Fh, 02Ah, 00Eh, 07Ch, 00Fh, 083h, 0C1h, 003h, 002h, 00Eh, 080h, 00Fh, 002h, 00Eh, 080h, 00Fh
DB 0BDh, 03Ah, 00Ch, 051h, 0B9h, 01Dh, 000h, 0E8h, 0C1h, 0F8h, 059h, 0FEh, 0C6h, 0E2h, 0F4h, 0B9h
DB 01Dh, 000h, 0BDh, 057h, 00Ch, 0E8h, 0B3h, 0F8h, 0C3h, 0B8h, 002h, 005h, 0CDh, 010h, 0B8h, 000h
DB 006h, 0B7h, 007h, 033h, 0C9h, 0BAh, 04Fh, 024h, 0CDh, 010h, 0B8h, 001h, 013h, 0B7h, 002h, 0B3h
DB 007h, 0B9h, 014h, 000h, 0B6h, 00Ch, 0B2h, 03Eh, 0BDh, 038h, 00Dh, 0CDh, 010h, 0B8h, 001h, 013h
DB 0B7h, 002h, 0B3h, 007h, 0B9h, 010h, 000h, 0B6h, 00Dh, 0B2h, 040h, 0BDh, 04Ch, 00Dh, 0CDh, 010h
DB 0BAh, 0DAh, 003h, 0ECh, 0BAh, 0D4h, 003h, 0B0h, 00Dh, 0EEh, 042h, 0B0h, 01Eh, 0EEh, 0B9h, 008h
DB 000h, 0BAh, 0C0h, 003h, 0B0h, 033h, 0EEh, 0A0h, 035h, 00Dh, 0EEh, 0FEh, 006h, 035h, 00Dh, 074h
DB 045h, 0E2h, 0EEh, 0C6h, 006h, 035h, 00Dh, 000h, 0BAh, 0D5h, 003h, 0A0h, 036h, 00Dh, 03Ch, 03Bh
DB 074h, 010h, 03Ch, 002h, 077h, 016h, 0C6h, 006h, 0DCh, 008h, 006h, 0C6h, 006h, 00Dh, 009h, 0C0h
DB 0EBh, 00Ah, 0C6h, 006h, 0DCh, 008h, 00Eh, 0C6h, 006h, 00Dh, 009h, 0C8h, 0FEh, 0C0h, 0A2h, 036h
DB 00Dh, 0E8h, 02Bh, 000h, 0EEh, 0BAh, 0C0h, 003h, 0B0h, 033h, 0EEh, 0B0h, 008h, 0EEh, 0B4h, 001h
DB 0CDh, 016h, 075h, 002h, 0EBh, 0A8h, 0BAh, 0C0h, 003h, 0B0h, 033h, 0EEh, 0B0h, 008h, 0EEh, 0BAh
DB 0D5h, 003h, 032h, 0C0h, 0EEh, 0B8h, 001h, 005h, 0CDh, 010h, 033h, 0C0h, 0CDh, 016h, 0C3h, 050h
DB 052h, 0BAh, 0DAh, 003h, 0ECh, 0A8h, 008h, 075h, 0F8h, 0ECh, 0A8h, 008h, 074h, 0FBh, 05Ah, 058h
DB 0C3h, 0BAh, 000h, 018h, 0B3h, 007h, 0E8h, 0E2h, 0F7h, 0EBh, 0FEh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh
DB 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh, 0FFh

;------ loader strings

nagyd		db	'ษออออ MasterBooter ', versiostr2, ' ออออป'
message		db	'บ      Choose a system:     บ'
windowwall	db	'บ                           บ'
windowbottom	db	'ศอออออออออออออออออออออออออออผ'
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



;----------------------------

H_help1		db	'MasterBooter is a boot manager. This utility examines your system and prints',0dh,0ah
		db	'some information about all installed operating systems. You can see the result',0dh,0ah
		db	'in the ',39,'Available partitions',39,' window. By moving the cursor block and pressing',0dh,0ah
		db	'ENTER, you can select the operating systems you want to include in the boot',0dh,0ah
		db	'menu, which will appear when you reboot your computer.',0dh,0ah,0dh,0ah
		db	'Available keys:',0dh,0ah
		db	'F1      - This help text',0dh,0ah
		db	'UP/DOWN - Move the block cursor',0dh,0ah
		db	'ENTER   - Select the system',0dh,0ah
		db	'DEL     - Deselect the last system from the ',39,'Selected partitions',39,' window',0dh,0ah
		db	'F10     - Proceed to the next window, where you can customize your menu',0dh,0ah
		db	'ESC     - quit MasterBooter$'

H_help2		db	'In this window, you can customize your boot menu by setting various parameters.',0dh,0ah
		db	'These parameters are:',0dh,0ah,0dh,0ah
		db	'System names     - Every system can have a name up to 16 characters.',0dh,0ah
		db	'System passwords - Every system can have a password up to 16 characters.',0dh,0ah
		db	'Protection       - It is possible to hide the partitions from the boot menu.',0dh,0ah
		db	'                   These hidden systems can be booted only with a special key',0dh,0ah
		db	'                   combination you can set here.',0dh,0ah
		db	'FAT/NTFS hiding  - This entry is a row of 1 and 0 characters. Every character',0dh,0ah
		db	'                   represents a system, the first the first system, the second',0dh,0ah
		db	'                   the second system and so on. Write 1 if you want to hide a',0dh,0ah
		db	'                   system from the actual system, 0 if you don',39,'t.',0dh,0ah
		db	'                   Note that this is effective only to FAT/NTFS partitions.',0dh,0ah
		db	'Delay Time       - The number of seconds (1-98) the menu waits for a keystroke.',0dh,0ah
		db	'                   Setting this value to 0 or 99 causes an infinite delay.',0dh,0ah
		db	'                   If you use 0, a screensaver will appear after 60 seconds.',0dh,0ah
		db	'Default System   - This value shows which system will start if the delay',0dh,0ah
		db	'                   reaches zero. Set this value 0 to default to the last',0dh,0ah
		db	'                   booted system.',0dh,0ah
		db	'Audible menu     - Indicates if there is a beep when the boot menu appears.',0dh,0ah
		db	'Master Password  - Others cannot alter your settings if you set this.',0dh,0ah
		db	'Hide boot menu   - Shows the menu only if a special key combination is pressed.',0dh,0ah
		db	'Enable floppy    - Shows the floppy boot option in the boot menu.$'

H_qhelp		db	'Press any key to exit help.$'

actualpart	db	0		; actual partition (row)
numosystems	db	0
targetdisk	db	0		; target disk to intsall to
filename	db	'mrbparam.bin$'

S_notinstalled	db	'Error: MasterBooter is not installed yet$'

S_macrow	db	0dh,0ah,'macro.mrb has been written successfully.$'

include strings.inc

S_ontrack	db	'Ontrack Disk Manager'
S_ezbios	db	'EZ-BIOS'
S_LILO		db	'LILO'
S_aborting	db	' has been found, aborting...$'

S_sure1		db	'Are you sure to save these settings?$'
S_sure2		db	'Press Y to save the changes, any other key to go back.$'

S_installed1	db	'MasterBooter has been successfully installed.$'
S_installed2	db	'Press ESC to quit to DOS, any other key to reboot.$'
S_installed22	db	'Press any key to quit, then shut down Windows and reboot.$'

S_badsetting	db	'The default system cannot be protected! Press any key...$'

S_entermaster	db	'Enter master password to continue: $'
S_badmaster	db	0dh,0ah,'Invalid master password, aborting...$'
S_tryagain	db	'Invalid password, try again: $'

S_thanks	db	'MasterBooter ',versiostr2, ' ', copyright,0dh,0ah
		db	'Thank You for using MasterBooter!$'

S_ON		db	'YES$'
S_OFF		db	'NO $'

macroptr	dw	0
macrofile	db	'macro.mrb',0
macrohandle	dw	0
public macro?
macro?		db	0
installed?	db	0
insregged?	db	0

regged?		dw	0

maxlen		db	0
strlen		db	0
passwd?		db	0
passq?		db	0
maxnuma		db	0

mainextoff	dd	0
extoffset	dd	0
extbuffer	dw	0
bootbuffer	dw	0

ascnum		db	8 dup (0), '$'

;-------- File systems ---------

T_nopart	db	0
notypes		equ	1

T_FStypes	db	1,4,6,7,0ah,0bh,0ch,0eh,12h
		db	14h,16h,17h,1bh,1ch,1eh
		db	38h,4fh,63h,82h,83h,0a5h,0ebh	; 22

Ptypes		equ	22

T_FSbase	dw	offset fat12,offset fat16,offset bigdos,offset hpfs
		dw	offset os2bm,offset fat32,offset fat32x,offset bigdosx
		dw	offset compaq,offset hfat16,offset hbigdos,offset hhpfs
		dw	offset hfat32,offset hfat32x,offset hbigdosx
		dw	offset theos,offset oberon,offset hurd,offset solfs
		dw	offset ext2fs,offset bsd,offset befs

fat12		db	'FAT12$'		; 01h	 - DOSes
fat16		db	'FAT16$'		; 04h	 - DOSes
bigdos		db	'BIGDOS$	'	; 06h    - DOSes, Win??, OS/2
hpfs		db	'HPFS/NTFS$'		; 07h	 - OS/2/NT
os2bm		db	'OS/2 BootManager$'	; 0Ah	 - OS/2 BM
fat32		db	'FAT32$'		; 0Bh    - Win
fat32x		db	'FAT32 LBA$'		; 0Ch    - Win
bigdosx		db	'BIGDOS LBA$'		; 0Eh    - Win
compaq		db	'Compaq Diagnostic$'	; 12h	 - Compaq Diag
hfat16		db	'Hidden FAT16$'		; 14h
hbigdos		db	'Hidden BIGDOS$'	; 16h
hhpfs		db	'Hidden HPFS/NTFS$'	; 17h
hfat32		db	'Hidden FAT32$'		; 1bh
hfat32x		db	'Hidden FAT32 LBA$'	; 1ch
hbigdosx	db	'Hidden BIGDOS LBA$'	; 1eh
theos		db	'Theos$'		; 38h	 - Theos
oberon		db	'Oberon$'		; 4fh	 - Oberon
hurd		db	'SysVFS$'		; 63h	 - SCO Unix / GNU HURD
solfs		db	'UFS$'			; 82h	 - Solaris / Linux swap
ext2fs		db	'Linux$'		; 83h	 - Linux
bsd		db	'UFS$'			; A5h	 - FreeBSD, NetBSD
befs		db	'BeFS$'			; EBh    - BeOS

;------- Operating Systems -------

msdos		db	'MS-DOS$'
ptsdos		db	'PTS-DOS$'
novelldos	db	'Novell DOS$'
ibmdos		db	'IBM DOS$'
opendos		db	'OpenDOS$'
drdos		db	'DR-DOS$'
os2		db	'OS/2 Warp$'
win95		db	'Windows95$'
win98		db	'Win98/Win2000$'
winnt		db	'WinNT/Win2000/WinXP$'
linux		db	'Linux$'
freebsd		db	'FreeBSD$'
gnuhurd		db	'SCO Unix / HURD$'
solaris		db	'Solaris x86$'
beos		db	'BeOS$'

S_unknown	db	'Unknown$'

;------ Boot sector signatures -------

msboot		db	'MSDO'		; MS-DOS
ptsboot		db	'PTSD'		; PTS-DOS
nwboot		db	'NWDO'		; Novell DOS
ibmboot		db	'IBM '		; IBM DOS
openboot	db	'OPEN'		; OpenDOS
drboot		db	'DRDO'		; Caldera DrDOS
os2boot		db	'OS2 '		; OS/2
ntboot		db	'NTFS'		; WinNT/Win2000/WinXP
win95boot	db	'MSWIN4.0'	; Win95		* not sure!
win98boot	db	'MSWIN4.1'	; OSR2		* not sure!


;----- Uncompatible strings -----

ontrack		db	'ONTRACK'
ezbios		db	'Micro H'
lilo		db	'LILO'

;----- Other -----

B_slots		db	0		; HD number
		dd	0		; sector of boot sector
		db	5 dup (0)	; 10 available slots
		db	5 dup (0)
		db	5 dup (0)
		db	5 dup (0)
		db	5 dup (0)
		db	5 dup (0)
		db	5 dup (0)
		db	5 dup (0)
		db	5 dup (0)


dataend		label
		ends

;=================================================================

_TEXT		segment	public
.386

ASSUME cs:_TEXT, ds:DataSegment


;======================== Local procedures ========================

installed	proc	near
;get installed params and systems, precopy to buffers for later analysis

		mov	installed?,0
		mov	insregged?,0

		mov	di,6
		mov	ax,versiostr
		cmp	es:[di],ax
		jne	@@notinstall

		mov	eax,'GERM'
		mov	di,2
		cmp	es:[di],eax
		jne	@@notreg
		mov	insregged?,1
		jmp	@@insq

@@notreg:	mov	eax,'AHSM'
		cmp	es:[di],eax
		jne	@@notinstall

@@insq:		mov	installed?,1


@@notinstall:	clc
		ret
		endp

;------------------------------------------------------------------

getdatasector	proc	near
;get settings from previous installation
		cmp	installed?,1
		jne	@@notinstl
		push	es
		push	ds
		pop	es
		lea	bx,MBR_data
		xor	dh,dh
		mov	dl,targetdisk
		add	dl,80h
		mov	cx,MBRsectors
		mov	ax,0201h
		int	13h
		pop	es

		mov	al,defchoi
		sub	al,30h
		mov	ah,31h
		movzx	cx,numoselected
		lea	si,B_scancodes
@@rds:		cmp	word ptr [si],0		; correct the defchoi
		jne	@@skdf			;  value for the installer
		dec	al
		jz	@@gotdok
@@skdf:		inc	ah
		add	si,2
		loop	@@rds
@@gotdok:	mov	defchoi,ah
		ret

@@notinstl:	push	es
		push	ds
		pop	es
		mov	cx,offset B_selparams-offset MBR_data
		xor	al,al			; clear data sector
		lea	di,B_selparams
		rep	stosb
		pop	es
		mov	defchoi,31h		; fill standard values
		mov	menucolor,17h
		mov	highcolor,3fh
		ret
		endp

;------------------------------------------------------------------

analyze		proc	near
;analyse partition tables, print info, fill slots

		movzx	ax,targetdisk
		mov	di,1beh
		lea	si,HDIDs
		add	si,ax
		mov	actualpart,0
		mov	cx,numodrives
		sub	cx,ax
		mov	numodrives,cx
@@analnextHD:	push	si
		mov	al,[si]
		mov	actualHD,al
		push	cx
		mov	cx,4			; 4 partitions per HD
@@analnextpar:	push	cx
		push	di

		lea	si,T_nopart
		mov	cx,notypes
		mov	al,es:[di+4]		; skip no OS holder types
@@skipnOS:	cmp	al,[si]
		je	@@emptypart
		inc	si
		loop	@@skipnOS

		lea	si,T_FStypes
		xor	cx,cx			; known types
		mov	al,es:[di+4]
@@checknFS:	cmp	al,[si]
		je	@@foundFSt
		inc	si
		inc	cx
		cmp	cx,Ptypes
		jb	@@checknFS

		cmp	al,5
		je	@@extended
		cmp	al,0fh
		je	@@extended

		lea	si,S_unknown
		jmp	@@prinfo

@@extended:	call	searchlogical
		jmp	@@emptypart

@@foundFSt:	lea	si,T_FSbase
		shl	cx,1
		add	si,cx
		mov	si,[si]

;SI - FS type
@@prinfo:	call	fillslot
		call	analBootSector		; DI - OS type
		call	prPartInfo
		mov	al,actualpart		; max 10 entries
		cmp	al,10
		jb	@@emptypart
		mov	numosystems,al
		pop	di			; stack fixup
		pop	cx
		pop	cx
		pop	si
		ret

@@emptypart:	pop	di
		pop	cx
		add	di,16
		loop	@@analnextpar
		pop	cx
		pop	si
		inc	si
		add	di,1c0h
		loop	@@analnextHD
		mov	al,actualpart
		mov	numosystems,al
		ret
		endp

;------------------------------------------------------------------

fillslot	proc	near
;OUT: EAX - size in MB
		push	si
		lea	si,B_slots
		mov	al,actualpart
		mov	ah,5
		mul	ah
		add	si,ax
		mov	al,actualHD
		sub	al,targetdisk
		mov	[si],al
		cmp	ebios?,1
		je	@@copyLBA

		mov	al,es:[di+1]
		mov	[si+1],al
		mov	ax,es:[di+2]
		mov	[si+2],ax
		jmp	@@qfill

@@copyLBA:	mov	eax,es:[di+8]
		mov	[si+1],eax
@@qfill:	mov	eax,es:[di+12]
		shr	eax,11
		pop	si
		ret
		endp

;------------------------------------------------------------------

searchlogical	proc	near
;ES:DI - pointer to main extended entry
		push	eax
		push	bx
		push	cx
		push	si
		push	di
		mov	eax,es:[di+8]		; get starting sector
		mov	mainextoff,eax
		mov	extoffset,eax
@@snl:		mov	bx,extbuffer
		call	getsectors		; load sector
		mov	di,bx
		add	di,1beh			; DI - first logical entry

		mov	cx,4
@@seeklinux:	cmp	byte ptr es:[di+4],83h		; search Linux
		je	short @@foundlogilin
		cmp	byte ptr es:[di+4],82h		; search Linux
		je	short @@foundlogilin
		cmp	byte ptr es:[di+4],7		; search HPFS
		je	short @@foundlogilin
@@notreallin:	add	di,16
		loop	@@seeklinux

@@seekagainex:	mov	cx,4
		mov	di,extbuffer
		add	di,1beh
@@fnemb:	cmp	byte ptr es:[di+4],5
		je	short @@embedded
		cmp	byte ptr es:[di+4],0fh
		je	short @@embedded
		add	di,16
		loop	@@fnemb
@@qflin:	pop	di
		pop	si
		pop	cx
		pop	bx
		pop	eax
		ret

@@foundlogilin:	mov	eax,extoffset
		add	es:[di+8],eax
		mov	bx,bootbuffer
		call	getsectors		; check if bootable Linux
		cmp	word ptr es:[bx+1feh],0aa55h
		jne	short @@notreallin
		cmp	dword ptr es:[bx+3],'SFTN' ; NTFS
		je	short @@notreallin
		cmp	byte ptr es:[di+4],7
		je	@@HPFS
		lea	si,ext2fs
		lea	bp,linux
		jmp	@@finallogi
@@HPFS:		lea	si,hpfs
		lea	bp,os2
@@finallogi:	call	fillslot
		call	prPartInfo
		jmp	@@seekagainex

@@embedded:	mov	eax,es:[di+8]
		add	eax,mainextoff
		mov	extoffset,eax
		mov	es:[di+8],eax
		jmp	@@snl

		endp



;------------------------------------------------------------------

analBootSector	proc	near
		push	eax
		push	bx
		push	si
		push	di
		mov	al,es:[di+4]

		cmp	al,0ah
		jne	@@notBM
		lea	bp,os2bm
		jmp	@@OSok

@@notBM:	cmp	al,12h
		jne	@@notcompaq
		lea	bp,compaq
		jmp	@@OSok

@@notcompaq:	cmp	al,38h
		jne	@@nottheos
		lea	bp,theos
		jmp	@@OSok

@@nottheos:	cmp	al,4fh
		jne	@@notoberon
		lea	bp,oberon
		jmp	@@OSok

@@notoberon:	cmp	al,63h
		jne	@@notsco
		lea	bp,gnuhurd
		jmp	@@OSok

@@notsco:	cmp	al,82h
		jne	@@notsolaris
		lea	bp,solaris
		jmp	@@OSok

@@notsolaris:	cmp	al,83h
		jne	@@notlinux
		lea	bp,linux
		jmp	@@OSok

@@notlinux:	cmp	al,0a5h
		jne	@@notfreeBSD
		lea	bp,freebsd
		jmp	@@OSok

@@notfreeBSD:	cmp	al,0ebh
		jne	@@notBeOS
		lea	bp,beos
		jmp	@@OSok

@@notBeOS:	cmp	al,1eh
		jbe	@@probabFAT		; if none and above
		lea	bp,S_unknown		;  type 1eh, then unknown
		jmp	@@OSok			;  else get boot sector

@@probabFAT:    mov     bx,bootbuffer
		call	getsectors		; load boot sector
		mov	di,bx
		add	di,3

		mov	cx,4
		lea	si,msboot
		call	cmpstr			; MS-DOS
		jnz	@@notms
		lea	bp,msdos
		jmp	@@OSok

@@notms:	mov	cx,4
		lea	si,ptsboot
		call	cmpstr			; PTS-DOS
		jnz	@@notpts
		lea	bp,ptsdos
		jmp	@@OSok

@@notpts:	lea	si,nwboot
		call	cmpstr			; Novell DOS
		jnz	@@notnw
		lea	bp,novelldos
		jmp	@@OSok

@@notnw:	lea	si,ibmboot
		call	cmpstr			; IBM DOS
		jnz	@@notibm
		lea	bp,ibmdos
		jmp	@@OSok

@@notibm:	lea	si,openboot
		call	cmpstr
		jnz	@@notopen		; Open DOS
		lea	bp,opendos
		jmp	@@OSok

@@notopen:	lea	si,drboot
		call	cmpstr
		jnz	@@notdr			; DR DOS
		lea	bp,drdos
		jmp	@@OSok

@@notdr:	lea	si,os2boot
		call	cmpstr
		jnz	@@notos2		; OS2
		lea	bp,os2
		jmp	@@OSok

@@notos2:	lea	si,ntboot
		call	cmpstr
		jnz	@@notnt			; NT
		lea	bp,winnt
		jmp	@@OSok

@@notnt:	mov	cx,8
		lea	si,win95boot
		call	cmpstr			; Win95
		jnz	@@notwin95
		lea	bp,win95
		jmp	@@OSok

@@notwin95:	lea	si,win98boot
		call	cmpstr			; OSR2/Win98
		jnz	@@not98
		lea	bp,win98
		jmp	@@OSok

@@not98:	lea	bp,S_unknown

@@OSok:		pop	di
		pop	si
		pop	bx
		pop	eax
		ret
		endp

;------------------------------------------------------------------

cmpstr		proc	near

		push	cx
		push	si
		push	di
		rep	cmpsb
		pop	di
		pop	si
		pop	cx
		ret
		endp

;--------------------- Print info about a partition -----------------------
prPartInfo	proc	near
;IN: EAX - size in MB
;    SI, BP - strings
;    ES:DI - partition entry

		mov	ebx,eax			; save size

		mov	dh,actualpart
		add	dh,4
		mov	dl,3
		call	gotoXY
		mov	ah,2
		mov	dl,actualHD
		sub	dl,4fh			; print HD number
		int	21h

		push	dx
		mov	dl,6
		call	gotoXY
		mov	dx,si			; print FS type
		mov	ah,9
		int	21h
		pop	dx

		push	dx
		mov	dl,26
		call	gotoXY
		mov	dx,bp
		mov	ah,9			; print OS type
		int	21h
		pop	dx

		mov	eax,ebx
		mov	dl,61			; print size
		call	gotoXY
		call	toascii

		mov	dl,64
		call	gotoXY			; label
		mov	bx,bootbuffer		; ES:BX -> boot sector (loaded)
		cmp	word ptr es:[bx+1feh],0aa55h
		jne	@novolume		; skip unformatted or invalid
		mov	al,es:[di+4]		; get type
		and	al,0efh
		cmp	al,6			; FAT
		je	@fat16vol
		cmp	al,0eh			; FATx
		je	@fat16vol
		cmp	al,0bh			; FAT32
		je	@fat32vol
		cmp	al,0ch			; FAT32x
		je	@fat32vol
		cmp	al,7			; NTFS
		jne	@novolume
		call	ntlabel
		jmp	@novolume

@fat16vol:	movzx	eax,word ptr es:[bx+22]	; sectors per FAT
		jmp	@@prlab
@fat32vol:	mov	eax,es:[bx+24h]		; sectors per FAT
@@prlab:	call	fatvolume

@novolume:	inc	actualpart
		ret
		endp

;----------------- Print FAT volume label ---------------------

fatvolume	proc
;IN: EAX - sectors per FAT
;    ES:DI -> partition entry
;    ES:BX -> boot sector

		shl	eax,1			; 2 FATs
		add	eax,es:[di+8]		; plus beginning sector
		movzx	ecx,word ptr es:[bx+0eh]
		add	eax,ecx			; plus reserved sectors
		mov	es:[di+8],eax
		call	getsectors		; get root directory
		jc	@@skipfatlab

		mov	cx,16			; scan 16 entries for label
@@searchlab:	mov	al,es:[bx+11]		; volume label?
		cmp	al,8
		je	@@lab
		cmp	al,28h
		je	@@lab
		add	bx,32
		loop	@@searchlab
		jmp	@@skipfatlab

@@lab:		mov	cx,11		; show max 11 chars from volume
@@fatvolc:	mov	al,es:[bx]
		cmp	al,' '
		jb	@@skipfatlab
		mov	dl,al
		mov	ah,2
		int	21h
		inc     bx
		loop	@@fatvolc

@@skipfatlab:	ret

                endp

;----------------- Print NTFS volume label ---------------------

ntlabel 	proc

		xor	eax,eax
		mov	al,es:[bx+0dh]		; get sec/clust
		mul	dword ptr es:[bx+30h]	; mul by MFT logical cluster
		add	eax,es:[di+8]		; add boot sector offset
		add	eax,6			; add VOLUME offset
		mov	es:[di+8],eax		; get VOLUME MFT entry
		call	getsectors
		jc	@@endntvol
		cmp	dword ptr es:[bx],'ELIF'; FILE? Bad if not...
		jne	@@endntvol

@@nextntv:	add	bx,150h			; ??? Guess...
		mov	cx,0b0h
		mov	al,60h			; scan for volume label ID
		mov	di,bx
		repnz	scasb
		jcxz	@@endntvol
		dec	di
		mov	cx,es:[di+10h]		; get volume name length
		shr	cx,1			; it's Unicode...
		test	cx,cx
		jz	@@endntvol		; jump if zero length
		add	di,word ptr es:[di+14h]
                cmp     cx,11
                jbe     @@nvolc
		mov	cx,11		; show only 11 chars from volume
@@nvolc:	mov	dx,es:[di]
		cmp	dl,' '
		jb	@@endntvol
		mov	ah,2
		int	21h
		add	di,2
		loop	@@nvolc
@@endntvol:	ret

		endp


;----------------------------------------------------------

select		proc
		push	es
		movzx	cx,numoselected		; check if all slot is full
		cmp	cx,8
		je	short @dontsel		; all is full, end

		push	ds
		pop	es
		mov	al,actualpart
		mov	ah,5
		mul	ah
		lea	si,B_slots
		add	si,ax			; SI - actual system params
		lea	di,B_selparams
		mov	cx,8
@exaalre:	push	cx
		mov	cx,5
		call	cmpstr
		pop	cx
		je	short @dontsel		; exit if already selected
		add	di,5
		loop	@exaalre

		mov	cx,7
		lea	di,B_selparams
@findempty:	cmp	byte ptr [di],0		; search for empty slot
		jz	short @foundempty
		add	di,5
		loop	@findempty		; if loop finishes, then the
						; 8th slot is free
@foundempty:	mov	cx,5
		rep	movsb			; copy params
		inc	numoselected

		mov	bl,actualpart		; we have to copy the entry
		add	bl,4
		mov	al,160			; to the 'selected' area
		mul	bl
		add	ax,10
		mov	si,ax			; SI - display address of entry
		movzx	cx,numoselected		; CX - slot number to use
		mov	bl,14
		add	bl,cl			; BL - Row number where to copy
		mov	al,160
		mul	bl
		add	ax,8
		mov	di,ax			; DI - address where to copy

		mov	ax,0b800h
		mov	es,ax
		mov	cx,73			; how many characters to copy
@copynext:	mov	al,es:[si]
		mov	es:[di],al
		inc	si
		inc	si
		inc	di
		inc	di
		loop	@copynext

@dontsel:	pop	es
		ret
		endp

;----------------------------------------------------------

deselect	proc
		lea	si,B_selparams+35
		mov	cx,8
@seekfordel:	cmp	byte ptr [si],0		; check if all are empty
		jne	@abledel		; then do nothing
		sub	si,5
		loop	@seekfordel
		jmp	@nodel

@abledel:	dec	numoselected
		mov	eax,0
		mov	[si],al			; clear actual selection slot
		mov	[si+1],eax
		mov	bl,14
		add	bl,cl
		mov	al,160
		mul	bl
		add	ax,10
		mov	di,ax			; clear that selected entry
		mov	cx,70			; from screen
		push	es
		mov	ax,0b800h
		mov	es,ax
		mov	ax,1b20h
		rep	stosw
		pop	es

@nodel:		ret
		endp

;------------------------------------------------------------------

makemenu	proc

;--- print imported data

		cmp	installed?,0
		jz	@@skpold
		movzx	cx,numoselected
		test	cx,cx
		jz	@@skpold
		lea	bp,B_names+3
		mov	bl,1bh
		mov	dx,0f05h
@@prolds:	push	cx
		mov	cx,16
@@gnonz:	cmp	byte ptr ds:[bp],0
		je	@@gnz
		inc	bp
		loop	@@gnonz
@@gnz:		sub	cx,16
		neg	cx
		sub	bp,cx
		call	printattr
		pop	cx
		add	bp,19
		inc	dh
		loop	@@prolds

@@skpold:	mov	actualpart,0
		xor	al,al
		call	highlight

@@chkkey:
		call    getkey8
		test	al,al			; check keystroke
		jnz	@@notfunc
		int	21h
		cmp	macro?,1
		jne	@@nomc1
		inc	bx
		mov	byte ptr fs:[bx],al
		inc	macroptr
@@nomc1:	mov	ah,al

@@notfunc:	cmp	ah,48h			; up
		jne	@@notup
		mov	al,-1
		call	highlight
		jmp	@@chkkey

@@notup:	cmp	ah,50h			; down
		jne	@@notdown
		mov	al,1
		call	highlight
		jmp	@@chkkey

@@notdown:	cmp	ah,44h			; F10
		jne	@@notF10
		cmp	numoselected,0
		jz	@@chkkey
		clc
		ret

@@notF10:	cmp	ah,3bh
		jne	@@notF1
		lea	dx,H_help1		; F1
                call    bighelp
		jmp	@@chkkey

@@notF1:	cmp	ah,53h			; DEL
		jne	@@notdel
		call	deselect
		jmp	@@chkkey

@@notdel:	cmp	al,0dh			; ENTER
		jne	@@notenter
		call	select
		jmp	@@chkkey

@@notenter:	cmp	al,1bh			; ESC
		jne	@@chkkey
		stc				; indicate ESC
		ret
		endp

;------------------------------------------------------------------

setupmenu	proc	near

		movzx	ax,numoselected
		mov	cx,ax
		lea	si,blockmatrix+14	; correct block length
@@corrmap:	mov	[si],ax			; of FAT hiding map field
		add	si,16
		loop	@@corrmap

@@setupag:	call	drawscreen2
		call	fillprevdata
		xor	ax,ax			; no movement
@@mblock:	call	moveblock

@@gk2:
		call	getkey8
		test	al,al			; get key
		jnz	short @@notfunc2
		int	21h
		cmp	macro?,1
		jne	@@nomc2
		inc	bx
		mov	byte ptr fs:[bx],al
		inc	macroptr
@@nomc2:	mov	ah,al

@@notfunc2:	cmp	ah,48h
		jne	short @@notup2
		mov	ah,-1			; up
		xor	al,al			; no side movement
		jmp	@@mblock

@@notup2:	cmp	ah,4bh
		jne	short @@notleft
		xor	ah,ah
		mov	al,-1			; left
		jmp	@@mblock

@@notleft:	cmp	ah,4dh
		jne	short @@notright
		xor	ah,ah
		mov	al,1			; right
		jmp	@@mblock

@@notright:	cmp	ah,50h
		jne	short @@notdown2
		mov	ah,1			; down
		xor	al,al
		jmp	@@mblock

@@notdown2:	cmp	al,0dh
		jne	short @@notenter2
		call	enterpressed		; ENTER
		lea	dx,helpline2
		call	printhelpline
		jmp	@@setupag

@@notenter2:	cmp	ah,44h
		jne	@@notF10_2		; F10
		call	checksettings
		jc	@@setupag
		ret

@@notF10_2:	cmp	ah,3bh
		jne	@@notF1_2
		lea	dx,H_help2		; F1
		call	bighelp
		jmp	@@gk2


@@notF1_2:	cmp	al,1bh
		jne	short @@notesc2
		stc
		ret

@@notesc2:	jmp	@@gk2

		ret
		endp

;------------------------------------------------------------------

bighelp		proc	near
		push	dx
		mov	ax,0501h
		int	10h			; set active page
		mov	ax,0600h
		mov	bh,7
		xor	cx,cx			; clear it
		mov	dx,174fh
		int	10h
		xor	dx,dx
		call	gotoXY
		pop	dx			; print help
		mov	ah,9
		int	21h
		mov	dx,1800h
		call	gotoXY
		lea	dx,H_qhelp
		int	21h
		xor	ax,ax			; wait for key
		int	16h
		mov	ax,0500h		; restore page
		int	10h
		ret
		endp

;------------------------------------------------------------------

fillprevdata	proc	near

;-- names --

		movzx	cx,numoselected
		mov	dx,0406h
		lea	bp,B_names+3
		mov	bl,1bh
@@prnnp:	push	cx
		mov	cx,16
@@nonae:	cmp	byte ptr ds:[bp],0
		je	short @@gtne
		inc	bp
		loop	@@nonae
@@gtne:		sub	cx,16
		neg	cx
		sub	bp,cx
		test	cx,cx
		jz	@@skippnam
		call	printattr		; print names
@@skippnam:	pop	cx
		add	bp,19
		inc	dh
		loop	@@prnnp

;-- passwords --

		movzx	cx,numoselected
		mov	dx,0418h
		lea	bp,B_passwd
@@prpp:		push	cx
		mov	cx,16
		call	gotoXY
@@noppr:	cmp	byte ptr ds:[bp],0
		je	short @@gpe
		inc	bp
		loop	@@noppr
@@gpe:		sub	cx,16
		neg	cx
		sub	bp,cx
		test	cx,cx
		jz	@@skipppas
		mov	ah,0ah			; print passwords
		mov	al,'*'
		xor	bh,bh
		int	10h
@@skipppas:	pop	cx
		add	bp,16
		inc	dh
		loop	@@prpp

;-- scancodes --

		movzx	cx,numoselected
		mov	dx,042ah
		lea	bp,B_scancodes
@@prsc:		push	dx
		call	gotoXY
		cmp	word ptr ds:[bp],0	; scancode not present?
		je	short @@protoff
		lea	dx,S_ON
		jmp	@@prscs
@@protoff:	lea	dx,S_OFF
@@prscs:	mov	ah,9			; print protection status
		int	21h
		pop	dx
		add	bp,2
		inc	dh
		loop	@@prsc

;-- FAT maps --

		movzx	cx,numoselected
		mov	dx,0436h
		lea	si,B_FATmap
		mov	ah,2
@@npfat:	push	cx
		push	dx
		call	gotoXY
		movzx	cx,numoselected
		mov	al,[si]
		ror	al,cl
@@nfbit:	mov	dl,'0'
		rol	al,1
		jnc	@@notfat1
		inc	dl
@@notfat1:	push	ax
		int	21h
		pop	ax
		loop	@@nfbit
		pop	dx
		pop	cx
		inc	dh
		inc	si
		loop	@@npfat

;--

		movzx	eax,delay
		mov	dx,delaypos		; print delay
		call	gotoXY
		call	toascii

;--

		cmp	lastboot?,1
		jne	@@vandef
		xor	eax,eax
		jmp	@@nodefc
@@vandef:	movzx	eax,defchoi
		sub	al,30h
@@nodefc:	mov	dx,defaultpos		; print default
		call	gotoXY
		call	toascii

;--

		mov	dx,floppypos
		call	gotoXY
		cmp	floppy?,1
		je	@@floppyon		; floppy status
		lea	dx,S_OFF
		jmp	short @@prflopp
@@floppyon:	lea	dx,S_ON
@@prflopp:	mov	ah,9
		int	21h

;--

		mov	dx,beeppos
		call	gotoXY
		cmp	beeper?,1
		je	@@beepon
		lea	dx,S_OFF
		jmp	short @@prbeep		; print beep status
@@beepon:	lea	dx,S_ON
@@prbeep:	mov	ah,9
		int	21h

;--

		mov	dx,hidemenupos
		call	gotoXY
		mov	ax,[hidemenu?+2]
		mov	hidemenu?,ax
		cmp	hidemenu?,0
		je	@@hideoff
		lea	dx,S_ON
		jmp	short @@prhide		; print hide menu status
@@hideoff:	lea	dx,S_OFF
@@prhide:	mov	ah,9
		int	21h

;--

		mov	dx,masterpos
		call	gotoXY
		lea	bp,B_masterpass
		mov	cx,16
@@noppr2:	cmp	byte ptr ds:[bp],0
		je	short @@gpe2
		inc	bp
		loop	@@noppr2
@@gpe2:		sub	cx,16
		neg	cx
		sub	bp,cx
		test	cx,cx
		jz	@@skippmas
		mov	ah,0ah			; print master password
		mov	al,'*'
		xor	bh,bh
		int	10h

@@skippmas:
		ret
		endp

;------------------------------------------------------------------

enterpressed	proc	near
		mov	dx,oldpos

		cmp	dx,delaypos
		jne	@@nodelset
		push	dx
		lea	dx,H_enterdelay
		call	printhelpline
		pop	dx
		mov	maxlen,2		; set delay time
		mov	maxnuma,'9'
		lea	si,dummy
		call	getnuma
                call    ascii2hex
		mov	delay,al
		ret

@@nodelset:	cmp	dx,defaultpos
		jne	@@nodefset
		push	dx
		lea	dx,H_enterdefault
		call	printhelpline		; set default system
		pop	dx
		mov	maxlen,1
		mov	al,numoselected
		add	al,30h
		mov	maxnuma,al
		lea	si,dummy
		call	getnuma
                call    ascii2hex
		test	al,al
		jne	@@notlastb
		mov	lastboot?,1
		ret
@@notlastb:	mov	lastboot?,0
		add	al,30h
		mov	defchoi,al
		ret


@@nodefset:	cmp	dx,hidemenupos
		jne	@@nohidemen
		push	dx
		lea	dx,S_enterscan
		call	putwindow		; set hide menu
		pop	dx
		call	gotoXY
		lea	si,hidemenu?
                call    @@scaga
		mov	ax,[si]
		mov	[hidemenu?+2],ax
		ret

@@nohidemen:	cmp	dx,floppypos
		jne	@@nofloppos
		call	gotoXY
		cmp	floppy?,1
		je	@@offflop		; set floppy shown status
		lea	dx,S_ON
		mov	floppy?,1
		jmp	@@yeahflopp
@@offflop:	lea	dx,S_OFF
		mov	floppy?,0
@@yeahflopp:	mov	ah,9
		int	21h
		ret

@@nofloppos:	cmp	dx,beeppos
		jne	@@nobeepset
		call	gotoXY
		cmp	beeper?,1
		je	@@offbeep
		lea	dx,S_ON
		mov	beeper?,1		; set beeper status
		jmp	@@yeahbeep
@@offbeep:	lea	dx,S_OFF
		mov	beeper?,0
@@yeahbeep:	mov	ah,9
		int	21h
		ret

@@nobeepset:	cmp	dx,masterpos
		jne	@@nomasterp
		push	dx
		lea	dx,H_entermpass
		call	printhelpline
		pop	dx
		mov	passwd?,1
		lea	si,B_masterpass		; set master password
		mov	maxlen,16
		call	query
		mov	passwd?,0
		ret

@@nomasterp:	cmp	dl,6
		jne	@@notname
		push	dx
		lea	dx,H_entername
		call	printhelpline		; set name
		pop	dx
		call	getname
		ret

@@notname:	cmp	dl,18h
		jne	@@notpass
		push	dx
		lea	dx,H_enterpasswd
		call	printhelpline		; set password
		pop	dx
		call	getpass
		ret

@@notpass:	cmp	dl,2ah
		jne	@@notscan
		push	dx
		lea	dx,S_enterscan
		call	putwindow
		pop	dx
		call	getscan			; get scan code
		ret

@@notscan:	cmp	dl,36h
		jne	@@notfatmap
		push	dx
		lea	dx,H_FAT
		call	printhelpline
		pop	dx
		call	getFATmap
		ret

@@notfatmap:	ret
		endp

;------------------------------------------------------------------

getname		proc	near
		sub	dh,4
		lea	si,B_names
		add	si,3
		mov	al,19
		mul	dh
		add	dh,4
		add	si,ax
		mov	maxlen,16
		call	query
		ret
		endp

;------------------------------------------------------------------

getpass		proc	near
		mov	passwd?,1
		sub	dh,4
		lea	si,B_passwd
		mov	al,16
		mul	dh
		add	dh,4
		add	si,ax
		mov	maxlen,16
		call	query
		mov	passwd?,0
		ret
		endp

;------------------------------------------------------------------

getscan		proc	near
		call	gotoXY
		movzx	ax,dh
		sub	al,4
		shl	al,1
		lea	si,B_scancodes
		add	si,ax

@@scaga:	call	getkey7
		cmp	al,'a'			; skip 'a', floppy reserves
		je	@@scaga
		mov	ah,'1'
		movzx	cx,numoselected
@@skscn:	cmp	al,ah
		je	@@scaga			; skip used numbers
		inc	ah
		loop	@@skscn
		cmp	al,0dh			; check if ENTER
		jne	short @@onscan
		xor	ax,ax
		mov	[si],ax
		mov	ah,9
		lea	dx,S_OFF
		int	21h
		ret

@@onscan:	xor	ah,ah
		test	al,al
		jz	short @@onem1		; jump if one more
		jmp	short @@stit1		; else save in AL

@@onem1:
		call    getkey7
		cmp	al,3bh			; Below F1?
		jb	@@oksp
		cmp	al,3eh			; Between F1 - F4?
		jbe	@@scaga
		cmp	al,48h
		je	@@scaga			; skip up arrow
		cmp	al,50h
		je	@@scaga			; skip down arrow
@@oksp:		mov	ah,1			; indicate special

@@stit1:	mov	[si],ax
		mov	ah,9
		lea	dx,S_ON
		int	21h
		ret
		endp

;------------------------------------------------------------------

getFATmap	proc	near
		lea	si,B_FATmap
		movzx	ax,dh
		sub	al,4
		add	si,ax
		push	si
		mov	al,numoselected
		mov	maxlen,al
		mov	maxnuma,'1'
		lea	si,dummy
		call	getnuma
		movzx	cx,numoselected
		xor	al,al
@@nextbit:	cmp	byte ptr [si],'1'
		je	@@stc
		clc
		jmp	@@rolal
@@stc:		stc
@@rolal:	rcl	al,1
		inc	si
		loop	@@nextbit
		pop	si
		mov	[si],al
		ret
		endp

;------------------------------------------------------------------


uncompat	proc	near

		lea	si,ontrack
		mov	di,3
		mov	cx,7
		rep	cmpsb
		jne	@@notontrack

		lea	dx,S_ontrack
		mov	ah,9
		int	21h
		jmp	@@uncomp

@@notontrack:	lea	si,ezbios
		mov	di,19ah
		mov	cx,7
		rep	cmpsb
		jne	@@notezb
		lea	dx,S_ezbios
		mov	ah,9
		int	21h
		jmp	@@uncomp

@@notezb:	lea	si,lilo
		mov	di,6
		mov	cx,4
		rep	cmpsb
		jne	@@notlilo
		lea	dx,S_LILO
		mov	ah,9
		int	21h
		jmp	@@uncomp

@@notlilo:
		jmp	@@compat

@@uncomp:	stc
		ret

@@compat:	clc
		ret
		endp

;----------------------------------------------------------

query		proc	near
;SI - buffer
;DX - beginning cursor pos
;'maxlen'

		push	ax
		push	bx
		push	cx
		push	dx
		push	si

		cmp	passq?,1
		je	@@skiptsh
		push	si
		movzx	cx,maxlen
@@ngch:		cmp	byte ptr [si],0
		je	@@gotstrend
		inc	si
		loop	@@ngch
@@gotstrend:	pop	si
		sub	cx,16
		neg	cx
@@skiptsh:	mov	strlen,cl
		add	si,cx			; SI - end of string
		add	dl,cl			; DX - end of string on screen
		mov	cx,1			; 1 character write
		xor	bx,bx			; video page 0
		call	showcursor
@@gnchar:	call	gotoXY

@@badchar:
		call    getkey8
		test	al,al
		jne	@@okqu
		int	21h
		cmp	macro?,1
		jne	@@nomc3
		inc	bx
		mov	byte ptr fs:[bx],al
		inc	macroptr
@@nomc3:	jmp	@@badchar

@@okqu:		cmp	al,0dh			; enter
		je	@@entpress
		cmp	al,8			; backspace
		je	@@bppress
		cmp	al,'$'			; skip '$'
		je	@@badchar
		cmp	al,20h
		jb	@@badchar
		mov	ah,strlen		; check if buffer is full
		cmp	ah,maxlen
		jz	@@badchar

		mov	[si],al
		inc	strlen
		inc	si
		inc	dl
		cmp	passwd?,1
		jne	@@notstar
		mov	al,'*'
@@notstar:	mov	ah,0ah
		int	10h		
		jmp	@@gnchar

@@bppress:	cmp	strlen,0
		jz	@@badchar
		dec	si
		dec	dl
		dec	strlen
		mov	byte ptr [si],0
		mov	ah,2
		int	10h
		mov	ah,0ah
		mov	al,20h
		int	10h
		jmp	@@badchar

@@entpress:	call	hidecursor
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		ret
		endp

;---------------------------------------------------------------

getkey8         proc    near
		mov	bx,macroptr
       		mov	ah,8
		int	21h
		cmp	macro?,1
		jne	@@dontmac1
		mov	byte ptr fs:[bx],al
		inc	macroptr
@@dontmac1:	ret
                endp
;---------------------------------------------------------------

getkey7         proc    near
		mov	bx,macroptr
       		mov	ah,7
		int	21h
		cmp	macro?,1
		jne	@@dontmac2
		mov	byte ptr fs:[bx],al
		inc	macroptr
@@dontmac2:	ret
                endp
                
;---------------------------------------------------------------
checksettings	proc	near
		movzx	cx,numoselected
		xor	al,al
		lea	si,B_scancodes
@@snsc:		cmp	word ptr [si],0
		je	@@skipsc
		inc	al
@@skipsc:	add	si,2
		loop	@@snsc
		mov	numoprotted,al
		cmp	al,numoselected
		je	@@badsetting

		cmp	lastboot?,1
		je	@@skipdchk

		movzx	ax,defchoi
		sub	al,31h
		shl	al,1
		lea	si,B_scancodes
		add	si,ax
		lodsw
		test	ax,ax
		jne	@@badsetting
@@skipdchk:	clc
		ret

@@badsetting:	lea	dx,S_badsetting
		call	putwindow
		xor	ax,ax
		int	16h
		stc
		ret
		endp

;---------------------------------------------------------------

getnuma		proc	near
;SI - buffer
;DX - beginning cursor pos
;maxlen
;maxnuma

		push	ax
		push	bx
		push	cx
		push	dx
		push	si

		mov	strlen,0
		call	showcursor
		call	gotoXY

		movzx	cx,maxlen
		xor	bh,bh
		mov	ah,0ah			; erase old content
		mov	al,' '
		int	10h

		mov	cx,1			; 1 char to write

@@gnchar2:	call	gotoXY

@@badchar2:
		call    getkey8
		test	al,al
		jne	short @@okqu2
		int	21h
		cmp	macro?,1
		jne	@@nomac5
		inc	bx
		mov	byte ptr fs:[bx],al
		inc	macroptr
@@nomac5:	jmp	@@badchar2

@@okqu2:	cmp	al,0dh			; enter
		je	@@entpress2
		cmp	al,8			; backspace
		je	@@bppress2
		cmp	al,30h
		jb	@@badchar2
		cmp	al,maxnuma
		ja	@@badchar2
		mov	ah,strlen		; check if buffer is full
		cmp	ah,maxlen
		jz	@@badchar2

		mov	[si],al
		inc	strlen
		inc	si
		mov	byte ptr [si],0
		inc	dl
		mov	ah,0ah
		int	10h		
		jmp	@@gnchar2

@@bppress2:	cmp	strlen,0
		jz	@@badchar2
		dec	si
		dec	dl
		dec	strlen
		mov	byte ptr [si],0
		mov	ah,2
		int	10h
		mov	ah,0ah
		mov	al,20h
		int	10h
		jmp	@@badchar2

@@entpress2:	cmp	strlen,0
		je	@@badchar2
		call	hidecursor
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		ret
		endp

;------------------------------------------------------------------

ascii2hex	proc	near
		push	bx
		push	cx
		push	dx
		push	si
		xor	ax,ax
		xor	bh,bh
		xor	dx,dx
		mov	cx,0ah
		lea	si,dummy
@@ndigit:	mov	bl,[si]
		mov	byte ptr [si],0
		inc	si
		cmp	bl,39h
		ja	@@convend
		sub	bl,30h
		jb	@@convend
		mul	cx
		add	ax,bx
		adc	dl,dh
		je	@@ndigit
@@convend:	pop	si
		pop	dx
		pop	cx
		pop	bx
		ret
		endp

;------------------------------------------------------------------

mastercheck	proc	near
		cmp	installed?,1
		jne	@@nomas
		lea	si,B_masterpass
		cmp	byte ptr [si],0
		je	@@nomas
		mov	cx,16
@@maslen:	lodsb
		test	al,al
		jz	@@endmaster
		loop	@@maslen
@@endmaster:	sub	cx,16
		neg	cx
		mov	bl,cl			; BL - master length
		lea	dx,S_entermaster
		mov	ah,9
		int	21h
		mov	ah,3
		xor	bh,bh			; get cursor pos for query
		int	10h
		mov	passwd?,1
		mov	maxlen,16
		lea	si,dummy
		mov	byte ptr [si],0
		call	query
		mov	passwd?,0
		cmp	bl,strlen		; same length ?
		jne	@@badmast
		movzx	cx,bl
		push	es
		push	ds
		pop	es
		lea	si,dummy
		lea	di,B_masterpass
		call	cmpstr
		pop	es
		je	@@nomas
@@badmast:	call	showcursor
		lea	dx,S_badmaster
		mov	ah,9
		int	21h
		stc
		ret

@@nomas:	clc
		ret
		endp

;------------------------------------------------------------------

areyousure	proc	near

		call	clearwindow
		mov	dx,0514h
		call	gotoXY
		mov	ah,9
		lea	dx,S_sure1
		int	21h
		mov	dx,060ch
		call	gotoXY
		mov	ah,9
		lea	dx,S_sure2
		int	21h
@@newgkey:
                call    getkey7
		and	al,0dfh
		cmp	al,'Y'
		je	@@okwrn
		cmp	al,'N'
		jne	@@newgkey
		stc
		ret

@@okwrn:	clc
		ret
		endp


;------------------------------------------------------------------

installedmsg	proc	near

		call	clearwindow
		mov	dx,0510h
		call	gotoXY
		mov	ah,9
		lea	dx,S_installed1
		int	21h
		cmp	Win95?,1
		jne	@@noqwin

		mov	dx,060ah
		call	gotoXY
		mov	ah,9
		lea	dx,S_installed22
		int	21h
		mov	ah,7
		int	21h
		jmp	@@back2dos

@@noqwin:	mov	dx,060eh
		call	gotoXY
		mov	ah,9
		lea	dx,S_installed2
		int	21h
		mov	ah,7
		int	21h
		cmp	al,1bh
		je	@@back2dos
		stc
		ret

@@back2dos:	clc
		ret
		endp

;------------------------------------------------------------------

correctdefault	proc	near

		mov	al,31h
		cmp	lastboot?,1
		je	@@lcdef

		movzx	cx,defchoi
		sub	cx,30h
		lea	si,B_scancodes
		mov	al,30h
@@rdsea:	cmp	word ptr [si],0
		jne	@@nind
		inc	al
@@nind:		add	si,2
		loop	@@rdsea
@@lcdef:	mov	defchoi,al
		ret
		endp

;------------------------------------------------------

;-------------------------------------------------------
macroon		proc	near
		cmp	macro?,1
		jne	@@macroquit

		mov	macroptr,0
		mov	ah,3ch
		xor	cx,cx
		lea	dx,macrofile	; open macrofile
		int	21h
		mov	macrohandle,ax
		mov	ah,48h		; allocate memory
		mov	bx,64		; for keystroke buffer
		int	21h
		mov	fs,ax

@@macroquit:	ret
		endp


;-------------------------------------------------------

macrowrite	proc	near
		push	ds
		push	fs
		mov	bx,macroptr
		mov	byte ptr fs:[bx],1bh
		mov	cx,bx
		inc	cx
		mov	ah,40h
		mov     bx,macrohandle
		pop	ds
		xor	dx,dx
		int	21h		; write macro
		pop	ds
		mov	ah,3eh
		int	21h		;close file
		push	es
		push	fs
		pop	es
		mov	ah,49h
		int	21h
		pop	es
        	ret
		endp

include common.inc


;=========================== Main Code ============================

start		proc	near

                cld

		call	ResizeMemory		; resize memory block
		call	CheckCPU		; check for 386+
		mov	ax,DataSegment
		mov	ds,ax
		mov	es,ax
                call    CheckNT			; don't run under NT
		call	DetectWin9x		; detect Win9x DOS box
		call	CheckEbios		; check if EBIOS available
		call	getnumodrives		; how many drives are there
		call	Allocate
        	mov	ax,numodrives
		mov	bx,200h
		mul	bx
		mov	bootbuffer,ax
		add	ax,200h
		mov	extbuffer,ax
		call	getMBRs
		jc	@quit2

		call	checkcmdline
		mov	al,targetdisk	; if we have a target disk
		test	al,al		; move all remaining MBRs to
		jz	@@skiptm	; the first place
		mov	cx,numodrives
		sub	cl,al		; CL -> number of remaining disks
		shl	ax,9
		mov	si,ax		; SI -> first needed MBR
		shl	cx,9
		xor	di,di
		push	ds
		push	es
		pop	ds
		rep	movsb
		pop	ds
@@skiptm:	call	uncompat
		jnc	@@copperp
		jmp	@quit2

;-- copy original partition table plus some more before to our loader --

@@copperp:	lea	si,loaderend
		mov	di,offset loaderend - offset loader
		mov	cx,offset origpart+4*16-loaderend
@copypart:	mov	al,es:[di]
		mov	[si],al
		inc	si
		inc	di
		loop	@copypart
;--
		call	installed
		jnc	short @@gds
		jmp	@quit2
@@gds:
		call	getdatasector
		call	mastercheck
		jc	@quit2

                cmp	byte ptr [B_commandline],0
		jz	@skipcmdline
		cmp	macro?,1		; macro?
		je	@skipcmdline

		cmp	insregged?,1
		je	@docmdline

		mov	ah,9                    ; not installed but
		lea	dx,S_notinstalled       ; there is a cmd :(
		int	21h
		stc
		jmp	@quit2
@docmdline:    	call	commandline
		jmp	@quit2

@skipcmdline:	call	checkVGA
		jc	short @quit2

@VGAok:
		call	macroon		; if we create a macro
		call	drawscreen1
		call	analyze
		call	makemenu	; create menu, C=1 if ESC pressed
		jc	short @quit
@notsure:
        	call	setupmenu	; setup menu, C=1 if ESC pressed
		jc	short @quit
		call	areyousure
		jc	short @notsure
		call	correctdefault
                cmp     macro?,1
                je      @@skipwr

		call	savemenu
        	call	installedmsg
		jnc	@quit

		mov	ax,40h
		mov	es,ax
		mov	di,72h
		mov	ax,1234h
		stosw				; warm reboot
		db	0eah
		dw	0h,0ffffh

@@skipwr:       call    macrowrite
@quit:		mov	ax,3
		int	10h
		lea	dx,S_thanks
		mov	ah,9
		int	21h
		cmp	macro?,1
		jne	@@donmesm
		mov	ah,9
		lea	dx,S_macrow
		int	21h
@@donmesm:
		clc
@quit2:		call	freemem
		mov	ax,4c00h
		adc	al,0
		int	21h

@errorquit:	mov	ax,4c01h
		int	21h

		endp
		ends
		end	start
