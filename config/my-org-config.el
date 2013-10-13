(setq org-directory "~/todo/")
(setq org-agenda-files (list "~/todo/"))
(setq org-mobile-directory "~/orgmobile/")
(setq org-mobile-inbox-for-pull "~/todo/mobile-pull.org")
;; (setq org-mobile-force-id-on-agenda-items nil)

(global-set-key (kbd "C-c a") 'org-agenda)



;;  ___  ____   ____       ____  _   _ ____  _   _    ______  _   _ _     _
;; / _ \|  _ \ / ___|     |  _ \| | | / ___|| | | |  / /  _ \| | | | |   | |
;;| | | | |_) | |  _ _____| |_) | | | \___ \| |_| | / /| |_) | | | | |   | |
;;| |_| |  _ <| |_| |_____|  __/| |_| |___) |  _  |/ / |  __/| |_| | |___| |___
;; \___/|_| \_\\____|     |_|    \___/|____/|_| |_/_/  |_|    \___/|_____|_____|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defvar my-org-rsync-output "")
(defvar my-org-rsync-pname "*OrgSync*")
(defvar my-org-rsync nil)

;;
;; INTERFACE
;;

;;;###autoload
(defun my-org-export ()
  "Export org files to OrgMobile."
  (interactive)
  (org-mobile-push)
  (my-org-start-rsync "orgmobile ec2:" )
  (my-org-start-timer))

;;;###autoload
(defun my-org-import ()
  "Fetch changes from OrgMobile and pull them into org."
  (interactive)
  (my-org-start-rsync "ec2:orgmobile/ orgmobile")
  (my-org-start-timer 'org-mobile-pull))



;;
;; IMPLEMENTATION
;;

(defun my-org-start-rsync (spec)
  "Start a new async rsync process. It will be started from home
directory. A `spec' arg is a string with two paths, FROM and TO,
in a format rsync will recognize."
  (let ((pname my-org-rsync-pname)
        (cmd (concat "cd ~/ && rsync --rsh=\"ssh\" -avc "
                     spec)))
    (setq my-org-rsync (start-process-shell-command pname pname cmd))
    (set-process-filter my-org-rsync 'my-org-rsync-filter)))

(defun my-org-rsync-filter (process output)
  (setq my-org-rsync-output (concat my-org-rsync-output output)))


(defun my-org-start-timer (&optional callback)
  "Schedule an rsync status checker to run in a bit. Pass a
callback to the checker if specified."
  (run-at-time "2 sec" nil 'my-org-check-rsync-status callback))

(defun my-org-check-rsync-status (&optional callback)
  "Check if rsync process finished. If not, try again in a bit.
It it finished print a message, clean-up it's buffer, output and
process. At the end (optionally) execute given callback."
  (if (not (eq (process-status my-org-rsync) 'exit))
      (my-org-start-timer callback)
    (message "Rsync finished with:\n'%s'" my-org-rsync-output)
    (setq my-org-rsync nil
          my-org-rsync-output "")
    (kill-buffer my-org-rsync-pname)
    (when callback
      (funcall callback))))
