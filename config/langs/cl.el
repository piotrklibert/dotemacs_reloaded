;;
;;  COMMON LISP
;;
(setq inferior-lisp-program "/home/cji/ccl/lx86cl64")
(setq slime-contribs '(slime-fancy))
(require 'slime-autoloads)

(defun my-lisp-hook ()
  (interactive)
  (paredit-mode 1))

(add-hook 'lisp-mode-hook 'my-lisp-hook)


(defun my-lisp-repl-hook ()
  (paredit-mode 1))

(add-hook 'slime-repl-mode-hook 'my-lisp-repl-hook)
