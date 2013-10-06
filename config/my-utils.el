(require 'cl)
(require 's)
(require 'dash)

(defvar my-debug-flag t)
(defun my-log (&rest things)
  (when my-debug-flag
    (with-current-buffer (get-buffer "*Messages*")
      (loop for thing in things
            do (insert (format "%s\n" thing))))))


(defun buffer-line (&optional lineno)
  (when lineno
    (goto-line lineno))
  (buffer-substring (line-beginning-position)
                    (line-end-position)))

(defun buffer-line-np (&optional lineno)
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


(defun magic-dir-p (dir)
  (member dir (list "." "..")))

(defun walk-d ()
  (let ((z (directory-files  "~/.emacs.d/"))
        (s '())
        (f '()))
    (while (or s z)
      (while (magic-dir-p (car z)) (pop z))
      (when (not z)
        (setq z (pop s)))
      (push (car z) f)
      (if (not (file-directory-p (car z)))
          (pop z)
        (when (cdr z)
          (push (cdr z) s))
        (setq z (directory-files (car z)))))
    f))

;; (length (walk-d))


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

(provide 'my-utils)


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
