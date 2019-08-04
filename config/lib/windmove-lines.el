;; -*- mode: emacs-lisp -*-
(require 'windmove)
(defvar my-toggle-keys)
(define-key my-toggle-keys (kbd "<right>") 'my-copy-line-other-window-right)
(define-key my-toggle-keys (kbd "<left>") 'my-copy-line-other-window-left)

(define-key my-toggle-keys (kbd "M-<right>") 'my-move-line-other-window-right)
(define-key my-toggle-keys (kbd "M-<left>") 'my-move-line-other-window-left)


(defun my-copy-line-other-window-right ()
  (interactive)
  (my-move-line-other-window 'right nil))


(defun my-copy-line-other-window-left ()
  (interactive)
  (my-move-line-other-window 'left nil))



(defun my-move-line-other-window-right ()
  (interactive)
  (my-move-line-other-window 'right t))


(defun my-move-line-other-window-left ()
  (interactive)
  (my-move-line-other-window 'left t))


(defun my-move-line-other-window (dir &optional del)
  (let*
      ((o (selected-window))
       (w (windmove-find-other-window dir))
       (bounds (if (not (region-active-p))
                   (cons (line-beginning-position) (line-end-position))
                 (cons (region-beginning) (region-end))))
       (text (buffer-substring-no-properties (car bounds)
                                             (cdr bounds)) ))
    (select-window w)
    (insert text) (newline)
    (select-window o)
    (when del
      (delete-region (car bounds) (cdr bounds))
      (delete-char 1))))


(provide 'windmove-lines)
