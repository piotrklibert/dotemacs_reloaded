
(defvar my-toggle-true-false-none-list
  (let
      ((l (list "True" "False" "None")))
    (setcdr (cdr (cdr l)) l)
    l))

(defun find-in-toggle-list(s)
  (cl-flet
      ((advance-lst ()
        (setq my-toggle-true-false-none-list
              (cdr my-toggle-true-false-none-list))))
    (while (not (string= s (car my-toggle-true-false-none-list)))
      (advance-lst))
    (advance-lst)
    (car my-toggle-true-false-none-list)))

(defun my-toggle-true-false-none()
  (interactive)
  (let
      ((word (current-word t t)))
    (when (member word (list "True" "False" "None"))
      (let
          ((repl (find-in-toggle-list word)))
        (message repl)
        (unless (member (char-after (point))
                        (list 32 47 92 41 34 10))
          (forward-word))
        (backward-kill-word 1)
        (insert repl)))))

(provide 'my-toggle-true-false)
