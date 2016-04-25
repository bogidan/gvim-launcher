
SOURCEDIR = .
SOURCES = $(wildcard $(SOURCEDIR)/*.nim)
BINARIES = $(SOURCES:.nim=.exe)
EXTRAS = nim.cfg

all: $(BINARIES)
	$(X)

%.exe: %.nim nim.cfg
	nim --out:$@ c $<


