(defun new-buf ()
  (switch-to-buffer-other-window (get-buffer-create "Argh")))

(with-current-buffer (new-buf)
  (erase-buffer)
  (insert (format "%s" (my-semantic-completions "^Act.*Handler$")))
  (pp-buffer))
