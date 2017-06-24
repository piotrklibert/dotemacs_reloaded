(setq my-garbling-characters (string-to-vector
                              (concat "abcdefghijklmnoprstuwxyz"
                                      "ABCDEFGHIJKLMNOPRSTUWXYZ")))

(defun get-random-identifier (len)
  (interactive "nHow long? ")
  (let*
      ((char-count (length my-garbling-characters))
       (rand-chars (loop for _ from 0 to len
                         collect (aref my-garbling-characters
                                       (random* char-count)))))
    (apply 'string rand-chars)))



(defun garble-sexp (arg)
  (interactive "P")
  (let
      ((my-garbling-characters (if arg (string-to-vector "0123456789") my-garbling-characters)))
    (destructuring-bind
        (word beg . end) (thing-at-point-with-bounds 'sexp)
      (delete-region beg end)
      (insert (get-random-identifier (length word)))
      (message "%s" word))))
