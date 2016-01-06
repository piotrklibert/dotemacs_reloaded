;;
;;  COMMON LISP
;;
(setq inferior-lisp-program "/home/cji/ccl/lx86cl64")
(setq slime-contribs '(slime-fancy))
(require 'slime-autoloads)

(font-lock-add-keywords 'lisp-mode
  '(("defcommand" . font-lock-keyword-face)
    ("defstruct"       . font-lock-keyword-face)))

(defun my-lisp-hook ()
  (interactive)
  (paredit-mode 1))

(add-hook 'lisp-mode-hook 'my-lisp-hook)


(defun my-lisp-repl-hook ()
  (paredit-mode 1))

(add-hook 'slime-repl-mode-hook 'my-lisp-repl-hook)
