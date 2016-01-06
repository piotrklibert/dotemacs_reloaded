(defun indent/tag-for-modes (modes tags)
  (loop for tag in tags
        do (loop for mode in modes
                 do (put (car tag) mode (cdr tag)))))

(provide 'lang-utils)
