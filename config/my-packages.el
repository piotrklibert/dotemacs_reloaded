(require 'use-package)

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

;; Forks with their git repos urls:
;;
;; ac-slime origin  git@github.com:purcell/ac-slime.git
;; alchemist-mode origin  https://github.com/tonini/alchemist.el.git
;; auto-complete origin  https://github.com/auto-complete/auto-complete.git
;; dash origin  git@github.com:magnars/dash.el.git
;; direx-el origin  https://github.com/m2ym/direx-el.git
;; dylan-mode origin  https://github.com/dylan-lang/dylan-mode.git
;; elpy origin  https://github.com/jorgenschaefer/elpy
;; emacs-async origin  git@github.com:jwiegley/emacs-async.git
;; emacs-elixir origin  https://github.com/elixir-lang/emacs-elixir.git
;; emacs-helm-ag origin  https://github.com/syohex/emacs-helm-ag.git
;; emacs-jedi origin  https://github.com/tkf/emacs-jedi
;; emacs-jedi-direx origin  https://github.com/tkf/emacs-jedi-direx.git
;; emacs-neotree origin  https://github.com/jaypei/emacs-neotree.git
;; emacs-python-environment origin  https://github.com/tkf/emacs-python-environment.git
;; expand-region-el origin  git@github.com:magnars/expand-region.el.git
;; helm origin  git@github.com:emacs-helm/helm.git
;; hy-mode origin  git://github.com/hylang/hy-mode
;; j-mode origin  https://github.com/zellio/j-mode.git
;; lua-mode origin  https://github.com/immerrr/lua-mode
;; magit origin  git@github.com:magit/magit.git
;; mediawiki origin  https://github.com/hexmode/mediawiki-el.git
;; multiple-cursors origin  git@github.com:magnars/multiple-cursors.el.git
;; nim-mode origin  git@github.com:reactormonk/nim-mode.git
;; org-html-themes origin  git@github.com:fniessen/org-html-themes.git
;; pony-mode.git origin  https://github.com/davidmiller/pony-mode.git
;; popup-el.git origin  https://github.com/auto-complete/popup-el.git
;; powerline.git origin  https://github.com/milkypostman/powerline.git
;; pyvenv origin  https://github.com/jorgenschaefer/pyvenv.git
;; slime origin  git@github.com:slime/slime.git
;; snippets origin https://github.com/AndreaCrotti/yasnippet-snippets.git
;; swiper origin https://github.com/abo-abo/swiper.git
;; virtualenvwrapper origin https://github.com/porterjamesj/virtualenvwrapper.el.git
;; web-mode origin git@github.com:fxbois/web-mode.git
;; wrap-region origin https://github.com/rejeep/wrap-region.el.git
;; yasnippet origin https://github.com/capitaomorte/yasnippet.git

(provide 'my-packages)
