(require 'dash)

(defvar my-indent-auto-mark-excludes '((indent-region-or-line     . ignore)
                                       (indent-for-tab-command    . ignore)
                                       (python-indent-shift-right . ignore)
                                       (python-indent-shift-left  . ignore)
                                       (my-indent                 . ignore)
                                       (my-dedent                 . ignore)
                                       (open-rectangle            . ignore)))

(setq auto-mark-command-class-alist (-union auto-mark-command-class-alist
                                            my-indent-auto-mark-excludes))

(global-set-key (kbd "C-M->") 'my-indent)
(global-set-key (kbd "C-M-<") 'my-dedent)

;; TODO: Move to utils module
(defun my-get-region-or-line-bounds ()
  (let ((active? (use-region-p)))
    (list active?
          (or (and active? (region-beginning))
              (line-beginning-position))
          (or (and active? (region-end))
              (line-end-position)))))

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
