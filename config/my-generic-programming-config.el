(require 'cl)
(require 'eassist)
(require 'electric)
(require 'thingatpt)
(require 'powerline)
(require 'rainbow-delimiters)

(require 'flymake)
(require 'flymake-checkers)


(require 'columnize)

(require 'align-string)
(require 'align-regexp)
(require 'align-by-current-symbol)      ; use with C-u for "strange" symbols,
                                        ; like ' ( ; and so on

(require 'ag)                           ; ack replacement in C
(require 'ffap)                         ; find file at point
(require 'fuzzy)                        ; fuzzy isearch support

(require 'jka-compr)                    ; searches tags in gzipped sources too
(require 'ls-lisp)                      ; elisp ls replacement

(require 'electric)

(eval-after-load "replace"
  '(progn
     (require 'occur-x)
     (require 'occur-default-current-word)
     (add-hook 'occur-mode-hook 'turn-on-occur-x-mode)
     (message "occur-x activated")))



;; Needs to be configured before require because. Just because.
(setq ace-jump-mode-submode-list
      '(ace-jump-word-mode
        ace-jump-line-mode              ; make C-u C-c spc jump to lines
        ace-jump-char-mode))
(require 'ace-jump-mode)                ; quickly jump to char

(require 'fuzzy-find-in-project)

(require 'my-highlight-word)            ; somewhat like * in Vim
(require 'my-ffap-wrapper)

;; that's silly, but it's my first "serious" Elisp, so I keep it around :)
(require 'my-toggle-true-false)

;; (eval-after-load "ace-jump-mode"
;;   '(ace-jump-mode-enable-mark-sync))
;; (define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)


;; (require 'etags-update)
;; It's not used right now because it's muuuch too slow for my Python projects,
;; and on the other hand it's unwieldy to reindex tags by hand everytime I
;; change something.
;; TODO: etags-update - look into it once more before discarding
;; (etags-update-mode 1)
;; default tag table file
;; (visit-tags-table "~/.emacs.d/TAGS")


;;              ____  _____ _____ _____ ___ _   _  ____ ____
;;             / ___|| ____|_   _|_   _|_ _| \ | |/ ___/ ___|
;;             \___ \|  _|   | |   | |  | ||  \| | |  _\___ \
;;              ___) | |___  | |   | |  | || |\  | |_| |___) |
;;             |____/|_____| |_|   |_| |___|_| \_|\____|____/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)                     ; Maintain tag database.
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)              ; Reparse buffer when idle.
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)                ; Show summary of tag at point.
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)              ; Highlight the current tag.
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)                  ; Show current fun in header line.
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)                ; Provide `switch-to-buffer'-like keybinding for tag names.
(add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode)                       ; A mouse 3 context menu.
(add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode) ; Highlight references of the symbol under point.
(semantic-mode 1)


(turn-on-fuzzy-isearch)                 ; complement: turn-off-fuzzy-isearch
(global-auto-mark-mode 1)               ; configured in my-indent-config.el (?)
(wrap-region-global-mode t)             ; select region and press ( to wrap it
(electric-pair-mode 1)

(column-number-mode t)                  ; show col num on modeline
(show-paren-mode t)                     ; highlight matching parens


;; set root dirs for FFIP
(let ((paths (list "/usr/www/tagasauris/" "/usr/www/tagasauris/solr/"
                   "/usr/www/tagasauris/src/tenclouds/tenclouds/"
                   "/usr/www/tagasauris/control/" "/usr/www/tagasauris/config/"
                   "/usr/www/tagasauris/doc/" "~/.emacs.d/config/"
                   "~/.emacs.d/plugins2/" "~/.emacs.d/pkg-langs/" "~/todo/")))
  (setq fuzzy-find-project-root (--map (f-expand it) paths)))



;; make Dired use gnu ls (from coreutils) instead of BSD ls
(when (file-exists-p "/usr/local/bin/gls")
  (setq ls-lisp-use-insert-directory-program t)
  (setq insert-directory-program "/usr/local/bin/gls"))


;;                           _  _________   ______
;;                          | |/ / ____\ \ / / ___|
;;                          | ' /|  _|  \ V /\___ \
;;                          | . \| |___  | |  ___) |
;;                          |_|\_\_____| |_| |____/
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-key my-toggle-keys (kbd "C-t") 'my-toggle-true-false-none)

(global-set-key (kbd "C-c C-l") 'pygmentize)
(global-set-key (kbd "C-=")     'indent-for-tab-command)
(global-set-key (kbd "C-M-=")   'align-by-current-symbol)
(global-set-key (kbd "C-M-\"")  'my-toggle-quotes)
(global-set-key (kbd "C-!")     'highlight-or-unhighlight-at-point)
(global-set-key (kbd "C-\"")    'comment-or-uncomment-region-or-line)

;;
;; Utilities for navigating around the codebase: searching, greping, jumping...
;;
(define-key mode-specific-map (kbd "SPC")   'ace-jump-mode)
(define-key mode-specific-map (kbd "C-SPC") 'ace-jump-mode)

(define-key my-find-keys (kbd "C-o")      'occur)
(define-key my-find-keys (kbd "C-g")      'global-occur)
(define-key my-find-keys (kbd "C-f")      'fuzzy-find-in-project)
(define-key my-find-keys (kbd "C-M-f")    'fuzzy-find-change-root)
(define-key my-find-keys (kbd "C-r")      'find-grep-dired)
(define-key my-find-keys (kbd "C-i")      'idomenu)
(define-key my-find-keys (kbd "C-m")      'my-imenu-show-popup)
(define-key my-find-keys (kbd "C-d")      'find-name-dired)
(define-key my-find-keys (kbd "C-a")      'ag)
(define-key my-find-keys (kbd "C-M-a")    'ack)
(define-key my-find-keys (kbd "C-p")      'my-project-ffap)
(define-key my-find-keys (kbd "C-M-p")    'ffap-other-window)





;; XXX: This proved to be slower and to have much worse interface than fuzzy-find.
;; As such it's not needed anymore, but I left it here to remind me to look
;; into the plugin use of minibuffer, which I might use someday.
;; XXX: (require 'find-file-in-project-autoloads)
;; (define-key my-find-keys (kbd "C-M-f") 'find-file-in-project)


;;
;;              ____  ____   ___   ____   _   _  ___   ___  _  __
;;             |  _ \|  _ \ / _ \ / ___| | | | |/ _ \ / _ \| |/ /
;;             | |_) | |_) | | | | |  _  | |_| | | | | | | | ' /
;;             |  __/|  _ <| |_| | |_| | |  _  | |_| | |_| | . \
;;             |_|   |_| \_\\___/ \____| |_| |_|\___/ \___/|_|\_\
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(add-hook 'prog-mode-hook 'my-init-prog-mode)

(defun my-init-prog-mode ()
  ;; modes which should be enabled by default:
  (electric-pair-mode 1)
  (fic-ext-mode 1)
  (rainbow-delimiters-mode 1)
  (rainbow-mode 1)
  (hl-line-mode 1)
  (fci-mode 1)
  (undo-tree-mode 1)
  (delete-selection-mode 1)
  (flymake-mode 1)
  ;; (global-linum-mode 1) made pdf viewing (Doc Mode) unusable, and it offered
  ;; no way of excluding just some modes, so I had to enable it locally for
  ;; prog-mode buffers only
  (linum-mode 1)

  ;; in Python it doesn't work well - folds whole classes, but not methods
  (when (not (memq major-mode
                   '(python-mode sh-mode web-mode)))
    (hs-minor-mode)
    (local-set-key (kbd "C-c C-c C-h") 'hs-hide-all)
    (local-set-key (kbd "C-c C-c C-s") 'hs-show-all)
    (local-set-key (kbd "C-c C-c C-t") 'hs-toggle-hiding))

  (local-set-key (kbd "C-x C-x") 'exchange-point-and-mark)
  (local-set-key (kbd "<return>") 'newline-and-indent))

(add-hook 'before-save-hook 'delete-trailing-whitespace)


;;  __  ____   __       _____ _   _ _   _  ____ _____ ___ ___  _   _ ____
;; |  \/  \ \ / /      |  ___| | | | \ | |/ ___|_   _|_ _/ _ \| \ | / ___|
;; | |\/| |\ V /       | |_  | | | |  \| | |     | |  | | | | |  \| \___ \
;; | |  | | | |        |  _| | |_| | |\  | |___  | |  | | |_| | |\  |___) |
;; |_|  |_| |_|        |_|    \___/|_| \_|\____| |_| |___\___/|_| \_|____/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun my-imenu-show-popup ()
  "Somehow I didn't find any setting for making this the
default."
  (interactive)
  (let ((imenu-use-popup-menu t))
    (imenu (imenu-choose-buffer-index))))

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


(defun pygmentize (lang)
  "Produces highlighted HTML representation of a selected source code region."
  (interactive "sLang? ")
  (let
      ((command (concat "pygmentize -l " lang " -f html")))
    (if (use-region-p)
        (shell-command-on-region (region-beginning) (region-end)
                                 command nil t)
      (message "I'm only working with regions"))))


;; I-search like in VIM * and # - actually it's easy. C-w pastes
;; current word to minibuffer when I-search is active. So
;; C-s C-w and C-r C-w does the trick.
;;
;; There's a little snippet to bind it to C-* (don't know if I want it):
;;
;; (require "thingatpt")
;; (require "isearch")
;; (define-key isearch-mode-map (kbd "C-*")
;;   (lambda ()
;;     "Reset current isearch to a word-mode search of the word under point."
;;     (interactive)
;;     (setq isearch-word t
;;           isearch-string ""
;;           isearch-message "")
;;     (isearch-yank-string (word-at-point))))
;;
;;

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
