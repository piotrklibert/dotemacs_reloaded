(defun load/expand (fname)
  (load-safe (f-expand fname)))

(defun load-many (&rest file-list)
  (dolist (file file-list)
    (load/expand file)))

(defun add-subdirs-to-path (&rest dirs)
  "Add given directory and all it's (immediate) subdirectories to load-path."
  (declare (indent 0))
  (dolist (dir dirs)
    (add-to-list 'load-path dir)
    (let
        ((default-directory dir))
      (normal-top-level-add-subdirs-to-load-path))))

(provide 'my-packages-utils)
