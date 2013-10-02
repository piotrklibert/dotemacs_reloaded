(require 'cl)

(defun buffer-line (&optional lineno)
  (when lineno
    (goto-line lineno))
  (buffer-substring (line-beginning-position)
                    (line-end-position)))

(defun buffer-line-np (&optional lineno)
  (when lineno
    (goto-line lineno))
  (buffer-substring-no-properties (line-beginning-position)
                                  (line-end-position)))

(defun my-get-region-or-line-bounds ()
  (let ((active? (use-region-p)))
    (list active?
          (or (and active? (region-beginning))
              (line-beginning-position))
          (or (and active? (region-end))
              (line-end-position)))))

(provide 'my-utils)
