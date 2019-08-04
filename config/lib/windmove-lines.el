;; -*- mode: emacs-lisp -*-

(define-key my-toggle-keys (kbd "<right>") 'my-move-line-other-window-right)
(define-key my-toggle-keys (kbd "<left>") 'my-move-line-other-window-left)


(defun my-move-line-other-window-right ()
  (interactive)
  (my-move-line-other-window 'right))


(defun my-move-line-other-window-left ()
  (interactive)
  (my-move-line-other-window 'left))


(defun my-move-line-other-window (dir)
  (let
      ((o (selected-window))
       (w (windmove-find-other-window dir))
       (line (buffer-substring-no-properties (line-beginning-position)
                                             (line-end-position))))
    (select-window w)
    (insert line) (newline)
    (select-window o)))


(provide 'windmove-lines)
