;;; align-by-current-symbol.el - Align lines containing a symbol according to
;;; that symbol.
;;
;;
;; Example usage:
;;
;; (require 'align-by-current-symbol)
;; (global-set-key (kbd "C-c C-.") 'align-by-current-symbol)
;;
;; Then just position a point on something you want aligned and invoke the
;; command. For example, place point on any of the `=` chars in the following
;; snippet and call `align-by-current-symbol`
;;
;; url = models.URLField()
;; creator = models.CharField(max_length=255)
;; created = models.DateTimeField(auto_now_add=True) data = JSONField()
;;
;; and this is what you'd get:
;;
;; url     = models.URLField()
;; creator = models.CharField(max_length=255)
;; created = models.DateTimeField(auto_now_add=True)
;; data    = JSONField()
;;

(eval-when-compile
  (require 'cl))

(require 'rx)
(require 'dash)
(require 'thingatpt)
(require 'align-string)

(require 'my-utils)


(defconst abc-skip-chars (seq-map (lambda (x) x) " \t\n"))

(defun abc-skip-regexp ()
  "Stop-chars for determining symbol boundaries."
  (rx (any " \t\n")))


;;;###autoload
(defun align-by-current-symbol (&optional raw)
  "Align some lines of text so that the thing at point (or char
at point, with prefix) is in the same column in all the lines."
  (interactive "P")
  (let*
      ((symbol-data (abc-current-symbol raw))
       (region-data (abc-find-region (cdr symbol-data))))
    (message "%s %s" (car symbol-data) (cdr symbol-data))
    (and (car symbol-data)
         (align-string (car region-data) (cdr region-data)
                       (cdr symbol-data) (car symbol-data)))))

;;
;; Determine the lines we want to work with.
;;
(defun abc-find-region (symbol)
  "Find the boundaries of a current symbol consecutive occurence."
  (cons (save-excursion
          (abc--backward-find-first-without symbol))
        (save-excursion
          (abc--forward-find-first-without symbol))))

(defun abc--backward-find-first-without (symbol)
  (let ((found (string-match-p symbol (buffer-line-np))))
    (while (and found (not (bobp)))
      (forward-line -1)
      (setq found (string-match-p symbol (buffer-line-np))))
    (point)))

(defun abc--forward-find-first-without (symbol)
  (let ((found (string-match-p symbol (buffer-line-np))))
    (while (and found (not (eobp)))
      (forward-line)
      (setq found (string-match-p symbol (buffer-line-np))))
    (point)))


;;
;; Determine the symbol we want to align.
;;
(defun abc-current-symbol (&optional arg)
  (cond
   (arg                                 ; return just the current char if raw
    (let ((char (string (char-after))))
      (abc--find-occurence-number char (current-column))))

   ((member (string (char-after))       ; without raw return nils if current
            abc-skip-chars)             ; char is skip-char
    (cons nil nil))

   (t (abc--find-whole-symbol))))       ; otherwise find a whole symbol at point


(defun abc--find-whole-symbol ()
  (let* ((symbol-bounds (abc--find-symbol-bounds))
         (symbol (buffer-substring-no-properties
                  (car symbol-bounds) (cdr symbol-bounds))))
    (abc--find-occurence-number symbol (current-column))))


(defun abc--find-occurence-number (str col)
  (let ((line (buffer-line-np))
        (str-re (rx-to-string str))
        (occurence 0)
        (match-pos -1))
    (while (and match-pos (< match-pos col))
      (setq match-pos (string-match str-re line (1+ match-pos)))
      (when match-pos
        (setq occurence (1+ occurence))))
    (cons occurence str)))


(defun abc--find-symbol-bounds ()
  (cons (progn
          (search-backward-regexp (abc-skip-regexp))
          (forward-char)
          (point))

        (save-excursion
          (search-forward-regexp (abc-skip-regexp))
          (backward-char)
          (point))))


(provide 'align-by-current-symbol)
