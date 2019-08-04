;; (put 'font-lock-add-keywords 'lisp-indent-function 1)


;; (defun my-make-txt-font-locks ()
;;   (let ((my-lst-line-re (rx (and line-start
;;                                  (0+ (in blank))
;;                                  "-"
;;                                  (opt blank)
;;                                  (group (0+ not-newline))
;;                                  line-end))))
;;     (font-lock-add-keywords nil
;;       `(("`.*?'" . font-lock-warning-face)
;;         (,my-lst-line-re 1 font-lock-warning-face)))))

;;; Some things I wrote but am not using anymore.
;;

(define-key my-wnd-keys (kbd "C-l")                 'switch-to-last-dired)

(defun switch-to-last-dired ()
  "Find a dired buffer and switch to it in one command."
  (interactive)
  (let ((bufs (buffer-list)))
    (catch 'no-more-bufs
      (dolist (b bufs)
        (with-current-buffer b
          (when (eq major-mode 'dired-mode)
              (switch-to-buffer b)
              (throw 'no-more-bufs nil))))
      (message "No direds open!"))))


(defun upcase-word-or-region ()
  (interactive)
  (if (use-region-p)
      (upcase-region (region-beginning) (region-end))
    (save-excursion
      (let
          ((bounds (bounds-of-thing-at-point 'word)))
        (goto-char (car bounds))
        (upcase-word 1)))))

(defun indent-region-or-line()
  "Re-indent marked region or current line if no region is active.

  I made std indent-for-tab behave nicely so this is unnecessary."
  (interactive)
  (let ((region-was-active (use-region-p))
        beg end)
    (if region-was-active
        (setq beg (region-beginning) end (line-end-position))
      (setq beg (line-beginning-position) end (line-end-position)))
    (indent-region beg end)
    (when region-was-active
      (setq deactivate-mark nil)
      (setq mark-active t))))

;; (defvar hilite-call nil)
;; (defvar hilite-data nil)
;; (setq hilite-call 10)
;; (setq hilite-data nil)
;; (reverse hilite-data)
;; (defun my-sue-hilighter (limit)
;;   ;; (set-text-properties
;;   ;;  2349 2362 '(font-lock-face error))
;;   (if (> (setq hilite-call (1- hilite-call)) 0)
;;       (progn
;;         (push (list (point) (point-max) limit) hilite-data)
;;         (goto-char (+ (point) (1- limit)) )
;;         t)
;;     nil))

;; (with-current-buffer (get-buffer "org-keys.org")
;;   ;; (font-lock-add-keywords nil '((my-sue-hilighter . font-lock-keyword-face)))

;;   )

;; (with-current-buffer (get-buffer "org-keys.org")
;;   ;; setq font-lock-keywords
;;   (font-lock-remove-keywords nil '(( org-font-lock-hook) my-sue-hilighter))

;;   (cdr font-lock-keywords)
;;   ;; (-flatten (cdr font-lock-keywords))
;;   )

;; (or (eq (car it) 'org-font-lock-hook)
;;                            (eq (car it) 'my-sue-hilighter))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; rectangle editing -- turns out it's built in with the rect.el module...
;;
;;
;; BTW: iedit has something for editing rectangles visually: C-<return>
;; (iedit-rectangle-mode)
;;
;; Turns out there's a mode for that in Emacs already. It lives in "rect.el",
;; as a `rectangle-mark-mode'. This is nuts - it either was added recently, or
;; most people on the web, me included, are idiots for not knowing about it.
;;
;; NOTE: C-<space> C-x <space> enables YET ANOTHER rectangle mode, this time
;; with visual feedback and working past the end of lines. And it's built in,
;; too.


(define-minor-mode free-rectangle-mode
  "Makes `right-char' append spaces at the eol. It's usefull for
marking rectangles which last/first line is shorter than other
lines. I'm not worried about leaving excess whitespace, because
they will be removed on save anyway."
  nil "Fr" nil
  (if free-rectangle-mode
      (fr-mode-on)
    (fr-mode-off)))

(defun fr-mode-on ()
  (ad-deactivate 'right-char)
  (ad-enable-advice 'right-char 'around 'append-spaces-at-eol)
  (ad-activate 'right-char)
  (set (make-local-variable 'free-rect-auto) auto-mark-mode)
  (when free-rect-auto
    (auto-mark-mode -1)))

(defun fr-mode-off ()
  (ad-deactivate 'right-char)
  (ad-disable-advice 'right-char 'around 'append-spaces-at-eol)
  (ad-activate 'right-char)
  (when free-rect-auto
    (setq free-rect-auto nil)
    (auto-mark-mode 1)))

(defun right-and-mark-active ()
  (let ((transient-mark-mode nil))
    (insert " ")
    (setq deactivate-mark nil)))

(defadvice right-char
  (around append-spaces-at-eol first disable)
  (if (equal (point)
             (line-end-position))
      (right-and-mark-active)
    ad-do-it))

(provide 'my-rectangular-editing)


;; RECT-MARK
;; (require 'rect-mark)
;; I don't use this anymore, the only thing it provides is visual feedback for
;; the rectangle, but does this at the expense of yet another set of keys.



;; For dealing with camel-cased text, not very useful.
;; (require 'subword)


;; A built-in alternative for iDo (which is built-in too...), not needed with
;; iDo enabled.
;;
;; (icomplete-mode 1)
;; (when (boundp 'icomplete-minibuffer-map)
;;   (define-key icomplete-minibuffer-map (kbd "<left>") 'icomplete-forward-completions)
;;   (define-key icomplete-minibuffer-map (kbd "<right>") 'icomplete-backward-completions))




;;  ___  ____   ____       ____  _   _ ____  _   _    ______  _   _ _     _
;; / _ \\|  _ \\ / ___|     |  _ \\| | | / ___|| | | |  / /  _ \\| | | | |   | |
;;| | | | |_) | |  _ _____| |_) | | | \\___ \\| |_| | / /| |_) | | | | |   | |
;;| |_| |  _ <| |_| |_____|  __/| |_| |___) |  _  |/ / |  __/| |_| | |___| |___
;; \\___/|_| \\_\\\\____|     |_|    \\___/|____/|_| |_/_/  |_|    \\___/|_____|_____|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'deferred)

;; ;;
;; ;; INTERFACE
;; ;;

;; ;;;###autoload
;; (defun my-org-export ()
;;   (interactive)
;;   (my-bzr-commit-and-push)
;;   ;; (deferred:$
;;   ;;   (deferred:call 'org-mobile-push)
;;   ;;   (deferred:next (lambda (ignored)   (my-start-rsync "orgmobile ec2:")))
;;   ;;   (deferred:nextc it (lambda (p)         (my-bzr-commit-and-push)))
;;   ;;   (deferred:error it (lambda (er)        (message "err: %s" er)))
;;   ;;   (deferred:nextc it (lambda (&rest arg) (message "export finished"))))
;;   )

;; ;;;###autoload
;; (defun my-org-import ()
;;   (interactive)
;;   (deferred:$
;;     (my-start-rsync "ec2:orgmobile/ orgmobile")
;;     (deferred:nextc it
;;       (lambda (out)
;;         (org-mobile-pull)
;;         (message "import finished")))))


;; ;;
;; ;; IMPLEMENTATION
;; ;;

;; (defun my-bzr-commit-and-push ()
;;   (message "bzr commit & push being called")
;;   (deferred:$
;;     (deferred:process-shell "cd ~/todo/ && bzr ci -m \\"commit\\"")
;;     (deferred:nextc it (lambda (output)
;;                          (deferred:process-shell "cd ~/todo/ && bzr push")))
;;     (deferred:nextc it (lambda (output)
;;                          (message "bzr finished")))))


;; (defun my-start-rsync (spec)
;;   (message "start-rsync being called")
;;   (let ((cmd (concat "cd ~/ && rsync --rsh=\\"ssh\\" -avc " spec)))
;;     (deferred:$
;;       (deferred:process-shell cmd)
;;       (deferred:nextc it (lambda (out)
;;                            (message "rsync finished" out)
;;                            (deferred:succeed out))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



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


;;   ____ _   _ ____ _____ ___  __  __      _    ____ _____ _   _ ____    _
;;  / ___| | | / ___|_   _/ _ \\|  \\/  |    / \\  / ___| ____| \\ | |  _ \\  / \\
;; | |   | | | \\___ \\ | || | | | |\\/| |   / _ \\| |  _|  _| |  \\| | | | |/ _ \\
;; | |___| |_| |___) || || |_| | |  | |  / ___ \\ |_| | |___| |\\  | |_| / ___ \\
;;  \\____|\\___/|____/ |_| \\___/|_|  |_| /_/   \\_\\____|_____|_| \\_|____/_/   \\_\\
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; (setq org-agenda-custom-commands
;;       '(("m" "Notes"
;;          ((tags "/!NEXT|ACTIVE"
;;                 ((org-agenda-overriding-header "Next tasks")))
;;           (tags "/SUSPENDED|WAITING"
;;                 ((org-agenda-overriding-header "Suspended tasks")))
;;           (tags "NOTE"
;;                 ((org-agenda-overriding-header "Notes")
;;                  (org-tags-match-list-sublevels nil)))))))





;; (setq org-structure-template-alist
;;  '(("s" "#+NAME:\\n#+BEGIN_SRC ?\\n\\n#+END_SRC")
;;    ("e" "#+BEGIN_EXAMPLE\\n?\\n#+END_EXAMPLE")
;;    ("q" "#+BEGIN_QUOTE\\n?\\n#+END_QUOTE")
;;    ("v" "#+BEGIN_VERSE\\n?\\n#+END_VERSE")
;;    ("V" "#+BEGIN_VERBATIM\\n?\\n#+END_VERBATIM")
;;    ("c" "#+BEGIN_CENTER\\n?\\n#+END_CENTER")
;;    ("l" "#+BEGIN_LaTeX\\n?\\n#+END_LaTeX")
;;    ("L" "#+LaTeX: ")
;;    ("h" "#+BEGIN_HTML\\n?\\n#+END_HTML")
;;    ("H" "#+HTML: ")
;;    ("a" "#+BEGIN_ASCII\\n?\\n#+END_ASCII")
;;    ("A" "#+ASCII: ")
;;    ("i" "#+INDEX: ?")
;;    ("I" "#+INCLUDE: %file ?")))

;; Faces
;; '(org-block-begin-line ((t (:foreground "#9ED5D5"))))
;; '(org-block-end-line ((t (:foreground "#9ED5D5"))))



;; This is the default, but it didn't work for me for some reason. It then
;; started working suddenly...
;; (setq org-src-fontify-natively t)

;; (setq org-remember-templates
;;      '(("Todo" ?t "* TODO %? %^g\\nAdded: %U\\n%i" "~/todo/todo.org" "TASKS")
;;        ("Post" ?p "* %T %^{topic}\\n %?" "~/todo/posty.org")
;;        ("Journal" ?j "* %T\\n\\t%?" "~/todo/journal.org")
;;        ("Browsing" ?j "* %T\\n\\t%?" "~/todo/journal.org")))
