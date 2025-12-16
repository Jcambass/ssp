.PHONY: clean
.PHONY: build
.PHONY: run
.PHONY: copy
.PHONY: pd
.PHONY: love

SDK = $(shell egrep '^\s*SDKRoot' ~/.Playdate/config | head -n 1 | cut -c9-)
SDKBIN=$(SDK)/bin
GAME=$(notdir $(CURDIR))
SIM=Playdate Simulator


build: clean compile run

run: open

pd:
	lua build/playdate-release.lua
	pdc _pdx SSP.pdx
	open -a '$(SDKBIN)/$(SIM).app/Contents/MacOS/$(SIM)' SSP.pdx

love:
	lua build/love2d-release.lua
	love _love2d

clean:
	rm -rf '$(GAME).pdx'

compile:
	"$(SDKBIN)/pdc" 'Source' '$(GAME).pdx'

open:
	open -a '$(SDKBIN)/$(SIM).app/Contents/MacOS/$(SIM)' '$(GAME).pdx'

release: clean
	awk -F '=' '/buildNumber/{$$2=$$2+1""}1' OFS='=' Source/pdxinfo > pdxinfo.tmp
	mv pdxinfo.tmp Source/pdxinfo
	"$(SDKBIN)/pdc" 'Source' '$(GAME).pdx'
	[ ! -e '$(GAME).pdx.zip' ] || rm '$(GAME).pdx.zip'
	zip -r '$(GAME).pdx.zip' '$(GAME).pdx'
	git add .
	git commit -m "Release $(shell awk -F '=' '/buildNumber/{print $$2}' Source/pdxinfo)"
	git push
	open .