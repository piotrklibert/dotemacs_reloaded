#! /bin/env make


help:
	@echo "Lightcorn docs generation"
	@echo
	@echo 'Usage:'
	@echo '    make build - run docs generation inside Docker'
	@echo '    make edit  - run a dockerized Emacs and open flow.org in it'
	@echo
	@echo '    make local - run docs generation using local Emacs, no Docker'


build: emacs
	docker run --rm --volume $$(pwd):/lcdocs truststamp/emacs \
		ash -c "cd /lcdocs && make index.html && chown $$(id -u):$$(id -g) index.*"


.ONESHELL:
emacs:
	docker build -t truststamp/emacs -f emacs.dockerfile .


.ONESHELL:
index.html: flow.org lisp/*.el
	@if ! command -v emacs >/dev/null; then
		echo "Looks like you don't have EMACS installed!"
		echo "Please install it and/or make sure it's on your PATH and try again."
		exit 1
	fi
	@if [ ! -d "lisp/org-mode/" ]; then
		(cd lisp && git clone --depth 1 https://github.com/piotrklibert/org-mode.git)
		(cd lisp/org-mode && make autoloads)
	fi
	cd lisp && LC_ALL=en_GB.utf8 emacs -Q --batch -l batch-export.el

edit: emacs
	@docker run --rm --volume $$(pwd):/lcdocs -ti truststamp/emacs \
		emacs /lcdocs/flow.org

local: index.html;
