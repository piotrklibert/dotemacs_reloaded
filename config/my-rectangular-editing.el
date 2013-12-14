;; BTW: iedit has something for editing rectangles visually: C-<return>
;; (iedit-rectangle-mode)

;; TODO: Make DEL work on regions too.
;; Also check to-read.txt

(defun yank-rectangle-as-text ()
  "Insert killed rectange as if it was normal text, ie. push
lines down to make space for it instead of pushing line contents
to the right."
  (interactive)
  (with-temp-buffer
    (yank-rectangle)
    (kill-region (point-min) (point-max)))
  (yank)
  (newline))



;; TODO: make next-line also append spaces at the end of line if needed

(define-minor-mode free-rectangle-mode
  "Makes `right-char' append spaces at the eol. It's usefull for
marking rectangles which last/first line is shorter than other
lines. I'm not worried about leaving excess whitespace, because
they will be removed on save anyway."
  nil "Fr" nil
  (if free-rectangle-mode
      (fr-mode-on)
    (fr-mode-off)))

(defun fr-mode-on ()
  (ad-deactivate 'right-char)
  (ad-enable-advice 'right-char 'around 'append-spaces-at-eol)
  (ad-activate 'right-char)
  (set (make-local-variable 'free-rect-auto) auto-mark-mode)
  (when free-rect-auto
    (auto-mark-mode -1)))

(defun fr-mode-off ()
  (ad-deactivate 'right-char)
  (ad-disable-advice 'right-char 'around 'append-spaces-at-eol)
  (ad-activate 'right-char)
  (when free-rect-auto
    (setq free-rect-auto nil)
    (auto-mark-mode 1)))

(defun right-and-mark-active ()
  (let ((transient-mark-mode nil))
    (insert " ")
    (setq deactivate-mark nil)))

(defadvice right-char
  (around append-spaces-at-eol first disable)
  (if (equal (point)
             (line-end-position))
      (right-and-mark-active)
    ad-do-it))

(provide 'my-rectangular-editing)


;; RECT-MARK
;; (require 'rect-mark)
;; I don't use this anymore, the only thing it provides is visual feedback for
;; the rectangle, but does this at the expense of yet another set of keys.
