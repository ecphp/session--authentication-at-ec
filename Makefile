OUTPUT_DIRECTORY = build

build-pandoc-presentation :
	HOME=$(PWD)/build pandoc src/pandoc/presentation/*.md --verbose --pdf-engine=lualatex --from markdown --slide-level 2 --shift-heading-level=0 -s --to=beamer --template=beamer-theme-ec.latex -o pandoc-presentation.pdf

pandoc-watch:
	while true; do \
		make build-pandoc-presentation; \
		inotifywait --exclude '\.pdf|\.git' -qre close_write .; \
	done
