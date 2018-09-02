(require 'magit-autoloads)

(use-package git-commit
  :commands git-commit-setup
  :config
  (define-key git-commit-mode-map (kbd "C-c C-s") 'my-set-ticket))

(use-package magit-blame
  :commands magit-blame)

(eval-after-load "magit"
  '(progn
    (define-key magit-mode-map    (kbd "C-w")    my-wnd-keys)))


(define-key mode-specific-map (kbd "C-g")   'magit-status) ; C-c C-g
(define-key mode-specific-map (kbd "C-M-g") 'magit-blame)  ; C-c C-M-g


(defadvice magit-section-show (after my-magit-selection-show-hook activate)
  (when (eq major-mode 'magit-status-mode)
   (recenter 5))
  )
(defadvice magit-section-hide (after my-magit-selection-show-hook activate)
  ;; (recenter)
  )

(defun my-auto-refresh-magit ()
  (let
      ((magit-buffer (--find (s-contains? "magit" (buffer-name it))
                             (buffer-list))))
    (when (not (eq (current-buffer) magit-buffer))
      (with-current-buffer magit-buffer
        (magit-refresh-buffer)))))
;; (cancel-timer (--find (eq (timer--function it) #'my-auto-refresh-magit)
;;                       timer-list))
;; (setq my-auto-refresh-magit-timer
;;       (run-at-time nil 5 #'my-auto-refresh-magit))

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
