(require 'cl)
(require 's)
(require 'dash)

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
      (push (car z) f)
      (if (not (file-directory-p (car z)))
          (pop z)
        (when (cdr z)
          (push (cdr z) s))
        (setq z (directory-files (car z)))))
    f))

;; (length (walk-d))


(defvar my-config-path "~/.emacs.d/config/")

(defun grep-todos ()
  "Grep files in config/ directory for TODOs and insert them
after point."
  (interactive)
  (let ((files (--filter (string-match "^[a-z].*.el$" it)
                         (directory-files my-config-path)))
        (todos '()))
    (loop for file in files
          do (with-temp-buffer
               (insert-file-contents (concat my-config-path file))
               (goto-char (point-min))
               (while (condition-case nil
                          (search-forward "TODO")
                        (error nil))
                 (push (list file
                             (line-number-at-pos)
                             (buffer-line-np))
                       todos))))
    (while (car todos)
      (let ((todo (pop todos)))
        (insert (apply 'format "%40s::%6s %s\n" todo) )
        (open-line 1)))))
;; (grep-todos)


;; find . -not -iname "*.elc" -not -ipath "*.git*" -not -path "*semanticdb*" -type f -exec ls -l \{\} \; | column -t | awk '{print $5}' | sum

(provide 'my-utils)
