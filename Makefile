# External dependencies:
include local.config

# Local stuff:
# > SRC is a list of all source files used to trigger a rebuild
SRC = castle-level-1.s castles.s display.s filing.s graphics.s input.output.s jok.system.s \
      math.mac.s monsters.s noise.s prolib.mac.s reset.s story.s variables.s \
      castle-level-2.s convert.s endgame.s general.mac.s io.mac.s jewel.of.kaldun.s \
      main.control.s math.s newgame.s places.s prolib.s shapes.s title.s jewel.end.game.s \
      jok.segments.s
JOK_SYS = JOK.SYSTEM
JOK_PIC = JEWEL.TITLE.PIC
NEWGAME = NEWGAME
JOK_PGM = JEWEL.OF.KALDUN
JOK_END = JEWEL.END.GAME
TMPL = template.po
APP = jewel-of-kaldun
DISK = $(APP).po
ZIP = $(APP).zip


jok: $(SRC)
	$(ASM) jok.system.s
	$(ASM) newgame.s
	$(ASM) jok.segments.s
	cp $(TMPL) $(DISK)
	cat $(JOK_SYS).bin | $(AC) -p $(DISK) $(JOK_SYS) SYS 0x2000
	$(AC) -k $(DISK) $(JOK_SYS)
	cat $(JOK_PIC).bin | $(AC) -p $(DISK) $(JOK_PIC) BIN 0x2000
	$(AC) -k $(DISK) $(JOK_PIC)
	cat $(NEWGAME).bin | $(AC) -p $(DISK) $(NEWGAME) BIN 0x1000
	$(AC) -k $(DISK) $(NEWGAME)
	cat $(JOK_PGM).bin | $(AC) -p $(DISK) $(JOK_PGM) BIN 0x6000
	$(AC) -k $(DISK) $(JOK_PGM)
	cat $(JOK_END).bin | $(AC) -p $(DISK) $(JOK_END) BIN 0x0800
	$(AC) -k $(DISK) $(JOK_END)
	$(AC) -ll $(DISK)
	zip $(ZIP) $(DISK)

clean:
	rm $(PGM) $(DISK) $(ZIP)
	rm *_Output.txt _FileInformation.txt
	rm $(JOK_SYS).bin $(NEWGAME).bin $(JOK_PGM).bin $(JOK_END).bin

