;; TODO:
;; 1* learn more about these tools and configure them better
;; 2* The problem is that they are all very similar
;; 3* check out Helm, too: https://github.com/emacs-helm/helm
;; 4* ICICLES!!! Make them alive in some parts.
(require 'ido)
(require 'idomenu)
;; (require 'icicles)
(require 'smex)
(require 'sr-speedbar)
(require 'edmacro)
(require 'unbound)

(require 'all)
(require 'all-ext)

(require 'bookmark+)
(define-key my-bookmarks-keys (kbd "C-b") 'bookmark-set)
(define-key my-bookmarks-keys (kbd "C-l") 'list-bookmarks)
(define-key my-bookmarks-keys (kbd "C-t") 'bm-toggle)

(iswitchb-mode 1)

;;
;; Replace normal Emacs interfaces with enchanced versions
;;
(global-set-key (kbd "C-x C-b") 'ibuffer)


(global-set-key (kbd "M-c")      'anything)
(global-set-key (kbd "M-X")      'smex-major-mode-commands)
(global-set-key (kbd "M-x")      'smex)

(global-set-key (kbd "C-<f1>")   'sr-speedbar-toggle)
(global-set-key (kbd "C-<f2>")   'recentf-open-files)


;; \/\/\/\/\/PLUGIN INITIALIZATIONS\/\/\/\/\/

;; Icicles - http://www.emacswiki.org/emacs/Icicles
;; (icy-mode 1)


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
(setq smex-save-file (concat user-emacs-directory ".smex-items"))
(smex-initialize)
