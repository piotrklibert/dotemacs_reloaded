;;; Some things I wrote but am not using anymore.
;;

(define-key my-wnd-keys (kbd "C-l")                 'switch-to-last-dired)

(defun switch-to-last-dired ()
  "Find a dired buffer and switch to it in one command."
  (interactive)
  (let ((bufs (buffer-list)))
    (catch 'no-more-bufs
      (dolist (b bufs)
        (with-current-buffer b
          (when (eq major-mode 'dired-mode)
              (switch-to-buffer b)
              (throw 'no-more-bufs nil))))
      (message "No direds open!"))))


(defun upcase-word-or-region ()
  (interactive)
  (if (use-region-p)
      (upcase-region (region-beginning) (region-end))
    (save-excursion
      (let
          ((bounds (bounds-of-thing-at-point 'word)))
        (goto-char (car bounds))
        (upcase-word 1)))))

(defun indent-region-or-line()
  "Re-indent marked region or current line if no region is active.

  I made std indent-for-tab behave nicely so this is unnecessary."
  (interactive)
  (let ((region-was-active (use-region-p))
        beg end)
    (if region-was-active
        (setq beg (region-beginning) end (line-end-position))
      (setq beg (line-beginning-position) end (line-end-position)))
    (indent-region beg end)
    (when region-was-active
      (setq deactivate-mark nil)
      (setq mark-active t))))

;; (defvar hilite-call nil)
;; (defvar hilite-data nil)
;; (setq hilite-call 10)
;; (setq hilite-data nil)
;; (reverse hilite-data)
;; (defun my-sue-hilighter (limit)
;;   ;; (set-text-properties
;;   ;;  2349 2362 '(font-lock-face error))
;;   (if (> (setq hilite-call (1- hilite-call)) 0)
;;       (progn
;;         (push (list (point) (point-max) limit) hilite-data)
;;         (goto-char (+ (point) (1- limit)) )
;;         t)
;;     nil))

;; (with-current-buffer (get-buffer "org-keys.org")
;;   ;; (font-lock-add-keywords nil '((my-sue-hilighter . font-lock-keyword-face)))

;;   )

;; (with-current-buffer (get-buffer "org-keys.org")
;;   ;; setq font-lock-keywords
;;   (font-lock-remove-keywords nil '(( org-font-lock-hook) my-sue-hilighter))

;;   (cdr font-lock-keywords)
;;   ;; (-flatten (cdr font-lock-keywords))
;;   )

;; (or (eq (car it) 'org-font-lock-hook)
;;                            (eq (car it) 'my-sue-hilighter))
