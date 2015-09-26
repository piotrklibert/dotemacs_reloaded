(require 's)
(require 'f)
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


(defmacro add-subdirs-to-path (&rest dirs)
  "Add given directory and all it's (immediate) subdirectories to load-path."
  ;; TODO: rewrite this as a proper macro (could be a function as it is now)
  `(dolist (dir (list ,@dirs))
     (add-to-list 'load-path dir)
     (let
       ((default-directory dir))
       (normal-top-level-add-subdirs-to-load-path))))

(require 'edit-server)
(edit-server-start t)

(defun my-edit-server-hook ()
  (elscreen-toggle-display-tab)
  ;; (markdown-mode)
  )

(add-hook 'edit-server-edit-mode-hook 'delete-other-windows)
(add-hook 'edit-server-edit-mode-hook 'my-edit-server-hook)
