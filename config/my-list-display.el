(defun new-buf ()
  (switch-to-buffer-other-window (get-buffer-create "Argh")))

(defun semsearch (arg)
  (interactive "s> ")
  (with-current-buffer (new-buf)
    (erase-buffer)
    (insert (format "%s" (my-semantic-completions arg)))
    (pp-buffer)))
