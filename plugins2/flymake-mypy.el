;;; flymake-mypy.el --- mypy plugin for flymake
;;
;; Author: Ryan Kung <ryankung@ieee.org>
;; Keywords: lamguages mode flymake
;; License: MIT
;; Package-Requires: ((flymake))


;;; Commentary:
;; Use `mypy' as flymake backend for type checking
;; support `typing' on `Python-3.5' or `Mypy' style typing comment
;; on `Python-2'
;; More details on `https://github.com/python/mypy'


;;; Usage:
;; (require `flymake-mypy)


;;; Code:

(require 'flymake)


(defun flymake-mypy-init ()
  "Init mypy."
  (interactive)
  (message "flymake-mypy-init called")
  (let*
      ((temp-file (flymake-proc-init-create-temp-buffer-copy
                   'flymake-create-temp-inplace))
       (local-file (file-relative-name
                    temp-file
                    (file-name-directory buffer-file-name))))
    (list "mypy" (list "--follow-imports=normal" local-file "-s"))))


(when (load "flymake" t)
  (add-to-list 'flymake-allowed-file-name-masks '("\\.py\\'" flymake-mypy-init))
  )
(provide 'flymake-mypy)
;;; flymake-mypy.el ends here
