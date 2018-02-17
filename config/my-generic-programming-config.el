(require 'isearch)
(require 'cl)
(require 'cl-lib)
(require 'pp)
(require 'pp+)
(require 'ffap)                         ; find file at point
(require 'electric)
(require 'thingatpt)
(require 'flymake)
(require 'jka-compr)                    ; searches tags in gzipped sources too

(require 'ls-lisp)                      ; elisp ls replacement
(setf ls-lisp-use-insert-directory-program t)
(setf insert-directory-program             "~/.emacs.d/ls.sh")

(require 'fuzzy)                        ; fuzzy isearch support
;; (require 'eassist)
;; (require 'flymake-checkers)


(require 'ag-autoloads)                 ; ack replacement in C
(require 'ggtags-autoloads)
(require 'rainbow-mode-autoloads)
(require 'fic-ext-mode-autoloads)
(require 'rainbow-delimiters-autoloads)


(use-package tail
  :commands tail-file)

(use-package tags-tree
  :commands tags-tree)

(use-package imenu-tree
  :commands imenu-tree)

(use-package helm-ag
  :commands helm-do-ag-project-root helm-do-ag)

(use-package swiper
  :commands swiper)

(use-package columnize
  :commands columnize-text columnize-strings)

(use-package ztree
  :commands ztree-dir
  :config
  (setq ztree-draw-unicode-lines t))

(use-package ace-jump-mode              ; quickly jump to char/line
  ;; jump to lines with prefix arg
  :commands ace-jump-mode
  :init
  (setq ace-jump-mode-submode-list '(ace-jump-word-mode
                                     ace-jump-line-mode
                                     ace-jump-char-mode)))

(use-package ace-window
  :commands ace-window)

(use-package align-by-current-symbol
  ; use with C-u to align by char instead of word
  :commands align-by-current-symbol)

(eval-after-load "replace"
  '(progn
     (require 'occur-x)
     (require 'occur-default-current-word)
     (add-hook 'occur-mode-hook 'turn-on-occur-x-mode)))


(global-set-key (kbd "C-c C-=") 'ace-window)


(require 'my-highlight-word)            ; somewhat like * in Vim
(require 'my-ffap-wrapper)
(require 'my-pygmentize)
(require 'my-toggle-true-false)         ; it's silly, but it's my first "real"
                                        ; Elisp, so I keep it around :)



;;              ____  _____ _____ _____ ___ _   _  ____ ____
;;             / ___|| ____|_   _|_   _|_ _| \ | |/ ___/ ___|
;;             \___ \|  _|   | |   | |  | ||  \| | |  _\___ \
;;              ___) | |___  | |   | |  | || |\  | |_| |___) |
;;             |____/|_____| |_|   |_| |___|_| \_|\____|____/
;;
;;================================================================================

(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)                     ; Maintain tag database.
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)              ; Reparse buffer when idle.
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)                ; Show summary of tag at point.
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)              ; Highlight the current tag.
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)                ; Provide `switch-to-buffer'-like keybinding for tag names.

;; (add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)                  ; Show current fun in header line.
;; (add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode)                       ; A mouse 3 context menu.
;; (add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode) ; Highlight references of the symbol under point.

(semantic-mode 1)

(defun my-prog-settings ()
  (turn-on-fuzzy-isearch)               ; complement: turn-off-fuzzy-isearch
  (show-paren-mode t)                   ; highlight matching parens
  (column-number-mode t)                ; show col num on modeline
  (electric-pair-mode 1))

(add-hook 'prog-mode-hook 'my-prog-settings)

(setf ivy-format-function 'my-ivy-format)
(setf gdb-many-windowsf t)

;;                           _  _________   ______
;;                          | |/ / ____\ \ / / ___|
;;                          | ' /|  _|  \ V /\___ \
;;                          | . \| |___  | |  ___) |
;;                          |_|\_\_____| |_| |____/
;;
;;================================================================================

(define-key my-toggle-keys (kbd "\"") 'my-toggle-quotes)

(global-set-key (kbd "C-c C-l") 'pygmentize)
(global-set-key (kbd "C-=")     'indent-for-tab-command)
(global-set-key (kbd "C-M-=")   'align-by-current-symbol)
(global-set-key (kbd "C-!")     'highlight-or-unhighlight-at-point)
(global-set-key (kbd "C-\"")    'comment-or-uncomment-region-or-line)
(global-set-key (kbd "<f9>")    'my-make)

(define-key mode-specific-map (kbd "SPC")   'ace-jump-mode)
(define-key mode-specific-map (kbd "C-SPC") 'ace-jump-mode)

(define-key my-find-keys (kbd "o")        'swiper)
(define-key my-find-keys (kbd "C-o")      'helm-occur)
(define-key my-find-keys (kbd "C-g")      'global-occur)
(define-key my-find-keys (kbd "C-f")      'fuzzy-find-in-project)
(define-key my-find-keys (kbd "C-M-f")    'fuzzy-find-change-root)
(define-key my-find-keys (kbd "C-c")      'fuzzy-find-choose-root-set)
(define-key my-find-keys (kbd "C-r")      'find-grep-dired)
(define-key my-find-keys (kbd "C-i")      'idomenu)
(define-key my-find-keys (kbd "C-m")      'my-imenu-show-popup)
(define-key my-find-keys (kbd "C-d")      'find-name-dired)

(autoload 'helm-do-ag-project-root "helm-ag" "" t)
(define-key my-find-keys (kbd "C-a")      'my-helm-do-ag-current-dir)
(define-key my-find-keys (kbd "a")        'helm-do-ag-project-root)
(define-key my-find-keys (kbd "C-p")      'my-project-ffap)
(define-key my-find-keys (kbd "C-M-p")    'ffap-other-window)


;;                        _   _  ___   ___  _  ______
;;                       | | | |/ _ \ / _ \| |/ / ___|
;;                       | |_| | | | | | | | ' /\___ \
;;                       |  _  | |_| | |_| | . \ ___) |
;;                       |_| |_|\___/ \___/|_|\_\____/
;;
;;================================================================================

(require 'my-generic-programming-init-hook)


(defun my-kill-scratch-buffer-hook ()
  "I frequently scribble things in the *scratch* buffer and then
leave them there 'for later'. Unfortunately, it happens a lot
that I forget to save them when exiting or restarting Emacs. It
even happened to me that I killed the scratch buffer by accident,
without saving it first.

This hook appends current contents of the scratch buffer to a
file if it was modified. It also adds a timestamp. This way I
don't need to worry about saving scratch buffer contents anymore
- they will be saved for me everytime."
  (when (and (string= (buffer-name) "*scratch*")
             (not (string= initial-scratch-message (buffer-substring-no-properties
                                                    (point-min)
                                                    (point-max)))))
    (goto-char (point-min))
    (insert "\n\n================================================================================\n")
    (insert (format-time-string "%A, %B %e, %Y %D -- %-I:%M %p\n"))
    (insert "================================================================================\n\n")
    (append-to-file (point-min) (point-max) "~/scratch")))

(add-hook 'kill-buffer-hook 'my-kill-scratch-buffer-hook)

(defun my-kill-emacs-scratch-hook ()
  (let ((scratch (get-buffer "*scratch*")))
    (when scratch
      (with-current-buffer scratch
        (my-kill-scratch-buffer-hook)))))

(add-hook 'kill-emacs-hook 'my-kill-emacs-scratch-hook)


;;              _____ _   _ _   _  ____ _____ ___ ___  _   _ ____
;;             |  ___| | | | \ | |/ ___|_   _|_ _/ _ \| \ | / ___|
;;             | |_  | | | |  \| | |     | |  | | | | |  \| \___ \
;;             |  _| | |_| | |\  | |___  | |  | | |_| | |\  |___) |
;;             |_|    \___/|_| \_|\____| |_| |___\___/|_| \_|____/
;;
;;================================================================================

(defun my-make ()
  (interactive)
  (let
      ((default-directory "/home/cji/projects/klibert_pl/"))
    (compile "make")))


(defun my-helm-do-ag-current-dir ()
  (interactive)
  (helm-do-ag (f-dirname (buffer-file-name (current-buffer))) "*.*"))


(defun my-imenu-show-popup ()
  "Somehow I didn't find any setting for making this the
default."
  (interactive)
  (helm-imenu))


(defun my-toggle-quotes ()
  "If point is inside quoted string, replace single quates with
double quotes and vice-versa."
  (interactive)
  (save-excursion
    (let*
        ((start (nth 8 (syntax-ppss)))
         (start-char (buffer-substring-no-properties start (1+ start)))
         (end (progn
                (search-forward start-char)
                (point)))
         (replace (cond
                   ((string= start-char "\"") "'")
                   ((string= start-char "'") "\""))))
      (goto-char start)
      (delete-char 1)
      (insert replace)
      (goto-char (1- end))
      (delete-char 1)
      (insert replace))))


(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if
there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning)
              end (region-end))
      (setq beg (line-beginning-position)
            end (line-end-position)))
    (comment-or-uncomment-region beg end)))


(defun global-occur (arg)
  "Find occurences of arg in all but temporary opened buffers."
  (interactive "sSearch string: ")
  (let*
      ((search-buffer-p (lambda (buf)
                          (not (string-match "*" (buffer-name buf)))))
       (buffers (remove-if-not search-buffer-p (buffer-list))))
    (multi-occur buffers arg)))


(defun my-isearch-current-word ()
  "Reset current isearch to a word-mode search of the word under point."
  (interactive)
  (setq isearch-word t
        isearch-string ""
        isearch-message "")
  (isearch-yank-string
   (if (not (region-active-p))
       (word-at-point)
     (prog1 (buffer-substring-no-properties (region-beginning) (region-end))
       (deactivate-mark)))))

(define-key isearch-mode-map (kbd "C-2") 'my-isearch-current-word)
(define-key isearch-mode-map (kbd "C-@") 'my-isearch-current-word)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                               Camelize name
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun mapcar-head (fn-head fn-rest list)
  "Like MAPCAR, but applies a different function to the first element."
  (if list
      (cons (funcall fn-head (car list))
            (mapcar fn-rest (cdr list)))))

(defun capitalize-downcased (word)
  (capitalize (downcase word)))

(defun camelize (s)
  "Convert under_score string S to CamelCase string."
  (let
      ((capitalized (mapcar 'capitalize-downcased (split-string s "_"))))
    (mapconcat 'identity capitalized "")))

(defun camelize-method (s)
  "Convert under_score string S to camelCase string."
  (mapconcat 'identity
             (mapcar-head 'downcase
                          'capitalize-downcased
                          (split-string s "_")) ""))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun ediff-with-revision (rev)
  "Compare a file with itself, but from a specific revision. Uses
ediff. I wrote this before I knew magit."
  (interactive "s")
  (let
      ((fname (file-name-nondirectory (buffer-file-name)))
       (buf (get-buffer-create (format "*Git revision %s*" rev))))
    (shell-command (format "git show %s:./%s" rev fname) buf)
    (let ((ediff-split-window-function 'split-window-horizontally))
      (ediff-buffers buf (current-buffer)))))


(defun safe-read-sexp (&optional buf)
  "Like normal read, but return `nil' instead of raising an error
if sexp is malformed."
  (setq buf (or buf (current-buffer)))
  (condition-case ex
     (let ((r (read buf))) (if (listp r) r (list r)))
   ('end-of-file nil)))
