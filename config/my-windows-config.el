(require 'tiling)
(require 'golden-ratio)
(require 'elscreen)
(require 'uniquify)
(require 'buffer-move)
(require 'my-reorder-buffer-list)

(elscreen-start)

;; (global-set-key (kbd "M-<f2>") 'minimap-mode)
;; (golden-ratio-mode t)


;; (require 'minimap)
;; (global-set-key (kbd "C-<tab>")           'elscreen-next)
(global-set-key (kbd "C-<next>")          'elscreen-next)

(global-set-key (kbd "C-S-<tab>")         'elscreen-previous)
(global-set-key (kbd "C-S-<iso-lefttab>") 'elscreen-previous)
(global-set-key (kbd "C-<prior>")         'elscreen-previous)


;; my-wnd-keys - C-w prefix


(defun my-enlarge-window-horizontally ()
  (interactive)
  (enlarge-window-horizontally 10))

(defun my-shrink-window-horizontally ()
  (interactive)
  (shrink-window-horizontally 10))



  ;; C-w is taken by cut by default, and life without it would be less than
  ;; comfortable, so we place it under C-w C-w


(define-key my-wnd-keys (kbd "C-w")                 'kill-region)

(define-key my-wnd-keys (kbd "C-<left>")            'windmove-left)
(define-key my-wnd-keys (kbd "C-<right>")           'windmove-right)

(define-key my-wnd-keys (kbd "<right>")             'my-enlarge-window-horizontally)
(define-key my-wnd-keys (kbd "<left>")              'my-shrink-window-horizontally)

(define-key my-wnd-keys (kbd "<up>")                'enlarge-window)
(define-key my-wnd-keys (kbd "<down>")              'shrink-window)


(define-key my-wnd-keys (kbd "C-<up>")              'windmove-up)
(define-key my-wnd-keys (kbd "C-<down>")            'windmove-down)
(define-key my-wnd-keys (kbd "M-<up>"   )           'buf-move-up)
(define-key my-wnd-keys (kbd "M-<down>" )           'buf-move-down)
(define-key my-wnd-keys (kbd "M-<right>")           'buf-move-right)
(define-key my-wnd-keys (kbd "M-<left>" )           'buf-move-left)

(define-key my-wnd-keys (kbd "C-s")                 'split-window-below)
(define-key my-wnd-keys (kbd "\"")                  'split-window-below)
(define-key my-wnd-keys (kbd "C-v")                 'split-window-right)
(define-key my-wnd-keys (kbd "%")                   'split-window-right)

(define-key my-wnd-keys (kbd "C-z")                 'delete-window)
(define-key my-wnd-keys (kbd "C-k")                 'kill-buffer-and-window)
(define-key my-wnd-keys (kbd "C-M-d")               'kill-buffer-and-window)
(define-key my-wnd-keys (kbd "C-d")                 'force-kill-buffer)

;; ie. C-x C-M-f
(define-key ctl-x-map (kbd "C-M-f")                 'find-file-other-window)

(define-key my-wnd-keys (kbd "C-o")                 'delete-other-windows)
(define-key my-wnd-keys (kbd "M-o")                 'golden-ratio)
(define-key my-wnd-keys (kbd "C-M-o")               'kill-other-window-and-buffer)

(define-key my-wnd-keys (kbd "C-c")                 'copy-to-register)

(define-key my-wnd-keys (kbd "C-t")                 'tiling-cycle)

(global-set-key (kbd "C-<f4>")                      'delete-frame)
(define-key my-wnd-keys (kbd "C-f")                 'delete-frame)



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
but call from elisp works. (Probably because kill-buffer key is
remapped or something)."
  (interactive "P")
  (when arg
    (save-buffer))
  (kill-buffer))
