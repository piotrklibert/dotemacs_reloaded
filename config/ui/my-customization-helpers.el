(require 'thingatpt)


(cl-defun symbol-customize-type (symbol)
  (cl-block nil
    (when (ignore-errors (plist-get (symbol-plist symbol) 'face-defface-spec))
      (cl-return 'face))
    (when (ignore-errors (plist-get (symbol-plist symbol) 'custom-group))
      (cl-return 'group))
    (when (ignore-errors (plist-get (symbol-plist symbol) 'standard-value))
      (cl-return 'option)))
  )
;; (mapcar 'symbol-customize-type '(region helm org-export-backends))

(defun customize-symbol (sym)
  (interactive "S")
  (let* ((type (symbol-customize-type sym))
         (customizer (intern (concat "customize-" (symbol-name type)))))
    (funcall customizer sym)))


(defun customize-symbol-at-pt (sym)
  (interactive (list (completing-read "Thing: " nil
                                      'identity nil (thing-at-point 'symbol))))
  (customize-symbol (intern sym)))




(provide 'my-customization-helpers)
