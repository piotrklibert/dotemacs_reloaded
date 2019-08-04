;;; flymake-mypy.el --- A flymake handler for python-mode files using mypy
;;
;; Author: Naoki Nakajima <n2.jima@gmail.com>
;; Package-Requires: ((flymake-easy "0.8"))

;;; Commentary:

;; Usage:

;;   (require 'flymake-mypy)
;;   (add-hook 'python-mode-hook 'flymake-python-mypy-load)

;; To use new type annotations in python 3.6 (PEP 526), add this line:
;;   (setq flymake-python-mypy-pep526 t)

;; Uses flymake-easy, from https://github.com/purcell/flymake-easy

;;; Code:

(require 'flymake-easy)

(defconst flymake-python-mypy-err-line-patterns
  '(("^\\(.*\\.py\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3)))

(defvar flymake-python-mypy-executable "mypy"
  "The mypy executable to use for syntax checking.")

(defgroup flymake-python-mypy nil
  "Flymake support for Python via mypy"
  :group 'flymake
  :prefix "flymake-python-mypy-")

(defcustom flymake-python-mypy-pep526 'nil
  "Boolean variable, disabled by default."
  :type 'boolean
  :group 'flymake-python-mypy)

(defun flymake-python-mypy-command (filename)
  "Construct a command that flymake can use to syntax-check FILENAME."
    (if flymake-python-mypy-pep526
        (append (list flymake-python-mypy-executable)
              (list filename "--python=3.6" "--fast-parser"))
      (append (list flymake-python-mypy-executable)
              (list filename))))

;;;###autoload
(defun flymake-python-mypy-load()
  "Configure flymake mode to check the current buffer's python syntax using mypy."
  (interactive)
  (flymake-easy-load 'flymake-python-mypy-command
                     flymake-python-mypy-err-line-patterns
                     'tempdir
                     "py"))

(provide 'flymake-python-mypy)
;;; flymake-mypy.el ends here
