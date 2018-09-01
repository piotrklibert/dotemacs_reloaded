;;
;; HTML & Django templates mode
;;

(defun my-sgml-mode-hook ()
  (hs-minor-mode -1)
  (auto-complete-mode t)
  (linum-mode 1))

(use-package sgml-mode
  :mode "\\.\\(html\\|html\\)\\'"
  :config
  (add-hook 'sgml-mode-hook 'my-sgml-mode-hook)
  ;; somehow flymake doesn't want to work
  (delete '("\\.html?\\'" flymake-xml-init) flymake-allowed-file-name-masks))

(require 'web-mode-autoloads)

(defun my-web-close-tag ()
  (interactive)
  (web-mode-element-close))

(defvar web-mode-map)
(defun my-web-mode-hook ()
  (define-key web-mode-map (kbd "C-c /") 'web-mode-element-close) ; + (indent-for-tab-command)
  (define-key web-mode-map (kbd "C-c C-/") 'web-mode-element-close)
  )
(add-hook 'web-mode-hook 'my-web-mode-hook)
