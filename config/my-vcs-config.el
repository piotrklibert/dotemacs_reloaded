(require 'git)
(require 'git-blame)

(require 'magit)
(require 'magit-blame)

(define-key magit-mode-map    (kbd "C-w")    my-wnd-keys)
(define-key mode-specific-map (kbd "C-g")   'magit-status)         ; C-c C-g
(define-key mode-specific-map (kbd "C-M-g") 'magit-blame-mode)     ; C-c C-M-g

(defvar my-tagasauris-ticket-name nil)
;; (setq my-tagasauris-ticket-name "RPA-5")

(defun my-tagasauris-set-ticket (ticket)
  (interactive "sNew ticket name: ")
  (setq my-tagasauris-ticket-name ticket))

(defun my-magit-commit-hook ()
  (unless my-tagasauris-ticket-name
    (setq my-tagasauris-ticket-name
          (read-string "Ticket name: ")))
  (goto-char (point-min))
  (unless (= 0 (length my-tagasauris-ticket-name)) ; don't insert a space is not needed
    (insert my-tagasauris-ticket-name " ")))
