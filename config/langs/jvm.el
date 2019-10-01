(require 'cc-mode)

(require 'use-package)


(use-package lsp-mode)
(use-package lsp-ui)
(use-package lsp-ivy)
(use-package lsp-treemacs)

(use-package helm-lsp)
;; (use-package company-lsp)

(use-package lsp-java
  :after lsp-mode
  :hook ((java-mode . lsp)
         (java-mode . lsp-ui-mode)))

;; (use-package dap-mode
;;   :config
;;   (dap-mode t)
;;   (dap-ui-mode t))

;; (use-package dap-java
;;   :after lsp-java)

;; Enable scala-mode and sbt-mode
(use-package scala-mode
  :hook ((scala-mode . lsp)
         (scala-mode . lsp-ui-mode)
         (scala-mode . my-scala-mode-hook))
  :mode "\\.s\\(cala\\|bt\\)$")

(defun my-scala-mode-hook ()
  (push 'ac-source-lsp-completions ac-sources))


(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition 'minibuffer-complete-word 'self-insert-command
                             minibuffer-local-completion-map))

;; Enable nice rendering of diagnostics like compile errors.
(use-package flycheck
  :init (global-flycheck-mode))


(use-package groovy-mode
  :hook ((groovy-mode . lsp)
         (groovy-mode . lsp-ui-mode))
  :mode (("\\.groovy\\'" . groovy-mode)
         ("Jenkinsfile\\'" . groovy-mode))
  :custom ((groovy-indent-offset 4)))


(defun lsp-ui-doc--render-buffer (string symbol)
  "Set the buffer with STRING."
  (lsp-ui-doc--with-buffer
   (if lsp-ui-doc-use-webkit
       (progn
         (lsp-ui-doc--webkit-execute-script
          (format
           "renderMarkdown('%s', '%s');"
           symbol
           (url-hexify-string string))
          'lsp-ui-doc--webkit-resize-callback))
     (erase-buffer)
     (let ((inline-p (lsp-ui-doc--inline-p)))
       (insert (concat (unless inline-p (propertize "\n" 'face '(:height 0.2)))
                       (-> (replace-regexp-in-string "`\\([\n]+\\)" "" string)
                           (string-trim-right))
                       (unless inline-p (propertize "\n\n" 'face '(:height 0.3))))))
     (lsp-ui-doc--make-clickable-link))
   (setq-local face-remapping-alist `((header-line lsp-ui-doc-header)))
   (setq-local window-min-height 5)
   (setq-local window-min-width 65)
   (setq header-line-format (when lsp-ui-doc-header (concat " " symbol))
         mode-line-format nil
         cursor-type nil)))
