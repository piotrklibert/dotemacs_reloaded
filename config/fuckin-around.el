;; **SCRATCH BUFFER **

(require 's)
(require 'dash)
(require 'cl)


(defun dirz ()
  (let ((stack '()))
    )
  )
(setq x '(8  (9 8 7 (0 1 0)) 8 7 6))
(pop x)
(defun walk-x ()
  (let ((z x)
        (s '()))
    (while (or s z)
      (if (not z)
          (setq z (pop s)))
      (message "%s" (car z))
      (if (not (listp (car z)))
          (setq z (cdr z))
        (when (cdr z)
          (push (cdr z) s))
        (setq z (car z))))))

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

(length (walk-d))
