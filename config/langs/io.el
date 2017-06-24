(require 'io-mode)

;; (progn
;;   (defconst spaces '(0+ " "))
;;   (defconst io-indent `(group (seq bol ,spaces)))
;;   (defconst io-word `(seq
;;                       (group (seq (0+ (any alpha "_"))))
;;                       (group ,spaces)))
;;   (defconst io-cap-word `(seq
;;                           (group (seq (any upper "_") (0+ (any alpha "_"))))
;;                           (group ,spaces)))

;;   (defconst io-method1-rx
;;     `(seq ,io-indent ,io-word ":=" ,spaces "method("))
;;   (defconst io-method2-rx
;;     `(seq ,io-indent ,io-cap-word ,io-word ":=" ,spaces "method("))
;;   (defconst io-method-re
;;     (rx-to-string `(or ,io-method1-rx ,io-method2-rx)))

;;   (defconst io-class-rx
;;     `(seq ,io-indent ,io-cap-word ":=" ,spaces ,io-cap-word "clone do("))
;;   (defconst io-class-re
;;     (rx-to-string io-class-rx))
;;   (defconst io-imenu-re
;;     (rx-to-string (list 'or io-class-rx io-method1-rx io-method2-rx))))


(defun my-io-mode-hook ()
  (auto-complete-mode 1)
  (setq imenu-generic-expression nil)
  (setq imenu-create-index-function 'io-imenu-create-index))

(defun looking-at-line (re)
  (save-excursion
    (beginning-of-line)
    (looking-at re)))

(defun io-imenu-create-index ()
  (let ((case-fold-search nil)
        idx
        (subidx (list "global"))
        (current-class "global")
        )
    (beginning-of-buffer)
    (condition-case nil
        (while t
          (search-forward-regexp io-imenu-re)
          (cond
           ((looking-at-line io-class-re)
            (setq current-class (match-string-no-properties 2))
            ;; (setq current-class-end
            ;;       (condition-case nil
            ;;           (save-excursion
            ;;             (backward-char)
            ;;             (forward-sexp)
            ;;             (point))
            ;;         (error nil)))
            ;; (message current-class-end)
            (setq idx (append idx (list (reverse subidx))))
            (setq subidx (list current-class)))

           ((looking-at-line io-method-re)
            (setq subidx (cons (cons
                                (match-string-no-properties 2)
                                (point))
                               subidx)))))
      (error
       (setq idx (append idx (list (reverse subidx))))))
    idx))

;; (with-current-buffer "parsing.io"
;;   (save-excursion
;;     (io-imenu-create-index)))
(add-hook 'io-mode-hook 'my-io-mode-hook)

;; (setq
;;  py->io/defs
;;  (rx "def " (group (one-or-more (any alpha "_")))
;;      "(" (group (zero-or-more (not (any ")")))) "):"))

;; (setq
;;  py->io/class
;;  (rx "class " (group (one-or-more (any alpha "_")))
;;      "(" (group (one-or-more (not (any ")")))) "):"))

;; (setq
;;  py->io/type
;;  (rx "isinstance" "("
;;      (group (one-or-more (any alpha " _"))) ","
;;      (group (one-or-more (not (any ")"))))
;;      ")"))

;; (setq
;;  py->io/meth
;;  (rx (group space) (group (one-or-more (any alpha)))
;;      "."
;;      (group (one-or-more (not (any space "(=\n"))))))

;; (setq
;;  py->io/exc
;;  (rx "raise" (group (one-or-more (any alpha " _")))))

;; (setq
;;  py->io/self
;;  (rx "(" (optional space) "self" (0+ (any space)) ","))

;; (setq py->io/= (rx (any whitespace) "=" (any whitespace)))
;; (setq py->io/: (rx ":" eol))
;; (setq py->io/init (rx "__init__"))
;; (setq py->io/ret (rx (group (optional " ")) "return"))
;; (setq py->io/none (rx "None"))
;; (setq py->io/str (rx "__str__"))
;; (setq py->io/str2 (rx "basestring"))
;; (setq py->io/isnil (rx "is ni"))
;; (setq py->io/isnotnil (rx "is not nil"))

;; (with-current-buffer (current-buffer)
;;     ;; (get-buffer "parsing.io")
;;   ;; (search-forward-regexp py->io/meth)
;;   (let ((lst '((py->io/defs . "\\1 := method(\\2,\n)")
;;                (py->io/class . "\\1 := \\2 clone do(")
;;                (py->io/type . "\\1 isKindOf(\\2)")
;;                (py->io/meth . "\\1\\2 \\3")
;;                (py->io/self . "(")
;;                (py->io/= . " := ")
;;                (py->io/: . ",")
;;                (py->io/init . "with")
;;                (py->io/none . "nil")
;;                (py->io/ret . "\\1return ")
;;                (py->io/str . "asString")
;;                (py->io/str2 . "Sequence")
;;                (py->io/isnil . "isNil")
;;                (py->io/isnotnil . "isNil not")
;;                (py->io/exc . "\\1 raise"))))

;;     (loop for x in lst
;;           do (progn
;;                (message "a")
;;                (goto-line 145)
;;                (condition-case nil
;;                    (funcall 'replace-regexp (symbol-value (car x)) (cdr x))
;;                  (error nil))
;;                (message "%s" x)))
;;     )
;;   )
