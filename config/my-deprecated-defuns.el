

(define-key my-wnd-keys (kbd "C-l")                 'switch-to-last-dired)

(defun switch-to-last-dired ()
  "Find a dired buffer and switch to it in one command."
  (interactive)
  (let ((bufs (buffer-list)))
    (catch 'no-more-bufs
      (dolist (b bufs)
        (with-current-buffer b
          (when (eq major-mode 'dired-mode)
              (switch-to-buffer b)
              (throw 'no-more-bufs nil))))
      (message "No direds open!"))))
