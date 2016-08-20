;; (require 'nim-mode)                     ;

;; (add-to-list 'company-backends 'company-nim)
;; ;(add-to-list 'auto-indent-multiple-indent-modes 'nim-mode)

;; (defun my-nim-hook ()
;;   (define-key nim-mode-map (kbd "C-c C-n") 'c2nim)
;;   (define-key nim-mode-map (kbd "C-c C-m") 'my-nim-func-to-method)
;;   (define-key nim-mode-map (kbd "C-c C-f") 'my-nim-method-to-func)
;;   ;; (auto-complete-mode -1)
;;   ;; (company-mode 1)
;;   )

;; (add-hook 'nim-mode-hook 'my-nim-hook)


;; (defun my-c2nim (beg end)
;;   (interactive "r")
;;   (let
;;       ((txt (buffer-substring-no-properties beg end)))
;;     (with-temp-file "~/c2nim.tmp.c"
;;       (insert txt))
;;     (shell-command "/home/cji/.nimble/bin/c2nim ~/c2nim.tmp.c -o ~/c2nim.tmp.nim")
;;     (kill-region beg end)
;;     (insert-file "~/c2nim.tmp.nim")))


;; (defun my-nim-method-to-func ()
;;   "With point anywhere in the line with a method-style call:
;;     surface.destroy()                     => destroy(surface)
;;     surface.draw_something(input, screen) => draw_something(surface, input, screen)"
;;   (interactive)
;;   (back-to-indentation)
;;   (kill-word 1)
;;   (delete-char 1)
;;   (search-forward "(")
;;   (yank)
;;   (when (not (looking-at (rx (zero-or-more whitespace) ")")))
;;     (insert ", ")))


;; (defun my-nim-func-to-method ()
;;   "With point anywhere in the line with a function-style call:
;;     destroy(surface)                       => surface.destroy()
;;     draw_something(surface, input, screen) => surface.draw_something(input, screen)
;; "
;;   (interactive)
;;   (back-to-indentation)
;;   (search-forward "(")
;;   (kill-word 1)
;;   (when (looking-at (rx (zero-or-more whitespace) ","))
;;     (delete-region (point)
;;                    (save-excursion
;;                      (search-forward ",")
;;                      (search-forward-regexp (rx (not whitespace)))
;;                      (1- (point)))))
;;   (back-to-indentation)
;;   (yank)(insert "."))
