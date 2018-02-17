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
