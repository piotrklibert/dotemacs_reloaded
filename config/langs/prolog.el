(require 'flymake)

(defun flymake-prolog-init ()
  (let* ((temp-file   (flymake-proc-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "swipl" (list "-q" "-t" "halt" "-s " local-file))))


(defun my-prolog-hook ()
  (require 'flymake)
  (make-local-variable 'flymake-allowed-file-name-masks)
  (make-local-variable 'flymake-err-line-patterns)
  (setq flymake-proc-err-line-patterns
        '(("ERROR: (?\\(.*?\\):\\([0-9]+\\)" 1 2)
          ("Warning: (\\(.*\\):\\([0-9]+\\)" 1 2)))
  (setq flymake-proc-allowed-file-name-masks '(("\\.pl\\'" flymake-prolog-init)))
  (flymake-mode 1))


(use-package prolog
  :mode ("\\.pl\\'" . prolog-mode)
  :config (add-hook 'prolog-mode-hook 'my-prolog-hook))
