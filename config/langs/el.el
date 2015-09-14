;;
;; Emacs Lisp mode tweaks
;;

(require 'paredit-autoloads)

(put 'font-lock-add-keywords 'lisp-indent-function 1)
(put 'indent/tag-for-modes 'lisp-indent-function 1)

(font-lock-add-keywords 'emacs-lisp-mode
  '(("eval-after-load" . font-lock-keyword-face)
    ("defstruct"       . font-lock-keyword-face)
    ("\bfunctionp?"    . font-lock-keyword-face)
    ("\bit\b"          . font-lock-builtin-face)))


;; no idea where or why I overriden default <return> function in isearch...
(define-key isearch-mode-map (kbd "<return>") 'isearch-exit)

(defun my-interactive-byte-compile ()
  (interactive)
  (byte-compile-file (buffer-file-name)))

(defun my-eval-last-sexp (arg)
  (interactive "P")
  (cond
   ((not arg) (call-interactively 'eval-last-sexp))
   ;; TODO: add ability for inserting result without pp via C-u C-u
   (t (call-interactively 'pp-eval-last-sexp))))



(add-hook 'emacs-lisp-mode-hook 'my-elisp-mode-setup)
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

  (global-set-key [remap eval-last-sexp] 'my-eval-last-sexp))




(add-hook 'eshell-mode-hook 'my-eshell-hook)
(defun my-eshell-hook ()
  (define-key eshell-mode-map (kbd "C-v") 'eshell-kill-input)
  (define-key eshell-mode-map (kbd "<up>") 'previous-line)
  (define-key eshell-mode-map (kbd "<down>") 'next-line)
  (define-key eshell-mode-map [remap kill-whole-line] 'eshell-kill-input)
  )

(require 'subr-x)
(defalias '-> 'thread-first)
(defalias '->> 'thread-last)



(list 3 4 5 '(76 5))
'(3 :asd 5
   (76 5))
