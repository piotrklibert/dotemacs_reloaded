
(defun move-text-internal (direction)
  (cond
   ;; if we deal with region
   ((and mark-active
         transient-mark-mode)

    ;; make it so that point is always at the beginning-of-region
    (when (> (point) (mark))
      (exchange-point-and-mark))

    (let
        ;; move point to beginning of line and save it's position
        ((beg (progn
                (beginning-of-line)
                (point)))
         ;; temporarily move point at the end of region, then to the end of line
         ;; plus + for newline char
         (end (save-excursion
                (exchange-point-and-mark)
                (1+ (line-end-position)))))
      ;; cut the region
      (assert (= beg (point)))
      (kill-region beg end)
      (assert (= beg (point)))

      ;; move point up or down a line
      (forward-line (case direction
                      ('up  -1)
                      ('down  1)))
      (yank)
      (let
          ((p (point)))
        (exchange-point-and-mark)
        (push-mark (1- p) nil t)
        (setq mark-active t)
        (setq deactivate-mark nil))))

   ;; so we know that's a single line
   (t
    (beginning-of-line)
    (case direction
      ('up
       (when (not (bobp))
         (transpose-lines 1)
         (forward-line -2)))
      ('down
       (when (not (eobp))
         (forward-line)
         (transpose-lines 1)
         (forward-line -1)))))))


(defun move-text-down (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines down."
  (interactive "*p")
  (if (> arg 1)
      (dotimes (i arg)
        (move-text-internal 'down))
    (move-text-internal 'down)))

(defun move-text-up (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines up."
  (interactive "*p")
  (if (> arg 1)
      (dotimes (i arg)
        (move-text-internal 'up))
    (move-text-internal 'up)))

(provide 'my-move-lines)
