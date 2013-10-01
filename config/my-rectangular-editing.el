(require 'rect-mark)

;; Make BACKSPACE and DEL work on regions and rect regions too.
;; iedit-rectangle-mode
;; Also check to-read.txt

;; TODO: make next-line also append spaces at the end of line if needed

(define-minor-mode free-rectangle-mode
  "Makes `right-char' append spaces at the eol."
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

;; (add-to-list 'auto-mark-command-class-alist '(ignore . right-char))

;; (global-set-key (kbd "C-x r C-SPC") 'rm-set-mark)
;; (define-key my-wnd-keys (kbd "C-w"))
;; (lambda(b e) (interactive "r") (if rm-mark-active (rm-kill-region b e) (kill-region b e)))
;; (global-set-key (kbd "M-w"))
;; (lambda(b e) (interactive "r") (if rm-mark-active (rm-kill-ring-save b e) (kill-ring-save b e)))
;; (global-set-key (kbd "C-x C-x"))
;; (lambda(&optional p) (interactive "p") (if rm-mark-active (rm-exchange-point-and-mark p) (exchange-point-and-mark p)))
(provide 'my-rectangular-editing)
