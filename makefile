# Macros for building, deleting
#
# IMPRTANT: if you change anything in loader.asm, you must do a 'make loader', then copy-paste loader.inc into main.asm,
# at label loader
#

BORLAND=\borlandc\bin

AS=$(BORLAND)\tasm /m9 /q
# /zi

LINK=$(BORLAND)\tlink /x
# /v

RM=del

# Rule to build .obj from .asm

.asm.obj:
	$(AS) $*;

# Targets:

all: mrbooter efdisk mrescue dosfix ntfix

mrbooter: main.obj gui.obj diskio.obj memory.obj cmdline.obj
	$(LINK) gui diskio cmdline memory main, mrbooter.exe

efdisk: efdisk.obj
	$(LINK) efdisk.obj

mrescue: mrescue.obj
	$(LINK) /t mrescue.obj
dosfix: dosfix.obj
	$(LINK) /t dosfix.obj
ntfix: ntfix.obj
	$(LINK) /t ntfix.obj

loader:	loader.obj
	$(LINK) loader.obj
	exe2bin loader.exe loader.bin
	bin2asm loader.bin > loader.inc

# Clean up:

clean:
	del *.obj
	del dosfix.com
	del ntfix.com
	del mrescue.com
	del loader.exe
	del loader.bin
	del loader.inc
	del mrbooter.exe
	del efdisk.exe
