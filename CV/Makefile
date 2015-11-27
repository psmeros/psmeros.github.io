FILE = psmerosCV
GARBAGE = $(FILE).log $(FILE).nav $(FILE).out $(FILE).toc $(FILE).vrb $(FILE).snm $(FILE).bbl $(FILE).lof $(FILE).bbl $(FILE).blg $(FILE).glo $(FILE).ist $(FILE).lot $(FILE).dvi $(FILE).ps *.aux


all: $(FILE).tex
	rm -f $(FILE).pdf $(GARBAGE)
	../etc/addContentCV.sh
	pdflatex $(FILE).tex
	evince $(FILE).pdf &
	rm -f $(GARBAGE)
	../etc/removeContentCV.sh


clean:
	rm -f $(FILE).pdf $(GARBAGE)


