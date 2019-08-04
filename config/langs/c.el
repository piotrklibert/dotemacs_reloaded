(defun my-semantic-goto-definition ()
  (interactive)
  (xref-push-marker-stack)
  (semantic-ia-fast-jump (point)))

(defun my-c++-hook ()
  (semantic-mode 1)
  (local-set-key (kbd "M-.") #'my-semantic-goto-definition))

(add-hook 'c++-mode-hook 'my-c++-hook)
(add-hook 'c-mode-hook 'my-c++-hook)

;; (add-to-list 'load-path "/path/to/ac-irony")

;; (defun my-ac-irony-setup ()
;;   (add-to-list 'ac-sources 'ac-source-irony)
;;   (define-key irony-mode-map (kbd "M-RET") 'ac-complete-irony-async))

;; (add-hook 'irony-mode-hook 'my-ac-irony-setup)
