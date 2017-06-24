(defun find-all-my-global-bindings ()
  (interactive)
  (ag-regexp "(global-set-|local-set-)key" "/home/cji/.emacs.d/config/"))


(defun find-all-my-bindings ()
  (interactive)
  (ag-regexp "(global-set-|define-)key" "/home/cji/.emacs.d/config/"))

(defun find-my-bindings-for (map)
  (interactive)
  (unless (stringp map)
    (setq map (symbol-name map)))
  (ag-regexp (concat "(global-set-|define-)key.*" map)
             (f-full"~/.emacs.d/config/")))


;; Mainly used for toggling things, invoking commands that used twice on
;; the same thing do nothing.
(define-prefix-command 'my-toggle-keys)
(global-set-key (kbd "C-t") 'my-toggle-keys)
;; (find-my-bindings-for 'my-toggle-keys)


;; functions related to searching paths, files and everything else.
(define-prefix-command 'my-find-keys)
(global-set-key (kbd "C-f") 'my-find-keys)
;; (find-my-bindings-for 'my-find-keys)


;; Shortcuts for bookmarks/
(define-prefix-command 'my-bookmarks-keys)
(global-set-key (kbd "C-b") 'my-bookmarks-keys)
;; (find-my-bindings-for 'my-bookmarks-keys)


;; Keys related to moving, rearrangind and killing buffers and windows.
(define-prefix-command 'my-wnd-keys)
(global-set-key (kbd "C-w") 'my-wnd-keys)

(defun my-calc-hook ()
  (message "calc hook")
  (define-key calc-mode-map (kbd "C-w") 'my-wnd-keys))
(add-hook 'calc-mode-hook 'my-calc-hook)
(define-key calc-mode-map (kbd "C-w") 'my-wnd-keys)
;; (find-my-bindings-for 'my-wnd-keys)
