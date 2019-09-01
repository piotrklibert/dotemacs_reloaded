;; -*- lexical-binding: t -*-
;;
;; Emacs Lisp mode tweaks
;;

(require 'subr-x)
(require 'lang-utils)
(require 's)
(require 'flymake)
(require 'flycheck)
(require 'eshell)
(require 'paredit)

(use-package debug
  :bind (:map debugger-mode-map
              ("C-g" . debugger-quit)))

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
  `(("eval-after-load"           . font-lock-keyword-face)
    ("defstruct"                 . font-lock-keyword-face)
    ("\bfunctionp?"              . font-lock-keyword-face)
    ;(,(rx (or " ") "it" (or eow ")"))          . font-lock-builtin-face)
    ))

;; (font-lock-remove-keywords
;;  'emacs-lisp-mode
;;  '(("it" . font-lock-builtin-face)
;;    ("\bit[\b)]"          . font-lock-keyword-face)))

(define-key emacs-lisp-mode-map (kbd "C-c <left>") 'hs-toggle-hiding)


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
  (delete 'elisp-flymake-checkdoc flymake-diagnostic-functions)
  (define-key global-map (kbd "C-M-d") 'duplicate-line-or-region)

  (define-key mode-specific-map (kbd "C-d") 'describe-function)
  (define-key mode-specific-map (kbd "d")   'describe-function)
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
(require 'esh-mode)
(add-hook 'eshell-mode-hook 'my-eshell-hook)
(defun my-eshell-hook ()
  (define-key eshell-mode-map (kbd "C-v") 'eshell-kill-input)
  (define-key eshell-mode-map (kbd "<up>") 'previous-line)
  (define-key eshell-mode-map (kbd "<down>") 'next-line)
  (define-key eshell-mode-map [remap kill-whole-line] 'eshell-kill-input))


;; (require 'subr-x)
;; (require 'cl-lib)

;; (defun my-get-subdirs (dir)
;;   (let*
;;       ((entries (directory-files dir))
;;        (dirs (cl-remove-if (lambda (z)
;;                              (or (not (file-directory-p
;;                                        (string-join (list dir z))))
;;                                  (member z '("." ".."))))
;;                            entries)))
;;     (mapcar (lambda (x) (string-join (list dir x))) dirs)))
;; (my-get-subdirs "/home/cji/")
;; (defun add-subdirs-to-path (&rest dirs)
;;   "Add given directory and all it's (immediate) subdirectories to load-path."
;;   (declare (indent 0))
;;   (dolist (dir dirs)
;;     (let ((dir (expand-file-name dir)))
;;       ;; (message "%s" dir)
;;       (add-to-list 'load-path dir)
;;       (cl-loop for d in (my-get-subdirs dir)
;;                do (add-to-list 'load-path d)))))

(defun pp-to-cmd (obj)
  (let ((s (->> (pp-to-string obj)
             (s-replace "\n" ""))))
   (replace-regexp-in-string (rx (1+ " ")) " " s t t)))
