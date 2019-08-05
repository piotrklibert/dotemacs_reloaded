(require 's)

(use-package git-gutter-fringe+
  :if window-system
  :ensure t
  :config
  (global-git-gutter+-mode t))

(use-package gitignore-mode
  :ensure t)

(use-package git-commit
  :commands git-commit-setup
  :config
  (define-key git-commit-mode-map (kbd "C-c C-s") 'my-set-ticket))

(use-package magit-blame
  :commands magit-blame)

(use-package magit
  :commands magit-status
  :config
  (require 'magit-patch)
  (require 'magit-diff)
  (require 'magit-subtree)
  (require 'magit-gitignore)
  (define-key magit-mode-map (kbd "C-w") my-wnd-keys))

(defun my-show-magit-status ()
  (interactive)
  (neotree-hide)
  (magit-status))

(define-key mode-specific-map (kbd "C-g")   'my-show-magit-status) ; C-c C-g
(define-key mode-specific-map (kbd "C-M-g") 'magit-blame)  ; C-c C-M-g


(defadvice magit-section-show (after my-magit-selection-show-hook activate)
  (when (eq major-mode 'magit-status-mode)
    (ignore-errors (recenter 5))))

(defadvice magit-section-hide (after my-magit-selection-show-hook activate)
  ;; (recenter)
  )


(defun my-magit-refresh-buffer-hook ()
  (when (eq major-mode 'magit-status-mode)
   (recenter)))

(add-hook 'magit-refresh-buffer-hook 'my-magit-refresh-buffer-hook)

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
  (auto-fill-mode)
  ;; (progn
  ;;   (unless my-current-ticket-name
  ;;     (setq my-current-ticket-name
  ;;           (read-string "Ticket name: ")))
  ;;   (goto-char (point-min))
  ;;   (unless (= 0 (length my-current-ticket-name)) ; don't insert a space if not needed
  ;;     (insert my-current-ticket-name " ")
  ;;     (save-excursion
  ;;       (newline)
  ;;       (newline))))
  )

(add-hook 'git-commit-mode-hook #'my-magit-commit-hook)
