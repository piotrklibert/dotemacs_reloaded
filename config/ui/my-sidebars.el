;; -*- mode: emacs-lisp -*- lexical-binding: t

;; Trees & sidebars
(require 'use-package)


(use-package speedbar
  :commands sr-speedbar-toggle)


(use-package sr-speedbar
  :after speedbar
  :bind (
         :map speedbar-mode-map
         ("C-<up>"  . speedbar-up-directory)
         ("<tab>"   . speedbar-expand-line)
         ("S-<tab>" . speedbar-expand-line-descendants)))


(use-package sidebar
  :commands sidebar-open)


(use-package treemacs
  :commands treemacs
  :bind (("<f1>" . treemacs)))

(use-package neotree
  :bind (("C-<f1>" . neotree-toggle)
         :map neotree-mode-map
         ("C-d" .       'neotree-delete-node)
         ("D" .         'neotree-delete-node)
         ("C-<up>" .    'neotree-select-up-node)
         ("C-o" .       'neotree-hidden-file-toggle)
         ("<delete>" .  'neotree-delete-node)
         ("r" .         'neotree-rename-node)
         ("l" .         'neotree-add-dir-to-load-path)))

(use-package dirtree
  :commands dirtree)

(use-package ztree
  :commands ztree-dir ztree-diff
  :config (setq ztree-draw-unicode-lines t))

(defalias 'my-switch-to-neotree 'my-switch-to-column-1)

(defun neotree-add-dir-to-load-path ()
  (interactive)
  (let ((path (neo-buffer--get-filename-current-line)))
    (when (f-dir? path)
      (add-to-list 'load-path path)
      (message "Added '%s' to `load-path'" path))))


(defun neotree-open-file-in-eaf ()
  "Open file on current line in an EAF instance. It uses browser
widget when it's a HTML file and simply calls `eaf-open'
otherwise."
  (interactive)
  (let ((fname (neo-buffer--get-filename-current-line)))
    (if (s-suffix-p ".html" fname)
        (eaf-open-url (concat "file://" fname))
      (eaf-open fname))))


(defun my-dirtree ()
  (interactive)
  (dirtree (f-dirname (buffer-file-name (current-buffer))) t))


(provide 'my-sidebars)
