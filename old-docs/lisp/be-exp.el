(require 'org)
(require 'be-config)


(defun be-dump-results-to-console (result &rest _)
  (message "\n%s\n" result))


(defun be-die-on-error (code stderr)
  (message "\n%s" stderr)
  (kill-emacs code))


(defun be-export (execute?)
  ;; Display results of block evaluation as soon as they are executed
  (advice-add 'org-babel-insert-result :before 'be-dump-results-to-console)

  ;; Stop processing immediately in case a block returns non-zero error code
  (advice-add 'org-babel-eval-error-notify :after 'be-die-on-error)

  ;; Enable or disable code block evaluation during export
  ;; NOTE: make sure there's no `:eval' in #+PROPERTY: header-args in the org
  ;; file as it would override `org-babel-default-header-args' set here
  (setq org-babel-default-header-args
        (append `((:eval . ,(if execute? "export" "no-export")))
                (delq :eval org-babel-default-header-args)))

  (org-html-export-to-html))


(provide 'be-exp)
