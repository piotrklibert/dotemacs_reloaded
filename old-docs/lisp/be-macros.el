(require 'org)
(require 'be-config)


(defvar my-org-macros-alist nil)

(defun my-get-local-macros (&optional list)
  (condition-case nil
      (org-macro-initialize-templates)))

(defun my-get-global-macros ()
  (append (be-get-config-values)
          (my-get-local-macros)))


(cl-defun my-org-macro-replace-all-in-string (code &optional templates)
  (let ((templates (or my-org-macros-alist (append (my-get-global-macros) templates))))
    (with-temp-buffer
      (insert code)
      (goto-char (point-min))
      (org-macro-replace-all templates)
      (buffer-substring-no-properties (point-min)
                                      (point-max)))))

;; replace macros with their value during evaluation
(defun be-org-babel-expand-noweb-references-advice (fn &optional info pb)
  (my-org-macro-replace-all-in-string (funcall fn info pb)))

(advice-add 'org-babel-expand-noweb-references
            :around #'be-org-babel-expand-noweb-references-advice)


;; replace macros with their values in code block when exporting them
(defun my-org-html-format-code-advice (fn code &rest args)
  (apply fn (my-org-macro-replace-all-in-string code) args))

(advice-add 'org-html-do-format-code
            :around #'my-org-html-format-code-advice)



(defun my-babel-tangle-advice (fn &rest args)
  (let ((my-org-macros-alist (my-get-global-macros)))
    (apply fn args)))

(advice-add 'org-babel-tangle
            :around #'my-babel-tangle-advice)

(defun my-babel-expand-macros (spec)
  (let*
      ((content (buffer-substring-no-properties (point-min) (point-max)))
       (content (my-org-macro-replace-all-in-string
                 content
                 (append (org-macro-initialize-templates)
                         my-org-macros-alist))))
    (erase-buffer)
    (insert content)))

(advice-add 'org-babel-spec-to-string
            :after #'my-babel-expand-macros)


(provide 'be-macros)
