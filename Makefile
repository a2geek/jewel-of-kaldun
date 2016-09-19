# External dependencies:
include local.config

# Local stuff:
# > PGMS is a list of direct assembler targetrs
PGMS = jok.system.s
# > SRC is a list of all source files used to trigger a rebuild
SRC = $(PGMS)
SYS = JOK.SYSTEM
TYPE = SYS
ADDR = 0x2000
TMPL = template.po
APP = jewel-of-kaldun
DISK = $(APP).po
ZIP = $(APP).zip


jok: $(SRC)
	$(ASM) $(PGMS)
	cp $(TMPL) $(DISK)
	cat $(SYS) | $(AC) -p $(DISK) $(SYS) $(TYPE) $(ADDR)
	$(AC) -k $(DISK) $(SYS)
	$(AC) -ll $(DISK)
	zip $(ZIP) $(DISK)

clean:
	rm $(PGM) $(DISK) $(ZIP)
	rm *_Output.txt _FileInformation.txt
	rm $(SYS)

