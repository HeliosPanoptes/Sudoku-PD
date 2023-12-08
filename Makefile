CC=pdc
SOURCE=Source/
OUTPUT=Sudoku-PD.pdx
SIMULATOR=$(PLAYDATE_SDK_PATH)/bin/Playdate\ Simulator.app

all: $(OUTPUT) run

sudoku: $(SOURCE)%.lua
	$(CC) $(SOURCE) Sudoku-PD.pdx

.PHONY: clean
clean:
	if [ -d $(OUTPUT) ]; then rm -rfv $(OUTPUT); fi;

.PHONY: run
run: $(OUTPUT)
	open -a $(SIMULATOR) $(OUTPUT)

