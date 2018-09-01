(add-hook 'prog-mode-hook  'my-init-prog-mode)
;; some languages modes don't derive from prog-mode and don't run prog-mode
;; hooks
(add-hook 'nim-mode-hook   'my-init-prog-mode)
(add-hook 'io-mode-hook    'my-init-prog-mode)

(defun my-setup-hs-minor-mode ()
  (hs-minor-mode 1)
  (-> (current-local-map)
    (K (define-key (kbd "s--") 'hs-hide-block))
    (K (define-key (kbd "s-=") 'hs-show-block))
    (K (define-key (kbd "C-s-=") 'hs-show-all))
    (K (define-key (kbd "C-s-=") 'hs-hide-all))))

(add-hook 'nxml-mode-hook 'my-setup-hs-minor-mode)
(require 'diminish)

(defun my-init-prog-mode ()
  ;; modes which should be enabled by default for every prog mode:
  (electric-pair-mode 1)
  (fic-ext-mode 1)          ; Show FIXME TODO in special face
  (rainbow-mode 1)          ; bg color for eg #0000ff,  white , blue background.
  (rainbow-delimiters-mode 1)
  (hl-line-mode 1)                      ; highlight current line
  (undo-tree-mode 1)
  (delete-selection-mode 1)
  (flymake-mode 1)
  (linum-mode 1)

  (turn-on-fuzzy-isearch)               ; complement: turn-off-fuzzy-isearch
  (show-paren-mode t)                   ; highlight matching parens
  (column-number-mode t)                ; show col num on modeline

  (diminish 'rainbow-mode)
  (diminish 'fic-ext-mode)
  (diminish 'hs-minor-mode)
  (diminish 'eldoc-mode)
  (diminish 'wrap-region-mode)
  (diminish 'paredit-mode)
  (diminish 'auto-complete-mode)
  (diminish 'undo-tree-mode)

  ;; (global-linum-mode 1) ; disabled: made pdf viewing (Doc Mode) unusable
  ;; (fci-mode 1) ; fill column indicator - broke Org exports among other things

  ;; make sure this isn't remapped. I'm too accustomed to this binding by now.
  (local-set-key (kbd "C-x C-x") 'exchange-point-and-mark)

  ;; Some modes should be present in *almost* all prog-modes. Here we deal with
  ;; exclusions.
  (let ((mm major-mode))
    (unless (memq mm '(python-mode sql-mode))
      (my-setup-hs-minor-mode))))


(add-hook 'before-save-hook 'delete-trailing-whitespace)


(provide 'my-generic-programming-init-hook)
