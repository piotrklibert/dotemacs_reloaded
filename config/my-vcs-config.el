(require 'git-commit)
(require 'magit-autoloads)

(autoload
  'magit-blame "magit-blame"
  "Major mode for editing Markdown files" t)

(eval-after-load "magit"
  '(progn
    (define-key magit-mode-map    (kbd "C-w")    my-wnd-keys)))


(define-key mode-specific-map (kbd "C-g")   'magit-status) ; C-c C-g
(define-key mode-specific-map (kbd "C-M-g") 'magit-blame) ; C-c C-M-g


;; customize: magit-blame-disable-modes instead of this hook
;; (eval-after-load "magit-blame"
;;   '(add-hook 'magit-blame-mode-hook
;;              'my-magit-blame-hook))
;; (defun my-magit-blame-hook ()
;;   (if magit-blame-mode
;;       (fci-mode -1)
;;     (fci-mode 1)))


(define-key git-commit-mode-map
  (kbd "C-c C-s") 'my-set-ticket)

(defvar my-current-ticket-name nil)

(defun my-set-ticket (ticket)
  (interactive "sNew ticket name: ")
  (setq my-current-ticket-name ticket))


;; M-x customize git-commit-mode-hook
(defun my-magit-commit-hook ()
  (unless my-current-ticket-name
    (setq my-current-ticket-name
          (read-string "Ticket name: ")))
  (goto-char (point-min))
  (unless (= 0 (length my-current-ticket-name)) ; don't insert a space if not needed
    (insert my-current-ticket-name " ")
    (save-excursion
      (newline)
      (newline))))
