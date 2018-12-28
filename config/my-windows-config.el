(require 'tiling)
(require 'golden-ratio)
(require 'uniquify)
(require 'buffer-move)
(require 'my-reorder-buffer-list)

(require 'elscreen)
(elscreen-start)

;; (global-set-key (kbd "M-<f2>") 'minimap-mode)
;; (golden-ratio-mode t)


;; (require 'minimap)
;; (global-set-key (kbd "C-<tab>")           'elscreen-next)
(global-set-key (kbd "C-<next>")          'elscreen-next)
(global-set-key (kbd "C-<XF86AudioPlay>") 'elscreen-previous)

(global-set-key (kbd "C-<prior>")         'elscreen-previous)
(global-set-key (kbd "C-<XF86AudioNext>") 'elscreen-next)


;; my-wnd-keys - C-w prefix


(defun my-enlarge-window-horizontally ()
  (interactive)
  (enlarge-window-horizontally 10))

(defun my-shrink-window-horizontally ()
  (interactive)
  (shrink-window-horizontally 10))



;; I would like to use C-w as a prefix for all window-manipulating functions,
;; but it is taken by cut by default. Life without it would be less than
;; comfortable, so we transfer it to C-w C-w.
(define-key my-wnd-keys (kbd "C-w")                 'kill-region)

(defmacro refresh-tab-bar-after (&rest funcs)
  `(progn ,@(loop for f in funcs
                collect (let ()
                          `(defadvice ,f (after my-elscreen-refresh-tab-bar activate)
                             (elscreen-e21-tab-update t))))))

(refresh-tab-bar-after
 windmove-up
 windmove-down
 windmove-left
 windmove-right)

(defun my-split-window-right ()
  (interactive)
  (select-window (split-window-right)))

(defun my-split-window-below ()
  (interactive)
  (select-window (split-window-below)))

(define-key my-wnd-keys (kbd "C-<left>")     'windmove-left)
(define-key my-wnd-keys (kbd "C-<right>")    'windmove-right)
(define-key my-wnd-keys (kbd "C-<up>")       'windmove-up)
(define-key my-wnd-keys (kbd "C-<down>")     'windmove-down)

(define-key my-wnd-keys (kbd "<right>")      'my-enlarge-window-horizontally)
(define-key my-wnd-keys (kbd "<left>")       'my-shrink-window-horizontally)
(define-key my-wnd-keys (kbd "<up>")         'enlarge-window) ; TODO: make it more natural with regards to arrow directions
(define-key my-wnd-keys (kbd "<down>")       'shrink-window)
(define-key my-wnd-keys (kbd "=")            'balance-windows)
(define-key my-wnd-keys (kbd "C-=")          'balance-windows)

(define-key my-wnd-keys (kbd "M-<up>"   )    'buf-move-up)
(define-key my-wnd-keys (kbd "M-<down>" )    'buf-move-down)
(define-key my-wnd-keys (kbd "M-<right>")    'buf-move-right)
(define-key my-wnd-keys (kbd "M-<left>" )    'buf-move-left)

(define-key my-wnd-keys (kbd "C-s")          'my-split-window-below)
;; (define-key my-wnd-keys (kbd "\"")           'my-split-window-below)
;; (define-key my-wnd-keys (kbd "C-\"")         'my-split-window-below)
(define-key my-wnd-keys (kbd "C-v")          'my-split-window-right)
;; (define-key my-wnd-keys (kbd "%")            'my-split-window-right)
;; (define-key my-wnd-keys (kbd "C-%")          'my-split-window-right)

(define-key my-wnd-keys (kbd "C-z")          'delete-window)
(define-key my-wnd-keys (kbd "C-k")          'kill-buffer-and-window)
(define-key my-wnd-keys (kbd "C-M-d")        'kill-buffer-and-window)
(define-key my-wnd-keys (kbd "C-d")          'force-kill-buffer)

;; ie. C-x C-M-f
(define-key ctl-x-map (kbd "C-M-f")          'find-file-other-window)

(define-key my-wnd-keys (kbd "C-o")          'delete-other-windows)
(define-key my-wnd-keys (kbd "M-o")          'golden-ratio)
(define-key my-wnd-keys (kbd "C-M-o")        'kill-other-window-and-buffer)

(define-key my-wnd-keys (kbd "C-c")          'copy-to-register)

(define-key my-wnd-keys (kbd "C-t")          'tiling-cycle)
(define-key my-wnd-keys (kbd "C-'")          'ace-window)
(define-key my-wnd-keys (kbd "'")            'ace-window)

;; (global-set-key (kbd "C-<f4>")                'delete-frame)
(global-set-key (kbd "C-<f4>")                'server-edit)
(define-key my-wnd-keys (kbd "C-f")           'delete-frame)


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

;; Auto-refresh ibuffer
(defun my-buffer-list-update-hook ()
  (and (eq major-mode 'ibuffer-mode)
       (ibuffer-current-state-list)))
;; buffer-list-update-hook
;; (add-hook 'buffer-list-update-hook 'my-buffer-list-update-hook)
;; (remove-hook 'buffer-list-update-hook 'my-buffer-list-update-hook)
