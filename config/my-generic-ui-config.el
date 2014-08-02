(defun make-local-hook (&rest things)
  "Something somewhere calls this obsolete function; I couldn't
  find it by grepping the sources so I decided to mock it to get
  rid of annoying warnings.")

(require 'ido)
(require 'idomenu)
(require 'ido-vertical-mode)
;; TODO: maybe enable this
;; (require 'ido-ubiquitous-mode)

(require 'direx)
(require 'generic-x)
(require 'smex)
(require 'sr-speedbar)
(require 'edmacro)
(require 'unbound)

(require 'sunrise-commander)

(require 'autorevert)
(global-auto-revert-mode 1)

;; set via customize:
;; (setq auto-revert-verbose nil)
;; (setq global-auto-revert-non-file-buffers t) ; revert Dired buffers too

(global-auto-composition-mode -1)       ; for entering strange chars, not needed
(mouse-avoidance-mode 'exile)           ; should move mouse away from point
(auto-compression-mode 1)               ; transparent editing of compressed files
(file-name-shadow-mode 1)               ; no idea :)
(savehist-mode 1)                       ; save the minibuffer history on exit

;; (require 'subword) ; for dealing with camel-cased text

(icomplete-mode 1)
(when (boundp 'icomplete-minibuffer-map)
  (define-key icomplete-minibuffer-map (kbd "<left>") 'icomplete-forward-completions)
  (define-key icomplete-minibuffer-map (kbd "<right>") 'icomplete-backward-completions))

;; schedule imports to be done after some modules are imported
(eval-after-load "dired"
  '(progn
     (require 'dired-x)
     (require 'dired+)))

(eval-after-load "info"
  '(require 'info+))

(eval-after-load "help"
  '(progn
     (require 'help-macro+)
     (require 'help-fns+)
     (require 'help+)
     (require 'help-mode+)))

(eval-after-load "thingatpt"
  '(require 'thingatpt+))

(eval-after-load "bookmark"
  '(require 'bookmark+))

(define-key my-bookmarks-keys (kbd "C-b") 'bookmark-set)
(define-key my-bookmarks-keys (kbd "C-l") 'list-bookmarks)
(define-key my-bookmarks-keys (kbd "C-t") 'bm-toggle)

;;
;; Replace normal Emacs interfaces with enchanced versions
;;
(global-set-key (kbd "C-x C-b")  'ibuffer)

(global-set-key (kbd "M-X")      'smex-major-mode-commands)
(global-set-key (kbd "M-x")      'smex)

(global-set-key (kbd "C-<f1>")   'sr-speedbar-toggle)
(global-set-key (kbd "C-<f2>")   'recentf-open-files)

(global-set-key (kbd "C-<f3>")   'sunrise)
(global-set-key (kbd "M-<f3>")   'sunrise-cd)


(global-set-key (kbd "C-<f4>")   'delete-frame)

;; IDo - Interactively Do Things.
;; Has autocompletions in minibufer and jumping to things, and more.
;; http://www.emacswiki.org/emacs/InteractivelyDoThings
(ido-mode 1)
(ido-everywhere 1)
(ido-vertical-mode 1)

(setq
 ido-max-prospects                       10
 ido-enable-prefix                       nil
 ido-create-new-buffer                   'always
 ido-use-virtual-buffers                 t
 ido-enable-flex-matching                t
 ido-use-filename-at-point               'guess
 ido-handle-duplicate-virtual-buffers    2
 ido-auto-merge-work-directories-length  nil
 ido-vertical-define-keys                'C-n-C-p-up-down-left-right)

;; but remember that files which are already open are placed last on a list in
;; IDo C-x C-f - I didn't find any way of overriding this behaviour
(setq ido-file-extensions-order '(".org" ".py" ".el" ".coffee"
                                  ".ls" ".less" ".txt"))


;; Smex - built on top of IDo M-x replacement.
;; http://www.emacswiki.org/emacs/Smex
(setq smex-save-file (concat user-emacs-directory "data/smex-items")
      smex-history-length 100)
(smex-initialize)


;;                            ____  _              _
;;                           |  _ \(_)_ __ ___  __| |
;;                           | | | | | '__/ _ \/ _` |
;;                           | |_| | | | |  __/ (_| |
;;                           |____/|_|_|  \___|\__,_|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun my-dired-back-to-top ()
  (interactive)
  (beginning-of-buffer)
  (dired-next-line 4))

(defun my-dired-jump-to-bottom ()
  (interactive)
  (end-of-buffer)
  (dired-next-line -1))

(define-key dired-mode-map [remap beginning-of-buffer] 'my-dired-back-to-top)
(define-key dired-mode-map [remap end-of-buffer] 'my-dired-jump-to-bottom)


;;                       ___ _            __  __
;;                      |_ _| |__  _   _ / _|/ _| ___ _ __
;;                       | || '_ \| | | | |_| |_ / _ \ '__|
;;                       | || |_) | |_| |  _|  _|  __/ |
;;                      |___|_.__/ \__,_|_| |_|  \___|_|
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun ibuffer-end ()
  (interactive)
  (goto-char (point-max))
  (forward-line -1)
  (ibuffer-skip-properties '(ibuffer-summary ibuffer-filter-group-name) -1))

(defun ibuffer-beginning ()
  (interactive)
  (goto-char (point-min))
  (ibuffer-skip-properties '(ibuffer-title ibuffer-filter-group-name) 1))

(defun my-ibuffer-mode-hook ()
  "Customized/added in ibuffer-mode-hook custom option."
  ;; see also ibuffer-formats for columns config
  (define-key ibuffer-mode-map (kbd "M-f")    'ibuffer-jump-to-buffer)
  (define-key ibuffer-mode-map (kbd "<down>") 'ibuffer-forward-line)
  (define-key ibuffer-mode-map (kbd "<up>")   'ibuffer-backward-line)

  (define-key ibuffer-mode-map [remap beginning-of-buffer] 'ibuffer-beginning)
  (define-key ibuffer-mode-map [remap end-of-buffer] 'ibuffer-end))
