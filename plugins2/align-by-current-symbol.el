;;; align-by-current-symbol.el --- Align lines containing a symbol according to
;;; that symbol.
;;
;; Rewrittent by Piotr Klibert, because it was shit.
;;
;; TODO:
;; 1* change region finding algorithm so that it handles eob and bob
;; 2* make adding of a space work (that's not that important tough)
;;
;; Example usage:
;;
;; (load "align-by-current-symbol.el")
;; (global-set-key (kbd "C-c C-.") 'align-by-current-symbol)
;;
;; By default it requires spaces to be around the symbol.
;;
;; Use the following to turn this off:
;;
;; (global-set-key (kbd "C-c C-.")
;;    (lambda ()
;;       (interactive) (align-by-current-symbol t)))

;; mumumu = zotzot
;; chi = far
;; popo = k
;; zarlo => mu

(eval-when-compile
  (require 'cl))
(require 'thingatpt)
(require 'dash)

(defvar abc-skip-chars '(" " "\t" "\n"))

(defun abc-skip-regexp ()
  (concat "[" (-reduce 'concat abc-skip-chars) "]"))

(defun abc-find-region ()
  (cons (save-excursion
          (search-backward "\n\n" (point-min)))
        (save-excursion
          (search-forward "\n\n" (point-max)))))

(defun abc-quoting-match (symbol line &optional symbol-match)
  (string-match (regexp-quote symbol) line (or symbol-match 0)))

(defun abc-regexp-symbol (symbol add-space)
  (let ((symbol (or (and add-space symbol)
                    (concat " " symbol " "))))
    (regexp-opt (list symbol))))


(defun align-by-current-symbol (&optional add-space)
  "Indent all the lines above and below the current by the
current non-whitespace symbol."
  (interactive "P")
  (destructuring-bind (symbol-number . symbol) (abc-current-symbol)
    (message "%s %s" symbol-number symbol)
    (when symbol
      (destructuring-bind
          (start . end) (if (use-region-p)
                            (cons (region-beginning) (region-end))
                          (abc-find-region))
        (align-string start end (abc-regexp-symbol symbol add-space) symbol-number)))))



(defun abc-current-symbol ()
  "Get the consecutive string of non-whitespace characters under
point. Count how many occurances of this string there are in
current line. Return a (cons occurances-before string-at-point)."
  (if (member (string (char-after)) abc-skip-chars)
      (cons nil nil)
    (let ((line (buf-substr-np (line-beginning-position) (line-end-position)))
          (symbol-number 0)
          (symbol-match -1)
          symbol symbol-beg symbol-end symbol-col )
      (save-excursion
        (setq symbol-beg (1+ (search-backward-regexp (abc-skip-regexp))))
        (forward-char)
        (setq symbol-col (current-column))
        (setq symbol-end (1- (search-forward-regexp (abc-skip-regexp))))
        (setq symbol (buf-substr-np symbol-beg symbol-end)))
      (while (and (< symbol-match symbol-col)
                  (setq symbol-match (abc-quoting-match symbol line
                                                        (1+ symbol-match))))
        (setq symbol-number (1+ symbol-number)))
      (cons symbol-number symbol))))


(provide 'align-by-current-symbol)
