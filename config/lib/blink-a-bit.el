;; -*- mode: emacs-lisp -*- lexical-binding: t

(defvar my-blinking-p nil)

(defun my-blink-a-bit ()
  (interactive)
  (unless my-blinking-p
    (blink-cursor-mode 1)
    (set-cursor-color "red")
    (setf my-blinking-p t)
    (run-at-time 2.2 nil
      (lambda ()
        (setf my-blinking-p nil)
        (set-cursor-color "white")
        (blink-cursor-mode 0)))
    nil))

(defun my-recenter-and-blink ()
  (recenter)
  (my-blink-a-bit))


(provide 'blink-a-bit)
