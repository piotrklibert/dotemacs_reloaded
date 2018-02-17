(require 'ob)
(require 'livescript-mode)

(eval-when-compile (require 'cl))
(defvar org-babel-tangle-lang-exts) ;; Autoloaded
(add-to-list 'org-babel-tangle-lang-exts '("livescript" . "ls"))
(add-to-list 'org-src-lang-modes '("ls" . livescript))


(defvar org-babel-default-header-args:ls '())
(defvar org-babel-ls-command "lsc"
  "Name of the command to use for executing LiveScript code.")

(defvar org-babel-ls-wrapper-method ""
  "Code in which to wrap the script being run")


(defun org-babel-execute:ls (body params)
  "Execute a block of LS code with org-babel.  This function is
called by `org-babel-execute-src-block'"

  (message "Executing LS source code block")

  (let* ((processed-params (org-babel-process-params params))
         (session nil)
         (vars "") ;;#1
         (result-params (nth 2 processed-params))
         (result-type (cdr (assoc :result-type params)))
         (full-body (org-babel-expand-body:generic body params))
         (result (org-babel-ls-evaluate (concat vars "\n\n" full-body))))
    (message "%s" (concat vars full-body))

    (org-babel-reassemble-table
     result
     (org-babel-pick-name
      (cdr (assoc :colname-names params)) (cdr (assoc :colnames params)))
     (org-babel-pick-name
      (cdr (assoc :rowname-names params)) (cdr (assoc :rownames params))))))


(defun org-babel-ls-evaluate (body)
  (if (member "repl" result-params)
      (org-babel-eval org-babel-ls-command body)

    (let ((src-file (org-babel-temp-file "ls-")))
      (progn (with-temp-file src-file (insert body))
	     (org-babel-eval (concat org-babel-ls-command " " src-file) "")))))




(provide 'ob-ls)
