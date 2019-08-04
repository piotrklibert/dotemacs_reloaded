;;; my-hideshow.el --- setup for hideshow-mode  -*- lexical-binding: t -*-
(require 'hideshow)


(define-key prog-mode-map (kbd "C-c <left>") 'hs-toggle-hiding)


(defvar-local my-hs-global-toggle-hiding-state t
  "t means show all, nil hide all")


(defun my-hs-global-toggle-hiding ()
  (interactive)
  (if my-hs-global-toggle-hiding-state
      (hs-show-all)
    (hs-hide-all))
  (setf my-hs-global-toggle-hiding-state (not my-hs-global-toggle-hiding-state)))


(defun my-hs-hide-comment-block ()
  (interactive)
  (hs-hide-comment-region (point)
                          (save-excursion
                            (while (forward-comment 1))
                            (point))))


(defun my-setup-hs-minor-mode ()
  (hs-minor-mode 1)
  (define-key mode-specific-map (kbd "C-M-=") 'my-hs-global-toggle-hiding)
  (define-key mode-specific-map (kbd "h") 'hs-toggle-hiding))


(provide 'my-hideshow)
