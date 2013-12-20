(require 'ido)
(require 'idomenu)
(require 'ido-vertical-mode)
;; TODO: maybe enable this
;; (require 'ido-ubiquitous-mode)

(require 'smex)
(require 'sr-speedbar)
(require 'edmacro)
(require 'unbound)

(require 'sunrise-commander)

(require 'autorevert)
(global-auto-revert-mode 1)

(eval-after-load "bookmark"
  '(require 'bookmark+))

(define-key my-bookmarks-keys (kbd "C-b") 'bookmark-set)
(define-key my-bookmarks-keys (kbd "C-l") 'list-bookmarks)
(define-key my-bookmarks-keys (kbd "C-t") 'bm-toggle)

(iswitchb-mode 1)

;;
;; Replace normal Emacs interfaces with enchanced versions
;;
(global-set-key (kbd "C-x C-b")  'ibuffer)

(global-set-key (kbd "M-X")      'smex-major-mode-commands)
(global-set-key (kbd "M-x")      'smex)

(global-set-key (kbd "C-<f1>")   'sr-speedbar-toggle)
(global-set-key (kbd "C-<f2>")   'recentf-open-files)
(global-set-key (kbd "C-<f3>")   'sunrise)


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


;; Smex - built on top of IDo M-x replacement.
;; http://www.emacswiki.org/emacs/Smex
(setq smex-save-file (concat user-emacs-directory "data/smex-items")
      smex-history-length 100)
(smex-initialize)


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
