# External dependencies:
include local.config

# Local stuff:
# > PGMS is a list of direct assembler targetrs
PGMS = jok.system.s
# > SRC is a list of all source files used to trigger a rebuild
SRC = $(PGMS)
JOK_SYS = JOK.SYSTEM
JOK_PIC = JOK.TITLE.PIC
TMPL = template.po
APP = jewel-of-kaldun
DISK = $(APP).po
ZIP = $(APP).zip


jok: $(SRC)
	$(ASM) $(PGMS)
	cp $(TMPL) $(DISK)
	cat $(JOK_SYS).bin | $(AC) -p $(DISK) $(JOK_SYS) SYS 0x2000
	$(AC) -k $(DISK) $(JOK_SYS)
	cat $(JOK_PIC).bin | $(AC) -p $(DISK) $(JOK_PIC) BIN 0x2000
	$(AC) -k $(DISK) $(JOK_PIC)
	$(AC) -ll $(DISK)
	zip $(ZIP) $(DISK)

clean:
	rm $(PGM) $(DISK) $(ZIP)
	rm *_Output.txt _FileInformation.txt
	rm $(JOK_SYS).bin

