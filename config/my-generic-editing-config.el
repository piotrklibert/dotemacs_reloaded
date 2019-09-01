;; use with C-u to align by char instead of word
(use-package align-by-current-symbol :commands align-by-current-symbol)

(defun my-occur-mode-hook ()
  (turn-on-occur-x-mode)
  (add-hook 'xref-backend-functions #'(lambda () 'elisp)))

(use-package replace
  :commands occur
  :demand)

(use-package occur-x
  :after replace
  :hook occur-hook)

(use-package occur-default-current-word
  :after replace)


(require 'undo-tree-autoloads)          ; visualisation of undo/redo (C-x u)
(require 'rect)                         ; C-x <space> to activate
(require 'iedit)                        ; edit many ocurrences of string at once
                                        ; (in the same buffer)
(require 'iedit-rect)                   ; mark region & C-<return>
(require 'register-list)                ; M-x register-list
(require 'mark-lines)                   ; mark whole line no matter where pt is

(require 'recentf)
(recentf-mode 1)

(require 'auto-mark)
(global-auto-mark-mode 1)               ; configured in my-indent-config.el (?)

(require 'visible-mark)
(global-visible-mark-mode 1)

(require 'wrap-region)                  ; select region and press " or ( or {,
(wrap-region-global-mode t)             ; etc. to wrap it


(require 'browse-kill-ring)     ; visualisation of kill-ring (M-y)

(defadvice yank-pop (around kill-ring-browse-maybe (arg) activate)
  (interactive "p")
  (if (not (eq last-command 'yank))
      (progn
        (helm-show-kill-ring))
    (barf-if-buffer-read-only)
    ad-do-it))

(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)


(require 'textobjects)                  ; eg. C-x w { or C-x w "
(global-textobject-mark-mode 1)

(require 'saveplace)                    ; Save point position between sessions
(setq save-place-file (f-expand "point_position_history" user-emacs-directory))
(save-place-mode t)

(setq mc/list-file "~/.emacs.d/data/mc-lists.el")
(require 'multiple-cursors)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)

(require 'expand-region)
(define-key mode-specific-map (kbd "C-=") 'er/expand-region) ; C-c C-=


(defun my-join-next-line ()
  (interactive)
  ;; NOTE: join-line is an alias for delete-indentation
  (join-line 1))


(defun my-join-prev-line ()
  (interactive)
  (forward-line -1)
  (my-join-next-line))


;; (define-key mode-specific-map (kbd "C-<up>") 'my-join-prev-line) ; C-c C-<up>
;; (define-key mode-specific-map (kbd "C-<down>") 'my-join-next-line) ; C-c C-<down>
(define-key mode-specific-map (kbd "<up>") 'my-join-prev-line) ; C-c <up>
(define-key mode-specific-map (kbd "<down>") 'my-join-next-line) ; C-c <down>


(require 'iy-go-to-char)
(add-to-list 'mc/cursor-specific-vars 'iy-go-to-char-start-pos)

(setq line-number-display-limit-width 2000000)

(defun move-to-word-beginning ()
  (unless (looking-back "\\b" nil)
    (backward-word)))

(defadvice upcase-word     (before my-upcase-word-advice     activate) (move-to-word-beginning))
(defadvice downcase-word   (before my-downcase-word-advice   activate) (move-to-word-beginning))
(defadvice capitalize-word (before my-capitalize-word-advice activate) (move-to-word-beginning))


;;                           _  _________   ______
;;                          | |/ / ____\ \ / / ___|
;;                          | ' /|  _|  \ V /\___ \
;;                          | . \| |___  | |  ___) |
;;                          |_|\_\_____| |_| |____/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (global-set-key (kbd "C-c +") 'text-scale-increase)
;; (global-set-key (kbd "C-c -") 'text-scale-decrease)
;; (global-set-key (kbd "C-c 0") (lambda () (interactive) (text-scale-set 0)))

(global-set-key (kbd "C-c >") 'iy-go-to-or-up-to-continue)
(global-set-key (kbd "C-c <") 'iy-go-to-or-up-to-continue-backward)
(global-set-key (kbd "C-c f") 'iy-go-to-char)
(global-set-key (kbd "C-c F") 'iy-go-to-char-backward)

;; TODO BUG: doesn't work, WM eats s-<up/down> key presses
(define-key global-map (kbd "s-<up>")   'my-delete-indentation)
(define-key global-map (kbd "s-<down>") 'my-delete-indentation-down)

(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(define-key my-toggle-keys (kbd "C-z") 'mc/mark-all-like-this)
;; (global-set-key (kbd "C-s-c C-s-c") 'mc/edit-lines)

;; (global-set-key (kbd "C-x C-d")    'counsel-dired)
(global-set-key (kbd "C-x C-d")    'dired-at-point)
(global-set-key (kbd "C-x M-d")    'sr-dired)

;; (global-set-key (kbd "s-<SPC>")    'just-one-space)

;; (global-set-key (kbd "C-x C-k")    'kill-region)
;; (global-set-key (kbd "C-c C-k")    'kill-region)
(global-set-key (kbd "M-<right>")  'forward-sexp)
(global-set-key (kbd "M-<left>")   'backward-sexp)
(global-set-key (kbd "<insert>")   'read-only-mode)
(global-set-key (kbd "M-V")        'mark-lines-next-line)
(global-set-key (kbd "C-{")        'backward-paragraph)
(global-set-key (kbd "C-}")        'forward-paragraph)

(global-set-key (kbd "C-<kp-multiply>")    'forward-quarter-page)
(global-set-key (kbd "C-<kp-divide>")      'backward-quarter-page)

;;
(global-set-key (kbd "C-M-d")          'duplicate-line-or-region)
(global-set-key (kbd "M-S-<down>")     'move-text-down)
(global-set-key (kbd "M-S-<up>")       'move-text-up)
(global-set-key (kbd "C-v")            'kill-whole-line)
(global-set-key (kbd "M-j")            'join-region)
(global-set-key (kbd "C-x r C-y")      'yank-rectangle-as-text)
(global-set-key (kbd "C-c C-o")        'browse-url-at-point)

(define-key my-toggle-keys (kbd "C-c") 'unix-line-endings)
(define-key my-toggle-keys (kbd "ł")   'toggle-truncate-lines)
(define-key my-toggle-keys (kbd "l")   'toggle-truncate-lines)


;; Use remap because setting a C-a key would potentially conflict with other
;; enhancements to beginning-of-line (like in Org mode).
(global-set-key [remap move-beginning-of-line] 'back-to-indentation-or-beginning)
(global-set-key                    (kbd "C-a") 'back-to-indentation-or-beginning)


;; no idea where or why I overriden default <return> function in isearch...
(define-key isearch-mode-map (kbd "<return>") 'isearch-exit)


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
  (linum-mode 1)

  ;; (setq show-paren-style 'parenthesis)    ; Highlight text between parens
  ;;     Valid styles are `parenthesis' (meaning show the matching paren),
  ;;     `expression' (meaning show the entire expression enclosed by the paren) and
  ;;     `mixed' (meaning show the matching paren if it is visible, and the expression
  ;;     otherwise).
  ;; (show-paren-mode nil)

  ;; (wrap-region 1)
  ;; This fucks up empty lines display in text modes, so
  ;; it's disabled
  )

(add-hook 'minibuffer-inactive-mode-hook 'electric-pair-mode)
;; (add-hook 'minibuffer-inactive-mode-hook 'wrap-region-hook)

(add-hook 'text-mode-hook 'my-text-mode-hook)


;;    __  ____   __       _____ _   _ _   _  ____ _____ ___ ___  _   _ ____
;;   |  \/  \ \ / /      |  ___| | | | \ | |/ ___|_   _|_ _/ _ \| \ | / ___|
;;   | |\/| |\ V /       | |_  | | | |  \| | |     | |  | | | | |  \| \___ \
;;   | |  | | | |        |  _| | |_| | |\  | |___  | |  | | |_| | |\  |___) |
;;   |_|  |_| |_|        |_|    \___/|_| \_|\____| |_| |___\___/|_| \_|____/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'vertmove-lines)
(require 'windmove-lines)
(require 'my-indent-config)
(require 'my-garble-word)

(defconst my-word-list (s-lines (f-read "/usr/share/dict/linux.words")))
(defun my-check-dict-format-column (str))

(defun my-check-dict (&optional input)
  (interactive (list (substring-no-properties
                      (completing-read "Word? " my-word-list))))
  (save-selected-window
    (let
        ((buf (switch-to-buffer-other-window "*MyDict*"))
         (word input))
      (erase-buffer)
      (call-process-shell-command (concat "/usr/local/bin/dict " word) nil buf)
      (let
          ((lines (s-lines (buffer-text-content buf))) tmp)
        (erase-buffer)
        (let*
            ((format-column (lambda (%1)
                              (->> %1
                                s-trim
                                (s-left 25)
                                (s-pad-left 25 " "))))
             (formatted (-map (lambda (%1)
                                (-map format-column (s-split "--" %1))) lines)))
          (loop for (col-pl col-en) in formatted
                do (insert (format "%s -- %s\n" col-pl col-en))))))))


(defun yank-quote ()
  (with-current-buffer (find-file-noselect "~/quotes.txt")
    (goto-char (point-max))
    (insert "\n=========================================\n")
    (my-insert-now)
    (insert "\n\n")
    (yank)
    (insert "\n\n=========================================\n")
    (save-buffer)))

(defun add-to-quotes ()
  (interactive)
  (if (region-active-p)
      (let*
          ((beg (region-beginning))
           (end (region-end)))
        (kill-ring-save beg end)
        (yank-quote))
    (find-file-other-window "~/quotes.txt")
    (goto-char (point-max))
    (insert "\n=========================================\n")
    (my-insert-now)
    (insert "\n\n")
    (save-excursion
      (insert "\n\n=========================================\n"))))

(define-key mode-specific-map (kbd "q") 'add-to-quotes)
(define-key mode-specific-map (kbd "C-q") 'add-to-quotes)


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
  "Duplicate current line. If there is a region selected,
duplicate all lines of the region. To duplicate the region itself
just use M-w C-y ;-)"
  (interactive)
  (destructuring-bind
      (region-active? beg end) (my-get-region-or-line-bounds)
    (goto-char beg)
    (move-end-of-line 0)                ; to the end of previous line, to have \n
    (push-mark)                         ; start selection
    (goto-char end)
    (move-end-of-line 1)                ; to the end of current line, without  \n
    (copy-region-as-kill                ; copy and disables selection
     (region-beginning)
     (region-end))
    (yank)))                           ; iow. paste

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
  (if (and (cl-equalp major-mode 'org-mode)
           (save-excursion
             (move-beginning-of-line 1)
             (looking-at (rx (1+ "*")))))
      (org-beginning-of-line arg)

    ;; Move lines first, with visual-line honored (never used).
    (when (not (= arg 1))
      (let ((line-move-visual nil))
        (forward-line (1- arg))))

    (let ((orig-point (point)))
      (move-beginning-of-line 1)
      (when (= orig-point (point))
        (back-to-indentation)))))


(defmacro like-this-maker (name dir)
  (let
      ((wname (gensym))
       (defun-name (intern (concat (symbol-name name) "-like-this")))
       (search-name (intern (concat "search-" (symbol-name dir) "-regexp"))))

    `(defun ,defun-name ()
       (interactive)
       (let
           ((,wname (thing-at-point 'sexp t)))
         (when (eq ',dir 'forward)
           (ignore-errors (forward-sexp)))
         (when ,wname
           (,search-name (concat "\\b" ,wname "\\b")))
         (unless (eq ',dir 'backward)
	       (backward-char (length ,wname))) ))))

(like-this-maker next forward)
(like-this-maker prev backward)

(global-set-key (kbd "C-s-<up>") 'prev-like-this)
(global-set-key (kbd "C-s-<down>") 'next-like-this)


(defun align-comment-end ()
  "FIXME: docs"
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
