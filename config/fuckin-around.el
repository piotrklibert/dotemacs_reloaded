(require 's)
(require 'dash)
(require 'cl)

(defun magic-dir-p (dir)
  (member dir (list "." "..")))

(defun walk-d ()
  (let ((z (directory-files  "~/.emacs.d/"))
        (s '())
        (f '()))
    (while (or s z)
      (while (magic-dir-p (car z)) (pop z))
      (when (not z)
        (setq z (pop s)))

      ;; (message "%s" (car z))
      (push (car z) f)

      (if (not (file-directory-p (car z)))
          (pop z)
        (when (cdr z)
          (push (cdr z) s))
        (setq z (directory-files (car z)))))
    f))

;; (length (walk-d))

(defun grep-todos ()
  (let
      ((files (--filter (string-match "^[a-z].*.el$" it)
                        (directory-files "~/.emacs.d/config/")))
       (todos '()))
    (loop for file in files
          do (with-temp-buffer
               (insert-file-contents file)
               (goto-char (point-min))
               (message (buffer-substring (line-beginning-position)
                                          (line-end-position))
               (while (condition-case nil
                          (search-forward "TODO")
                        (error nil))
                 (push (buffer-substring-no-properties (line-beginning-position)
                                                       (line-end-position))
                       todos))))
          todos))
(grep-todos)
