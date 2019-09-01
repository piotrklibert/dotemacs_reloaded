(require 'f)
(require 'ag-autoloads)

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
(global-set-key (kbd "C-z") 'my-toggle-keys)
;; (find-my-bindings-for 'my-toggle-keys)
;; (find-my-bindings-for 'my-find-keys)
;; (find-my-bindings-for 'my-bookmarks-keys)

(defun delete-selected-window ()
  (interactive)
  (delete-window (frame-selected-window)))

(global-set-key (kbd "<f10>")  'delete-selected-window)



(provide 'my-keymaps-config)
