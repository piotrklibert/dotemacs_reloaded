;; Mainly used for toggling things, invoking commands that used twice on
;; the same thing do nothing.
(define-prefix-command 'my-toggle-keys)
(global-set-key (kbd "C-t") 'my-toggle-keys)


;; Functions related to searching paths, files and everything else.
(define-prefix-command 'my-find-keys)
(global-set-key (kbd "C-f") 'my-find-keys)


;; Shortcuts for bookmarks/
(define-prefix-command 'my-bookmarks-keys)
(global-set-key (kbd "C-b") 'my-bookmarks-keys)


;; Keys related to moving, rearrangind and killing buffers and windows.
(define-prefix-command 'my-wnd-keys)
(global-set-key (kbd "C-w") 'my-wnd-keys)

;; (define-key )
