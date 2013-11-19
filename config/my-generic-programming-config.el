(require 'cl)
(require 'eassist)
(require 'electric)
(require 'thingatpt)
(require 'powerline)
(require 'rainbow-delimiters)

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


(require 'expand-region)
(define-key mode-specific-map (kbd "C-=") 'er/expand-region) ; C-c C-=


(setq ace-jump-mode-submode-list
      '(ace-jump-word-mode
        ace-jump-line-mode              ; make C-u C-c spc jump to lines
        ace-jump-char-mode))
(require 'ace-jump-mode)                ; quickly jump to char
;; you can select the key you prefer to
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(define-key global-map (kbd "C-c C-SPC") 'ace-jump-mode)
;; (eval-after-load "ace-jump-mode"
;;   '(ace-jump-mode-enable-mark-sync))
;; (define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)



;; It's not used right now because it's muuuch too slow for my Python projects,
;; and on the other hand it's unwieldy to reindex tags by hand everytime I
;; change something.
;; TODO: etags-update
;; look into it once more before discarding
;; (require 'etags-update)
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
;; (add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)            ; Show completions when idle.
;; (add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)                  ; Additional tag decorations.
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)              ; Highlight the current tag.
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)                  ; Show current fun in header line.
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)                ; Provide `switch-to-buffer'-like keybinding for tag names.
(add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode)                       ; A mouse 3 context menu.
(add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode) ; Highlight references of the symbol under point.
(semantic-mode 1)


(turn-on-fuzzy-isearch)                 ; complement: turn-off-fuzzy-isearch
(global-auto-mark-mode 1)
(wrap-region-global-mode t)
(electric-pair-mode 1)
;; this makes pdf viewing unusable, and offers no way of excluding some modes,
;; so I will enable it for programming modes only
;; (global-linum-mode 1)                   ; Show line numbers on buffers
(column-number-mode t)
(show-paren-mode t)

(require 'fuzzy-find-in-project)
(setq fuzzy-find-project-root
      '("/usr/www/tagasauris/"
        "/root/.emacs.d/config/"
        "/root/.emacs.d/plugins2"
        "/root/.emacs.d/pkg-langs"
        "/root/todo/"))


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
(define-key my-find-keys (kbd "C-o")      'occur)
(define-key my-find-keys (kbd "C-g")      'global-occur)
;; (global-set-key (kbd "C-M-y")             'fuzzy-find-in-project)
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

(define-key ctl-x-map (kbd "C-M-b") 'bs-show)
;; (define-key ctl-x-map (kbd "C-M-b") 'electric-buffer-listw)

(defun my-imenu-show-popup ()
  (interactive)
  (let ((imenu-use-popup-menu t))
    (imenu (imenu-choose-buffer-index))))


;; XXX: This proved to be slower and to have much worse interface than fuzzy-find.
;; As such it's not needed anymore, but I left it here to remind me to look
;; into the plugin use of minibuffer, which I might use someday.
;; XXX: (require 'find-file-in-project-autoloads)
;; (define-key my-find-keys (kbd "C-M-f") 'find-file-in-project)

;;
;;                              PROG-MODE HOOKS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; these should be autloaded:
;; (require 'fic-ext-mode)
;; (require 'rainbow-mode)
;; (add-hook 'prog-mode-hook   'fic-ext-mode)
;; (add-hook 'prog-mode-hook   'rainbow-delimiters-mode)
;; (add-hook 'prog-mode-hook   'rainbow-mode)
;; (add-hook 'prog-mode-hook   'hl-line-mode)
;; (add-hook 'prog-mode-hook   'fci-mode)
;; (add-hook 'prog-mode-hook   'undo-tree-mode)
;; (add-hook 'prog-mode-hook   'delete-selection-mode)


(add-hook 'prog-mode-hook 'my-init-prog-mode)

(defun my-init-prog-mode ()
  ;; modes which should be enabled by default:
  (fic-ext-mode 1)
  (rainbow-delimiters-mode 1)
  (rainbow-mode 1)
  (hl-line-mode 1)
  (fci-mode 1)
  (undo-tree-mode 1)
  (delete-selection-mode 1)
  (linum-mode 1)

  ;; TODO: why not in python-mode?
  (when (not (memq major-mode '(python-mode
                                sh-mode
                                web-mode)))
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
;;

(require 'my-highlight-word)

(require 'my-toggle-true-false)


(defun my-toggle-quotes ()
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
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning)
              end (region-end))
      (setq beg (line-beginning-position)
            end (line-end-position)))
    (comment-or-uncomment-region beg end)))


(defun global-occur (arg)
  "Find occurances of arg in all but temporary opened buffers."
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

(if nil
    (if-bsd
     ;; Load CEDET library - used by ECB. Needs to be loaded before
     ;; anything else.
     (load-file "~/.emacs.d/plugins/cedet/common/cedet.el")
     ;; Enable the Project management system
     (global-ede-mode 1)

     ;; Enable prototype help and smart completion
     (semantic-load-enable-code-helpers)

     ;; Enable template insertion menu
     (global-srecode-minor-mode 1)

     ;; Enable ECB extension
     (require 'ecb)))

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


(defun ediff-with-revision (rev)
  "Compare a file with itself, but from a specific revision. Uses ediff, because
default git diff is sooo weak..."
  (interactive "s")
  (let
      ((fname (file-name-nondirectory (buffer-file-name)))
       (buf (get-buffer-create (format "*Git revision %s*" rev))))
    (shell-command (format "git show %s:./%s" rev fname) buf)
    (let ((ediff-split-window-function 'split-window-horizontally))
      (ediff-buffers buf (current-buffer)))
    ))


(defun safe-read-sexp (&optional buf)
  (setq buf (or buf (current-buffer)))
  (condition-case ex
     (let ((r (read buf))) (if (listp r) r (list r)))
   ('end-of-file nil)))


;; ____   _____        ___   _ _     ___    _    ____    ____   _    ____ _____
;;|  _ \ / _ \ \      / / \ | | |   / _ \  / \  |  _ \  |  _ \ / \  / ___| ____|
;;| | | | | | \ \ /\ / /|  \| | |  | | | |/ _ \ | | | | | |_) / _ \| |  _|  _|
;;| |_| | |_| |\ V  V / | |\  | |__| |_| / ___ \| |_| | |  __/ ___ \ |_| | |___
;;|____/ \___/  \_/\_/  |_| \_|_____\___/_/   \_\____/  |_| /_/   \_\____|_____|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'thingatpt)

(defun my-fetch-page (page-url)
  "Fetch a HTTP page and insert it's body at point."
  (interactive
   (list
    (let*
        ((prompt    "Enter url (default: %s): ")
         (at-point  (thing-at-point 'url t))
         (input     (read-string (format prompt (or at-point ""))))
         (got-input (not (equal input ""))))
      (if (and (not got-input)
               (not at-point))
          (error "No url given")
        (if got-input input at-point)))))
  (lexical-let ((target (current-buffer)))
    (url-retrieve
     page-url
     (lambda (status)
       (search-forward "\n\n")
       (let
           ((body (buffer-substring (point) (point-max))))
         (message "%s" target)
         (with-current-buffer target
           (if current-prefix-arg
               (goto-char (point-max))
             (end-of-line))
           (newline)
           (insert body)))))))


(require 's)
(require 'dash)
(require 'deferred)

(defstruct file-buffers-list
  list pos)

(defvar my-file-buffers nil)
(defvar my-last-traverse nil)
(defvar my-deferred nil)

(defmacro make-fbl (list pos)
  `(make-file-buffers-list :list ,list
                           :pos ,pos))
(defun fbl-list ()
  (file-buffers-list-list my-file-buffers))
(defun fbl-pos ()
  (file-buffers-list-pos my-file-buffers))

(defmacro fb-list-nth (fb-list)
  "Get a current buffer out of given `file-buffers-list' struct.
If it's `pos' is somehow out of range, wrap it before returning."
  `(let*
       ((pos   (file-buffers-list-pos ,fb-list))
        (list  (file-buffers-list-list ,fb-list) )
        (pos   (% pos (length list)))
        (pos   (if (< pos 0) (1+ (- (length list) pos)) pos)))
     (nth pos list)))


(defun tfb-hidden-buf? (it)
  (s-contains? "*" it))

(defun tfb-buf-names ()
  (let ((names (-map 'buffer-name (buffer-list))))
    (-remove 'tfb-hidden-buf? names)))

(defun tfb-init ()
  (setq my-file-buffers (make-fbl (tfb-buf-names) 0)))

(defun tfb-finish ()
  (switch-to-buffer (fb-list-nth my-file-buffers))
  (setq my-file-buffers  nil
        my-last-traverse nil
        my-deferred      nil)
  (message "finished %s" (tfb-buf-names)))

(defun my-schedule-cleanup ()
  (unless my-deferred
    (setq my-deferred
          (deferred:$
            (deferred:wait 1000)
            (deferred:nextc it
              (lambda (x)
                (if (> (- (float-time) my-last-traverse) 2.5)
                    (tfb-finish)
                  (setq my-deferred nil)
                  (my-schedule-cleanup))))))))

(defun tfb-moveto (&optional delta)
  (setq my-last-traverse   (float-time))
  (unless delta            (setq delta 1))
  (unless my-file-buffers  (tfb-init))
  (let*
      ((pos (fbl-pos))
       (len (length (fbl-list)))
       (dest (+ pos delta))
       (dest (if (< dest 0) (1- len) dest)))
    (setf (file-buffers-list-pos my-file-buffers) dest)
    (switch-to-buffer (fb-list-nth my-file-buffers) t)
    (my-schedule-cleanup)))

(defun tfb-up ()
  (interactive)
  (tfb-moveto 1))

(defun tfb-down ()
  (interactive)
  (tfb-moveto -1))

(global-set-key (kbd "C-M-<prior>") 'tfb-down)
(global-set-key (kbd "C-M-<next>")  'tfb-up)


(defvar my-ffap-roots '("/usr/www/tagasauris/tagasauris/"
                        "/usr/www/tagasauris/tagasauris/statics/"
                        "/usr/www/tagasauris/tagasauris/templates/"))

(defun my-project-ffap ()
  (interactive)
  (let* ((fname-at-pt (ffap-string-at-point))
         (fname-normalized (if (file-name-absolute-p fname-at-pt)
                               (replace-regexp-in-string "^/" "" fname-at-pt t t)
                             fname-at-pt))
         found)
    (loop for r in my-ffap-roots
          for fname = (concat (file-name-as-directory r) fname-normalized)
          if (file-exists-p fname)
          do (setq found fname))
    (or (and found (find-file found))
        (call-interactively 'ffap))))
