(require 'subr-x)

(defconst my-prev-face-attribute-func (symbol-function 'face-attribute))

(defun my-filter-color-faces (variants)
  (loop for (meta . attributes) in variants
        when (eq 'color (car (alist-get 'class meta)))
        for colors = (car (alist-get 'min-colors meta))
        collect (cons colors (car attributes))))


(defun my-face-attribute (face attribute &optional frame inherit)
  (let
      ((face-name (symbol-name face)))
    (let*
        ((theme-face-variants (cadr (assoc 'wombat (get face 'theme-face))))
         (theme-face-attrs (thread-first theme-face-variants
                             (my-filter-color-faces)
                             (cl-sort #'> :key #'car)
                             (cdar)))
         (val (or (plist-get theme-face-attrs attribute)
                  (car-safe (cdr (assoc attribute (face-user-default-spec face)))))))

      (when (and (not val) (not (eq attribute :inherit)))
        (let ((inherited-face (my-face-attribute face :inherit)))
          (when (and inherited-face
                     (null (eq inherited-face 'unspecified)))
            (setq val (my-face-attribute inherited-face attribute)))))

      (or val 'unspecified))))

(when noninteractive
  (advice-add 'face-attribute :override #'my-face-attribute))


(provide 'be-faces)
