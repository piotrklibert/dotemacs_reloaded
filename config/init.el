;; Basic look & feel customization, placed here so that Emacs looks good from the
;; start :)
(setf frame-title-format "Emacs starting..."
      inhibit-startup-message t         ; Don't show splash on startup
      load-prefer-newer t
      debug-on-error t
      fast-but-imprecise-scrolling t)

(tool-bar-mode   -1)
(scroll-bar-mode -1)
;; (fringe-mode     '(18 . 8))
(menu-bar-mode    -1)
(load-theme       'wombat)
(set-cursor-color "white")


;; Add the paths of plugins to load-path.
(add-to-list 'load-path "~/.emacs.d/config")
(add-to-list 'load-path "~/.emacs.d/config/lib")
(add-to-list 'load-path "~/.emacs.d/config/org")
(add-to-list 'load-path "~/.emacs.d/config/ui")

(add-to-list 'load-path "~/portless/org-mode/lisp")
(add-to-list 'load-path "~/portless/org-mode/contrib/lisp")


;; For semantic submodules, see doc-string of `semantic-default-submodes'
(require 'semantic)
(semantic-mode 1)                       ; Enable Semantic


(require 'my-packages-utils)            ; for `add-subdirs-to-path'

(add-subdirs-to-path
  "~/.emacs.d/elpa"
  "~/.emacs.d/forked-plugins"
  "~/.emacs.d/plugins2"
  "~/.emacs.d/plugins"
  "~/.emacs.d/pkg-langs")

(require 'use-package)
(setf use-package-verbose t)

(require 'anaphora)

(require 'my-utils)
(require 'my-system-config)

(load-safe "my-packages")


;; Font and modes configuration when running in graphical mode.
;;
;; Beware: Help At Pt group!

(defun my-set-default-font (&optional frame)
  (interactive)
  (cl-flet
      ((set-font (font-name) (set-face-attribute 'default nil :font font-name)))
    (set-font "DejaVu Sans Mono-14")))


(when window-system
  (mouse-wheel-mode t)
  (blink-cursor-mode -1)
  (add-hook 'after-make-frame-functions 'my-set-default-font)
  (my-set-default-font)
  ;; make setting default font available from keyboard if it somehow didn't run
  (global-set-key (kbd "C-<f10>") 'my-set-default-font))


;; Other basic editing settings.
;; TODO: move to `custom.el' and/or `my-generic-editing-config.el'
(setq-default indent-tabs-mode nil) ; DON'T use tabs for indenting, use spaces only
(setq-default tab-width 4)              ; Length of tab is 4 SPC
(setq-default indicate-empty-lines t)   ; Show empty lines
(setq tab-width 4)                      ; Make sure tab width is set!
(setq indent-line-function 'insert-tab) ; Set indent function to the default, because.
(setq sentence-end-double-space nil)    ; Sentences end with one space
(setq require-final-newline 't)         ; Always newline at end of file
(setq blink-matching-paren-distance nil) ; Blink parenthesis even if far

(setq next-line-add-newlines nil)       ; Don't add lines when <down> is pressed
                                        ; at the end of a file
;; defaults:
;; whitespace-line-column 80
;; diff-switches "-u"
(setq color-theme-is-global t)


(put 'dired-find-alternate-file 'disabled nil)
(put 'downcase-region 'disabled nil)

(add-to-list 'safe-local-variable-values '(whitespace-line-column . 80))

(setq ring-bell-function (lambda ()))   ; make Emacs shut up and *never* beep


;; schedule starting of Emacs server after everything else is loaded (5 min
;; *should* be enough for startup :))
(defun my-start-server ()
  (condition-case nil
      (cl-letf
          ;; TODO: use warning levels for this, see warnings.el
          (((symbol-function 'display-warning) #'identity))
        (server-start)
        (message "Server started!"))
    (t (message "Couldn't start the server!"))))

(run-at-time "1 min 30 sec" nil 'my-start-server)



;; import custom keymaps declarations, used by DEFINE-KEY in scripts.
(load-safe "my-keymaps-config")

;; Make pressing <return> mean "yes" in minibufer
(load-safe "my-minibuf-prompt")

;; Settings and additional functionality for auto-completion and snippets
(load-safe "my-auto-completion")

;; Additional interfaces and functionalities activation and config
(load-safe "my-generic-ui-config")

(load-safe "my-hydra-stables")

;; Python, JavaScript, YAML, Rust, Racket and so on (and on, and on... 🙂) config
(load-safe "langs/base.el")

;; Everything that is useful for normal editing or not programming specific
(load-safe "my-generic-editing-config")

;; everything that's useful for programming and not language specific
(load-safe "my-generic-programming-config")

;; Keybinding and function that deal with windows and buffers, mostly bound to
;; C-w C-... Elscreen lives here, too (under C-M-z ...).
(load-safe "my-windows-config")

;; project definitions for fuzzy find and others
(load-safe "my-projects")

;; git configuration, not much there
(load-safe "my-vcs-config")

;; org-mode customizations
(load-safe "org/my-org-ux")

;; JABBER.el (XMPP) settings
;; (load-safe "my-jabber")

(require 'my-download-page)


;; Load settings from Emacs Customize system.
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)


(setf debug-on-error nil)

;; XXX: Ugly hack - somehow, between loading org/my-org-ux.el and here, the
;; Racket entry in auto-mode-alist gets overwritten by Scheme mode. The macro
;; removes that and associates `.rkt' with `racket-mode' again.
(make-scheme-great-again)


(provide 'init)
;;; init.el ends here
