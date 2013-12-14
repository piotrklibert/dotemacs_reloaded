;;
;; Changing current buffer places this buffer at the top of buffers list. This
;; means that functions like "previous-buffer" only loop between first two
;; buffers in a list. I don't like this.
;;
;; I wanted to be able to move to Nth last displayed buffer and have it moved at
;; the top, with all the other buffers still where they were. I implement this
;; by "freezing" a buffer list and switching between buffers without making them
;; current. I then install a timer, which performs a full switch-to-buffer after
;; a given time elapsed and the buffer wasn't changed.
;;
;; This could use some love, but it works for me well enough for now.

(require 'deferred)

(defstruct file-buffers-list
  list pos)

(defvar my-file-buffers nil)
(defvar my-last-traverse nil)
(defvar my-deferred nil)

(defmacro make-fbl (list pos)
  `(make-file-buffers-list :list ,list
                           :pos ,pos))
(defun fbl-list ()
  (file-buffers-list-list my-file-buffers))
(defun fbl-pos ()
  (file-buffers-list-pos my-file-buffers))

(defmacro fb-list-nth (fb-list)
  "Get a current buffer out of given `file-buffers-list' struct.
If it's `pos' is somehow out of range, wrap it before returning."
  `(let*
       ((pos   (file-buffers-list-pos ,fb-list))
        (list  (file-buffers-list-list ,fb-list) )
        (pos   (% pos (length list)))
        (pos   (if (< pos 0) (1+ (- (length list) pos)) pos)))
     (nth pos list)))


(defun tfb-hidden-buf? (it)
  (s-contains? "*" it))

(defun tfb-buf-names ()
  (let ((names (-map 'buffer-name (buffer-list))))
    (-remove 'tfb-hidden-buf? names)))

(defun tfb-init ()
  (setq my-file-buffers (make-fbl (tfb-buf-names) 0)))

(defun tfb-finish ()
  (switch-to-buffer (fb-list-nth my-file-buffers))
  (setq my-file-buffers  nil
        my-last-traverse nil
        my-deferred      nil)
  (message "Current buffer made first in buffer list."))

(defun my-schedule-cleanup ()
  (unless my-deferred
    (setq my-deferred
          (deferred:$
            (deferred:wait 1000)
            (deferred:nextc it
              (lambda (x)
                (if (> (- (float-time) my-last-traverse) 1.2)
                    (tfb-finish)
                  (setq my-deferred nil)
                  (my-schedule-cleanup))))))))

(defun tfb-moveto (&optional delta)
  (setq my-last-traverse   (float-time))
  (unless delta            (setq delta 1))
  (unless my-file-buffers  (tfb-init))
  (let*
      ((pos (fbl-pos))
       (len (length (fbl-list)))
       (dest (+ pos delta))
       (dest (if (< dest 0) (1- len) dest)))
    (setf (file-buffers-list-pos my-file-buffers) dest)
    (switch-to-buffer (fb-list-nth my-file-buffers) t)
    (my-schedule-cleanup)))

(defun tfb-up ()
  (interactive)
  (tfb-moveto 1))

(defun tfb-down ()
  (interactive)
  (tfb-moveto -1))

(global-set-key (kbd "C-M-<prior>") 'tfb-down)
(global-set-key (kbd "C-M-<next>")  'tfb-up)

(provide 'my-reorder-buffer-list)
