;; TODO:
;; save all org mode buffers on push/pull
;; success message
;; * parse rsync output
;; * one line message only
;; * notify about failure too


(defun my-org-clear-subtree ()
  (interactive)
  (org-mark-subtree) ;; mark the current subtree
  (kill-region (region-beginning) (region-end))) ;; delete the rest


(defadvice org-shifttab (after org-shifttab-recenter activate)
  (recenter nil))


(defun my-org-fold-current ()
  (interactive)
  (unless (save-excursion
            (goto-char (line-beginning-position))
            (looking-at (rx bol (1+ ?*) " ")))
    (org-previous-visible-heading 1))
  (hide-subtree))

(defun my-org-show-next-heading-tidily ()
  "Show next entry, keeping other entries closed."
  (interactive)
  (if (save-excursion (end-of-line) (outline-invisible-p))
      (progn (org-show-entry) (show-children))
    (outline-next-heading)
    (unless (and (bolp) (org-on-heading-p))
      (org-up-heading-safe)
      (hide-subtree)
      (error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (show-children)))

(defun my-org-show-previous-heading-tidily ()
  "Show previous entry, keeping other entries closed."
  (interactive)
  (let ((pos (point)))
    (outline-previous-heading)
    (unless (and (< (point) pos) (bolp) (org-on-heading-p))
      (goto-char pos)
      (hide-subtree)
      (error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (show-children)))

(defun my-org-show-current-heading-tidily ()
  "Show next entry, keeping other entries closed."
  (interactive)
  (if (save-excursion (end-of-line) (outline-invisible-p))
      (progn
        (message "invis")
        (org-show-entry)
        (outline-show-subtree))
    (message "visible")
    (outline-back-to-heading)
    (unless (and (bolp) (org-on-heading-p))
      (org-up-heading-safe)
      (hide-subtree)
      (error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (outline-show-subtree)
    (recenter)))


(defun my-org-search-next-macro ()
  (let ((re (rx (* any) (group "{{{" (in alnum ?-)))))
    (re-search-forward re nil t)))

(defun my-org-kill-macro-body (begin end)
  ;; Preserve whitespaces after the macro.
  (delete-region begin (progn (goto-char end)
        		              (skip-chars-backward " \t")
        		              (point))))

(cl-defun my-org-macro-replace-all-in-string (code &optional (templates org-macro-templates))
  (unless templates
   (message "--- %s ----" code))
  (with-temp-buffer
    (insert code)
    (goto-char (point-min))

    (loop while (my-org-search-next-macro)
          for macro = (save-excursion
                        (goto-char (match-beginning 1))
                        (org-element-macro-parser))
          when macro
          do (let* ((begin (org-element-property :begin macro))
                    (end (org-element-property :end macro))
                    (expansion (if templates
                                   (org-macro-expand macro templates)
                                 "<<<ERROR>>>")))
               (my-org-kill-macro-body begin end)
               (insert expansion)))
    (buffer-substring-no-properties (point-min) (point-max))))


(defvar tmp-in-src-block-export-p nil)

(defun org-html-src-block (src-block _contents info)
  "Transcode a SRC-BLOCK element from Org to HTML.
CONTENTS holds the contents of the item.  INFO is a plist holding
contextual information."
  ;; (message "%s" (list 1 org-macro-templates))
  (let ((tmp-in-src-block-export-p t))
      (if (org-export-read-attribute :attr_html src-block :textarea)
       (org-html--textarea-block src-block)
     (let* ((lang (org-element-property :language src-block))
	        (code (org-html-format-code src-block info))
	        (label (let ((lbl (and (org-element-property :name src-block)
				                   (org-export-get-reference src-block info))))
		             (if lbl (format " id=\"%s\"" lbl) "")))
	        (klipsify  (and  (plist-get info :html-klipsify-src)
                             (member lang '("javascript" "js"
					                        "ruby" "scheme" "clojure" "php" "html")))))
       (if (not lang) (format "<pre class=\"example\"%s>\n%s</pre>" label code)
	     (format "<div class=\"org-src-container\">\n%s%s\n</div>"
		         ;; Build caption.
		         (let ((caption (org-export-get-caption src-block)))
		           (if (not caption) ""
		             (let ((listing-number
			                (format
			                 "<span class=\"listing-number\">%s </span>"
			                 (format
			                  (org-html--translate "Listing %d:" info)
			                  (org-export-get-ordinal
			                   src-block info nil #'org-html--has-caption-p)))))
		               (format "<label class=\"org-src-name\">%s%s</label>"
			                   listing-number
			                   (org-trim (org-export-data caption info))))))
		         ;; Contents.
		         (if klipsify
		             (format "<pre><code class=\"src src-%s\"%s%s>%s</code></pre>"
			                 lang
			                 label
			                 (if (string= lang "html")
				                 " data-editor-type=\"html\""
			                   "")
			                 code)
		           (format "<pre class=\"src src-%s\"%s>%s</pre>"
                           lang label code))))))))


(defun my-org-babel-tangle (&optional arg target-file lang)
     "Write code blocks to source-specific files.
Extract the bodies of all source code blocks from the current
file into their own source-specific files.
With one universal prefix argument, only tangle the block at point.
When two universal prefix arguments, only tangle blocks for the
tangle file of the block at point.
Optional argument TARGET-FILE can be used to specify a default
export file for all source blocks.  Optional argument LANG can be
used to limit the exported source code blocks by language."
     (interactive "P")


     ;; HACK BUG GOD-HAVE-MERCY
     (unless tmp-in-src-block-export-p
       (org-macro-initialize-templates))


     (run-hooks 'org-babel-pre-tangle-hook)
     ;; Possibly Restrict the buffer to the current code block
     (let ((templates org-macro-templates))
       ;; (message "%s" (list 2 (buffer-name) (point) org-macro-templates))
       (save-restriction
         (save-excursion
           (when (equal arg '(4))
	         (let ((head (org-babel-where-is-src-block-head)))
	           (if head
	               (goto-char head)
	             (user-error "Point is not in a source code block"))))
           (let ((block-counter 0)
	             (org-babel-default-header-args
	              (if target-file
		              (org-babel-merge-params org-babel-default-header-args
					                          (list (cons :tangle target-file)))
		            org-babel-default-header-args))
	             (tangle-file
	              (when (equal arg '(16))
		            (or (cdr (assq :tangle (nth 2 (org-babel-get-src-block-info 'light))))
		                (user-error "Point is not in a source code block"))))
	             path-collector)
	         (mapc ;; map over all languages
	          (lambda (by-lang)
	            (let* ((lang (car by-lang))
		               (specs (cdr by-lang))
		               (ext (or (cdr (assoc lang org-babel-tangle-lang-exts)) lang))
		               (lang-f (intern
			                    (concat
			                     (or (and (cdr (assoc lang org-src-lang-modes))
				                          (symbol-name
				                           (cdr (assoc lang org-src-lang-modes))))
				                     lang)
			                     "-mode")))
		               she-banged)
	              (mapc
	               (lambda (spec)
		             (let ((get-spec (lambda (name) (cdr (assoc name (nth 4 spec))))))
		               (let* ((tangle (funcall get-spec :tangle))
			                  (she-bang (let ((sheb (funcall get-spec :shebang)))
                                          (when (> (length sheb) 0) sheb)))
			                  (tangle-mode (funcall get-spec :tangle-mode))
			                  (base-name (cond
				                          ((string= "yes" tangle)
				                           (file-name-sans-extension
					                        (nth 1 spec)))
				                          ((string= "no" tangle) nil)
				                          ((> (length tangle) 0) tangle)))
			                  (file-name (when base-name
				                           ;; decide if we want to add ext to base-name
				                           (if (and ext (string= "yes" tangle))
					                           (concat base-name "." ext) base-name))))
		                 (when file-name
		                   ;; Possibly create the parent directories for file.
		                   (let ((m (funcall get-spec :mkdirp))
			                     (fnd (file-name-directory file-name)))
			                 (and m fnd (not (string= m "no"))
			                      (make-directory fnd 'parents)))
		                   ;; delete any old versions of file
		                   (and (file-exists-p file-name)
			                    (not (member file-name (mapcar #'car path-collector)))
			                    (delete-file file-name))
		                   ;; drop source-block to file
		                   (with-temp-buffer
			                 (when (fboundp lang-f) (ignore-errors (funcall lang-f)))
			                 (when (and she-bang (not (member file-name she-banged)))
			                   (insert (concat she-bang "\n"))
			                   (setq she-banged (cons file-name she-banged)))
			                 (org-babel-spec-to-string spec)


			                 ;; We avoid append-to-file as it does not work with tramp.
			                 (let ((content (my-org-macro-replace-all-in-string (buffer-string) templates)))


			                   (with-temp-buffer
			                     (when (file-exists-p file-name)
			                       (insert-file-contents file-name))
			                     (goto-char (point-max))
			                     ;; Handle :padlines unless first line in file
			                     (unless (or (string= "no" (cdr (assq :padline (nth 4 spec))))
					                         (= (point) (point-min)))
			                       (insert "\n"))
			                     (insert content)
			                     (write-region nil nil file-name))))
		                   ;; if files contain she-bangs, then make the executable
		                   (when she-bang
			                 (unless tangle-mode (setq tangle-mode #o755)))
		                   ;; update counter
		                   (setq block-counter (+ 1 block-counter))
		                   (unless (assoc file-name path-collector)
			                 (push (cons file-name tangle-mode) path-collector))))))
	               specs)))
	          (if (equal arg '(4))
	              (org-babel-tangle-single-block 1 t)
	            (org-babel-tangle-collect-blocks lang tangle-file)))
	         (message "Tangled %d code block%s from %s" block-counter
		              (if (= block-counter 1) "" "s")
		              (file-name-nondirectory
		               (buffer-file-name
		                (or (buffer-base-buffer) (current-buffer)))))
	         ;; run `org-babel-post-tangle-hook' in all tangled files
	         (when org-babel-post-tangle-hook
	           (mapc
	            (lambda (file)
	              (org-babel-with-temp-filebuffer file
		            (run-hooks 'org-babel-post-tangle-hook)))
	            (mapcar #'car path-collector)))
	         ;; set permissions on tangled files
	         (mapc (lambda (pair)
		             (when (cdr pair) (set-file-modes (car pair) (cdr pair))))
	               path-collector)
	         (mapcar #'car path-collector))))))

(defalias 'org-babel-tangle 'my-org-babel-tangle)

(eval-after-load "ob-tangle"
  '(defalias 'org-babel-tangle 'my-org-babel-tangle))

(eval-after-load "org"
  '(add-hook 'org-mode-hook 'my-org-hook))



(defun my-org-html-format-code (element info)
  (let*
      ((lang (org-element-property :language element))
       ;; Extract code and references.
	   (code-info (org-export-unravel-code element))
	   (code (car code-info))
	   (refs (cdr code-info))

	   ;; Does the src block contain labels?
	   (retain-labels (org-element-property :retain-labels element))

       ;; Does it have line numbers?
	   (num-start (org-export-get-loc element info))

       ;; XXX HACK NOTE make sure macros are expanded in code blocks on export
	   (code (my-org-macro-replace-all-in-string code)))

    (org-html-do-format-code code lang refs
                             retain-labels
                             num-start)))


(defalias 'org-html-format-code 'my-org-html-format-code)

(eval-after-load "ox-html"
  '(defalias 'org-html-format-code 'my-org-html-format-code))



(defun my-org-occur-headers ()
  "Preconfigured Occur for Org headers."
  (interactive)
  (helm-occur-init-source)
  (let
      ((bufs (list (buffer-name (current-buffer)))))

    (helm-attrset 'moccur-buffers bufs helm-source-occur)
    (helm-set-local-variable 'helm-multi-occur-buffer-list bufs)
    (helm-set-local-variable 'helm-multi-occur-buffer-tick
                             (cl-loop for b in bufs
                                      collect (buffer-chars-modified-tick (get-buffer b)))))
  (helm :sources 'helm-source-occur
        :buffer "*helm occur*"
        :input "^\\*\\*? "
        :history 'helm-occur-history
        :preselect (and (memq 'helm-source-occur helm-sources-using-default-as-input)
                        (format "%s:%d:" (regexp-quote (buffer-name))
                                (line-number-at-pos (point))))
        :truncate-lines helm-moccur-truncate-lines))




(defun my-org-hook ()
  (require 'org)
  (require 'ox-html)
  (require 'ox-md)
  (require 'org-tempo)
  (require 'org-goto)

  (define-key org-mode-map (kbd "C-c <up>")     'outline-previous-visible-heading)
  (define-key org-mode-map (kbd "C-c C-k")      'my-org-clear-subtree)
  (define-key org-mode-map (kbd "C-c <down>")   'outline-next-visible-heading)
  (define-key org-mode-map (kbd "C-c C-<up>")   'org-backward-heading-same-level)
  (define-key org-mode-map (kbd "C-c C-<down>") 'org-forward-heading-same-level)
  (define-key org-mode-map (kbd "C-c C-h")      'my-org-jump-to-heading)
  (define-key org-mode-map (kbd "C-c l")        'org-store-link)
  (define-key org-mode-map (kbd "C-c =")        'er/expand-region)
  (define-key org-mode-map (kbd "C-c M-<up>")   'my-org-fold-current)
  (define-key org-mode-map (kbd "C-c M-=")      'my-org-show-current-heading-tidily)
  (define-key org-mode-map (kbd "C-c M--")      'my-org-show-previous-heading-tidily)
  (define-key org-mode-map (kbd "C-c M-+")      'my-org-show-next-heading-tidily)
  (define-key org-mode-map (kbd "s-c")          'my-tangle-and-run)
  (define-key org-mode-map (kbd "<return>")     'org-return-indent)
  (define-key org-mode-map (kbd "C-j")          'org-return)
  (define-key org-mode-map (kbd "C-c C-j")      'my-org-occur-headers)
  (define-key org-mode-map (kbd "<kp-up>")      'org-previous-visible-heading)
  (define-key org-mode-map (kbd "<kp-down>")    'org-next-visible-heading)
  (define-key org-mode-map (kbd "C-<kp-up>")    'org-previous-block)
  (define-key org-mode-map (kbd "C-<kp-down>")  'org-next-block)

  (define-key org-mode-map (kbd "C-c +") 'text-scale-increase)
  (define-key org-mode-map (kbd "C-c -") 'text-scale-decrease)
  (define-key org-mode-map (kbd "C-c 0") (lambda () (interactive) (text-scale-set 0)))

  )


;; TODO: failed experiment, cleanup
;; (defun my-org-edit-special (&optional arg) (interactive "P") (let ((element (org-element-at-point)) (type (->> (org-element-at-point) (org-element-property :parent) (org-element-property :type)))) (barf-if-buffer-read-only) (if (equal type "note") (my-org-edit-note) (org-edit-special arg))))
;; (defun my-org-edit-note () (let ((element (org-element-property :parent (org-element-at-point)))) (org-src--edit-element element (org-src--construct-edit-buffer-name (buffer-name) "note") #'text-mode (lambda () (org-escape-code-in-region (point-min) (point-max))))))
;; (add-to-list org-export-filter-special-block-functions 'my-org-note-filter)


(eval-after-load "org"
  '(setq org-babel-default-header-args
         (cons '(:noweb . "yes")
               (assq-delete-all :noweb org-babel-default-header-args))))

;; (with-current-buffer "nowe.org"
;;   (->> (org-element-at-point)
;;     (org-element-property :parent)
;;     (org-element-property :type)))

(defun export-lightcorn-docs ()
  (let ((fname (buffer-file-name)))
    (when (and (s-contains-p "lightcorn/docs" fname)
               (s-ends-with-p ".org" fname))
      (let ((system-time-locale "C"))
        (org-html-export-to-html)
        (org-babel-tangle)))))

(add-hook 'after-save-hook 'export-lightcorn-docs)

(defun my-tangle-and-run ()
  (interactive)
  ;; (load-theme 'whiteboard)
  (rainbow-mode -1)
  (hl-line-mode -1)
  (fic-ext-mode -1)
  (auto-mark-mode -1)
  (visible-mark-mode -1)
  (rainbow-delimiters-mode -1)
  (org-html-export-to-html)
  ;; (org-babel-tangle)
  ;; (load-theme 'wombat)
  ;; (shell-command "time nim c -o=nom -r -d:release --opt:speed nom.nim >/dev/null")
  )




(setq org-html-htmlize-output-type 'inline-css)
(setq org-html-htmlize-font-prefix "")
(setq org-treat-S-cursor-todo-selection-as-state-change nil)
(setq org-directory "~/todo/")
(setq org-agenda-files (list "~/todo/"))
(setq org-default-notes-file "~/todo/notes")


;; (org-clock-persistence-insinuate)

;; (setq org-html-htmlize-font-prefix "") ;; default
;; (setq org-html-htmlize-font-prefix "org-")


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


(eval-after-load "org"
  '(progn
     (require 'ob-ls)
     (add-to-list 'org-src-lang-modes
                  '("ls" . livescript))))

(setq org-babel-load-languages
      (--map (cons it t)
             '(emacs-lisp python scheme js ls livescript io)))


;; This is the default, but it didn't work for me for some reason. It then
;; started working suddenly...
;; (setq org-src-fontify-natively t)

(setq org-remember-templates
     '(("Todo" ?t "* TODO %? %^g\\nAdded: %U\\n%i" "~/todo/todo.org" "TASKS")
       ("Post" ?p "* %T %^{topic}\\n %?" "~/todo/posty.org")
       ("Journal" ?j "* %T\\n\\t%?" "~/todo/journal.org")
       ("Browsing" ?j "* %T\\n\\t%?" "~/todo/journal.org")))


(setq org-capture-templates
      (quote (("t" "todo" entry (file+headline "~/todo/work.org" "TASKS")
               "* TODO %?\\n  Added: %U\\n  Origin: %a\\n")

              ("T" "todo" entry (file+headline "~/todo/todo.org" "TASKS")
               "* TODO %?\\n  Added: %U\\n  Origin: %a\\n")

              ("n" "note" entry (file "~/todo/notes.org")
               "* %? :NOTE:\\n  Added: %U\\n  Origin: %a\\n  %i")

              ("r" "respond" entry (file "~/todo/refile.org")
               "* NEXT Respond to %:from on %:subject\\nSCHEDULED: %t\\n%U\\n%a\\n" :clock-in t :clock-resume t :immediate-finish t)
              ("j" "Journal" entry (file+datetree "~/todo/notes.org")
               "* %?\\n%U\\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/todo/refile.org")
               "* TODO Review %c\\n%U\\n" :immediate-finish t)
              ("m" "Meeting" entry (file "~/todo/refile.org")
               "* MEETING with %? :MEETING:\\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file "~/todo/refile.org")
               "* PHONE %? :PHONE:\\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/todo/refile.org")
               "* NEXT %?\\n%U\\n%a\\nSCHEDULED: %(format-time-string \\"<%Y-%m-%d %a .+1d/3d>\\")\\n:PROPERTIES:\\n:STYLE: habit\\n:REPEAT_TO_STATE: NEXT\\n:END:\\n"))))


;;   ____ _   _ ____ _____ ___  __  __      _    ____ _____ _   _ ____    _
;;  / ___| | | / ___|_   _/ _ \\|  \\/  |    / \\  / ___| ____| \\ | |  _ \\  / \\
;; | |   | | | \\___ \\ | || | | | |\\/| |   / _ \\| |  _|  _| |  \\| | | | |/ _ \\
;; | |___| |_| |___) || || |_| | |  | |  / ___ \\ |_| | |___| |\\  | |_| / ___ \\
;;  \\____|\\___/|____/ |_| \\___/|_|  |_| /_/   \\_\\____|_____|_| \\_|____/_/   \\_\\
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


(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")


;; (global-set-key (kbd "C-c a") 'org-agenda)
;; (global-set-key (kbd "C-c c") 'org-capture)
;; (require 'remember)

(defun my-open-notes ()
  (interactive)
  (my-split-window-below)
  (find-file (expand-file-name "~/todo/nowe.org")))

(global-set-key (kbd "C-c r") #'my-open-notes)


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





;; org-goto-interface
;; org-goto-auto-isearch


;; Stolen from: http://www.emacswiki.org/cgi-bin/wiki/Journal
;; because on my FreeBSD Org crashed with C-c C-s...

(defun my-now ()
  "Insert string for the current time formatted like '2:34 PM'."
  (format-time-string "%H:%M"))

(defun my-today ()
  (format-time-string "%Y-%m-%d"))

(defun my-insert-now ()
  (interactive)
  (insert (concat "<" (my-now) ">")))

(defun my-insert-datetime ()
  "Insert string for today's date nicely formatted in American style,
e.g. Sunday, September 17, 2000."
  (interactive)
  (let ((date (my-today))
        (time (my-now))
        (day (elt '(Mon Tue Wed Thu Fri Sat Sun)
                  (1- (string-to-number (format-time-string "%u"))))))
    (insert (concat "<" date " " (symbol-name day) " " time ">"))))

(defun my-insert-today ()
  (interactive)
  (let ((date (format-time-string "%Y-%m-%d") ))
    (insert (concat "[" date "]"))))


;; (define-key my-toggle-keys (kbd "C-t") 'my-insert-datetime)
;; (define-key my-toggle-keys (kbd "t") 'my-insert-now)




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

(provide 'my-org-config)
