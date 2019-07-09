(require 'org-macro)


(defvar be-credentials nil)
(defvar be-secrets-file-name)           ; provided as a buffer local in flow.org

(defconst be-default-credentials
  '(("test_instance" . "https://lightcorn-dev.truststamp.net/")
    ("test_username" . "cji")
    ("test_password" . "cji")))


(defun load-creds-from-file ()
  (when (boundp 'be-secrets-file-name)
    ;; `be-secrets-file-name' is local to the main buffer and would lose its
    ;; value inside `with-temp-buffer' below
    (let ((fn be-secrets-file-name))
      (condition-case err
          (read (with-temp-buffer
                  (insert-file-contents fn)
                  (buffer-substring-no-properties (point-min)
                                                  (point-max))))
        (file-missing
         (message "\n*** Cannot find credentials file to execute examples. ***")
         (message "\t(tried loading from: '%s')" (car (last err)))
         (message "*** Falling back to the default credentials: ***\n")
         (pp be-default-credentials)
         (message "\nPlease review the settings in case of errors in example scripts.\n")
         be-default-credentials)))))


(defun append-creds-to-macro-templates ()
  (setf org-macro-templates
        (append org-macro-templates (be-get-config-values))))


(defun be-get-config-values ()
  (or be-credentials
      (setq be-credentials (load-creds-from-file))))


(provide 'be-config)
