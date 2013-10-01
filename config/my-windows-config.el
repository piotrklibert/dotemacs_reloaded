(require 'tiling)
(require 'elscreen)
(require 'buffer-move)
(require 'uniquify)



(elscreen-start)

(global-set-key (kbd "C-<tab>")           'elscreen-next)
(global-set-key (kbd "C-<next>")          'elscreen-next)

(global-set-key (kbd "C-S-<tab>")         'elscreen-previous)
(global-set-key (kbd "C-S-<iso-lefttab>") 'elscreen-previous)
(global-set-key (kbd "C-<prior>")         'elscreen-previous)

;; was overwritten
(define-key my-wnd-keys (kbd "C-w")                 'kill-region)

(define-key my-wnd-keys (kbd "C-<left>")            'windmove-left)
(define-key my-wnd-keys (kbd "C-<right>")           'windmove-right)
(define-key my-wnd-keys (kbd "C-<up>")              'windmove-up)
(define-key my-wnd-keys (kbd "C-<down>")            'windmove-down)
(define-key my-wnd-keys (kbd "M-<up>"   )           'buf-move-up)
(define-key my-wnd-keys (kbd "M-<down>" )           'buf-move-down)
(define-key my-wnd-keys (kbd "M-<right>")           'buf-move-right)
(define-key my-wnd-keys (kbd "M-<left>" )           'buf-move-left)

(define-key my-wnd-keys (kbd "C-s")                 'split-window-below)
(define-key my-wnd-keys (kbd "C-v")                 'split-window-right)

(define-key my-wnd-keys (kbd "C-z")                 'delete-window)
(define-key my-wnd-keys (kbd "C-k")                 'kill-buffer-and-window)
(define-key my-wnd-keys (kbd "C-M-d")               'kill-buffer-and-window)
(define-key my-wnd-keys (kbd "C-d")                 'force-kill-buffer)

(define-key my-wnd-keys (kbd "C-o")                 'delete-other-windows)
(define-key my-wnd-keys (kbd "C-M-o")               'kill-other-window-and-buffer)

(define-key my-wnd-keys (kbd "C-c")                 'copy-to-register)


(define-key my-wnd-keys (kbd "C-t")                 'tiling-cycle)



;;
;; Custom functions
;;
(defun kill-other-window-and-buffer ()
  "Like `delete-other-windows', but also kills the buffers."
  (interactive)
  (let ((windows (cdr (window-list nil nil (selected-window)))))
    (loop for win in windows
          for buf = (window-buffer win)
          do (progn
               (kill-buffer buf)
               (delete-window win)))))


(defun force-kill-buffer (&optional arg)
  "Sometimes interactive version of `kill-buffer' doesn't work,
but call from elisp works. Dunno why."
  (interactive "P")
  (when arg
    (save-buffer))
  (kill-buffer))
