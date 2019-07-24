(require 'hydra)
(require 'tiling)
(require 'golden-ratio)
(require 'uniquify)
(require 'buffer-move)
(require 'my-reorder-buffer-list)


(require 'elscreen)
(elscreen-start)
(global-set-key (kbd "C-<next>")          'elscreen-next)
(global-set-key (kbd "C-<XF86AudioNext>") 'elscreen-next)
(global-set-key (kbd "C-<prior>")         'elscreen-previous)
(global-set-key (kbd "C-<XF86AudioPlay>") 'elscreen-previous)


;; (require 'minimap)
;; (global-set-key (kbd "M-<f2>") 'minimap-mode)

;; (golden-ratio-mode t)


;; C-w ... - keys related to moving, rearrangind and killing buffers and
;; windows.
(define-prefix-command 'my-wnd-keys)
(global-set-key (kbd "C-w") 'my-wnd-keys)
;; (find-my-bindings-for 'my-wnd-keys)


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


(define-key my-wnd-keys (kbd "d <left>")     'windmove-delete-left)
(define-key my-wnd-keys (kbd "d <right>")    'windmove-delete-right)
(define-key my-wnd-keys (kbd "d <up>")       'windmove-delete-up)
(define-key my-wnd-keys (kbd "d <down>")     'windmove-delete-down)


(define-key my-wnd-keys (kbd "<right>")      'hydra-splitter/hydra-move-splitter-right)
(define-key my-wnd-keys (kbd "<left>")       'hydra-splitter/hydra-move-splitter-left)
(define-key my-wnd-keys (kbd "<up>")         'hydra-splitter/hydra-move-splitter-up) ; TODO: make it more natural with regards to arrow directions
(define-key my-wnd-keys (kbd "<down>")       'hydra-splitter/hydra-move-splitter-down)
(define-key my-wnd-keys (kbd "=")            'balance-windows)
(define-key my-wnd-keys (kbd "C-=")          'balance-windows)

(define-key my-wnd-keys (kbd "M-<up>"   )    'buf-move-up)
(define-key my-wnd-keys (kbd "M-<down>" )    'buf-move-down)
(define-key my-wnd-keys (kbd "M-<right>")    'buf-move-right)
(define-key my-wnd-keys (kbd "M-<left>" )    'buf-move-left)

(define-key my-wnd-keys (kbd "C-s")          'my-split-window-below)
(define-key my-wnd-keys (kbd "\"")           'my-split-window-below)
(define-key my-wnd-keys (kbd "C-v")          'my-split-window-right)
(define-key my-wnd-keys (kbd "%")            'my-split-window-right)

(define-key my-wnd-keys (kbd "C-z")          'delete-window)
;; (define-key my-wnd-keys (kbd "C-k")          'kill-buffer-and-window)
(define-key my-wnd-keys (kbd "C-d")          'force-kill-buffer)
(define-key my-wnd-keys (kbd "C-M-d")        'kill-buffer-and-window)
(define-key my-wnd-keys (kbd "M-d")          'kill-other-buffer)

;; ie. C-x C-M-f
(define-key ctl-x-map (kbd "C-M-f")          'find-file-other-window)

(define-key my-wnd-keys (kbd "C-o")          'delete-other-windows)
(define-key my-wnd-keys (kbd "C-M-o")        'kill-other-window-and-buffer)
(define-key my-wnd-keys (kbd "M-o")          'golden-ratio)

(define-key my-wnd-keys (kbd "C-c")          'copy-to-register)

(define-key my-wnd-keys (kbd "C-t")          'tiling-cycle)
(define-key my-wnd-keys (kbd "C-'")          'ace-window)
(define-key my-wnd-keys (kbd "'")            'ace-window)

(define-key my-wnd-keys (kbd "C-f")           'delete-frame)
(global-set-key (kbd "C-<f4>")                'delete-frame)
;; (global-set-key (kbd "C-<f4>")                'server-edit)


;;
;; Custom functions
;;
(defun kill-other-buffer ()
  "Kill the buffer displayed in other window without killing the window."
  (interactive)
  (save-window-excursion
    (other-window 1)
    (force-kill-buffer)))


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


;; auto-hscroll-mode
;; byte-compile-warnings
;; (remove-hook 'buffer-list-update-hook 'my-buffer-list-update-hook)
