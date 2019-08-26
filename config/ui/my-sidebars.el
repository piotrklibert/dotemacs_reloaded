;; -*- mode: emacs-lisp -*- lexical-binding: t

;; Trees & sidebars
(require 'use-package)


(use-package speedbar
  :commands sr-speedbar-toggle
  :config (require 'sr-speedbar))

(use-package sidebar
  :commands sidebar-open)

(use-package sr-speedbar
  :after speedbar
  :bind (
         :map speedbar-mode-map
         ("C-<up>"  . speedbar-up-directory)
         ("<tab>"   . speedbar-expand-line)
         ("S-<tab>" . speedbar-expand-line-descendants)))

(use-package treemacs
  :commands treemacs)

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


(defun my-dirtree ()
  (interactive)
  (dirtree (f-dirname (buffer-file-name (current-buffer))) t))


(provide 'my-sidebars)
