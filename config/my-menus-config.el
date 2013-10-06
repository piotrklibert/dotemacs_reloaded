(require 'ido)
(require 'idomenu)
(require 'smex)
(require 'sr-speedbar)
(require 'edmacro)
(require 'unbound)

(eval-after-load "bookmark"
  '(require 'bookmark+))
(define-key my-bookmarks-keys (kbd "C-b") 'bookmark-set)
(define-key my-bookmarks-keys (kbd "C-l") 'list-bookmarks)
(define-key my-bookmarks-keys (kbd "C-t") 'bm-toggle)

(iswitchb-mode 1)

;;
;; Replace normal Emacs interfaces with enchanced versions
;;
(global-set-key (kbd "C-x C-b") 'ibuffer)


(global-set-key (kbd "M-X")      'smex-major-mode-commands)
(global-set-key (kbd "M-x")      'smex)

(global-set-key (kbd "C-<f1>")   'sr-speedbar-toggle)
(global-set-key (kbd "C-<f2>")   'recentf-open-files)


;; \/\/\/\/\/PLUGIN INITIALIZATIONS\/\/\/\/\/

;; IDo - Interactively Do Things.
;; Has autocompletions in minibufer and jumping to things, and more.
;; http://www.emacswiki.org/emacs/InteractivelyDoThings
(ido-mode t)
(ido-everywhere t)
(setq
 ido-max-prospects                       10
 ido-enable-prefix                       nil
 ido-create-new-buffer                   'always
 ido-use-virtual-buffers                 t
 ido-enable-flex-matching                t
 ido-use-filename-at-point               'guess
 ido-handle-duplicate-virtual-buffers    2
 ido-auto-merge-work-directories-length  nil)


;; Smex - built on top of IDo M-x replacement.
;; http://www.emacswiki.org/emacs/Smex
;; (concat user-emacs-directory )
(setq smex-save-file "/root/.emacs.d/data/smex-items"
      smex-history-length 100)
(smex-initialize)
