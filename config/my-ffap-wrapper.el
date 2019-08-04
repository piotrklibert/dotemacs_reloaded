;;
;;   _____ _____ _    ____   __        ______      _    ____  ____  _____ ____
;;  |  ___|  ___/ \  |  _ \  \ \      / /  _ \    / \  |  _ \|  _ \| ____|  _ \
;;  | |_  | |_ / _ \ | |_) |  \ \ /\ / /| |_) |  / _ \ | |_) | |_) |  _| | |_) |
;;  |  _| |  _/ ___ \|  __/    \ V  V / |  _ <  / ___ \|  __/|  __/| |___|  _ <
;;  |_|   |_|/_/   \_\_|        \_/\_/  |_| \_\/_/   \_\_|   |_|   |_____|_| \_\
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'dash)

(defconst my-ffap-roots '("/home/cji/projects/bmw-ecard/"
                          "/home/cji/projects/cars/resources/"
                          "/home/cji/projects/donorship/backend/"
                          "/home/cji/projects/ebundler/code/backend/"))

(defun my-goto-thing-at-pt ()
  (interactive)
  (condition-case nil
      (xref-find-definitions (thing-at-point 'sexp))
    (error 2)))

;; (call-interactively #'my-goto-thing-at-pt)

(defun search-path-in-parents (path subpath)
  (if (not (string= subpath ""))
      (cl-loop for joined = (f-join path subpath)
            for parent = (f-parent path)
            if (f-exists? joined) return joined
            while parent do (setf path parent))
    nil))

(defvar my-ffap-found-file nil)

(defun search-path-in-roots (path)
  (cl-loop for normalizer in '(normalize-ffap-name convert-python-dotted-to-path)
           do (cl-loop for root in my-ffap-roots
                       for fname1 = (concat (file-name-as-directory root)
                                            (funcall normalizer path))
                       if (file-exists-p fname1)
                       do (progn
                            (message fname1)
                            (setq my-ffap-found-file fname1)))))

(defun search-subpath ()
  (cl-block nil
    (let*
        ((fname (ffap-string-at-point))
         (buf-name (-> (current-buffer) buffer-file-name))
         (buf-dir (if (not buf-name)
                      (return nil)
                    (f-parent buf-name)))
         my-ffap-found-file)
      (setf my-ffap-found-file (search-path-in-parents buf-dir fname))
      (when my-ffap-found-file (return my-ffap-found-file))
      (setf my-ffap-found-file (search-path-in-roots fname))
      (when my-ffap-found-file (return my-ffap-found-file)))))

(require 'xref)

(defun my-project-ffap (&optional new-win)
  "A `ffap' replacement which checks for existence of the file at
point under a few known directories. Calls original if it's more
complicated than this."
  (interactive "P")
  (let ((my-ffap-found-file (search-subpath))
        (find-file-fun (if new-win 'find-file-other-window 'find-file)))
    (if my-ffap-found-file
        (progn
          (ring-insert xref--marker-ring (point-marker))
          (funcall find-file-fun my-ffap-found-file))
      (call-interactively 'ffap))))


(defun convert-python-dotted-to-path (fname)
  (when (string-match "\\w+\\.\\w+.*" fname)
    (-> (s-replace "." "/" fname)
      (concat ".py"))))


(defun normalize-ffap-name (fname)
  (if (file-name-absolute-p fname)
      (replace-regexp-in-string "^/" "" fname t t)
    fname))


(provide 'my-ffap-wrapper)
