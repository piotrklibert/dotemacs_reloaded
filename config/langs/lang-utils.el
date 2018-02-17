(defun indent/tag-for-modes (modes tags)
  (loop for tag in tags
        do (loop for mode in modes
                 do (put (car tag) mode (cdr tag)))))

(defun font-lock-for-modes (modes config)
  (loop for mode in modes
        do (font-lock-add-keywords mode config)))

(provide 'lang-utils)
