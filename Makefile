# External dependencies:
include local.config

# Local stuff:
# > PGMS is a list of direct assembler targetrs
PGMS = jok.system.s newgame.s
# > SRC is a list of all source files used to trigger a rebuild
SRC = $(PGMS) castle-level-1.s castle-level-2.s variables.s
JOK_SYS = JOK.SYSTEM
JOK_PIC = JOK.TITLE.PIC
NEWGAME = NEWGAME
TMPL = template.po
APP = jewel-of-kaldun
DISK = $(APP).po
ZIP = $(APP).zip


jok: $(SRC)
	$(ASM) jok.system.s
	$(ASM) newgame.s
	cp $(TMPL) $(DISK)
	cat $(JOK_SYS).bin | $(AC) -p $(DISK) $(JOK_SYS) SYS 0x2000
	$(AC) -k $(DISK) $(JOK_SYS)
	cat $(JOK_PIC).bin | $(AC) -p $(DISK) $(JOK_PIC) BIN 0x2000
	$(AC) -k $(DISK) $(JOK_PIC)
	cat $(NEWGAME).bin | $(AC) -p $(DISK) $(NEWGAME) BIN 0x1000
	$(AC) -k $(DISK) $(NEWGAME)
	$(AC) -ll $(DISK)
	zip $(ZIP) $(DISK)

clean:
	rm $(PGM) $(DISK) $(ZIP)
	rm *_Output.txt _FileInformation.txt
	rm $(JOK_SYS).bin

