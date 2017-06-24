;;; parenface-plus.el --- Provide a face for parens in lispy modes.

;; Author: Dave Pearson <davep@davep.org>
;; Version: 1.1
;; Maintainer: Grant Rettke

;; Add a paren-face to emacs and add support for it to the various lisp modes.
;;
;; Based on some code that Boris Schaefer <boris@uncommon-sense.net> posted
;; to comp.lang.scheme in message <87hf8g9nw5.fsf@qiwi.uncommon-sense.net>.
;;
;; Modifications by Grant Rettke <grettke@acm.org>, November 2012 only to add support for editor and REPL modes for:
;; Clojure (and nREPL), IELM, Jess and inferior-jess.

(defvar paren-face 'paren-face)

(defface paren-face
    '((((class color))
       (:foreground "DimGray")))
  "Face for displaying a paren."
  :group 'faces)

(defmacro paren-face-add-support (keywords)
  "Generate a lambda expression for use in a hook."
  `(lambda ()
    (let* ((regexp "(\\|)")
           (match (assoc regexp ,keywords)))
      (unless (eq (cdr match) paren-face)
        (setq ,keywords (append (list (cons regexp paren-face)) ,keywords))))))

(defun paren-face-add-keyword ()
  "Adds paren-face support to the mode."
  (font-lock-add-keywords nil '(("(\\|)" . paren-face))))

;; Keep the compiler quiet.
(eval-when-compile
  (defvar clojure-font-lock-keywords nil)
  (defvar jess-font-lock-keywords)
  (defvar lisp-font-lock-keywords-2 nil)
  (defvar scheme-font-lock-keywords-2 nil))

(add-hook 'clojure-mode-hook          (paren-face-add-support clojure-font-lock-keywords))
(add-hook 'emacs-lisp-mode-hook       (paren-face-add-support lisp-font-lock-keywords-2))
(add-hook 'ielm-mode-hook             'paren-face-add-keyword)
(add-hook 'inferior-jess-mode-hook    'paren-face-add-keyword)
(add-hook 'jess-mode-hook             (paren-face-add-support jess-font-lock-keywords))
(add-hook 'lisp-interaction-mode-hook (paren-face-add-support lisp-font-lock-keywords-2))
(add-hook 'lisp-mode-hook             (paren-face-add-support lisp-font-lock-keywords-2))
(add-hook 'nrepl-mode-hook            'paren-face-add-keyword)
(add-hook 'scheme-mode-hook           (paren-face-add-support scheme-font-lock-keywords-2))
(add-hook 'slime-repl-mode-hook       'paren-face-add-keyword)

(provide 'parenface-plus)

;;; parenface-plus.el ends here
