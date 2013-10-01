(setq my-system-windows-p (string-match "windows" (symbol-name system-type)))

(defmacro if-windows (&rest list-of-expressions)
  `(when my-system-windows-p
     ,@list-of-expressions))


(defmacro if-bsd (&rest list-of-expressions)
  `(unless my-system-windows-p
     ,@list-of-expressions))

(eval-when-compile
  (require 's))

(defmacro if-hostname (name &rest body)
  "Example usage:
\(if-hostname urkaja2
  \(set some-var some-value\)
  \(set other-var other-val\)
  ... \)"
  (declare (indent defun))
  (if (equal (symbol-name name)
             (s-trim (shell-command-to-string "hostname")))
      `(progn ,@body)
    '(list 1)))
