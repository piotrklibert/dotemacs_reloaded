;; A module for generating human-readable and unique custom links to elements in
;; Org Mode files.
;;
;; Usage:
;;
;;     M-x be-regenerate-custom-ids
;;
(require 's)
(require 'dash)
(require 'org)


(defun be-escape-hash (s)
  (s-join "-" (-> s
                (s-downcase)
                (split-string " " t))))


(defun be-outline-up ()
  (condition-case nil
      (outline-up-heading 1)
    (error nil)))


(defun be-get-all-parents ()
  (save-excursion
    (loop while (be-outline-up)
          collect (-> (org-element-at-point)
                    (second)
                    (plist-get :title)
                    (be-escape-hash)))))


(defun be-get-headline-text ()
  (-> (org-element-headline-parser (point-max) t)
    (second)
    (plist-get :title)))


(defun be-regenerate-custom-ids ()
  (interactive)
  (cl-labels
      ((set-element-custom-id ()
        (let*
            ((headline (be-escape-hash (be-get-headline-text)))
             (element-ancestry (reverse (cons headline (be-get-all-parents))))
             (element-id (->> element-ancestry
                           (s-join "__" )
                           (s-replace "/" "")
                           (s-replace "?" "")
                           ;(s-right 60)
                           )))
          (assert (equal (first (org-element-at-point)) 'headline))
          (org-entry-put nil "CUSTOM_ID" element-id))))
    (org-map-entries #'set-element-custom-id)))


(provide 'my-org-custom-id)
