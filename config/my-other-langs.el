(require 'elixir-mode)
(require 'nimrod-mode)
(require 'nginx-mode)
;;
;; HTML & Django templates mode
;;
(require 'nxml-mode)

(require 'web-mode)
(setq-default web-mode-engine "django")

;; The only problem with web-mode is that it stops highlighting the buffer after
;; any edit. I have no idea why could this be, given what little I know about
;; font-lock and friends...
(defun my-web-mode-hook ()
  (define-key web-mode-map (kbd "C-c C-s") 'web-mode-scan-buffer)
  (hs-minor-mode -1)
  (fci-mode -1))

(add-hook 'web-mode-hook 'my-web-mode-hook)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))

;; somehow flymake doesn't want to work for me
(delete '("\\.html?\\'" flymake-xml-init) flymake-allowed-file-name-masks)

;; (add-to-list 'load-path "path-to/django-mode/")
;; (require 'django-html-mode)
;; ;; (yas/load-directory "path-to/django-mode/snippets")
;; (add-to-list 'auto-mode-alist '("\\.html$" . django-html-mode))

;; MUCH too slow/quirky.
;; https://answers.launchpad.net/nxhtml/+question/225782
;; (load "~/.emacs.d/pkg-langs/nxhtml/autostart.el")
;; (eval-after-load 'nxhtml
;;   '(nxhtml-toggle-visible-warnings))
;; (setq mumamo-background-colors nil)
;; (setq auto-mode-alist
;;       (append '(("\\.html?$" . django-html-mumamo-mode)) auto-mode-alist))
;; (add-to-list 'auto-mode-alist '("\\.html$" . django-html-mumamo-mode))


;;
;; Emacs Lisp mode tweaks
;;

(put 'font-lock-add-keywords 'lisp-indent-function 1)
(font-lock-add-keywords 'emacs-lisp-mode
  '(("eval-after-load" . font-lock-keyword-face)))

(require 'paredit-autoloads)

(global-set-key (kbd "C-c C-f")        'find-function)

;; no idea where or why I overriden default <return> function in isearch...
(define-key isearch-mode-map (kbd "<return>") 'isearch-exit)

(defun my-interactive-byte-compile ()
  (interactive)
  (byte-compile-file (buffer-file-name)))


(defun my-elisp-mode-setup ()
  (paredit-mode 1)
  (local-set-key (kbd "C-M-d")   'duplicate-line-or-region)
  (local-set-key (kbd "C-c C-b") 'my-interactive-byte-compile)
  (local-set-key (kbd "C-c C-j") 'eval-print-last-sexp)

  (define-key paredit-mode-map (kbd "M-S-<left>")  'backward-word)
  (define-key paredit-mode-map (kbd "M-?")         'paredit-convolute-sexp)
  (define-key paredit-mode-map (kbd "M-S-<right>") 'forward-word)
  (define-key paredit-mode-map (kbd "C-c C-j")     'eval-print-last-sexp)
  (define-key paredit-mode-map (kbd "C-M-d")       'duplicate-line-or-region))


(add-hook 'emacs-lisp-mode-hook 'my-elisp-mode-setup)
(font-lock-add-keywords 'emacs-lisp-mode
  '(
    ("defstruct" . font-lock-keyword-face)
    ("\bit\b" . font-lock-builtin-face)
    ))

;;
;; SQL interactions mode
;;
(require 'sql-completion)
(setq sql-interactive-mode-hook
      (lambda ()
        (define-key sql-interactive-mode-map "\t" 'comint-dynamic-complete)
        (sql-mysql-completion-init)))


;;
;; Markdown support
;;
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))


;; Julia mode does not provide autoloads at this point and I don't use it yet,
;; so importing it on emacs start is not jusifiable.
;; (require 'julia-mode)

(require 'rust-mode-autoloads)


;;
;; Erlang and Distel (Erlang shell integration) config
;;
;; (require 'erlang-start)
(require 'erlang-autoloads)

(add-to-list 'auto-mode-alist '("\\.erl\\'" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.hrl\\'" . erlang-mode))

(add-to-list 'ac-modes 'erlang-mode)

(add-hook 'erlang-mode-hook
          (lambda ()
            (require 'distel)
            (distel-setup)))


;;
;; YAML mode
;;
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))


;;
;; JavaScript mode
;;
(require 'js2-mode)


;;       ____      _    ____ _  _______ _____   __  __  ___  ____  _____
;;      |  _ \    / \  / ___| |/ / ____|_   _| |  \/  |/ _ \|  _ \| ____|
;;      | |_) |  / _ \| |   | ' /|  _|   | |   | |\/| | | | | | | |  _|
;;      |  _ <  / ___ \ |___| . \| |___  | |   | |  | | |_| | |_| | |___
;;      |_| \_\/_/   \_\____|_|\_\_____| |_|   |_|  |_|\___/|____/|_____|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; BTW:
;; insert lambda char: C-M-y or C-c C-\
;; start geiser:       C-c C-z or C-c C-a
;;
(require 'racket-mode)

;; Geiser config
(setq geiser-racket-binary           (f-expand "~/portless/racket/racket/bin/racket"))
(setq geiser-active-implementations '(racket))

(setq geiser-mode-company-p t)          ; not sure if it's needed
(setq geiser-repl-company-p t)          ; not sure if it's needed


(defvar racket-file-exts '("\\.rkt\\'" "\\.rktd\\'"))

(defun my-sanitize-auto-modes-racket ()
  (setq auto-mode-alist
        (--remove  (string-match ".rkt" (car it)) auto-mode-alist))
  ;; add racket-mode to auto-mode-alist
  (loop for ext in racket-file-exts
        do (push `(,ext . racket-mode) auto-mode-alist)))

;; (assoc "\\.rkt\\'" auto-mode-alist)

;; geiser uses autoloads and sets auto-mode-alist then, so we need to change it
;; back when it happens
(eval-after-load "geiser-autoloads" '(my-sanitize-auto-modes-racket))
(eval-after-load "geiser"           '(my-sanitize-auto-modes-racket))

;; But even if Geiser never loads we still want racket-mode in auto-mode-alist,
;; so we set it right now too.
(my-sanitize-auto-modes-racket)

(add-hook 'geiser-repl-mode-hook 'my-geiser-repl-hook)
(defun my-geiser-repl-hook ()
  (auto-complete-mode 1))

;; Smalltalk: ale slaby. Trzeba zobaczyc Shampoo.
(require 'smalltalk-mode)
(push '("\\.st\\'" . smalltalk-mode)  auto-mode-alist)


(require 'io-mode)
