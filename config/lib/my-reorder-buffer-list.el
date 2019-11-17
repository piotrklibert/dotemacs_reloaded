;;
;; Changing current buffer places this buffer at the top of buffers list. This
;; means that functions like "previous-buffer" only loop between first two
;; buffers in a list. I don't like this.
;;
;; I wanted to be able to move to Nth last displayed buffer and have it moved at
;; the top, with all the other buffers still where they were. I implement this
;; by "freezing" a buffer list and switching between buffers without making them
;; current as long as you only invoke only the `tfb-up' `tfb-down' functions.
;; Once you press any other key, the currently displayed buffer is made current.
;;
;; This could use some love, but it works for me well enough for now.

(require 's)
(require 'dash)

(cl-defstruct file-buffers-list
  list pos)


(defun make-fbl (list pos)
  (make-file-buffers-list :list list :pos pos))


(defvar my-file-buffers nil)


;; Shortened accessors
(defun fbl-list () (file-buffers-list-list my-file-buffers))
(defun fbl-pos () (file-buffers-list-pos my-file-buffers))

(defun fb-list-nth (fb-list)
  "Get a current buffer out of given `file-buffers-list' struct.
If its `pos' is somehow out of range, wrap it before returning."
  (let*
      ((pos   (file-buffers-list-pos fb-list))
       (list  (file-buffers-list-list fb-list) )
       (pos   (% pos (length list)))
       (pos   (if (< pos 0) (1+ (- (length list) pos)) pos)))
    (nth pos list)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun tfb-init ()
  (interactive)
  (setq my-file-buffers (make-fbl (tfb--buf-names) 0)))

(defun tfb-moveto (&optional delta)
  (unless delta (setq delta 1))
  (unless my-file-buffers
    (tfb-init))
  (unless overriding-local-map
    (tfb--override-local-map))

  (let* ((pos (fbl-pos))
         (len (length (fbl-list)))
         (dest (+ pos delta))
         (dest (if (< dest 0) (1- len) dest)))
    (setf (file-buffers-list-pos my-file-buffers) dest)
    (switch-to-buffer (fb-list-nth my-file-buffers) t)))

(defun tfb-finish ()
  (switch-to-buffer (fb-list-nth my-file-buffers))
  (setq my-file-buffers nil)
  (message "Current buffer made first in buffer list."))

(defun tfb-done ()
  (interactive)
  (tfb-finish)
  (setq overriding-local-map nil)

  (let* ((keys (progn
                 (setq unread-command-events (append (this-single-command-raw-keys)
                                                     unread-command-events))
                 (read-key-sequence-vector "")))
         (command (and keys (key-binding keys))))
    (when (commandp command)
      (setq this-command          command)
      (setq this-original-command command)
      (call-interactively command))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun tfb--override-local-map ()
  "Override the local key map for jump char CHAR."
  (setq overriding-local-map
        (let ((map (make-sparse-keymap)))
          (define-key map (kbd "C-M-<kp-next>")  #'tfb-up)
          (define-key map (kbd "C-M-<next>")  #'tfb-up)
          (define-key map (kbd "C-M-<kp-prior>") #'tfb-down)
          (define-key map (kbd "C-M-<prior>") #'tfb-down)
          (define-key map [t]                 #'tfb-done)
          map)))


(defconst tfb-special-buffers-whitelist '("shell" "ibuffer" "repl" "scratch" "info" "help"))

(defun tfb--hidden-buf? (buffer-name)
  (setq buffer-name (s-downcase buffer-name))
  (and (s-contains? "*" buffer-name)
       (not (-any 'identity (--map (s-contains? it buffer-name)
                                   tfb-special-buffers-whitelist)))))

(defun tfb--buf-names ()
  (let ((names (-map 'buffer-name (buffer-list))))
    (-remove 'tfb--hidden-buf? names)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun tfb-up ()
  (interactive)
  (tfb-moveto 1))

(defun tfb-down ()
  (interactive)
  (tfb-moveto -1))

(global-set-key (kbd "C-M-<prior>") 'tfb-down)
(global-set-key (kbd "C-M-<next>")  'tfb-up)

(provide 'my-reorder-buffer-list)
