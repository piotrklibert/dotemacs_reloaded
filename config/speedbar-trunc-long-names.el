
;; (defadvice speedbar-fetch-dynamic-imenu
;;   (around shorten-tags last (&rest args) activate)
;;   (let
;;       ((lst ad-do-it))
;;     (let ((ret (loop for elt in lst
;;                      for function-name = (car elt)
;;                      for mark = (cdr elt)
;;                      collect (cons (wrap-fname function-name)
;;                                    mark))))
;;       (message (format "%s" ret))
;;       ret)))
;; (defun wrap-fname (fname)
;;   (let
;;       ((splitted (split-string fname "\\.")))
;;     (if (eq (length splitted) 1)
;;         (car splitted)
;;       (concat (car splitted)
;;               (string ?\n)
;;               "  "
;;               (nth 1 splitted)))))
