(require 's)
(require 'f)
(require 'cl)
(require 'dash)


(defconst my-hostname (s-trim (shell-command-to-string "hostname")))


(defun hostname-p (name)
  (let ((name (or (and (symbolp name) (symbol-name name)) name)))
    (equal name my-hostname)))


(defmacro my-if-hostname (name &rest body)
  (declare (indent defun))
  (if (hostname-p name)
      `(progn ,@body)
    '(list 1)))


(defmacro my-match-hostname (&rest body)
  (declare (indent 0))
  (let ((conds (loop for condition in body
                     collect `((hostname-p ',(car condition))
                               ,@(cddr condition)))))
    `(cond ,@conds)))

;; (my-match-hostname
;;  (f25b t t nil)
;;  (urkaja t))

(defmacro make-self-quoting (name)
  "Make NAME into a self-quoting function like `lambda'."
  `(defmacro ,name (&rest cdr)
     (list 'function (cons ',name cdr))))

(make-self-quoting closure)             ; some plugin uses `closure' instead of
                                        ; `function', which is not defined by default


(provide 'my-system-config)
