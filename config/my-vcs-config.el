(require 'git)
(require 'git-blame)

(require 'magit)
(require 'magit-blame)

(define-key magit-mode-map    (kbd "C-w")  my-wnd-keys)
(define-key mode-specific-map (kbd "C-g") 'magit-status)     ; C-c C-g

(defvar my-tagasauris-ticket-name nil)

(defun my-magit-commit-hook ()
  (unless my-tagasauris-ticket-name
    (setq my-tagasauris-ticket-name
          (read-string "Ticket name: ")))
  (goto-char (point-min))
  (insert my-tagasauris-ticket-name " "))
