(require 'ein)
(setq ein:use-auto-complete t)
;; TODO: make some keybinding

(require 'elpy)
(require 'django-mode)
(require 'python-django)

(elpy-enable)                       ; adds (elpy-mode) as a hook for python-mode
(elpy-use-ipython)


;;
;;                           Additional keybindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-elpy-mode-setup ()
   (local-set-key (kbd "C-M->") 'python-indent-shift-right)
   (local-set-key (kbd "C-M-<") 'python-indent-shift-left))

(add-hook 'elpy-mode-hook 'my-elpy-mode-setup)
