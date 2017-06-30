;;
;;  COMMON LISP
;;

;; Interactive dev settings
(setq slime-contribs '(slime-fancy))
(require 'slime)


(font-lock-add-keywords 'lisp-mode
  '(("defcommand" . font-lock-keyword-face)
    ("defstruct"  . font-lock-keyword-face)))


(defun my-lisp-hook ()
  (define-key slime-mode-map (kbd "C-c C-c") 'slime-repl)
  ;; (local-set-key (kbd "C-c C-c") 'slime-repl)
  (paredit-mode 1))

(add-hook 'lisp-mode-hook 'my-lisp-hook)

(defun my-lisp-repl-hook ()
  (paredit-mode 1))

(add-hook 'slime-repl-mode-hook  'my-lisp-repl-hook)

(run-at-time "1 sec" nil
  (lambda ()
    (slime-connect "127.0.0.1" 4005)
    (run-at-time "1 sec" nil
      (lambda ()
        (let ((repl-wins (-filter (lambda (x)
                                    (s-contains? "repl sbcl" (-> x window-buffer buffer-name)))
                                  (window-list))))
          (when (> (length repl-wins) 0)
            (-map (lambda (x) (delete-window x)) repl-wins))
          (slime-repl-eval-string "(in-package :stumpwm-user)"))))))


;; (s-contains? "repl sbcl" (-> (selected-window) window-buffer buffer-name))
