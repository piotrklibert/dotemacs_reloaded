(require 'recentf)
(recentf-mode 1)

(require 'delim-col)                    ; formats columnar text, needs config

(require 'register-list)                ; M-x register-list

(require 'auto-mark)
(global-auto-mark-mode 1)

(require 'mark-lines)                   ; mark whole line no matter where pt is
(require 'visible-mark)                 ; recompile after Emacs update!
(global-visible-mark-mode 1)

(require 'wrap-region)                  ; select region and press " to wrap it
                                        ; with quotes

(require 'fill-column-indicator)        ; vertical line on the 'fill' col
(require 'undo-tree)                    ; visualisation of undo/redo

(require 'browse-kill-ring)             ; visualisation of kill-ring (M-y)
(browse-kill-ring-default-keybindings)


(require 'rect)                         ; C-x <space> to activate
(require 'iedit)                        ; edit many ocurrences of string at once
                                        ; (in the same buffer)
(require 'iedit-rect)                   ; C-<return>


(require 'saveplace)                    ; Save point position between sessions
(setq-default save-place t)
(setq save-place-file (expand-file-name "h.places" user-emacs-directory))

;; edit all occurances of a regexp in a separate buffer (disabled becaus I
;; learned that occur-mode has this feature already - under 'e')
;; (require 'all)
;; (require 'all-ext)


(setq mc/list-file "~/.emacs.d/data/mc-lists.el")
(require 'multiple-cursors)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)

(require 'expand-region)
(define-key mode-specific-map (kbd "C-=") 'er/expand-region) ; C-c C-=
(define-key mode-specific-map (kbd "=")   'er/expand-region) ; C-c =

(require 'textobjects)
(global-textobject-mark-mode 1)

(require 'iy-go-to-char)
(add-to-list 'mc/cursor-specific-vars 'iy-go-to-char-start-pos)
;; (global-set-key (kbd "C-c ;") 'iy-go-to-or-up-to-continue)
;; (global-set-key (kbd "C-c ,") 'iy-go-to-or-up-to-continue-backward)

;; make artist-mode leave mouse pointer shape alone (it changes it otherwise)
(eval-after-load "artist"
  (setq artist-pointer-shape x-pointer-left-ptr))

;; make sure we're using english dictionary even if the locale says otherwise
;; (ispell-change-dictionary "english")

;;                           _  _________   ______
;;                          | |/ / ____\ \ / / ___|
;;                          | ' /|  _|  \ V /\___ \
;;                          | . \| |___  | |  ___) |
;;                          |_|\_\_____| |_| |____/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

(global-set-key (kbd "C-x C-d")    'ido-dired)

(global-set-key (kbd "C-x C-k")    'kill-region)
(global-set-key (kbd "C-x b")      'helm-buffers-list)
(global-set-key (kbd "C-c C-k")    'kill-region)
(global-set-key (kbd "M-<right>")  'forward-sexp)
(global-set-key (kbd "M-<left>")   'backward-sexp)
(global-set-key (kbd "<insert>")   'read-only-mode)
(global-set-key (kbd "M-V")        'mark-lines-next-line)
(global-set-key (kbd "C-M-<SPC>")  'just-one-space)
(global-set-key (kbd "C-{")        'backward-paragraph)
(global-set-key (kbd "C-}")        'forward-paragraph)
(global-set-key (kbd "C-c f")      'iy-go-to-char)
(global-set-key (kbd "C-c F")      'iy-go-to-char-backward)

(global-set-key (kbd "C-<kp-multiply>")    'forward-quarter-page)
(global-set-key (kbd "C-<kp-divide>")      'backward-quarter-page)


;; My little ponies (I mean defuns):
(global-set-key (kbd "C-M-d")          'duplicate-line-or-region)
(global-set-key (kbd "M-S-<down>")     'move-text-down)
(global-set-key (kbd "M-S-<up>")       'move-text-up)
(global-set-key (kbd "C-v")            'kill-whole-line)
(global-set-key (kbd "M-j")            'join-region)
(global-set-key (kbd "C-x r C-y")      'yank-rectangle-as-text)


(define-key my-toggle-keys (kbd "C-c") 'unix-line-endings)


;; Use remap because setting a C-a key would potentially conflict with other
;; enhancements to beginning-of-line (like in Org mode).
(global-set-key [remap move-beginning-of-line]
                'back-to-indentation-or-beginning)


;;                        _   _  ___   ___  _  ______
;;                       | | | |/ _ \ / _ \| |/ / ___|
;;                       | |_| | | | | | | | ' /\___ \
;;                       |  _  | |_| | |_| | . \ ___) |
;;                       |_| |_|\___/ \___/|_|\_\____/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun my-text-mode-hook ()
  ;; I'm leaving this disabled for now, because:
  ;; a) it conflicts with table mode
  ;; b) I don't really use it that often anyways
  ;; (require 'flyspell)
  ;; (turn-on-flyspell)
  (delete-selection-mode 1)
  (undo-tree-mode 1)
  (turn-on-auto-fill)

  ;; This fucks up empty lines display in text modes, so
  ;; it's disabled
  (fci-mode -1))

(add-hook 'text-mode-hook 'my-text-mode-hook)


;;    __  ____   __       _____ _   _ _   _  ____ _____ ___ ___  _   _ ____
;;   |  \/  \ \ / /      |  ___| | | | \ | |/ ___|_   _|_ _/ _ \| \ | / ___|
;;   | |\/| |\ V /       | |_  | | | |  \| | |     | |  | | | | |  \| \___ \
;;   | |  | | | |        |  _| | |_| | |\  | |___  | |  | | |_| | |\  |___) |
;;   |_|  |_| |_|        |_|    \___/|_| \_|\____| |_| |___\___/|_| \_|____/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'my-move-lines)
(require 'my-indent-config)


(defun forward-quarter-page (&optional arg)
  "Move point forward by 1/4 of a window height"
  (interactive "p")
  (let
      ((jump-len (/ (window-body-height) 4)))
    (forward-line (* jump-len arg))))

(defun backward-quarter-page (&optional arg)
  "Move point backward by 1/4 of a window height"
  (interactive "p")
  (let
      ((jump-len (/ (window-body-height) 4)))
    (forward-line (- (* jump-len arg)))))


(defun renumber (&optional num)
  "Renumber the list items in the current paragraph,starting at point."
  (interactive)
  (setq num (or num 1))
  (let ((end (region-end))
        (m (mark)))
    (save-excursion
      (when (> (point) (mark)) (exchange-point-and-mark))
      (while (re-search-forward "^\\([;# ]*\\)[0-9]+" end t)
        (replace-match  (concat "\\1" (number-to-string num)))
        (setq num (1+ num))))
    (set-mark m)
    (setq deactivate-mark nil)))


(defun duplicate-line-or-region ()
  "Duplicate current line. If there is a region active, duplicate
all lines of the region. To duplicate the region itself just use
M-w C-y ;-)"
  (interactive)
  (destructuring-bind
      (region-active beg end) (my-get-region-or-line-bounds)

    (goto-char beg)
    (move-end-of-line 0)                ; to the end of previous line, to have \n
    (push-mark)
    (goto-char end)
    (move-end-of-line 1)                ; to the end of current line, no \n
    (copy-region-as-kill (region-beginning)
                         (region-end))
    (yank)
    ;; it conflicts with auto-mark-mode which is irritating
    ;; (when region-active
    ;;   (restore-region beg end))
    ))

(defun restore-region (beg end)
  (ensure-mark-active)
  (set-mark beg)
  (goto-char end))

(defun my-join-region ()
  "Remove indentation and newline characters between point and mark."
  (interactive)
  (let
      ((beg (region-beginning)))
    (goto-char (region-end))
    (while (> (line-beginning-position) beg)
      (delete-indentation))))

;; backwards compat
(defalias 'join-region 'my-join-region)


;; TODO: make it work with rect.el too, maybe?
(defalias 'paste-rectangle-as-text 'yank-rectangle-as-text)
(defun yank-rectangle-as-text ()
  "Insert killed rectange as if it was normal text, ie. push
lines down to make space for it instead of pushing line contents
to the right."
  (interactive)
  (with-temp-buffer
    (yank-rectangle)
    (kill-region (point-min) (point-max)))
  (yank)
  (newline))



(defun my-unix-line-endings (&optional save)
  "Make current file's newlines converted to unix format if they
are not already."
  (interactive "P")
  (let ((coding (symbol-name buffer-file-coding-system)))
    (if (not (s-contains? "unix" coding))
        (progn
          (set-buffer-file-coding-system 'utf-8-unix)
          (when save (save-buffer)))
      (message "File already has UNIX style line endings."))))

;; backwards compat
(defalias 'unix-line-endings 'my-unix-line-endings)


(defun my-filter-existing-paths ()
  "Each line of a buffer is a path, like in .gitignore. Remove
the lines which files do not exist. Does not handle wildcards.
Does not recurse. Only works in the simplest case."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (not (= (point) (point-max)))
      (let ((line (buffer-line-np)))
        (when (not (s-contains? "*" line))
          (when (s-starts-with? "/" line) ; magit seems to insert this
            (setq line (s-chop-prefix "/" line)))
          (when (not (f-exists? line))
            (kill-whole-line)
            (forward-line -1))))
      (forward-line))))
(defalias 'filer-existing 'my-filer-existing-paths)


(defun back-to-indentation-or-beginning (arg)
  "Move point to beginning of line, unless it's already there, in
which case move it to the first non-whitespace char in line.
Handles prefix arg like `move-beginning-of-line' does."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first, with visual-line honored (never used).
  (when (not (= arg 1))
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (move-beginning-of-line 1)
    (when (= orig-point (point))
      (back-to-indentation))))



(defmacro like-this-maker (name dir)
  (let
      ((wname (gensym))
       (defun-name (intern (concat (symbol-name name) "-like-this")))
       (search-name (intern (concat "search-" (symbol-name dir) "-regexp"))))

    `(defun ,defun-name ()
       (interactive)
       (let
           ((,wname (thing-at-point 'word t)))
         (when ,wname
           (,search-name (concat "\\b" ,wname "\\b")))
         (if (eq dir 'backward)
	     t
	   (backward-char (length ,wname))) ))))

(like-this-maker next forward)
(like-this-maker prev backward)

(global-set-key (kbd "C-s-<up>") 'prev-like-this)
(global-set-key (kbd "C-s-<down>") 'next-like-this)


(defun align-comment-end ()
  (interactive)
  (let* ((target 60)
        (line (buffer-line))
        (line-length (length line)))
    (unless (> line-length target)
      (save-excursion
        (search-forward "*")
        (backward-char)
        (insert (apply 'concat (loop for _ to (- target line-length)
                                     collect  " ")))))))
