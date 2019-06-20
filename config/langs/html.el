;;
;; HTML & Django templates mode
;;

(defun my-sgml-mode-hook ()
  (require 'tidy)
  (hs-minor-mode -1)
  (auto-complete-mode t)
  (linum-mode 1))

(use-package sgml-mode
  :mode "\\.\\(html\\|html\\)\\'"
  :config
  (add-hook 'sgml-mode-hook 'my-sgml-mode-hook)
  ;; somehow flymake doesn't want to work
  (delete '("\\.html?\\'" flymake-xml-init) flymake-allowed-file-name-masks))


(defun my-html-mode-hook () "Customize my html-helper-mode."
  (tidy-build-menu html-helper-mode-map)
  (local-set-key [(control c) (control c)] 'tidy-buffer)
  (setq sgml-validate-command "tidy"))

(add-hook 'html-helper-mode-hook 'my-html-mode-hook)

(require 'web-mode-autoloads)

(defun my-web-close-tag ()
  (interactive)
  (web-mode-element-close))

(defvar web-mode-map)
(defun my-web-mode-hook ()
  (require 'tidy)
  (define-key web-mode-map (kbd "C-c /") 'web-mode-element-close) ; + (indent-for-tab-command)
  (define-key web-mode-map (kbd "C-c C-/") 'web-mode-element-close)
  )
(add-hook 'web-mode-hook 'my-web-mode-hook)
