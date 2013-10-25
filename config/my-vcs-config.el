(require 'git)
(require 'git-blame)

(require 'magit)
(require 'magit-blame)

(define-key magit-mode-map    (kbd "C-w")  my-wnd-keys)
(define-key mode-specific-map (kbd "C-g") 'magit-status)     ; C-c C-g

(defvar my-tagasauris-ticket-name nil)

(defun my-magit-commit-hook ()
  (when (and (boundp 'my-tagasauris-ticket-name)
           my-tagasauris-ticket-name)
    (goto-char (point-min))
    (insert my-tagasauris-ticket-name " ")))
