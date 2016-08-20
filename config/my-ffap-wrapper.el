;;
;;   _____ _____ _    ____   __        ______      _    ____  ____  _____ ____
;;  |  ___|  ___/ \  |  _ \  \ \      / /  _ \    / \  |  _ \|  _ \| ____|  _ \
;;  | |_  | |_ / _ \ | |_) |  \ \ /\ / /| |_) |  / _ \ | |_) | |_) |  _| | |_) |
;;  |  _| |  _/ ___ \|  __/    \ V  V / |  _ <  / ___ \|  __/|  __/| |___|  _ <
;;  |_|   |_|/_/   \_\_|        \_/\_/  |_| \_\/_/   \_\_|   |_|   |_____|_| \_\
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defvar my-ffap-roots '("/home/cji/projects/donorship/backend/"
                        "/home/cji/projects/cars/resources/"))


(defun my-project-ffap (&optional new-win)
  "A `ffap' replacement which checks for existence of the file at
point under a few known directories. Calls original if it's more
complicated than this."
  (interactive "P")
  (let
      ((fname (ffap-string-at-point))
       found)

    (loop for normalizer in '(normalize-ffap-name
                              convert-python-dotted-to-path)
          do (loop for root in my-ffap-roots
                   for fname1 = (concat (file-name-as-directory root)
                                       (funcall normalizer fname))
                   if (file-exists-p fname1)
                   do (progn
                        (message fname1)
                        (setq found fname1))))

    (if found
        (funcall (if new-win 'find-file-other-window 'find-file) found)
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
