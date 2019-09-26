(require 's)

(use-package git-gutter+
  :commands git-gutter+-mode
  ;; The toggle-things Hydra uses this as indicator, but it's unbound before the
  ;; package is imported.
  :init (setq git-gutter+-mode nil))

(use-package git-gutter-fringe+
  :after git-gutter+
  :commands git-gutter+-toggle-fringe)

(use-package gitignore-mode
  :ensure t)

(use-package git-commit
  :commands git-commit-setup
  :config
  (define-key git-commit-mode-map (kbd "C-c C-s") 'my-set-ticket))

(use-package magit-blame
  :commands magit-blame magit-blame-addition
  :bind (:map mode-specific-map
         ("C-M-g" . magit-file-dispatch))
  :config
  (define-key magit-blame-mode-map (kbd "q") 'magit-blame-quit))

(use-package magit
  :commands magit-status
  :bind (:map mode-specific-map
         ("C-g" . my-show-magit-status))
  :config
  (require 'magit-patch)
  (require 'magit-diff)
  (require 'magit-subtree)
  (require 'magit-gitignore)
  (require 'magit-blame)
  (define-key magit-mode-map (kbd "C-w") my-wnd-keys))


(defun my-show-magit-status ()
  (interactive)
  (when (fboundp 'neotree-hide)
    (neotree-hide))
  (call-interactively #'magit-status))


(defun my-magit-refresh-buffer-hook ()
  (when (and (eq major-mode 'magit-status-mode)
             (get-buffer-window))
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


(defun ediff-with-revision (rev)
  "Compare a file with itself, but from a specific revision. Uses
ediff. I wrote this before I knew magit."
  (interactive "s")
  (let
      ((fname (file-name-nondirectory (buffer-file-name)))
       (buf (get-buffer-create (format "*Git revision %s*" rev))))
    (shell-command (format "git show %s:./%s" rev fname) buf)
    (let ((ediff-split-window-function 'split-window-horizontally))
      (ediff-buffers buf (current-buffer)))))
