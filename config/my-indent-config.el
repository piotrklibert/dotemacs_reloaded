;; Make indent operations leave region active when done. It's a pain to press
;; C-x C-x after indenting a block just to be able indent it a bit more.

(require 'my-utils)

(defvar my-auto-mark-excludes
  '((indent-region-or-line               . ignore)
    (indent-for-tab-command              . ignore)
    (python-indent-shift-right           . ignore)
    (python-indent-shift-left            . ignore)
    (my-indent                           . ignore)
    (my-dedent                           . ignore)
    (open-rectangle                      . ignore)
    (comment-or-uncomment-region-or-line . ignore)))

(setq auto-mark-command-class-alist (-union auto-mark-command-class-alist
                                            my-auto-mark-excludes))

(global-set-key (kbd "C-M->") 'my-indent)
(global-set-key (kbd "C-M-<") 'my-dedent)

(defun ensure-mark-active ()
  "Force mark to be active, even if something tried to deactivate
it before."
  (setq deactivate-mark nil)
  (setq mark-active t))

(defadvice indent-rigidly
  (after indent-rigidly-keep-region activate)
  (setq deactivate-mark nil))

(defadvice indent-for-tab-command       ; ie. TAB in elisp mode
  (around indent-for-tab-keep-region activate)
  (let ((region-info (my-get-region-or-line-bounds)))
    ad-do-it
    (when (car region-info)
     (setq deactivate-mark nil)
     (setq mark-active t))))

(defun my-indent-rigidly (dir &optional arg)
  (unless arg
    (setq arg 4))
  (destructuring-bind
      (region-was-active? start end) (my-get-region-or-line-bounds)
    (indent-rigidly start end (funcall dir arg))))

(defun my-indent (&optional arg)
  (interactive "P")
  (when (and arg (listp arg))
    (setq arg (car arg)))
  (my-indent-rigidly '+ arg))

(defun my-dedent (&optional arg)
  (interactive "P")
  (when (and arg (listp arg))
    (setq arg (car arg)))
  (my-indent-rigidly '- arg))


(provide 'my-indent-config)
