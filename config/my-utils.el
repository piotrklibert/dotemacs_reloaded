(require 's)
(require 'dash)
(require 'f)
(require 'cl)
(require 'pcase)


(defun my-ivy-format (cands)
  "Transform CANDS into a string for minibuffer."
  (if (bound-and-true-p truncate-lines)
      (mapconcat (lambda (x) (concat "                    " x) )
                 cands "\n")
    (let ((ww (- (window-width)
                 (if (and (boundp 'fringe-mode) (eq fringe-mode 0)) 1 0))))
      (mapconcat
       (lambda (s)
         (if (> (length s) ww)
             (concat (substring s 0 (- ww 3)) "...")
           s))
       cands "\n"))))

;; See: https://en.wikipedia.org/wiki/SKI_combinator_calculus/Informal_description
(defmacro K (prev expr)
  (let ((pnam (gensym)))
    `(let ((,pnam ,prev))
       (-> ,pnam ,expr)
       ,pnam)))

(defmacro measure-time (s &rest body)
  "Measure the time it takes to evaluate BODY."
  `(let ((time (current-time)))
     ,@body
     (message "Loading %s took: %.06f" ,s (float-time (time-since time)))))

(defmacro load-safe (arg)
  `(condition-case err
       (measure-time ,arg (load ,arg))
     (error (my-log (propertize "Couldn't load: %s %s" 'face 'error)
                    ,arg err))))


(defconst example-path
  (concat "~/fasd/:/usr/local/openjdk6/bin:~/portless/dictpl:/sbin:/bin:/usr/sbin:"
          "/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:~/bin:"
          "/usr/local/kde4/bin"))

;; (only-existing-paths)
(cl-defun only-existing-paths (&optional path)
  (let
      ((existing-paths (--filter (f-exists? (f-expand it))
                                 (s-split ":" (or path (getenv "PATH") example-path)))))
    (s-join ":" existing-paths)))

(defvar my-debug-flag t)

;; (my-log (propertize "some thing %s another" 'face 'error) "or")
(defun my-log (fmt &rest things)
  (with-current-buffer (get-buffer "*Messages*")
    (let ((inhibit-read-only t))
      (goto-char (point-max))
      (unless (zerop (current-column))
        (insert "\n"))
      (insert (apply 'format fmt things))
      (insert "\n"))))


(defun buffer-line (&optional lineno)
  "Get a line in which point is as a string."
  (when lineno
    (goto-line lineno))
  (buffer-substring (line-beginning-position)
                    (line-end-position)))

(defun buffer-line-np (&optional lineno)
  "Get a line in which point is as a string. Strip text properties."
  (when lineno
    (goto-line lineno))
  (buffer-substring-no-properties (line-beginning-position)
                                  (line-end-position)))


(defun my-get-region-or-line-bounds ()
  (let ((active? (use-region-p)))
    (list active?
          (or (and active? (region-beginning))
              (line-beginning-position))
          (or (and active? (region-end))
              (line-end-position)))))


;;             __        ___    _     _  __     ____ ___ ____
;;             \ \      / / \  | |   | |/ /    |  _ \_ _|  _ \
;;              \ \ /\ / / _ \ | |   | ' /     | | | | || |_) |
;;               \ V  V / ___ \| |___| . \     | |_| | ||  _ <
;;                \_/\_/_/   \_\_____|_|\_\    |____/___|_| \_\
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun magic-dir-p (dir)
  (member (file-name-nondirectory dir)
          '("." "..")))

(defun directory-subdirs (root)
  (loop for filename in (directory-files root t)
        if (and (file-directory-p filename)
                (not (magic-dir-p filename)))
        collect filename))

(defun walk-dirs (root)
  "This one should actually work."
  (let*
      ((kids (directory-subdirs root))
       (descendants (loop for dir in kids
                          append (walk-dirs dir) ))) ; recurse!
    (append kids descendants)))

;; (walk-dirs "/usr/www/tagasauris/tagasauris/")

(defvar my-config-path "~/.emacs.d/config/")

(defun grep-todos ()
  "Grep files in config/ directory for TODOs and insert them
after point."
  (interactive)
  (let ((files (--filter (string-match "^[a-z].*.el$" it)
                         (directory-files my-config-path)))
        (todos '()))
    (loop for file in files
          do (with-temp-buffer
               (insert-file-contents (concat my-config-path file))
               (goto-char (point-min))
               (while (condition-case nil
                          (search-forward "TODO")
                        (error nil))
                 (push (list file
                             (line-number-at-pos)
                             (buffer-line-np))
                       todos))))
    (while (car todos)
      (let ((todo (pop todos)))
        (insert (apply 'format "%40s::%6s %s\n" todo) )
        (open-line 1)))))
;; (grep-todos)


;; find . -not -iname "*.elc" -not -ipath "*.git*" -not -path "*semanticdb*" -type f -exec ls -l \{\} \; | column -t | awk '{print $5}' | sum




(defun get-defuns-from-file ()
  "Append a list of defuns in the current buffer at the and of it
or after a special string, which is two semicolons followed by
space and a ToC string. This string is constructed
programmatically in case the function is called on the file it is
defined in."
  (interactive)
  (let ((toc-string (concat ";;" " " "ToC"))
        (forms '())
        (form '())
        (funs '()))
    (save-excursion
      (goto-char 1)
      (while (setq form (safe-read-sexp))
        (setq forms (cons form forms))))

    (setq funs (--keep (when (eq 'defun (car it))
                         (cadr it))
                       (reverse forms)))
    (save-excursion
      (goto-char 1)
      (condition-case nil
          (search-forward toc-string)
        (error (goto-char (point-max))
               (newline)
               (insert toc-string)))
      (newline)
      ;; (delete-region (line-beginning-position) (point-max))
      (--each funs (insert (format ";; %s\n" it))))))


(defun my-remove-files (target-dir files)
  (let ((current-dir default-directory))
    (cd target-dir)
    (dolist (file files) (delete-file file))
    (cd current-dir)))


(defun my-timer (msg &optional label)
  (lexical-let ((msg msg)
                (label label))
    (lambda ()
      (interactive "P")
      (x-popup-dialog (get-window-with-predicate (lambda (x) t))
                      (list msg (cons (or label "ok!") t))) )))





;;                           _    _     ___ ____ _____
;;                          / \  | |   |_ _/ ___|_   _|
;;                         / _ \ | |    | |\___ \ | |
;;                        / ___ \| |___ | | ___) || |
;;                       /_/   \_\_____|___|____/ |_|
;;                                   UTILS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Found, by accident, in elscreen source. Extracted from there. Somehow I was
;; sure that there will be better support for alists (like in Erlang for
;; example), but it turns out it's not there.

(defun util-get-alist (key alist)
  (cdr (assoc key alist)))


(defun util-remove-alist (symbol key)
  "Delete an element whose car equals KEY from the alist bound to
SYMBOL."
  (when (boundp symbol)
    (set symbol (util-del-alist key (symbol-value symbol)))))


(defun util-del-alist (key alist)
  "Delete an element whose car equals KEY from ALIST.
Return the modified ALIST."
  (let ((pair (assoc key alist)))
    (if pair (delq pair alist) alist)))


(defun util-set-alist (symbol key value)
  "Set cdr of an element (KEY . ...) in the alist bound to SYMBOL
to VALUE."
  (or (boundp symbol)
      (set symbol nil))
  (set symbol (util-put-alist key value (symbol-value symbol))))


(defun util-put-alist (key value alist)
  "Set cdr of an element (KEY . ...) in ALIST to VALUE and return ALIST.
If there is no such element, create a new pair (KEY . VALUE) and
return a new alist whose car is the new pair and cdr is ALIST."
  (let ((elm (assoc key alist)))
    (if (not elm)
        (cons (cons key value) alist)
      (setcdr elm value)
      alist)))


(provide 'my-utils)
