;; ;; -*- mode: emacs-lisp -*- lexical-binding: t

(require 'auto-complete)

(defvar ac-alchemist-candidates nil)
(defvar ac-alchemist-filter-output nil)

(defun ac-alchemist-init ()
  (let
      ((prefix (car (last (ac-alchemist-scope-expression)))))
    (if prefix
        (setq alchemist-company-last-completion prefix)
      (setq alchemist-company-last-completion ""))
    (alchemist-server-complete-candidates
     (alchemist-company-build-server-arg prefix)
     #'ac-alchemist-filter))
  )

(defun ac-alchemist-filter (_process output)
  (setq ac-alchemist-filter-output
        (cons output ac-alchemist-filter-output))
  (if (alchemist-server-contains-end-marker-p output)
      (let*
          ((candidates (alchemist-complete--build-candidates-from-process-output
                        ac-alchemist-filter-output)))
        (setq ac-alchemist-filter-output nil)
        (setq ac-alchemist-candidates candidates))))

(defun ac-alchemist-candidates ()
  ac-alchemist-candidates)

(defun ac-alchemist-prefix ()
  (if (or (looking-at "\s") (eolp))
      (unless (looking-back ".+:" nil)
        (car (ac-alchemist-scope-expression)))))

(defun ac-alchemist-scope-expression ()
  "Return the expression under the cursor."
  (save-excursion
    (let*
        ((skip-chars "-_A-Za-z0-9.?!@:")
         (p1 (progn (skip-chars-backward skip-chars) (point)))
         (p2 (progn (skip-chars-forward  skip-chars) (point))))
      (list p1 p2 (buffer-substring-no-properties p1 p2)))))

(ac-define-source alchemist
  '((prefix     . ac-alchemist-prefix)
    (init       . ac-alchemist-init)
    (candidates . ac-alchemist-candidates)))

(provide 'ac-elixir)
