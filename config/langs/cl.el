;;
;;  COMMON LISP
;;

;; Interactive dev settings
(setq slime-contribs '(slime-fancy))

(defun my-slime-hook ()
  (paredit-mode 1))


(use-package slime
  :commands slime-connect
  :bind (("C-c !" . slime-connect))
  :config
  (load-many "~/quicklisp/slime-helper.el"
             "~/quicklisp/clhs-use-local.el")

  (font-lock-add-keywords 'lisp-mode
    '(("defcommand" . font-lock-keyword-face)
      ("defsystem" . font-lock-keyword-face)
      ("defstruct"  . font-lock-keyword-face)))

  (indent/tag-for-modes
      '(lisp-indent-function)
    '((define-modeline-subthread . 1)
      (add-hook . 1)
      (defcommand . 3)))
  (add-hook 'slime-repl-mode-hook 'my-slime-hook))


(defun my-lisp-hook ()
  (require 'slime)
  (define-key slime-mode-map (kbd "C-c C-c") 'slime-repl)
  (paredit-mode 1))

(add-hook 'lisp-mode-hook 'my-lisp-hook)


;; (when (not (getenv "INHIBIT_SLIME"))
;;   (run-at-time "1 sec" nil
;;     (lambda ()
;;       (slime-connect "127.0.0.1" 4005)
;;       (run-at-time "1 sec" nil
;;         (lambda ()
;;           (let ((repl-wins (-filter (lambda (x)
;;                                       (s-contains? "repl sbcl" (-> x
;;                                                                  window-buffer
;;                                                                  buffer-name)))
;;                                     (window-list))))
;;             (when (> (length repl-wins) 0)
;;               (-map (lambda (x) (delete-window x)) repl-wins))
;;             (slime-repl-eval-string "(in-package :stumpwm-user)")))))))


;; ;; (s-contains? "repl sbcl" (-> (selected-window) window-buffer buffer-name))
