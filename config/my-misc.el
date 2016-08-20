
;; (defconst models-replacements
;;   '(("Column(String(250))" . "models.CharField(max_length=250)")
;;     ("Column(Date())"      . "models.DateField()")
;;     ("Column(Numeric())"   . "models.IntegerField()")))

;; (defun conv10c ()
;;   (loop for x in models-replacements
;;         do (save-excursion
;;              (while (search-forward (car x) nil t)
;;                (replace-match (cdr x) nil nil)))))
