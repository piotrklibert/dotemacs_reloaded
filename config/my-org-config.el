;; TODO:
;; save all org mode buffers on push/pull
;; success message
;; * parse rsync output
;; * one line message only
;; * notify about failure too

;; (setq org-html-htmlize-output-type 'inline-css) ;; default
(setq org-html-htmlize-output-type 'inline-css)
;; (setq org-html-htmlize-font-prefix "") ;; default
;; (setq org-html-htmlize-font-prefix "org-")
(setq org-html-htmlize-font-prefix "")


(setq org-structure-template-alist
 '(("s" "#+NAME:\n#+BEGIN_SRC ?\n\n#+END_SRC")
   ("e" "#+BEGIN_EXAMPLE\n?\n#+END_EXAMPLE")
   ("q" "#+BEGIN_QUOTE\n?\n#+END_QUOTE")
   ("v" "#+BEGIN_VERSE\n?\n#+END_VERSE")
   ("V" "#+BEGIN_VERBATIM\n?\n#+END_VERBATIM")
   ("c" "#+BEGIN_CENTER\n?\n#+END_CENTER")
   ("l" "#+BEGIN_LaTeX\n?\n#+END_LaTeX")
   ("L" "#+LaTeX: ")
   ("h" "#+BEGIN_HTML\n?\n#+END_HTML")
   ("H" "#+HTML: ")
   ("a" "#+BEGIN_ASCII\n?\n#+END_ASCII")
   ("A" "#+ASCII: ")
   ("i" "#+INDEX: ?")
   ("I" "#+INCLUDE: %file ?")))


(defface org-block-begin-line
  '((t (:height 0.85 :foreground "#9ED5D5" :background "#968E8E")))
  "Face used for the line delimiting the begin of source blocks.")

(defface org-block-end-line
  '((t (:height 0.85 :foreground "#9ED5D5"  :background "#968E8E")))
  "Face used for the line delimiting the end of source blocks.")



(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(setq org-directory "~/todo/")
(setq org-agenda-files (list "~/todo/"))
(setq org-mobile-directory "~/orgmobile/")
(setq org-mobile-inbox-for-pull "~/todo/mobile-pull.org")

(setq org-default-notes-file "~/todo/notes")
(org-clock-persistence-insinuate)



(require 'ob-ls)

(add-to-list 'org-src-lang-modes '("ls" . livescript))

(setq org-babel-load-languages '((emacs-lisp . t)
                                 (python . t)
                                 (scheme . t)
                                 (js . t)
                                 (ls . t)
                                 (livescript . t)
                                 (io . t)))




(require 'org)
(setq remember-annotation-functions '(org-remember-annotation))
(setq remember-handler-functions '(org-remember-handler))
(add-hook 'remember-mode-hook 'org-remember-apply-template)

(setq org-src-fontify-natively t)

;; (setq org-remember-templates
;;      '(("Todo" ?t "* TODO %? %^g\nAdded: %U\n%i" "~/todo/todo.org" "TASKS")
;;        ("Post" ?p "* %T %^{topic}\n %?" "~/todo/posty.org")
;;        ("Journal" ?j "* %T\n\t%?" "~/todo/journal.org")
;;        ("Browsing" ?j "* %T\n\t%?" "~/todo/journal.org")))


(setq org-capture-templates
      (quote (("t" "todo" entry (file+headline "~/todo/work.org" "TASKS")
               "* TODO %?\n  Added: %U\n  Origin: %a\n")

              ("T" "todo" entry (file+headline "~/todo/todo.org" "TASKS")
               "* TODO %?\n  Added: %U\n  Origin: %a\n")

              ("n" "note" entry (file "~/todo/notes.org")
               "* %? :NOTE:\n  Added: %U\n  Origin: %a\n  %i")

              ("r" "respond" entry (file "~/todo/refile.org")
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("j" "Journal" entry (file+datetree "~/todo/notes.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/todo/refile.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file "~/todo/refile.org")
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file "~/todo/refile.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/todo/refile.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))


;;   ____ _   _ ____ _____ ___  __  __      _    ____ _____ _   _ ____    _
;;  / ___| | | / ___|_   _/ _ \|  \/  |    / \  / ___| ____| \ | |  _ \  / \
;; | |   | | | \___ \ | || | | | |\/| |   / _ \| |  _|  _| |  \| | | | |/ _ \
;; | |___| |_| |___) || || |_| | |  | |  / ___ \ |_| | |___| |\  | |_| / ___ \
;;  \____|\___/|____/ |_| \___/|_|  |_| /_/   \_\____|_____|_| \_|____/_/   \_\
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

(setq org-agenda-custom-commands
      '(("m" "Notes"
         ((tags "/!NEXT|ACTIVE"
                ((org-agenda-overriding-header "Next tasks")))
          (tags "/SUSPENDED|WAITING"
                ((org-agenda-overriding-header "Suspended tasks")))
          (tags "NOTE"
                ((org-agenda-overriding-header "Notes")
                 (org-tags-match-list-sublevels nil)))))))

;; '((" " "Agenda"
;;    ((agenda "" nil)
;;     (tags "REFILE"
;;           ((org-agenda-overriding-header "Tasks to Refile")
;;            (org-tags-match-list-sublevels nil)))
;;     (tags-todo "-CANCELLED/!"
;;                ((org-agenda-overriding-header "Stuck Projects")
;;                 (org-agenda-skip-function 'bh/skip-non-stuck-projects)
;;                 (org-agenda-sorting-strategy
;;                  '(priority-down category-keep))))
;;     (tags-todo "-HOLD-CANCELLED/!"
;;                ((org-agenda-overriding-header "Projects")
;;                 (org-agenda-skip-function 'bh/skip-non-projects)
;;                 (org-agenda-sorting-strategy
;;                  '(priority-down category-keep))))
;;     (tags-todo "-CANCELLED/!NEXT"
;;                ((org-agenda-overriding-header "Project Next Tasks")
;;                 (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
;;                 (org-tags-match-list-sublevels t)
;;                 (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
;;                 (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
;;                 (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
;;                 (org-agenda-sorting-strategy
;;                  '(priority-down todo-state-down effort-up category-keep))))
;;     (tags-todo "-REFILE-CANCELLED-WAITING/!"
;;                ((org-agenda-overriding-header (if (marker-buffer org-agenda-restrict-begin) "Project Subtasks" "Standalone Tasks"))
;;                 (org-agenda-skip-function 'bh/skip-project-tasks-maybe)
;;                 (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
;;                 (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
;;                 (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
;;                 (org-agenda-sorting-strategy
;;                  '(category-keep))))
;;     (tags-todo "-CANCELLED+WAITING/!"
;;                ((org-agenda-overriding-header "Waiting and Postponed Tasks")
;;                 (org-agenda-skip-function 'bh/skip-stuck-projects)
;;                 (org-tags-match-list-sublevels nil)
;;                 (org-agenda-todo-ignore-scheduled 'future)
;;                 (org-agenda-todo-ignore-deadlines 'future)))
;;     (tags "-REFILE/"
;;           ((org-agenda-overriding-header "Tasks to Archive")
;;            (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
;;            (org-tags-match-list-sublevels nil))))
;;    nil))

;; Custom agenda command definitions
;; (
;;       (quote

;;               ("h" "Habits" tags-todo "STYLE=\"habit\""
;;                ((org-agenda-overriding-header "Habits")
;;                 (org-agenda-sorting-strategy
;;                  '(todo-state-down effort-up category-keep))))

;;               ("r" "Tasks to Refile" tags "REFILE"
;;                ((org-agenda-overriding-header "Tasks to Refile")
;;                 (org-tags-match-list-sublevels nil)))
;;               ("#" "Stuck Projects" tags-todo "-CANCELLED/!"
;;                ((org-agenda-overriding-header "Stuck Projects")
;;                 (org-agenda-skip-function 'bh/skip-non-stuck-projects)))
;;               ("n" "Next Tasks" tags-todo "-WAITING-CANCELLED/!NEXT"
;;                ((org-agenda-overriding-header "Next Tasks")
;;                 (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
;;                 (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
;;                 (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
;;                 (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
;;                 (org-tags-match-list-sublevels t)
;;                 (org-agenda-sorting-strategy
;;                  '(todo-state-down effort-up category-keep))))
;;               ("R" "Tasks" tags-todo "-REFILE-CANCELLED/!-HOLD-WAITING"
;;                ((org-agenda-overriding-header "Tasks")
;;                 (org-agenda-skip-function 'bh/skip-project-tasks-maybe)
;;                 (org-agenda-sorting-strategy
;;                  '(category-keep))))
;;               ("p" "Projects" tags-todo "-HOLD-CANCELLED/!"
;;                ((org-agenda-overriding-header "Projects")
;;                 (org-agenda-skip-function 'bh/skip-non-projects)
;;                 (org-agenda-sorting-strategy
;;                  '(category-keep))))
;;               ("w" "Waiting Tasks" tags-todo "-CANCELLED+WAITING/!"
;;                ((org-agenda-overriding-header "Waiting and Postponed tasks"))
;;                (org-tags-match-list-sublevels nil))
;;               ("A" "Tasks to Archive" tags "-REFILE/"
;;                ((org-agenda-overriding-header "Tasks to Archive")
;;                 (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
;;                 (org-tags-match-list-sublevels nil))))))


(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")


(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c r") 'org-remember)
(global-set-key (kbd "C-c c") 'org-capture)


(defun my-org-jump-to-heading (heading)
  (interactive
   (list (org-icompleting-read "Value: "
                               (mapcar 'list (org-property-values "CUSTOM_ID")))))
  (org-match-sparse-tree nil (concat "CUSTOM_ID=\"" heading "\"")))


(defun swap-cells ()
  (interactive)
  (org-table-previous-field)
  (let
      ((val (org-table-get-field nil "")))
    (org-table-next-field)
    (insert val)
    (org-table-recalculate)))


(defun my-org-hook ()
  (define-key org-mode-map (kbd "<f4>")         'swap-cells)  ; orgtbl mode
  (define-key org-mode-map (kbd "C-c <up>")     'outline-previous-visible-heading)
  (define-key org-mode-map (kbd "C-c <down>")   'outline-next-visible-heading)
  (define-key org-mode-map (kbd "C-c C-<up>")   'org-backward-heading-same-level)
  (define-key org-mode-map (kbd "C-c C-<down>") 'org-forward-heading-same-level)
  (define-key org-mode-map (kbd "C-c C-h")      'my-org-jump-to-heading))


(add-hook 'org-mode-hook 'my-org-hook)


;; org-goto-interface
;; org-goto-auto-isearch


;; Stolen from: http://www.emacswiki.org/cgi-bin/wiki/Journal
;; because on my FreeBSD Org crashed with C-c C-s...

(defun my-now (&optional arg)
  "Insert string for the current time formatted like '2:34 PM'."
  (interactive "p")
  (format-time-string "%H:%M"))

(defun my-insert-now ()
  "Insert string for today's date nicely formatted in American style,
e.g. Sunday, September 17, 2000."
  (interactive)                         ; permit invocation in minibuffer
  (let
      ((date (format-time-string "%Y-%m-%d %a"))
       (time (my-now)))
    (insert (concat "<" date " " time ">"))))



(defun my-insert-today ()
  (interactive)
  (let ((date (format-time-string "%Y-%m-%d") ))
    (insert (concat "[" date "]"))))


(define-key my-toggle-keys (kbd "t") 'my-insert-now)
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
  (my-bzr-commit-and-push)
  ;; (deferred:$
  ;;   (deferred:call 'org-mobile-push)
  ;;   (deferred:next (lambda (ignored)   (my-start-rsync "orgmobile ec2:")))
  ;;   (deferred:nextc it (lambda (p)         (my-bzr-commit-and-push)))
  ;;   (deferred:error it (lambda (er)        (message "err: %s" er)))
  ;;   (deferred:nextc it (lambda (&rest arg) (message "export finished"))))
  )

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



(defun org-dblock-write:rangereport (params)
  "Display day-by-day time reports. Insert comething like this:

#+BEGIN: rangereport :maxlevel 4 :scope tree3 :tstart \"<2013-11-12 wto>\" :tend \"<2013-11-28 czw>\"
#+END:

and press C-c C-x C-u (org-dblock-update) while on it to generate the report.
"
  (let* ((ts (plist-get params :tstart))
         (te (plist-get params :tend))
         (start (time-to-seconds
                 (apply 'encode-time (org-parse-time-string ts))))
         (end (time-to-seconds
               (apply 'encode-time (org-parse-time-string te))))
         day-numbers startendday)
    (setq params (plist-put params :tstart nil))
    (setq params (plist-put params :end nil))
    (while (<= start end)
      (save-excursion
        (setq startendday (+ 86400 start))
        (insert "\n\n"
                (format-time-string (car org-time-stamp-formats)
                                    (seconds-to-time start))
                "----------------\n")
        (org-dblock-write:clocktable
         (plist-put
          (plist-put
           params
           :tstart
           (format-time-string (car org-time-stamp-formats)
                               (seconds-to-time start)))
          :tend
          (format-time-string (car org-time-stamp-formats)
                              (seconds-to-time startendday))))
        (setq start (+ 86400 start))))))
