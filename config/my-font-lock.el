(put 'font-lock-add-keywords 'lisp-indent-function 1)


(defun my-make-txt-font-locks ()
  (let ((my-lst-line-re
         (rx (and line-start (0+ (in blank))
                  "-" (opt blank) (group (0+ not-newline))
                  line-end))))
    (font-lock-add-keywords nil
      `(("`.*?'" . font-lock-warning-face)
        (,my-lst-line-re 1 font-lock-warning-face)))))
