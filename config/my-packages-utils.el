;; -*- mode: emacs-lisp -*-

(defmacro measure-time (s &rest body)
  "Measure the time it takes to evaluate BODY."
  `(let ((time (current-time)))
     ,@body
     (message "Loading %s took: %.06f" ,s (float-time (time-since time)))))



(defun load-expand (fname)
  (load-safe (f-expand fname)))

(defun load-many (&rest file-list)
  (dolist (file file-list)
    (load-expand file)))



(defmacro load-safe (arg)
  `(condition-case err
       (measure-time ,arg (load ,arg))
     (error (my-log (propertize "Couldn't load: %s %s" 'face 'error)
                    ,arg err))))


(defun add-subdirs-to-path (&rest dirs)
  "Add given directory and all it's (immediate) subdirectories to load-path."
  (declare (indent 0))
  (dolist (dir dirs)
    (add-to-list 'load-path dir)
    (let
        ((default-directory dir))
      (normal-top-level-add-subdirs-to-load-path))))

(provide 'my-packages-utils)
