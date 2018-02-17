;;
;; Emacs Lisp mode tweaks
;;
(require 'subr-x)
(require 'paredit-autoloads)
(require 'lang-utils)

(indent/tag-for-modes
    '(lisp-indent-function)
  '((font-lock-add-keywords . 1)
    (run-at-time . 2)
    (define-frame-preference . 1)
    (run-with-timer . 2)
    (indent/tag-for-modes . 1)
    (propertize . 1)
    (font-lock-for-modes . 1)))


(font-lock-add-keywords 'emacs-lisp-mode
  '(("eval-after-load" . font-lock-keyword-face)
    ("defstruct"       . font-lock-keyword-face)
    ("\bfunctionp?"    . font-lock-keyword-face)
    ("\bit\b"          . font-lock-keyword-face)))


(defalias '-> 'thread-first)
(defalias '->> 'thread-last)

(defun my-interactive-byte-compile ()
  (interactive)
  (byte-compile-file (buffer-file-name)))

(defun my-eval-last-sexp (arg)
  (interactive "P")
  (cond
   ((not arg) (call-interactively 'eval-last-sexp))
   (t (call-interactively 'pp-eval-last-sexp))))



;;
;; Emacs Lisp hook
;;
(add-hook 'emacs-lisp-mode-hook 'my-elisp-mode-setup)
(add-hook 'inferior-emacs-lisp-mode-hook 'my-elisp-mode-setup) ; for ielm command

(defun my-elisp-mode-setup ()
  (paredit-mode 1)
  (local-set-key (kbd "C-M-d") 'duplicate-line-or-region)

  (define-key mode-specific-map (kbd "C-b") 'my-interactive-byte-compile)
  (define-key mode-specific-map (kbd "C-j") 'eval-print-last-sexp)
  (define-key mode-specific-map (kbd "C-f") 'find-function)

  (define-key paredit-mode-map (kbd "M-S-<left>")  'backward-word)
  (define-key paredit-mode-map (kbd "M-?")         'paredit-convolute-sexp)
  (define-key paredit-mode-map (kbd "M-S-<right>") 'forward-word)
  (define-key paredit-mode-map (kbd "C-c C-j")     'eval-print-last-sexp)
  (define-key paredit-mode-map (kbd "C-M-d")       'duplicate-line-or-region)

  (global-set-key [remap eval-last-sexp] 'my-eval-last-sexp)
  (flycheck-mode -1))



;;
;; Eshell hook
;;
(add-hook 'eshell-mode-hook 'my-eshell-hook)
(defun my-eshell-hook ()
  (define-key eshell-mode-map (kbd "C-v") 'eshell-kill-input)
  (define-key eshell-mode-map (kbd "<up>") 'previous-line)
  (define-key eshell-mode-map (kbd "<down>") 'next-line)
  (define-key eshell-mode-map [remap kill-whole-line] 'eshell-kill-input)
  )
