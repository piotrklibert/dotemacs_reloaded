(use-package tidy
  :commands (tidy-buffer))

;; (rx (0+ any) (group (or "yml" "yaml")) "'")
(use-package yaml-mode
  :mode ("\\(\\(?:y\\(?:a?ml\\)\\)\\)'" . yaml-mode))

(use-package rust-mode
  :mode ("\\.rs\\'" . rust-mode))

(use-package gitconfig-mode
  :mode ("\\.gitconfig\\'" . gitconfig-mode))

(use-package crontab-mode
  :mode ("\\.pl\\'" . crontab-mode))

(use-package clips-mode
  :mode ("\\.clp\\'" . clips-mode))

(use-package js2-mode
  :commands (js2-mode js2-minor-mode))

(use-package less-css-mode
  :mode ("\\.less\\'" . less-css-mode))

(use-package paredit
  :commands (paredit-mode))

(use-package paredit-menu
  :after (paredit))


(require 'ack-autoloads)
(require 'auto-indent-mode-autoloads)
(require 'buffer-stack-autoloads)
(require 'col-highlight-autoloads)
(require 'cm-mode-autoloads)
(require 'deferred-autoloads)
(require 'dired+-autoloads)
(require 'epoch-view-autoloads)
(require 'fic-ext-mode-autoloads)
(require 'fill-column-indicator-autoloads)
(require 'flymake-easy-autoloads)

(require 'flymake-jshint-autoloads)
(require 'flymake-python-pyflakes-autoloads)

(require 'fuzzy-autoloads)

(require 'highlight-autoloads)
(require 'highlight-indentation-autoloads)

(require 'hl-line+-autoloads)
(require 'ido-ubiquitous-autoloads)
(require 'idomenu-autoloads)
(require 'iedit-autoloads)
(require 'ipython-autoloads)


(require 'levenshtein-autoloads)
(require 'list-utils-autoloads)
(require 'logito-autoloads)
(require 'macrostep-autoloads)
(require 'nose-autoloads)

(require 'project-autoloads)
(require 'pyflakes-autoloads)
(require 'python-pylint-autoloads)
(require 'pylint-autoloads)
(require 'pymacs-autoloads)
(require 'pyvirtualenv-autoloads)
(require 'python-django-autoloads)

(require 'rainbow-delimiters-autoloads)
(require 'rainbow-mode-autoloads)

(require 'shell-here-autoloads)
(require 'sr-speedbar-autoloads)
(require 'unbound-autoloads)
(require 'undo-tree-autoloads)
(require 'xml-rpc-autoloads)
(require 'zencoding-mode-autoloads)

;; eshell-manual-autoloads
;; find-file-in-git-repo-autoloads
;; highline-autoloads
;; nurumacs-autoloads
;; hl-sexp-autoloads
;; idle-highlight-mode-autoloads
;; jira-autoloads
;; paredit-autoloads
;; paredit-everywhere-autoloads
;; paredit-menu-autoloads
;; pycomplete-autoloads
;; quack-autoloads
;; smex-autoloads
;; hl-sentence-autoloads
;; ido-load-library-autoloads



(require 'pcache)
(require 'persistent-soft)


(defconst plugins2-list
  (list 'ac-company
        'align-by-current-symbol
        'align-regexp
        'align-string
        'auto-mark
        ;; 'bm
        ;; 'bookmark+
        ;; 'bookmark+-1
        ;; 'bookmark+-1
        ;; 'bookmark+-bmu
        ;; 'bookmark+-chg
        ;; 'bookmark+-doc
        ;; 'bookmark+-key
        ;; 'bookmark+-lit
        ;; 'bookmark+-mac
        'browse-kill-ring
        'buffer-move
        'columnize
        'elscreen
        'etags-update
        'fixmee
        'fuzzy-find-in-project
        'git
        'git-blame
        'golden-ratio
        'help+
        'help-fns+
        'help-macro+
        'help-mode+
        'ido-vertical-mode
        'info+
        'iy-go-to-char
        'mark-lines
        'mo-git-blame
        'mysql
        'place-windows
        'powerline
        'relative-linum
        'revbufs
        'slurp
        'speedbar-extension
        'sticky-windows
        'sunrise-commander
        'sunrise-x-buttons
        'sunrise-x-checkpoints
        'sunrise-x-loop
        'sunrise-x-mirror
        'sunrise-x-modeline
        'sunrise-x-old-checkpoints
        'sunrise-x-popviewer
        'sunrise-x-tabs
        'sunrise-x-tree
        'synonyms
        'textobjects
        'thingatpt+
        'tiling
        'title-time
        'vc+
        'vc-
        'visible-mark
        'winring)
  "Modules which have their autoloads in plugins2-autoloads")

;; url = https://github.com/tkf/emacs-jedi
;; url = https://github.com/tonini/alchemist.el.git
;; url = git@github.com:magnars/expand-region.el.git
;; url = https://github.com/auto-complete/auto-complete.git
;; url = https://github.com/jorgenschaefer/elpy
;; url = https://github.com/AndreaCrotti/yasnippet-snippets.git
;; url = git@github.com:purcell/ac-slime.git
;; url = git@github.com:slime/slime.git
;; url = https://github.com/davidmiller/pony-mode.git
;; url = https://github.com/zellio/j-mode.git
;; url = https://github.com/dylan-lang/dylan-mode.git
;; url = https://github.com/syohex/emacs-helm-ag.git
;; url = git@github.com:reactormonk/nim-mode.git
;; url = https://github.com/porterjamesj/virtualenvwrapper.el.git
;; url = git@github.com:emacs-helm/helm.git
;; url = git@github.com:magit/magit.git
;; url = https://github.com/jaypei/emacs-neotree.git
;; url = git@github.com:fxbois/web-mode.git
;; url = https://github.com/elixir-lang/emacs-elixir.git
;; url = git@github.com:jwiegley/emacs-async.git
;; url = https://github.com/tkf/emacs-python-environment.git
;; url = https://github.com/hexmode/mediawiki-el.git
;; url = git@github.com:magnars/multiple-cursors.el.git
;; url = git@github.com:fniessen/org-html-themes.git
;; url = https://github.com/capitaomorte/yasnippet.git
;; url = https://github.com/auto-complete/popup-el.git
;; url = git@github.com:magnars/dash.el.git
;; url = https://github.com/tkf/emacs-jedi-direx.git
;; url = https://github.com/m2ym/direx-el.git
;; url = https://github.com/milkypostman/powerline.git
;; url = https://github.com/jorgenschaefer/pyvenv.git
;; url = git://github.com/hylang/hy-mode
;; url = https://github.com/auto-complete/popup-el.git
;; url = https://github.com/rejeep/wrap-region.el.git
;; url = https://github.com/immerrr/lua-mode
;; url = https://github.com/abo-abo/swiper.git



(provide 'my-packages)
