;; Scheme and Racket
;;
;; BTW, in Racket mode:
;; insert lambda char: C-M-y or C-c C-\
;; start geiser:       C-c C-z or C-c C-a
;;


(require 'scheme)
(require 'lang-utils)


(indent/tag-for-modes
    '(scheme-indent-function
      racket-indent-function)
  '((serve/servlet . 1)
    (send-resp! . 1)
    (~> . 1)
    (call-with-semaphore . 1)
    (response/full . 3)
    (with-semaphore . 1)
    (check-exn . 1)
    (run-movie . 1)
    (new . 1)
    (set! . 1)))


(loop for mode in '(scheme-mode racket-mode)
      do (font-lock-add-keywords mode
           '(("send-resp!" . font-lock-keyword-face)
             ("serve/servlet" . font-lock-keyword-face)
             ("send/suspend" . font-lock-builtin-face)
             ("defcommand" . font-lock-keyword-face))))

(defun my-scheme-hook ()
  (my-init-prog-mode)
  (paredit-mode)
  (rainbow-mode 1)
  (undo-tree-mode))

(add-hook 'scheme-mode-hook 'my-scheme-hook)

(require 'racket-mode-autoloads)

;; Geiser config
;; (require 'geiser)
;; (setq geiser-active-implementations '(racket))
;; (setq geiser-racket-binary           (f-expand "~/portless/racket/racket/bin/racket"))
;; (setq geiser-mode-company-p t)          ; not sure if it's needed
;; (setq geiser-repl-company-p t)          ; not sure if it's needed
;; (add-hook 'geiser-repl-mode-hook 'my-geiser-repl-hook)
;; (defun my-geiser-repl-hook () (auto-complete-mode 1))


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


(defun my-racket-hook ()
  (paredit-mode))

(defun my-racket-repl-hook ()
  (paredit-mode)
  (define-key racket-repl-mode-map (kbd "C-w") my-wnd-keys))


(add-hook 'racket-mode-hook 'my-racket-hook)
(add-hook 'racket-repl-mode-hook 'my-racket-repl-hook)

(eval-after-load "paredit"
  '(define-key paredit-mode-map (kbd "M-[") 'paredit-wrap-square))
