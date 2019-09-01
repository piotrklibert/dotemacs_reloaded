(require 'use-package)
(require 'f)
(require 'my-keymaps-config)

(require 'isearch)
(eval-when-compile
  (require 'cl))
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


(require 'ag-autoloads)                 ; ack replacement in C
(require 'ggtags-autoloads)
(require 'rainbow-mode-autoloads)
(require 'fic-ext-mode-autoloads)
(require 'rainbow-delimiters-autoloads)


(use-package tail       :commands tail-file)
(use-package tags-tree  :commands tags-tree)
(use-package imenu-tree :commands imenu-tree)
(use-package helm-ag    :commands helm-do-ag
                                  helm-do-ag-project-root)
(use-package swiper     :commands swiper)
(use-package columnize  :commands columnize-text
                                  columnize-strings)





(require 'my-hideshow)



(defun my-msg-mode-hook ()
  (add-hook 'xref-backend-functions #'(lambda () 'elisp)))

(add-hook 'message-mode-hook 'my-msg-mode-hook)


(defun my-info-mode-hook ()
  (add-hook 'xref-backend-functions #'(lambda () 'elisp))
  (define-key 'Info-mode-map (kbd "<mouse-5>") (lambda () (scroll-down 4)))
  (define-key 'Info-mode-map (kbd "<mouse-4>") (lambda () (scroll-up 4))))

;; (add-hook 'Info-mode-hook 'my-info-mode-hook)
;; (remove-hook 'Info-mode-hook 'my-info-mode-hook)

(define-key help-map (kbd "C-a") 'helm-apropos)
(define-key help-map (kbd "a") 'apropos)

(defun my-help-mode-hook ()
  (add-hook 'xref-backend-functions #'(lambda () 'elisp)))

(add-hook 'help-mode-hook 'my-help-mode-hook)


(autoload 'helm-def-source--emacs-functions "helm-elisp")
(defun helm-apropos-functions (default)
  "Preconfigured helm to describe functions."
  (interactive (list (thing-at-point 'symbol)))
  (helm :sources (list (helm-def-source--emacs-functions))
        :history 'helm-apropos-history
        :buffer "*helm apropos*"
        :input default
        :preselect default))

(define-key help-map (kbd "C-f") 'helm-apropos-functions)

(eval-after-load "pcase"
  '(put 'pcase 'function-documentation '()))


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

(require 'ivy)
(setf ivy-format-function 'my-ivy-format)

;;                           _  _________   ______
;;                          | |/ / ____\ \ / / ___|
;;                          | ' /|  _|  \ V /\___ \
;;                          | . \| |___  | |  ___) |
;;                          |_|\_\_____| |_| |____/
;;
;;================================================================================

(define-key my-toggle-keys (kbd "\"") 'my-toggle-quotes)
(define-key mode-specific-map (kbd "\"") 'my-toggle-quotes)

(define-key prog-mode-map (kbd "C-c <left>") 'hs-toggle-hiding)

;; (global-set-key (kbd "C-c C-l") 'pygmentize)
(global-set-key (kbd "C-=")     'indent-for-tab-command)
(global-set-key (kbd "C-M-=")   'align-by-current-symbol)
(global-set-key (kbd "C-M-.")   'xref-find-definitions-other-window)
(global-set-key (kbd "C-!")     'highlight-or-unhighlight-at-point)
(global-set-key (kbd "C-\"")    'comment-or-uncomment-region-or-line)
(global-set-key (kbd "<f9>")    'my-make)


(define-key mode-specific-map (kbd "e") 'flymake-show-diagnostics-buffer)
(define-key mode-specific-map (kbd "w w") 'flymake-show-diagnostics-buffer)
(define-key mode-specific-map (kbd "w <down>") 'flymake-goto-next-error)
(define-key mode-specific-map (kbd "w <up>") 'flymake-goto-prev-error)
(define-key mode-specific-map (kbd "M-.") 'xref-find-definitions-other-window)

;; functions related to searching paths, files and everything else.
(defvar my-find-keys)
(define-prefix-command 'my-find-keys)
(global-set-key (kbd "C-f") 'my-find-keys)


(define-key my-find-keys (kbd "o")        'occur)
(define-key my-find-keys (kbd "l")        'find-library-other-window)
(define-key my-find-keys (kbd "C-o")      'helm-occur)
(define-key my-find-keys (kbd "C-g")      'global-occur)


(define-key my-find-keys (kbd "f")    'helm-projectile-find-file)
(define-key my-find-keys (kbd "C-f")  'fuzzy-find-in-project)
(define-key my-find-keys (kbd "C-M-f")  'fuzzy-find-choose-root-set)
;; (define-key my-find-keys (kbd "C-c") 'fuzzy-find-choose-root-set)

(define-key my-find-keys (kbd "C-r")      'find-grep-dired)
(define-key my-find-keys (kbd "C-i")      'helm-imenu)
(define-key my-find-keys (kbd "C-m")      'my-imenu-show-popup)
(define-key my-find-keys (kbd "C-d")      'find-name-dired)

(define-key my-find-keys (kbd "C-c")     'iy-go-to-char)
(define-key my-find-keys (kbd "c")       'iy-go-to-char)
(define-key my-find-keys (kbd "<SPC>")   'iy-go-to-char)
(define-key my-find-keys (kbd "C-<SPC>") 'iy-go-to-char)

(autoload 'helm-do-ag-project-root "helm-ag" "" t)
(define-key my-find-keys (kbd "C-a")      'my-helm-do-ag-current-dir)
(define-key my-find-keys (kbd "a")        'helm-do-ag-project-root)
(define-key my-find-keys (kbd "M-a")      'ag)

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
  (let*
      ((fname (buffer-file-name (current-buffer)))
       (dir (if fname (f-dirname fname) default-directory)))
    (helm-do-ag dir "*.*")))

(require 'helm-imenu)

(defun my-imenu-show-popup ()
  "Somehow I didn't find any setting for making this the
default."
  (interactive)
  (setq helm-source-occur
        (car (helm-occur-build-sources (list (current-buffer)) "Helm occur")))
  (helm-set-local-variable 'helm-occur--buffer-list (list (current-buffer))
                           'helm-occur--buffer-tick
                           (list (buffer-chars-modified-tick (current-buffer))))
  (helm :sources '(helm-source-imenu helm-source-occur)))


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
       (buffers (cl-remove-if-not search-buffer-p (buffer-list))))
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
