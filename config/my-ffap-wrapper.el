;;
;;   _____ _____ _    ____   __        ______      _    ____  ____  _____ ____
;;  |  ___|  ___/ \  |  _ \  \ \      / /  _ \    / \  |  _ \|  _ \| ____|  _ \
;;  | |_  | |_ / _ \ | |_) |  \ \ /\ / /| |_) |  / _ \ | |_) | |_) |  _| | |_) |
;;  |  _| |  _/ ___ \|  __/    \ V  V / |  _ <  / ___ \|  __/|  __/| |___|  _ <
;;  |_|   |_|/_/   \_\_|        \_/\_/  |_| \_\/_/   \_\_|   |_|   |_____|_| \_\
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defconst my-ffap-roots '("/home/cji/projects/donorship/backend/"
                          "/home/cji/projects/cars/resources/"
                          "/home/cji/projects/donorship/backend/"
                          "/home/cji/projects/ebundler/code/backend/"
                          "/Users/piotrklibert/projects/bunsen/"
                          "/Users/piotrklibert/projects/bunsen/api/resources/"
                          "/Users/piotrklibert/projects/bunsen/api/"))

(defun search-path-in-parents (path subpath)
  (if (not (string= subpath ""))
      (loop for joined = (f-join path subpath)
            for parent = (f-parent path)
            if (-> joined f-exists?) return joined
            while parent do (setf path parent))
    nil))

(defun search-path-in-roots (path)
  (loop for normalizer in '(normalize-ffap-name convert-python-dotted-to-path)
        do (loop for root in my-ffap-roots
                 for fname1 = (concat (file-name-as-directory root)
                                      (funcall normalizer fname))
                 if (file-exists-p fname1)
                 do (progn
                      (message fname1)
                      (setq found fname1)))))

(defun search-subpath ()
  (cl-block nil
    (let*
        ((fname (ffap-string-at-point))
         (buf-name (-> (current-buffer) buffer-file-name))
         (buf-dir (if (not buf-name)
                      (return nil)
                    (f-parent buf-name)))
         found)
      (setf found (search-path-in-parents buf-dir fname))
      (when found
        (message "1")
        (return found))

      (setf found (search-path-in-roots fname))
      (message "2")
      (when found (return found)))))

(defun my-project-ffap (&optional new-win)
  "A `ffap' replacement which checks for existence of the file at
point under a few known directories. Calls original if it's more
complicated than this."
  (interactive "P")
  (let ((found (search-subpath))
        (find-file-fun (if new-win 'find-file-other-window 'find-file)))
    (if found
        (progn
          (ring-insert xref--marker-ring (point-marker))
          (funcall find-file-fun found))
      (call-interactively 'ffap))))


(defun convert-python-dotted-to-path (fname)
  (when (string-match "\\w+\\.\\w+.*" fname)
    (-> (replace-in-string fname "\\." "/")
      (concat ".py"))))


(defun normalize-ffap-name (fname)
  (if (file-name-absolute-p fname)
      (replace-regexp-in-string "^/" "" fname t t)
    fname))


(provide 'my-ffap-wrapper)
