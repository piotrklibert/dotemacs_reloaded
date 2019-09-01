(require 'use-package)


(defun my-helm-M-x-outside (&rest args)
  (interactive)
  (let ((helm-split-window-inside-p nil))
    (call-interactively 'helm-M-x)))


(use-package sunrise
  :commands sunrise sunrise-cd
  :init
  (global-set-key (kbd "C-<f3>") 'sunrise)
  (global-set-key (kbd "M-<f3>") 'sunrise-cd)
  :config
  (define-key sunrise-mode-map (kbd "C-<prior>") 'elscreen-previous)
  (define-key sunrise-mode-map (kbd "C-<up>") 'sunrise-dired-prev-subdir)
  (define-key sunrise-mode-map (kbd "C-<f3>") 'sunrise-quit)
  (define-key sunrise-mode-map (kbd "M-x") 'my-helm-M-x-outside)
  (require 'sunrise-tree)
  (require 'sunrise-modeline))


(provide 'my-sunrise)
