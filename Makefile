# External dependencies:
include local.config

# Local stuff:
SRC = 
PGM = jok
SYS = jok.system
TYPE = SYS
ADDR = 0x2000
TMPL = template.po
DISK = jewel-of-kaldun.po


jok: $(SRC)
	$(ASM) $(PGM).s
	cp $(TMPL) $(DISK)
	cat $(PGM) | $(AC) -p $(DISK) $(SYS) $(TYPE) $(ADDR)
	$(AC) -k $(DISK) $(SYS)
	$(AC) -ll $(DISK)
	zip $(PGM).zip $(DISK)

clean:
	rm $(PGM) $(DISK) $(PGM).zip

