;;
;;   _____ _____ _    ____   __        ______      _    ____  ____  _____ ____
;;  |  ___|  ___/ \  |  _ \  \ \      / /  _ \    / \  |  _ \|  _ \| ____|  _ \
;;  | |_  | |_ / _ \ | |_) |  \ \ /\ / /| |_) |  / _ \ | |_) | |_) |  _| | |_) |
;;  |  _| |  _/ ___ \|  __/    \ V  V / |  _ <  / ___ \|  __/|  __/| |___|  _ <
;;  |_|   |_|/_/   \_\_|        \_/\_/  |_| \_\/_/   \_\_|   |_|   |_____|_| \_\
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defvar my-ffap-roots '("/home/cji/projects/donorship/backend/"
                        "/home/cji/projects/ebundler/code/backend/"))

(defun my-project-ffap (&optional new-win)
  "A `ffap' replacement which checks for existence of the file at
point under a few known directories. Calls original if it's more
complicated than this."
  (interactive "P")
  (let* ((fname-at-pt (ffap-string-at-point))
         (fname-normalized (if (file-name-absolute-p fname-at-pt)
                               (replace-regexp-in-string "^/" "" fname-at-pt t t)
                             fname-at-pt))
         found)

    (loop for r in my-ffap-roots
          for fname = (concat (file-name-as-directory r) fname-normalized)
          if (file-exists-p fname)
          do (setq found fname))

    (or (and found (funcall (if new-win 'find-file-other-window 'find-file)
                            found))
        (call-interactively 'ffap))))

(provide 'my-ffap-wrapper)
