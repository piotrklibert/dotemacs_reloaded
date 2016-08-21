;; (package-initialize)
(require 'calc)
(fringe-mode     '(4 . 8))
;; disable early so they don't appear during startup
(setf frame-title-format "Emacs starting...")
(menu-bar-mode    1)
(tool-bar-mode   -1)
(scroll-bar-mode -1)

;; this doesn't want to be set anywhere else...
(setq srecode-map-save-file "~/.emacs.d/data/srecode-map.el")


;; Two giant packages: CEDET and Org-Mode

(unless (featurep 'cedet-devel-load)
  ;; do not load cedet if it's loaded already - happens when using dumped
  ;; emacs with normal init file
  (condition-case nil
      (progn
        (load "~/cedet/cedet-devel-load.el")
        (load "~/cedet/contrib/cedet-contrib-load.el"))
    (error (message (concat "Fetch the latest CEDET package and place it "
                            "inside `~/cedet/'. Remember to `make' it.")))))


(add-to-list 'load-path "~/portless/org-mode/lisp/")
(add-to-list 'load-path "~/portless/org-mode/contrib/lisp/")


(defun add-subdirs-to-path (&rest dirs)
  "Add given directory and all it's (immediate) subdirectories to load-path."
  (dolist (dir dirs)
    (add-to-list 'load-path dir)
    (let
        ((default-directory dir))
      (normal-top-level-add-subdirs-to-load-path))))



;; we don't want to add direct children of Emacs home directory to path,
;; because there are many non-lisp dirs in there
;; (add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/config")
;; (add-to-list 'load-path "~/.emacs.d/forked-plugins/lua-mode")
;; (add-to-list 'load-path "/home/cji/.emacs.d/forked-plugins/magit/lisp")

(put 'add-subdirs-to-path 'lisp-indent-function 0)

(add-subdirs-to-path
  "~/.emacs.d/elpa"
  "~/.emacs.d/pkg-langs"
  "~/.emacs.d/plugins2"
  "~/.emacs.d/forked-plugins/")

;; import macros for checking hostname
(load "my-system-config")


;;     _     ___   ___  _  __                  _   _____ _____ _____ _
;;    | |   / _ \ / _ \| |/ /   __ _ _ __   __| | |  ___| ____| ____| |
;;    | |  | | | | | | | ' /   / _` | '_ \ / _` | | |_  |  _| |  _| | |
;;    | |__| |_| | |_| | . \  | (_| | | | | (_| | |  _| | |___| |___| |___
;;    |_____\___/ \___/|_|\_\  \__,_|_| |_|\__,_| |_|   |_____|_____|_____|
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Beware: Help At Pt group!


(load-theme          'wombat)
(set-cursor-color    "white")


(when window-system
  (mouse-wheel-mode t)
  (blink-cursor-mode -1)
  (set-mouse-color "sky blue"))

(defun my-set-default-font (&optional frame)
  ;; another possible font:
  ;; (set-face-attribute 'default nil :font "DejaVu Sans Mono-12")
  (interactive)
  (when window-system
    (if-hostname f23
      (set-face-attribute 'default nil
                          :font "Bitstream Vera Sans Mono-11"))
    (if-hostname fedorcia2
      (set-face-attribute 'default nil
                          :font "Bitstream Vera Sans Mono-9"))
    (if-hostname urkaja2                ; at home
      (set-face-attribute 'default nil
                          :font "Bitstream Vera Sans Mono-13"))
    (if-hostname "Piotr Klibert Mac"
      (set-face-attribute 'default nil
			  :font "Monaco-12"))))

(add-hook 'after-make-frame-functions 'my-set-default-font)
(my-set-default-font)

;; make setting default font available from keyboard if it somehow didn't run
(global-set-key (kbd "C-<f10>") 'my-set-default-font)


;; Make each new frame maximized by default
;; TODO: maximize only first frame, this interferes with ediff
;; (add-hook 'after-make-frame-functions
;;           (lambda (frame)
;;             (set-frame-parameter frame 'fullscreen 'maximized)))




;;                            ____ ___  ____  _____
;;                           / ___/ _ \|  _ \| ____|
;;                          | |  | | | | | | |  _|
;;                          | |__| |_| | |_| | |___
;;                           \____\___/|____/|_____|
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defmacro make-self-quoting (name)
  "Make NAME into a self-quoting function like `lambda'."
  `(defmacro ,name (&rest cdr)
     (list 'function (cons ',name cdr))))

(make-self-quoting closure)

;; schedule starting of Emacs server after everything else is loaded (5 min
;; *should* be enough for startup :))
(defun my-start-server ()
  (condition-case nil
      (server-start)
    (nil (message "asdasd"))))
(run-at-time "5 min" nil 'my-start-server)

(defmacro load-indexed (arg)
  (list 'load arg))

;; import custom keymaps declarations, used by DEFINE-KEY in scripts.
(load-indexed "my-keymaps-config")

;; Make pressing <return> mean "yes" in minibufer
(load-indexed "my-minibuf-prompt")

;; Settings and additional functionality for auto-completion and snippets
(load-indexed "my-auto-completion")

;; Additional interfaces and functionalities (through plugins) activation and
;; config - mainly ido-mode
(load-indexed "my-generic-ui-config")

;; Keybinding and function that deal with windows and buffers, mostly bound to
;; C-w C-... Elscreen lives here, too (under C-M-z ...).
(load-indexed "my-windows-config")

;; Main configuration for Python
(load-indexed "my-python-config")

;; JavaScript, YAML, Rust, Racket and so on - configuration
(load-indexed "langs/base.el")

;; Everything that is useful for normal editing or not programming specific
(load-indexed "my-generic-editing-config")

;; everything that's useful for programming and not language specific
(load-indexed "my-generic-programming-config")

;; project definitions for fuzzy find and others
(load-indexed "my-projects")

;; git configuration, not much there
(load-indexed "my-vcs-config")

;; org-mode customizations
(load-indexed "my-org-config")

;; JABBER.el (XMPP) settings
(load-indexed "my-jabber")

(require 'my-download-page)


;;
;;                      ____ _   _ ____ _____ ___  __  __
;;                     / ___| | | / ___|_   _/ _ \|  \/  |
;;                    | |   | | | \___ \ | || | | | |\/| |
;;                    | |___| |_| |___) || || |_| | |  | |
;;                     \____|\___/|____/ |_| \___/|_|  |_|
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; TODO: more robust backup config:
(setq backup-directory-alist `(("." . "~/.saves")))
;; (defvar user-temporary-file-directory
;;   (concat "/tmp/" user-login-name "/emacs_backup/"))
;; (make-directory user-temporary-file-directory t)
;; (setq make-backup-files t)
;; (setq backup-by-copying t)
;; (setq version-control t)
;; (setq delete-old-versions t)
;; (setq kept-new-versions 10)
;; (setq backup-directory-alist `(("." . ,user-temporary-file-directory)))
;; (setq tramp-backup-directory-alist backup-directory-alist)
;; (setq tramp-auto-save-directory user-temporary-file-directory)
;; (setq auto-save-list-file-prefix
;;       (concat user-temporary-file-directory ".auto-saves-"))
;; (setq auto-save-file-name-transforms
;;       `((".*" ,user-temporary-file-directory t)))



;; DON'T use tabs for indenting, use spaces only
(setq-default indent-tabs-mode nil)
;; Length of tab is 4 SPC
(setq-default tab-width 4)
;; Make sure tab width is set!
(setq tab-width 4)
;; Set indent function to the default, because.
(setq indent-line-function 'insert-tab)
;; Don't show splash on startup
(setq inhibit-startup-message t)
;; Sentences end with one space
(setq sentence-end-double-space nil)
;; Show empty lines
(setq-default indicate-empty-lines t)
;; Add newline when at buffer end
(setq next-line-add-newlines t)
;; Always newline at end of file
(setq require-final-newline 't)
;; Blinking parenthesis
(setq blink-matching-paren-distance nil)
;; Highlight text between parens
(setq show-paren-style 'parenthesis)
;; Don't add lines when <down> is pressed at the end of a file
(setq next-line-add-newlines nil)

(setq-default imenu-auto-rescan t
              color-theme-is-global t
              sentence-end-double-space nil
              mouse-yank-at-point t
              whitespace-line-column 80
              diff-switches "-u")

(add-to-list 'safe-local-variable-values '(whitespace-line-column . 80))

;; don't beep. Just don't.
(setq ring-bell-function (lambda ()))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)


(put 'dired-find-alternate-file 'disabled nil)
(put 'downcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
