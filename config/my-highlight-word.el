(require 'thingatpt)

;; TODO:
;; 1* make it into minor mode
;; 2. check if it really provides anything that isearch does not
;;

(defvar highlight-words-at-point-last-search nil)

(defun highlight-words-at-point ()
  (interactive)
  (let ((word (thing-at-point 'sexp)))
    (setq highlight-words-at-point-last-search word)
    (highlight-regexp word)))

(defun unhighlight-words-at-point ()
  (interactive)
  (when highlight-words-at-point-last-search
    (unhighlight-regexp highlight-words-at-point-last-search)
    (setq highlight-words-at-point-last-search nil)))

(defun highlight-or-unhighlight-at-point ()
  (interactive)
  (if highlight-words-at-point-last-search
      (unhighlight-words-at-point)
    (highlight-words-at-point)))


(provide 'my-highlight-word)
