(load "~/cedet/cedet-devel-load.el")
(load "~/cedet/contrib/cedet-contrib-load.el")

(defmacro add-subdirs-to-path (&rest dirs)
  "Add given directory and all it's (immediate) subdirectories to load-path."
  `(dolist (dir (list ,@dirs))
     (add-to-list 'load-path dir)
     (let
       ((default-directory dir))
     (normal-top-level-add-subdirs-to-load-path))))


;; we don't want to add direct children of Emacs home directory to path,
;; because there are many non-lisp dirs in there
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/config")


(add-subdirs-to-path
  "~/.emacs.d/elpa"
  "~/.emacs.d/pkg-langs"
  "~/.emacs.d/plugins2")


;; import IF-WINDOWS and IF-BSD macros - very important!
(load "my-system-detection")



;;     _     ___   ___  _  __                  _   _____ _____ _____ _
;;    | |   / _ \ / _ \| |/ /   __ _ _ __   __| | |  ___| ____| ____| |
;;    | |  | | | | | | | ' /   / _` | '_ \ / _` | | |_  |  _| |  _| | |
;;    | |__| |_| | |_| | . \  | (_| | | | | (_| | |  _| | |___| |___| |___
;;    |_____\___/ \___/|_|\_\  \__,_|_| |_|\__,_| |_|   |_____|_____|_____|
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Beware: Help At Pt group!

(load-theme          'wombat)
(tool-bar-mode       -1)
(scroll-bar-mode     -1)
(fringe-mode         '(4 . 8))
(set-cursor-color    "white")
(when window-system
  (mouse-wheel-mode t)
  (blink-cursor-mode -1)
  (set-mouse-color "sky blue")) ; list-colors-display - buffer with all colors



;; (set-face-attribute 'default nil :font "DejaVu Sans Mono-12")
(defun my-set-default-font()
  (interactive)
  (if-hostname klibertp.10clouds.com
   (set-face-attribute 'default nil :font "Bitstream Vera Sans Mono-12"))
  (if-hostname urkaja2
   (set-face-attribute 'default nil :font "Bitstream Vera Sans Mono-13")))

(if-bsd
 ;; Set a font to something I can see, unless we're in the terminal window
 ;; (happens when Emacs is started as a daemon). In that case bind a key that
 ;; sets the font; it can be used later (when emacsclient is started).
 (if window-system
     (my-set-default-font))
 (add-hook 'after-make-frame-functions
              (lambda (f)
                (if window-system
                    (my-set-default-font))))
 (global-set-key (kbd "C-<f10>") 'my-set-default-font))



;;                 ____   ____ ____  ___ ____ _____ ____
;;                / ___| / ___|  _ \|_ _|  _ \_   _/ ___|
;;                \___ \| |   | |_) || || |_) || | \___ \
;;                 ___) | |___|  _ < | ||  __/ | |  ___) |
;;                |____/ \____|_| \_\___|_|    |_| |____/
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; import modules which majority of scripts use or don't fit anywhere
(require 'cl)
(require 'nxml-mode)
(require 's-autoloads)

(eval-after-load "info"
  '(require 'info+))

(eval-after-load "help"
  '(progn
     (require 'help-macro+)
     (require 'help-fns+)
     (require 'help+)
     (require 'help-mode+)))

(eval-after-load "thingatpt"
  '(require 'thingatpt+))


;; TODO:
;; all -- make all-global
;; helm - bo anything poszlo do piachu
;; auto-indent-mode
;; buffer-stack
;; grin! instead of ack
;; idle-highlight-mode
;; todotxt
;; ehh... auto-complete w minibuffer / hippie-expand: C-c . (!!!)

;; import custom keymaps declarations, used by DEFINE-KEY in scripts
(load "my-keymaps-config")

;; Make pressing <return> mean "yes" in minibufer
(load "my-minibuf-prompt")

;; Settings and additional functionality for auto-completion and snippets
(load "my-auto-completion")

;; Additional interfaces and functionalities (through plugins) activation and
;; config
(load "my-menus-config")

;; Keybinding and function that deal with windows and buffers, mostly bound to
;; C-w C-... Elscreen lives here, too.
(load "my-windows-config")

;; Main configuration for Python
(load "my-python-config")

;; JavaScript, YAML, Rust, Racket and so on - configuration
(load "my-other-langs")

;; Everything that is useful for normal editing or not programming specific
(load "my-generic-editing-config")

;; everything that's useful for programming and not language specific
(load "my-generic-programming-config")

;; git configuration, not much there
(load "my-vcs-config")





;;
;;                      ____ _   _ ____ _____ ___  __  __
;;                     / ___| | | / ___|_   _/ _ \|  \/  |
;;                    | |   | | | \___ \ | || | | | |\/| |
;;                    | |___| |_| |___) || || |_| | |  | |
;;                     \____|\___/|____/ |_| \___/|_|  |_|
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq backup-directory-alist `(("." . "~/.saves")))
; DON'T use tabs for indenting, use spaces only
(setq-default indent-tabs-mode nil)
; Length of tab is 4 SPC
(setq-default tab-width 4)
; Make sure tab width is set!
(setq tab-width 4)
; Set indent function to the default, because.
(setq indent-line-function 'insert-tab)
; Don't show splash on startup
(setq inhibit-startup-message t)
; Sentences end with one space
(setq sentence-end-double-space nil)
; Show empty lines
(setq-default indicate-empty-lines t)
; Add newline when at buffer end
(setq next-line-add-newlines t)
; Always newline at end of file
(setq require-final-newline 't)
; Blinking parenthesis
(setq blink-matching-paren-distance nil)
; Highlight text between parens
(setq show-paren-style 'parenthesis)
; Don't add lines when <down> is pressed at the end of a file
(setq next-line-add-newlines nil)

(setq-default imenu-auto-rescan t
              color-theme-is-global t
              sentence-end-double-space nil
              mouse-yank-at-point t
              ;; whitespace-style '(face trailing lines-tail tabs)
              whitespace-line-column 80
              diff-switches "-u")

(add-to-list 'safe-local-variable-values '(whitespace-line-column . 80))

(setq ring-bell-function (lambda ()))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu 0.3)
 '(ac-quick-help-prefer-x t)
 '(ag-highlight-search t)
 '(ag-reuse-buffers t)
 '(auto-mark-ignore-move-on-sameline t)
 '(bmkp-last-as-first-bookmark-file "/root/.emacs.d/bookmarks")
 '(coffee-tab-width 4)
 '(completion-ignored-extensions
   (quote
    (".o" "~" ".bin" ".lbin" ".so" ".a" ".ln" ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".svn/" ".hg/" ".git/" ".bzr/" "CVS/" "_darcs/" "_MTN/" ".fmt" ".tfm" ".class" ".fas" ".lib" ".mem" ".x86f" ".sparcf" ".dfsl" ".pfsl" ".d64fsl" ".p64fsl" ".lx64fsl" ".lx32fsl" ".dx64fsl" ".dx32fsl" ".fx64fsl" ".fx32fsl" ".sx64fsl" ".sx32fsl" ".wx64fsl" ".wx32fsl" ".fasl" ".ufsl" ".fsl" ".dxl" ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".cp" ".fn" ".ky" ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo")))
 '(debug-on-quit nil)
 '(delete-selection-mode nil)
 '(dired-use-ls-dired (quote unspecified))
 '(ecb-auto-activate t)
 '(ecb-layout-name "left3")
 '(ecb-maximize-ecb-window-after-selection nil)
 '(ecb-options-version "2.40")
 '(ecb-process-non-semantic-files t)
 '(ecb-tip-of-the-day nil)
 '(ecb-use-speedbar-instead-native-tree-buffer nil)
 '(ecb-vc-enable-support t)
 '(ecb-windows-width 0.13)
 '(ediff-keep-variants nil)
 '(ediff-merge-split-window-function (quote split-window-horizontally))
 '(ediff-no-emacs-help-in-control-buffer t)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(enable-recursive-minibuffers t)
 '(eval-expression-print-length 100)
 '(fic-highlighted-words (quote ("FIXME" "TODO" "BUG" "REDFLAG" "XXX")))
 '(fill-column 80)
 '(flymake-no-changes-timeout 5)
 '(flymake-start-syntax-check-on-newline t)
 '(fuzzy-accept-error-rate 0.2)
 '(help-at-pt-display-when-idle t nil (help-at-pt))
 '(help-at-pt-timer-delay 3)
 '(ibuffer-expert t)
 '(icicle-Completions-max-columns 1)
 '(icicle-Completions-text-scale-decrease 0.0)
 '(icicle-files-ido-like-flag t)
 '(icicle-mode t)
 '(icicle-show-Completions-initially-flag nil)
 '(imenu-sort-function (quote imenu--sort-by-name))
 '(imenu-use-popup-menu nil)
 '(initial-scratch-message ";; **SCRATCH BUFFER **

")
 '(mumamo-background-colors nil)
 '(nxhtml-menu-mode t)
 '(nxhtml-skip-welcome t)
 '(nxhtml-validation-header-mumamo-modes nil)
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/")
     ("marmalade" . "http://marmalade-repo.org/packages/"))))
 '(quack-programs
   (quote
    ("mzscheme" "bigloo" "csi" "csi -hygienic" "gosh" "gracket" "gsi" "gsi ~~/syntax-case.scm -" "guile" "kawa" "mit-scheme" "racket" "racket -il typed/racket" "rs" "scheme" "scheme48" "scsh" "sisc" "stklos" "sxi")))
 '(recentf-auto-cleanup (quote never))
 '(recentf-max-menu-items 100)
 '(recentf-max-saved-items 100)
 '(recentf-menu-action (quote find-file))
 '(scroll-conservatively 108)
 '(set-mark-command-repeat-pop t)
 '(sgml-basic-offset 4)
 '(shell-file-name "/usr/local/bin/bash")
 '(speedbar-default-position (quote left))
 '(speedbar-hide-button-brackets-flag t)
 '(speedbar-show-unknown-files t)
 '(speedbar-tag-regroup-maximum-length 4)
 '(speedbar-verbosity-level 1)
 '(sr-speedbar-right-side nil)
 '(tab-stop-list
   (quote
    (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120)))
 '(tags-revert-without-query t)
 '(truncate-lines t)
 '(truncate-partial-width-windows nil)
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify))
 '(uniquify-separator ":")
 '(uniquify-strip-common-suffix t)
 '(uniquify-trailing-separator-p t)
 '(web-mode-code-indent-offset 4)
 '(web-mode-comment-style 2)
 '(web-mode-css-indent-offset 4)
 '(web-mode-disable-auto-pairing nil)
 '(web-mode-enable-block-faces nil)
 '(web-mode-markup-indent-offset 4)
 '(web-mode-tag-auto-close-style 2))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-local-directory ((t (:foreground "dark orange"))))
 '(bmkp-local-file-without-region ((t (:foreground "cyan"))))
 '(css-selector ((t (:inherit font-lock-function-name-face :foreground "deep sky blue"))))
 '(font-lock-fic-face ((t (:background "wheat4" :foreground "cyan" :weight bold))))
 '(hl-line ((t (:background "gray10"))))
 '(magit-item-highlight ((t (:background "gray19" :underline nil))))
 '(table-cell ((t (:background "gray20" :foreground "gray90" :inverse-video nil))))
 '(visible-mark-face ((t (:background "gray26")))))

(toggle-diredp-find-file-reuse-dir t)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
