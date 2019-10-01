(require 'tiling)
(require 'golden-ratio)
(require 'uniquify)
(require 'buffer-move)
(require 'elscreen)

(define-prefix-command 'my-wnd-keys)

(elscreen-start)

(global-set-key (kbd "C-<next>")    'elscreen-next)
(global-set-key (kbd "C-<prior>")   'elscreen-previous)
(define-key elscreen-map (kbd "T")  'elscreen-toggle-display-tab)

(defmacro refresh-tab-bar-after (&rest funcs)
  `(progn
     ,@(loop for f in funcs
             collect (let ()
                       `(defadvice ,f (after my-elscreen-refresh-tab-bar activate)
                          (elscreen-e21-tab-update t))))))

(refresh-tab-bar-after
 windmove-up windmove-down windmove-left windmove-right)
;; ==============================================================================

(use-package ace-window
  :commands ace-window
  :bind (:map my-wnd-keys ("'" . ace-window)))


(use-package minimap
  :bind ("<f5>" . minimap-mode))


;; (golden-ratio-mode t)


;; C-w ... - keys related to moving, rearranging and killing buffers and
;; windows.
(global-set-key (kbd "C-w") 'my-wnd-keys)
;; (find-my-bindings-for 'my-wnd-keys)


;; I would like to use C-w as a prefix for all window-manipulating functions,
;; but it is taken by cut by default. Life without it would be less than
;; comfortable, so we transfer it to C-w C-w.
(define-key my-wnd-keys (kbd "C-w")                 'kill-region)


(defvar my-zoom nil)

(defun my-zoom-windows ()
  (interactive)
  (if (not my-zoom)
      (progn
        (setq my-zoom (current-window-configuration))
        (delete-other-windows))
    (set-window-configuration my-zoom)
    (setq my-zoom nil)))

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

(defun my-windows-delete-window-and-buffer-in-dir ()
  (interactive)
  (let* ((vec (this-command-keys-vector))
         (dir (elt vec (1- (length vec))))
         (dirname (s-replace "M-" "" (symbol-name dir))))
    (funcall (intern (concat "windmove-" dirname)))
    (kill-buffer-and-window)))

(define-key my-wnd-keys (kbd "d M-<left>")     'my-windows-delete-window-and-buffer-in-dir)
(define-key my-wnd-keys (kbd "d M-<right>")    'my-windows-delete-window-and-buffer-in-dir)
(define-key my-wnd-keys (kbd "d M-<up>")       'my-windows-delete-window-and-buffer-in-dir)
(define-key my-wnd-keys (kbd "d M-<down>")     'my-windows-delete-window-and-buffer-in-dir)


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
(define-key my-wnd-keys (kbd "z")            'my-zoom-windows)
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

(define-key my-wnd-keys (kbd "C-f")           'delete-frame)
(global-set-key (kbd "C-<f4>")                'delete-frame)
;; (global-set-key (kbd "C-<f4>")                'server-edit)


(defun my-switch-to-column (column)
  (interactive)
  (ignore-errors
    (while t (windmove-left)))
  ;; (message "buffer: %s col: %s" (current-buffer) column)
  (when (and column (> column 0))
    (loop repeat (1- column)
          do (windmove-right)))
  ;; (message "buffer: %s col: %s" (current-buffer) column)
  )

(defun my-switch-to-column-1 ()
  (interactive)
  (my-switch-to-column 1))

(defun my-switch-to-column-2 ()
  (interactive)
  (my-switch-to-column 2))

(defun my-switch-to-column-3 ()
  (interactive)
  (my-switch-to-column 3))

(global-set-key (kbd "M-1") #'my-switch-to-neotree)
(global-set-key (kbd "M-2") #'my-switch-to-column-2)
(global-set-key (kbd "M-3") #'my-switch-to-column-3)

(defun scroll-left-a-bit ()
  (interactive)
  (scroll-left (max 15 (round (* (window-width) 0.2)) )))

(defun scroll-rigth-a-bit ()
  (interactive)
  (scroll-right (max 15 (round (* (window-width) 0.2)))))

(define-key ctl-x-map (kbd ">") 'scroll-left-a-bit)
(define-key ctl-x-map (kbd "<") 'scroll-rigth-a-bit)

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
          do (ignore-errors
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


;; byte-compile-warnings
;; (remove-hook 'buffer-list-update-hook 'my-buffer-list-update-hook)
