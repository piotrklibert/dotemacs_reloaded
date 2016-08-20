;;
;;  COMMON LISP
;;

(font-lock-add-keywords 'lisp-mode
  '(("defcommand" . font-lock-keyword-face)
    ("defstruct"  . font-lock-keyword-face)))


(defun my-lisp-hook ()
  (paredit-mode 1))

(add-hook 'lisp-mode-hook 'my-lisp-hook)



(defun my-lisp-repl-hook ()
  (paredit-mode 1))

(add-hook 'slime-repl-mode-hook  'my-lisp-repl-hook)

;; Interactive dev settings
(setq slime-contribs '(slime-fancy))
(require 'slime-autoloads)

(if-hostname "Pior Klibert Mac"
  (setq inferior-lisp-program "/usr/local/bin/sbcl"))

(if-hostname f23
  (setq inferior-lisp-program "/bin/sbcl")
  (run-at-time "1 sec" nil
    (lambda ()
      (slime-connect "127.0.0.1" 4005))))
