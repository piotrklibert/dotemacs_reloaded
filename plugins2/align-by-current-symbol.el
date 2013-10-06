;;; align-by-current-symbol.el --- Align lines containing a symbol according to
;;; that symbol.
;;
;; Rewrittent by Piotr Klibert, because it was shit.
;;
;; TODO:
;; 1. make region detecting function check presence of a symbol
;; 2. make adding spaces to the symbol possible
;;
;; Example usage:
;;
;; (load "align-by-current-symbol.el")
;; (global-set-key (kbd "C-c C-.") 'align-by-current-symbol)
;;

;; mumumu = zotzot
;; chi = far
;; popo = k
;; zarlo => mu

(eval-when-compile
  (require 'cl))
(require 'rx)
(require 'dash)
(require 'thingatpt)
(require 'align-string)

(require 'my-utils)


(defvar abc-skip-chars " \t\n")

(defun abc-skip-regexp ()
  (rx-to-string `(any ,abc-skip-chars) t))


;;;###autoload
(defun align-by-current-symbol (&optional raw)
  (interactive "P")
  (let ((region-data (abc-find-region))
        (symbol-data (abc-current-symbol raw)))
    (message "%s %s" (car symbol-data) (cdr symbol-data))
    (and (car symbol-data)
         (align-string (car region-data) (cdr region-data)
                       (cdr symbol-data) (car symbol-data)))))


(defun abc-find-region ()
  "Returns beginning and end of a region surrounding point,
starting at the closests two newlines backwards and ending on
closest two newlines forward. In both cases, if two newlines are
not found before bob or eob the beggining or end of buffer are
correspondingly returned."
  ;; TODO: Make it check for presence of current symbol
  (cons (or (1+ (save-excursion
                  (search-backward "\n\n" (point-min) t)))
            (point-min))
        (or (save-excursion
              (search-forward "\n\n" (point-max) t))
            (point-max))))


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
         (symbol (buffer-substring (car symbol-bounds)
                                   (cdr symbol-bounds))))
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

;; ToC
;; abc-skip-regexp
;; align-by-current-symbol
;; abc-find-region
;; abc-current-symbol
;; abc--find-whole-symbol
;; abc--find-occurence-number
;; abc--find-symbol-bounds
