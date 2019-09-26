(require 'generic-x)
(require 'hydra)

;; NOTE: IMPORTANT: (customize-face-other-window 'hl-line)


(use-package avy
  :bind (:map my-find-keys
              ("e" . avy-goto-char-timer)
              ("C-e" . avy-goto-char-timer)
              ("C-l" . avy-goto-line)
              ("l" . avy-goto-line)))


(require 'info)
(defun Info-apropos-matches (string)
  "Collect STRING matches from all known Info files on your system.
Return a list of matches where each element is in the format
\((FILENAME INDEXTEXT NODENAME LINENUMBER))."
  (unless (string= string "")
    (let ((pattern (format "\n\\* +\\([^\n]*\\(%s\\)[^\n]*\\):[ \t]+\\([^\n]+\\)\\.\\(?:[ \t\n]*(line +\\([0-9]+\\))\\)?"
			   (regexp-quote string)))
	  (ohist Info-history)
	  (ohist-list Info-history-list)
	  (current-node Info-current-node)
	  (current-file Info-current-file)
	  manuals matches node nodes)
      (let ((Info-fontify-maximum-menu-size nil))
	(Info-directory)
	;; current-node and current-file are nil when they invoke info-apropos
	;; as the first Info command, i.e. info-apropos loads info.el.  In that
	;; case, we use (DIR)Top instead, to avoid signaling an error after
	;; the search is complete.
	(when (null current-node)
	  (setq current-file Info-current-file)
	  (setq current-node Info-current-node))
	(message "Searching indices...")
	(goto-char (point-min))
	(re-search-forward "\\* Menu: *\n" nil t)
	(while (re-search-forward "\\*.*: *(\\([^)]+\\))" nil t)
	  ;; Make sure we don't have duplicates in `manuals',
	  ;; so that the following dolist loop runs faster.
	  (cl-pushnew (match-string 1) manuals :test #'equal))

    (setq manuals '("elisp" "org" "emacs"))
    (message ">>> %s <<<" manuals)

	(dolist (manual (nreverse manuals))
	  (message "Searching %s" manual)
	  (condition-case err
	      (if (setq nodes (Info-index-nodes (Info-find-file manual)))
                  (save-excursion
                    (Info-find-node manual (car nodes))
                    (while
                        (progn
                          (goto-char (point-min))
                          (while (re-search-forward pattern nil t)
			    (let ((entry (match-string-no-properties 1))
				  (nodename (match-string-no-properties 3))
				  (line (match-string-no-properties 4)))
			      (add-text-properties
			       (- (match-beginning 2) (match-beginning 1))
			       (- (match-end 2) (match-beginning 1))
			       '(face info-index-match) entry)
			      (setq matches (cons (list manual entry nodename line)
						  matches))))
                          (setq nodes (cdr nodes) node (car nodes)))
                      (Info-goto-node node))))
	    (error
	     (message "%s" (if (eq (car-safe err) 'error)
			       (nth 1 err) err))
	     (sit-for 1 t)))))
      (Info-find-node current-file current-node)
      (setq Info-history ohist
	    Info-history-list ohist-list)
      (message "Searching indices...done")
      (or (nreverse matches) t))))


(use-package docker
  :commands docker)

(require 'counsel)

(require 'my-customization-helpers)


(use-package linum
  ;; Hook esp. for Dockerfiles and some actual configs; prog-modes already have
  ;; linum enabled.
  :hook (conf-mode . linum-mode))

(use-package epoch-view
  :commands epoch-view-mode)

(require 'blink-a-bit)
(require 'my-powerline-config)
(require 'my-reorder-buffer-list)
(require 'my-ibuffer)
(require 'my-new-buffers)
(require 'my-messages-buffer)
(require 'my-sidebars)
(require 'my-sunrise)


(use-package ov)
(use-package frame-local)
(use-package font-lock+)


(use-package eaf
  :commands eaf-open eaf-open-url)

(use-package kubernetes
  :commands kubernetes-overview)


(require 'desktop)
(desktop-save-mode 1)
;; (use-package workgroups2
;;   :commands wg-save-session wg-reload-session
;;   :bind (("<pause>" .     wg-reload-session)
;;          ("C-S-<pause>" . wg-save-session)
;;          ("s-z" .         wg-switch-to-workgroup)
;;          ("s-/" .         wg-switch-to-previous-workgroup)))

(global-set-key (kbd "C-n") my-new-buffer-map)

(define-key ctl-x-map (kbd "b")     'helm-for-files)
(define-key ctl-x-map (kbd "M-b")   'ido-switch-buffer-other-window)

;; (define-key ctl-x-map (kbd "C-M-b")   'my-switch-buffer-other-elscreen)
;; (define-key ctl-x-map (kbd "C-M-f")   'my-find-file-other-elscreen)
;; previously: (define-key ctl-x-map (kbd "f")   'ido-find-file)

(define-key ctl-x-map (kbd "C-M-b")   'ibuffer-other-window)
(define-key ctl-x-map (kbd "C-M-f")   'ido-find-file-other-window)
(define-key ctl-x-map (kbd "f")       'helm-find-files)

;; Use ibuffer rather than whatever Emacs uses by default...
(define-key ctl-x-map (kbd "C-b")   'ibuffer)
(global-set-key (kbd "M-x")        'helm-M-x)
(global-set-key (kbd "C-<f2>")     'helm-recentf)
(global-set-key (kbd "<escape>")   'keyboard-quit)
(global-set-key (kbd "M-n")        'clone-buffer)

(defvar my-toggle-keys)
(require 'my-datetime)
(define-key my-toggle-keys (kbd "C-t") 'my-insert-datetime)
(define-key my-toggle-keys (kbd "M-t") 'my-insert-today)
(define-key my-toggle-keys (kbd "t") 'my-insert-now)


(advice-add 'pop-to-mark-command :after #'my-recenter-and-blink)
(advice-add 'xref-pop-marker-stack :after #'my-recenter-and-blink)
(advice-add 'recenter-top-bottom :after #'my-blink-a-bit)


;; shell mode has its own ideas about `mode-specific-map', apparently, so we
;; need to bind the keys explicitly in its map, the `sh-mode-map'
(require 'shell)
(defvar sh-mode-map)

(defun my-shell-mode-hook-for-hydra-zoom ()
  (define-key sh-mode-map (kbd "C-c +") 'hydra-zoom/text-scale-increase)
  (define-key sh-mode-map (kbd "C-c -") 'hydra-zoom/text-scale-decrease))

(add-hook 'sh-mode-hook 'my-shell-mode-hook-for-hydra-zoom)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defvar helm-M-x-fuzzy-match)
(use-package helm
  :config
  (require 'helm-config)
  (require 'helm-command)
  (require 'helm-projectile)
  (setq helm-M-x-fuzzy-match t)
  (define-key helm-map (kbd "DEL") 'helm-backspace)
  (setq helm-for-files-preferred-list '(helm-source-buffers-list
                                        helm-source-recentf
                                        helm-source-buffer-not-found
                                        helm-source-files-in-current-dir)))


(defun helm-backspace ()
  "Forward to `backward-delete-char'. On error (read-only), quit
without selecting."
  (interactive)
  (condition-case nil
      (backward-delete-char 1)
    (error (helm-keyboard-quit))))


;; TODO: prettier display
(use-package unbound
  :bind ("C-h C-u" . describe-unbound-keys)
  :commands describe-unbound-keys)

;; Advice on advice(s):
;; (advice-mapc (lambda (a b) (message "%s :: %s" a b)) 'pop-to-mark-command)
;; (advice-mapc (lambda (a b) (message "%s :: %s" a b)) 'recenter-top-bottom)
;; (advice-remove 'pop-to-mark-command 'ad-Advice-pop-to-mark-command)

;; Frame TITLE (displayed on StumpWM mode-line (or on the title bar))
(setf frame-title-format
      '(;"Emacs -"
        (:eval (condition-case nil
                   (car (reverse (s-split "/" buffer-file-name)))
                 (error (buffer-name))))
        ":"
        (:eval (s-replace "/home/cji/" "~/" default-directory))))


;; Whenever a file that Emacs is editing has been changed by another
;; program the user normally has to execute the command `revert-buffer'
;; to load the new content of the file into Emacs.
(require 'autorevert)                   ; customize-group available


(global-auto-revert-mode 1)
(global-auto-composition-mode -1)      ; for entering strange chars, not needed
(mouse-avoidance-mode -1)              ; clicking on a currently typed word is
                                       ; difficult if this is enabled
(auto-compression-mode 1)              ; transparent editing of compressed files
(file-name-shadow-mode 1)              ; no idea :)
(savehist-mode 1)                      ; save the minibuffer history on exit


;; schedule imports to be done after some modules are imported


(use-package info+ :after info)

(use-package help+
  :after help
  :config
  (require 'help+)
  (require 'help-macro+)
  (require 'help-fns+)
  (require 'help-mode+))


(use-package helpful
  :bind (("C-h f" . helpful-symbol)
         ("C-h k" . helpful-key)))


(defun my-info-apropos (str)
  (interactive (list (read-from-minibuffer "Search manuals for: " (symbol-name (symbol-at-point)))))
  (Info-index-entries-across-manuals str nil '("Elisp" "Emacs" "cl")))

(define-key help-map (kbd "I") 'my-info-apropos)

(use-package thingatpt+
  :after thingatpt)


(defun my-dired-back-to-top ()
  (interactive)
  (beginning-of-buffer)
  (dired-next-line 4))

(defun my-dired-jump-to-bottom ()
  (interactive)
  (end-of-buffer)
  (dired-next-line -1))

(autoload 'sr-dired-prev-subdir "sunrise-commander" "" t)

(use-package dired
  :commands dired dired-at-point
  :bind (:map dired-mode-map
         ([remap beginning-of-buffer] . my-dired-back-to-top)
         ([remap end-of-buffer] . my-dired-jump-to-bottom)
         ("C-<up>" . dired-up-directory)
         ("C-o" . dired-omit-mode))
  :config
  (require 'dired-x)
  (require 'dired+))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;              _ ____                           __ _
;;             (_)  _ \  ___     ___ ___  _ __  / _(_) __ _
;;             | | | | |/ _ \   / __/ _ \| '_ \| |_| |/ _` |
;;             | | |_| | (_) | | (_| (_) | | | |  _| | (_| |
;;             |_|____/ \___/   \___\___/|_| |_|_| |_|\__, |
;;                                                    |___/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; IDo - Interactively Do Things. Has autocompletions in minibufer. Very, very
;; nice, particularly as a replacement to normal read
;; http://www.emacswiki.org/emacs/InteractivelyDoThings
(require 'ido)
(require 'ido-vertical-mode)

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
 ;; ido-handle-duplicate-virtual-buffers    2
 ido-auto-merge-work-directories-length  nil
 ido-vertical-define-keys                'C-n-C-p-up-down-left-right)

;; Make *.py files be sorted before *.pyc and *.ls files before *.js and so on.
;; (but already open files are always placed at the end of file list anyway)
(setq ido-file-extensions-order
      '(".org" ".py" ".el" ".coffee" ".ls" ".less" ".txt"))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;               ____ ___ _   _ ____ ___ _   _  ____ ____                      ;
;;              | __ )_ _| \ | |  _ \_ _| \ | |/ ___/ ___|                     ;
;;              |  _ \| ||  \| | | | | ||  \| | |  _\___ \                     ;
;;              | |_) | || |\  | |_| | || |\  | |_| |___) |                    ;
;;              |____/___|_| \_|____/___|_| \_|\____|____/                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-bookmark-set ()
  (interactive)
  (if (region-active-p)
      (bookmark-set (buffer-substring-no-properties (region-beginning)
                                                    (region-end)))
    (let ((name (s-trim (thing-at-point 'line t))))
      (if (equal "" name)
          (bookmark-set)
        (bookmark-set name))))
  (message "Bookmark set!"))


;; Shortcuts for bookmarks
(define-prefix-command 'my-bookmarks-keys)
(global-set-key (kbd "C-b") 'my-bookmarks-keys)

(define-key my-bookmarks-keys (kbd "C-b") 'my-bookmark-set)
(define-key my-bookmarks-keys (kbd "C-l") 'helm-bookmarks)
(define-key my-bookmarks-keys (kbd "M-l") 'edit-bookmarks)



(defun my-switch-buffer-other-elscreen ()
  (interactive)
  (elscreen-create)
  (call-interactively 'helm-buffers-list))

(defun my-find-file-other-elscreen ()
  (interactive)
  (elscreen-create)
  (call-interactively 'helm-find-files))

(defun my-eshell-other-window (args)
  (interactive "P")
  (split-window-right)
  (windmove-right)
  (eshell))


(defun my-shell-here (arg)
  (interactive "P")
  (letf (((symbol-function 'pop-to-buffer) #'switch-to-buffer))
    (if arg
        (shell)
      (shell-here))))

(defun my-pop-shell-here (arg)
  (interactive "P")
  (if arg
      (shell)
    (shell-here)))


(define-key mode-specific-map (kbd "C-e") 'eshell)
(define-key mode-specific-map (kbd "C-s") 'my-shell-here)
(define-key mode-specific-map (kbd "M-s") 'my-pop-shell-here)
(define-key mode-specific-map (kbd "M-e") 'my-eshell-other-window)


(require 'dirtrack)
(defconst my-dirtrack-list (list (rx line-start
                                     (*? anything) "@" (*? anything)
                                     " " (group (*? anything)) " $")
                                 1))
(defun my-shell-mode-hook ()
  (dirtrack-mode)
  (setq dirtrack-list my-dirtrack-list)
  (local-set-key (kbd "C-c C-s") (lambda ()
                                   (interactive)
                                   (my-shell-here t)))
  (local-set-key (kbd "C-c M-s") 'shell)
  (local-set-key (kbd "C-c M-c") 'comint-kill-subjob)
  (local-set-key (kbd "C-u") 'kill-whole-line)

  ;; (local-set-key (kbd "C-a") ')
  (local-set-key (kbd "<up>") 'previous-line)
  (local-set-key (kbd "<down>") 'next-line)
  (local-set-key (kbd "C-<up>") 'comint-previous-input)
  (local-set-key (kbd "C-<down>") 'comint-next-input)

  (local-set-key (kbd "C-c C-l") 'comint-clear-buffer)
  (local-set-key (kbd "C-l") 'comint-clear-buffer)

  )
(add-hook 'shell-mode-hook 'my-shell-mode-hook)


(defun my-term-mode-hook ()
  (define-key term-mode-map (kbd "C-w") my-wnd-keys)
  (define-key term-raw-map (kbd "C-w") my-wnd-keys)
  (define-key term-raw-map (kbd "C-h") help-map))

(add-hook 'term-mode-hook 'my-term-mode-hook)
(add-hook 'term-exec-hook 'my-term-mode-hook)

(require 'calc-mode)

(defun my-calc-hook ()
  (define-key calc-mode-map (kbd "C-w") 'my-wnd-keys))

(eval-after-load 'calc
  '(progn
     (add-hook 'calc-mode-hook 'my-calc-hook)
     (define-key calc-mode-map (kbd "C-w") 'my-wnd-keys)))

(provide 'my-generic-ui-config)
