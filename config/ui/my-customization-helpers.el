(require 'thingatpt)


(cl-defun symbol-customize-type (symbol)
  (cl-block nil
    (when (ignore-errors (plist-get (symbol-plist symbol) 'face-defface-spec))
      (cl-return 'face))
    (when (ignore-errors (plist-get (symbol-plist symbol) 'custom-group))
      (cl-return 'group))
    (when (ignore-errors (plist-get (symbol-plist symbol) 'standard-value))
      (cl-return 'option))))

;; (mapcar 'symbol-customize-type '(region helm org-export-backends))

(defun customize-symbol (sym)
  "You most probably don't want this function; use
`customize-symbol-at-pt' instead."
  (interactive "S")
  (let* ((type (symbol-customize-type sym))
         (customizer (intern (concat "customize-" (symbol-name type)))))
    (funcall customizer sym)))


(defun my-custom-symbol-prompt ()
  (let* ((v (variable-at-point))
	     (default (and (symbolp v) (custom-variable-p v) (symbol-name v)))
	     (enable-recursive-minibuffers t)
         (prompt (if default (format "Customize symbol (default %s): " default) "Customize symbol: "))
	     val)
    (setq val (completing-read prompt obarray 'my-custom-symbol-p t nil nil default))
    (list (if (equal val "")
	          (if (symbolp v) v nil)
	        (intern val)))))

(defun my-custom-symbol-p (symbol)
  (or (custom-variable-p symbol)
      (or (and (get symbol 'custom-loads)
               (not (get symbol 'custom-autoload)))
          (get symbol 'custom-group))))



(defun customize-symbol-at-pt (sym)
  "Generic customize which works with any kind of custom-enabled
variables."
  (interactive (my-custom-symbol-prompt))
  (customize-symbol sym))


(provide 'my-customization-helpers)
