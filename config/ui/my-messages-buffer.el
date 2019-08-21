

(defun my-shrink-buffer (&optional buf)
  (setq buf (or buf (messages-buffer)))
  (with-current-buffer buf
    (text-scale-set -2)))

(add-hook 'emacs-startup-hook #'my-shrink-buffer)
(add-hook 'messages-buffer-mode-hook #'my-shrink-buffer)


(defun colorize-messages-buffer ()
  (interactive)
  (setq font-lock-keywords nil)
  (font-lock-add-keywords nil
    `(

      ;; (,(rx (any "E" "e") "rror") (0 '(:underline t :foreground "aquamarine")))

      (,(rx (group "Loading ")
            (group (1+ (not (any "\n"))))
            (group "...done"))
       (1 '(:foreground "green4"))
       (2 '(:foreground "orange1"))
       (3 '(:foreground "green"))

       )

      (,(rx (group (1+ any)) (group "...done"))
       (1 '(:foreground "aquamarine"))
       (2 '(:foreground "green")))

      (,(rx (group "[") (group (1+ digit)) (group " times]"))
       (1 '(:foreground "brown"))
       (2 '(:foreground "red"))
       (3 '(:foreground "brown"))

       )
      (,(rx (or "disabled" "enabled")) (:foreground "red"))
      (,(rx (not (any "(")) (group (1+ (not (any ":" "\n"))) ":") (group (1+ (not (any ":" "\n")))))
       (1 '(:foreground "pink"  ))
       (2 '(:foreground "red2" ))

       )))
  (font-lock-fontify-buffer))

;; make defined hi-lock faces available as variables (to use in font-lock)
;; (cl-loop for (x . _) in (get 'hi-lock-faces 'custom-group)
;;          collect (set (intern (concat (symbol-name x) "-face")) x))

(provide 'my-messages-buffer)
