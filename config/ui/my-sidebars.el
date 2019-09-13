;; -*- mode: emacs-lisp -*- lexical-binding: t

;; Trees & sidebars
(require 'use-package)


(use-package speedbar
  :bind (
         :map speedbar-mode-map
         ([tab] . speedbar-toggle-line-expansion)
         ("h" . speedbar-toggle-show-all-files)
         ("C-<up>"  . speedbar-up-directory)
         ("<backtab>" . speedbar-expand-line-descendants))
  )

;; TODO: customize - speedbar-file-unshown-regexp
;; TODO: not all icons are displayed sometimes

(use-package sr-speedbar
  :after speedbar
  :commands sr-speedbar-toggle
  :bind ("C-c <f1>" . sr-speedbar-toggle))


(use-package sidebar
  :commands sidebar-open)


(use-package treemacs
  :commands treemacs
  :bind (("<f1>" . treemacs)))


(defun my-neotree-toggle (prefix-arg)
  (interactive "p")
  (if (not prefix-arg)
      ;; no C-u
      (call-interactively 'neotree-toggle)
    (case prefix-arg
      ;; C-u
      (4 (neotree-dir (f-dirname (buffer-file-name))) )
      ;; C-u C-u
      (16 (neotree-dir (projectile-project-root)))
      ;; 3+ x C-u or worse
      (t  (call-interactively 'neotree-toggle)))))


(use-package neotree
  :commands neotree-dir
  :bind (("C-<f1>" . my-neotree-toggle)
         :map neotree-mode-map
         ("C-d" .       'neotree-delete-node)
         ("D" .         'neotree-delete-node)
         ("C-<up>" .    'neotree-select-up-node)
         ("C-o" .       'neotree-hidden-file-toggle)
         ("<delete>" .  'neotree-delete-node)
         ("r" .         'neotree-rename-node)
         ("l" .         'neotree-add-dir-to-load-path)))

(use-package dirtree
  :commands dirtree
  :bind (("C-c C-<f1>" . my-dirtree)
         :map dirtree-mode-map
         ([tab] . tree-mode-toggle-expand)
         ("C-<up>" . my-dirtree-up)))

(use-package ztree
  ;; ztree-dir would need a lot of bindings to work; ztree-diff actually works
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

(defun my-dirtree-up ()
  (interactive)
  (save-excursion
    (goto-char (+ (point-min) 4))
    (let ((parent (f-parent (buffer-substring-no-properties (point) (line-end-position))))
          (inhibit-read-only t))
      (erase-buffer)
      (dirtree parent t))))

(defun my-dirtree ()
  (interactive)
  (dirtree (aif (buffer-file-name (current-buffer))
               (f-dirname it)
             default-directory) t))


(provide 'my-sidebars)
