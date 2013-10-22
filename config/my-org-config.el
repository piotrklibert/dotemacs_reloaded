;; TODO:
;; save all org mode buffers on push/pull
;; success message
;; * parse rsync output
;; * one line message only
;; * notify about failure too

(setq org-directory "~/todo/")
(setq org-agenda-files (list "~/todo/"))
(setq org-mobile-directory "~/orgmobile/")
(setq org-mobile-inbox-for-pull "~/todo/mobile-pull.org")

(setq org-default-notes-file "~/todo/notes")


(require 'org)
(org-remember-insinuate)
(setq remember-annotation-functions '(org-remember-annotation))
(setq remember-handler-functions '(org-remember-handler))
(add-hook 'remember-mode-hook 'org-remember-apply-template)


(setq org-remember-templates
      '(("Todo" ?t "* TODO %? %^g\nAdded: %U\n%i" "~/todo/todo.org" "TASKS")
        ("Post" ?p "* %T %^{topic}\n %?" "~/todo/posty.org")
        ("Journal" ?j "* %T\n\t%?" "~/todo/journal.org")
        ("Browsing" ?j "* %T\n\t%?" "~/todo/journal.org")))


(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "runchrome.sh")


(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c r") 'org-remember)
(global-set-key (kbd "C-c c") 'org-capture)


(defun my-org-jump-to-heading (heading)
  (interactive
   (list (org-icompleting-read "Value: "
                               (mapcar 'list (org-property-values "CUSTOM_ID")))))
  (org-match-sparse-tree nil (concat "CUSTOM_ID=\"" heading "\"")))


(defun my-org-hook ()
  (define-key org-mode-map (kbd "C-c <up>")     'outline-previous-visible-heading)
  (define-key org-mode-map (kbd "C-c <down>")   'outline-next-visible-heading)
  (define-key org-mode-map (kbd "C-c C-<up>")   'org-backward-heading-same-level)
  (define-key org-mode-map (kbd "C-c C-<down>") 'org-forward-heading-same-level)
  (define-key org-mode-map (kbd "C-c C-h")      'my-org-jump-to-heading))




(add-hook 'org-mode-hook 'my-org-hook)


;; org-goto-interface
;; org-goto-auto-isearch


;; Stolen from: http://www.emacswiki.org/cgi-bin/wiki/Journal

(defun my-now (&optional arg)
  "Insert string for the current time formatted like '2:34 PM'."
  (interactive "p")
  (format-time-string "%H:%M"))

(defun my-insert-today ()
  "Insert string for today's date nicely formatted in American style,
e.g. Sunday, September 17, 2000."
  (interactive)                 ; permit invocation in minibuffer
  (insert (concat "<"
                  (format-time-string "%Y-%m-%d %a")
                  " "
                  (my-now)
                  ">")))

(define-key my-toggle-keys (kbd "t") 'my-insert-today)
(define-key my-toggle-keys (kbd "C-t") 'my-insert-today)




;;  ___  ____   ____       ____  _   _ ____  _   _    ______  _   _ _     _
;; / _ \|  _ \ / ___|     |  _ \| | | / ___|| | | |  / /  _ \| | | | |   | |
;;| | | | |_) | |  _ _____| |_) | | | \___ \| |_| | / /| |_) | | | | |   | |
;;| |_| |  _ <| |_| |_____|  __/| |_| |___) |  _  |/ / |  __/| |_| | |___| |___
;; \___/|_| \_\\____|     |_|    \___/|____/|_| |_/_/  |_|    \___/|_____|_____|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; YaSnippet: mo - insert my-org defun
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'deferred)


;;
;; INTERFACE
;;

;;;###autoload
(defun my-org-export ()
  (interactive)
  (deferred:$
    (deferred:call 'org-mobile-push)
    (deferred:nextc it (lambda (ignored)   (my-start-rsync "orgmobile ec2:")))
    (deferred:nextc it (lambda (p)         (my-bzr-commit-and-push)))
    (deferred:error it (lambda (er)        (message "err: %s" er)))
    (deferred:nextc it (lambda (&rest arg) (message "export finished")))))

;;;###autoload
(defun my-org-import ()
  (interactive)
  (deferred:$
    (my-start-rsync "ec2:orgmobile/ orgmobile")
    (deferred:nextc it
      (lambda (out)
        (org-mobile-pull)
        (message "import finished")))))


;;
;; IMPLEMENTATION
;;

(defun my-bzr-commit-and-push ()
  (message "bzr commit & push being called")
  (deferred:$
    (deferred:process-shell "cd ~/todo/ && bzr ci -m \"commit\"")
    (deferred:nextc it (lambda (output)
                         (deferred:process-shell "cd ~/todo/ && bzr push")))
    (deferred:nextc it (lambda (output)
                         (message "bzr finished")))))


(defun my-start-rsync (spec)
  (message "start-rsync being called")
  (let ((cmd (concat "cd ~/ && rsync --rsh=\"ssh\" -avc " spec)))
    (deferred:$
      (deferred:process-shell cmd)
      (deferred:nextc it (lambda (out)
                           (message "rsync finished" out)
                           (deferred:succeed out))))))
