;; Scheme and Racket
;;
;; BTW, in Racket mode:
;; insert lambda char: C-M-y or C-c C-\
;; start geiser:       C-c C-z or C-c C-a
;;


(require 'lang-utils)

(defun initialize-any-scheme ()
  (indent/tag-for-modes
      '(scheme-indent-function racket-indent-function)
    '((serve/servlet . 1)
      (send-resp! . 1)
      (~> . 1)
      (vl-append . 1)
      (vc-append . 1)
      (vr-append . 1)
      (ht-append . 1)
      (htl-append . 1)
      (hc-append . 1)
      (only-in . 1)
      (do . 0)
      (rename-in . 1)
      (hbl-append . 1)
      (hb-append . 1)
      (if-let . 1)
      (when-let . 1)
      (~>> . 1)
      (call-with-semaphore . 1)
      (response/full . 3)
      (with-semaphore . 1)
      (check-exn . 1)
      (run-movie . 1)
      (new . 1)
      (set! . 1)
      (linewidth . 1)))

  (font-lock-for-modes
      '(scheme-mode racket-mode)
    '(("send-resp!" . font-lock-keyword-face)
      ("serve/servlet" . font-lock-keyword-face)
      ("send/suspend" . font-lock-builtin-face)
      ("zip" . font-lock-builtin-face)
      ("defcommand" . font-lock-keyword-face)
      ("define/case" . font-lock-keyword-face)
      ("define/contract" . font-lock-keyword-face)
      ("if-let" . font-lock-keyword-face)
      ("when-let" . font-lock-keyword-face))))

(defun my-scheme-hook ()
  (my-init-prog-mode)
  (paredit-mode)
  (rainbow-mode 1)
  (undo-tree-mode))

(use-package scheme
  :mode ("\\.scm\\'" . scheme-mode)
  :config
  (initialize-any-scheme)
  (add-hook 'scheme-mode-hook 'my-scheme-hook))

(defun my-racket-hook ()
  (paredit-mode))

(defun my-racket-repl-hook ()
  (paredit-mode)
  (define-key racket-repl-mode-map (kbd "C-w") my-wnd-keys))


(defconst racket-file-exts '("\\.rkt\\'" "\\.rktd\\'"))
(defun my-sanitize-auto-modes-racket ()
  (setq auto-mode-alist (loop for x in auto-mode-alist
                              unless (s-contains? "rkt" (car x))
                              collect x)))
(my-sanitize-auto-modes-racket)

(use-package racket-mode
  :mode "\\.rkt[dl]?\\'"
  :interpreter "racket"
  :config
  (initialize-any-scheme)
  (modify-coding-system-alist 'file "\\.rkt[dl]?\\'" 'utf-8)
  (add-hook 'racket-mode-hook 'my-racket-hook)
  (add-hook 'racket-repl-mode-hook 'my-racket-repl-hook)
  (eval-after-load "paredit"
    '(define-key paredit-mode-map (kbd "M-[") 'paredit-wrap-square)))

;; add racket-mode to auto-mode-alist
;; (loop for ext in racket-file-exts
;;       do (push `(,ext . racket-mode) auto-mode-alist))
;; (assoc "\\.rkt\\'" auto-mode-alist)

;; geiser uses autoloads and sets auto-mode-alist then, so we need to change it
;; back when it happens
;; (eval-after-load "geiser-autoloads" '(my-sanitize-auto-modes-racket))
;; (eval-after-load "geiser"           '(my-sanitize-auto-modes-racket))
;; But even if Geiser never loads we still want racket-mode in auto-mode-alist,
;; so we set it right now too.

;; Geiser config
;; (require 'geiser)
;; (setq geiser-active-implementations '(racket))
;; (setq geiser-racket-binary           (f-expand "~/portless/racket/racket/bin/racket"))
;; (setq geiser-mode-company-p t)          ; not sure if it's needed
;; (setq geiser-repl-company-p t)          ; not sure if it's needed
;; (add-hook 'geiser-repl-mode-hook 'my-geiser-repl-hook)
;; (defun my-geiser-repl-hook () (auto-complete-mode 1))
