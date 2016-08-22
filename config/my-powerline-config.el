(require 'powerline)

(powerline-default-theme)

(defun my-join-path (parts)
  (s-join "/" parts))

(defun my-shorten-path-segment (p)
  (if (<= (length p) 7)
      p
    (concat (substring p 0 2) ".." (substring p -2))))

(defun my-shorten-path-drop-segments (path max-size)
  (if (< (length path) max-size)
      path
    (let ((p (s-split "/" path))
          (idx 0))
      (while (and (> (length (my-join-path p)) max-size)
                  (> (length p) 2))
        (setf p (cdr p)))
      (my-join-path p))))

(defun my-shorten-path-shorten-segments (path max-size)
  (if (< (length path) max-size)
      path
    (let ((p (s-split "/" path))
          (idx 0))
      (while (and (> (length (my-join-path p)) max-size)
                  (< idx (length p)))
        (setf (nth idx p) (my-shorten-path-segment (nth idx p)))
        (setf idx (1+ idx)))
      (my-join-path p))))

;; (my-shorten-path "Users/piotrklibert/projects/bunsen/api/resources/blog/migrations/20160414113000-file-object.up.sql" 35)
;; (my-shorten-path-segment "piotrklibert")
;; (my-shorten-path "Users/piotrklibert/.emacs.d/config/my-powerline-config.el" 35)

(defun my-pl-format-dir (buffer-path)
  (->> buffer-path
    (s-replace "projects/" "")
    (s-replace "/Users/piotrklibert/" "")
    (s-split "/")
    (-butlast)
    (s-join "/")))

(defun my-pl-buffer-dir ()
  (condition-case error
      (-> (buffer-file-name)
        (my-pl-format-dir)
        (my-shorten-path-drop-segments my-powerline-max-path-length)
        (concat "/"))
    (error "")))

(defvar my-powerline-max-path-length 30)

(defpowerline powerline-buffer-id
  (let ((buffer-ident (powerline-trim
                       (format-mode-line
                        mode-line-buffer-identification))))
    (concat
     (propertize (concat " " (my-pl-buffer-dir))
                 'face 'diff-added-face)
     (propertize (concat " " buffer-ident " ")
                 'face 'pl/buffer-id-face))))


(provide 'my-powerline-config)
