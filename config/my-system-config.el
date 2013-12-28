(require 's)
(require 'cl)                           ; no idea why would this be bad...
(require 'dash)

;; TODO: maybe make it into `cond-hostname' ?
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

;; TODO: this is generally what package-initialize does... But not all the
;; plugins are packaged.
(defmacro add-subdirs-to-path (&rest dirs)
  "Add given directory and all it's (immediate) subdirectories to load-path."
  `(dolist (dir (list ,@dirs))
     (add-to-list 'load-path dir)
     (let
       ((default-directory dir))
     (normal-top-level-add-subdirs-to-load-path))))
