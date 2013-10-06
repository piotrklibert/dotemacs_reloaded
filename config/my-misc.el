(rquire 'dash)

(defun get-defuns-from-file ()
  "Append a list of defuns in the current buffer at the and of it
or after a special string, which is two semicolons followed by
space and a ToC string. This string is constructed
programmatically in case the function is called on the file it is
defined in."
  (interactive)
  (let ((toc-string (concat ";;" " " "ToC"))
        (forms '())
        (form '())
        (funs '()))
    (save-excursion
      (goto-char 1)
      (while (setq form (safe-read-sexp))
        (setq forms (cons form forms))))
    (setq funs (--keep (when (eq 'defun (car it))
                         (cadr it))
                       (reverse forms)))
    (save-excursion
      (goto-char 1)
      (condition-case nil
          (search-forward toc-string)
        (error (goto-char (point-max))
               (newline)
               (insert toc-string)))
      (newline)
      (delete-region (line-beginning-position) (point-max))
      (--each funs (insert (format ";; %s\n" it))))))

(provide 'my-misc)
