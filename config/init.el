;; This needs to be set before it's used, but I don't know where it's used for
;; the first time so I placed it before *everything* :)
(setq srecode-map-save-file "~/.emacs.d/data/srecode-map.el")


;; Basic look & feel customization, placed here so that Emacs looks good from the
;; start :)
(setf frame-title-format "Emacs starting..."
      inhibit-startup-message t)        ; Don't show splash on startup
(tool-bar-mode   -1)
(scroll-bar-mode -1)
(fringe-mode     '(4 . 8))
(menu-bar-mode    1)
(load-theme       'wombat)
(set-cursor-color "white")


;; Add the paths of plugins to load-path.
(add-to-list 'load-path "~/.emacs.d/config")
(require 'my-packages-utils)            ; for `add-subdirs-to-path'

(add-subdirs-to-path
  "~/.emacs.d/forked-plugins/"
  "~/.emacs.d/plugins2"
  "~/.emacs.d/plugins"
  "~/.emacs.d/pkg-langs"
  "~/.emacs.d/elpa")

(require 'my-utils)
(require 'my-system-config)
(require 'my-packages)


;; Font and modes configuration when running in graphical mode.
;;
;; Beware: Help At Pt group!

(defun my-set-default-font (&optional frame)
  ;; another possible font: "DejaVu Sans Mono-12"
  (interactive)
  (cl-flet
      ((set-font (font-name) (set-face-attribute 'default nil :font font-name)))
    (my-match-hostname
      (f25b                => (set-font "Bitstream Vera Sans Mono-13"))
      (fedorcia2           => (set-font "Bitstream Vera Sans Mono-9"))
      (urkaja2             => (set-font "Bitstream Vera Sans Mono-13"))
      ("Piotr Klibert Mac" => (set-font "Monaco-12")))))


(when window-system
  (mouse-wheel-mode t)
  (blink-cursor-mode -1)
  (set-mouse-color "sky blue")

  (add-hook 'after-make-frame-functions 'my-set-default-font)
  (my-set-default-font)
  ;; make setting default font available from keyboard if it somehow didn't run
  (global-set-key (kbd "C-<f10>") 'my-set-default-font))


;; Other basic editing settings.
;; TODO: move to `custom.el' and/or `my-generic-editing-config.el'
(setq-default indent-tabs-mode nil) ; DON'T use tabs for indenting, use spaces only
(setq-default tab-width 4)              ; Length of tab is 4 SPC
(setq tab-width 4)                      ; Make sure tab width is set!
(setq indent-line-function 'insert-tab) ; Set indent function to the default, because.
(setq sentence-end-double-space nil)    ; Sentences end with one space
(setq-default indicate-empty-lines t)   ; Show empty lines
(setq require-final-newline 't)         ; Always newline at end of file
(setq blink-matching-paren-distance nil) ; Blinking parenthesis
(setq show-paren-style 'parenthesis)    ; Highlight text between parens
(setq next-line-add-newlines nil)       ; Don't add lines when <down> is pressed
                                        ; at the end of a file

(setq-default imenu-auto-rescan           t
              color-theme-is-global       t
              sentence-end-double-space   nil
              mouse-yank-at-point         t
              whitespace-line-column      80
              diff-switches              "-u")

;; TODO: more robust backup config - move to `custom.el'
(setq backup-directory-alist `(("." . "~/.saves")))
;; (defvar user-temporary-file-directory (concat "/tmp/" user-login-name "/emacs_backup/"))
;; (make-directory user-temporary-file-directory t)
;; (setq make-backup-files t)
;; (setq backup-by-copying t)
;; (setq version-control t)
;; (setq delete-old-versions t)
;; (setq kept-new-versions 10)
;; (setq backup-directory-alist `(("." . ,user-temporary-file-directory)))
;; (setq tramp-backup-directory-alist backup-directory-alist)
;; (setq tramp-auto-save-directory user-temporary-file-directory)
;; (setq auto-save-list-file-prefix (concat user-temporary-file-directory ".auto-saves-"))
;; (setq auto-save-file-name-transforms `((".*" ,user-temporary-file-directory t)))

(put 'dired-find-alternate-file 'disabled nil)
(put 'downcase-region 'disabled nil)

(add-to-list 'safe-local-variable-values '(whitespace-line-column . 80))

(setq ring-bell-function (lambda ()))   ; make Emacs shut up and *never* beep


;; schedule starting of Emacs server after everything else is loaded (5 min
;; *should* be enough for startup :))
(defun my-start-server ()
  (condition-case nil
      (server-start)
    (nil (message "Couldn't start the server!"))))
(run-at-time "1 min 30 sec" nil 'my-start-server)



;; import custom keymaps declarations, used by DEFINE-KEY in scripts.
(load-safe "my-keymaps-config")

;; Make pressing <return> mean "yes" in minibufer
(load-safe "my-minibuf-prompt")

;; Settings and additional functionality for auto-completion and snippets
(load-safe "my-auto-completion")

;; Additional interfaces and functionalities (through plugins) activation and
;; config - mainly ido-mode
(load-safe "my-generic-ui-config")

;; JavaScript, YAML, Rust, Racket and so on - configuration
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
(load-safe "my-org-config")

;; JABBER.el (XMPP) settings
(load-safe "my-jabber")

(require 'my-download-page)


;; Load settings from Emacs Customize system.
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
