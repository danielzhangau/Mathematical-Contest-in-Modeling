all:
	pdflatex main.tex
	bibtex main
	pdflatex main.tex
	pdflatex main.tex
clean:
        find . -name '*.pre' -type f -exec rm -rf {} \;
        find . -name '*.aux' -type f -exec rm -rf {} \;
        find . -name '*.bbl' -type f -exec rm -rf {} \;
        find . -name '*.blg' -type f -exec rm -rf {} \;
        find . -name '*.log' -type f -exec rm -rf {} \;
        find . -name '*.nav' -type f -exec rm -rf {} \;
        find . -name '*.out' -type f -exec rm -rf {} \;
        find . -name '*.snm' -type f -exec rm -rf {} \;
        find . -name '*.toc' -type f -exec rm -rf {} \;
        find . -name '*.vrb' -type f -exec rm -rf {} \;

