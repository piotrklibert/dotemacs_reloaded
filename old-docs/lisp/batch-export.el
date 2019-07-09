;; -*- mode: emacs-lisp -*-
(require 'subr-x)
(require 'shell)
(require 'cl-lib)


(add-to-list 'load-path (expand-file-name "."))
(add-to-list 'load-path (expand-file-name "org-mode/lisp/"))
(add-to-list 'load-path (expand-file-name "org-mode/contrib/lisp/"))


(require 'org)
(require 'ob)
(require 'ox-html)
(require 'ob-shell)

(require 'json-mode)
(require 'htmlize)


(require 'be-config)
(require 'be-custom)
(require 'be-faces)
(require 'be-macros)


(provide 'batch-export)


;; HACK: make element ids numerical and the numbers monotonically rising - and
;; pray that the function is not called more than once for a single element,
;; as the processed elements are not cached.
(defvar reference-counter 0)

(defun org-export-get-reference-around  (orig a b)
  (setq reference-counter (1+ reference-counter))
  (format "%s" reference-counter))
(advice-add 'org-export-get-reference
            :around #'org-export-get-reference-around)


;; TODO: read it from env or command-line-args/command-line-args-left
(defconst be-tangle t)
(defconst be-export t)
(defconst be-export-execute nil)


(when noninteractive
  (message "Opening main source file...")

  ;; NOTE: this changes default-directory (cwd) to ".." (ie. lightcorn/docs/)
  (find-file "../flow.org")

  (message "\nGenerating test scripts...\n")
  (when be-tangle
    (org-babel-tangle))

  ;; (message "\nRunning tests...\n")
  ;; (let ((proc (make-process :name "run_poppy.sh"
  ;;                           :command '("sh" "./scripts/run_poppy.sh")
  ;;                           :filter (lambda (proc out) (message "%s" out)))))
  ;;   (while (not (eq (process-status proc) 'exit))
  ;;     (accept-process-output proc 1)))


  (when be-export
    (require 'be-exp)
    (message "\nExporting to HTML...\n")
    (be-export be-export-execute))

  (message "\nDone!"))
