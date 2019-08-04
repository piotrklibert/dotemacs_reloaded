(require 'generic-x)
(require 'avy-autoloads)
(require 'helm-autoloads)
(require 'linum)
(require 'counsel)

(require 'my-powerline-config)



;; shell mode has its own ideas about `mode-specific-map', apparently, so we
;; need to bind the keys explicitly in its map, the `sh-mode-map'
(require 'shell)
(defvar sh-mode-map)

(defun my-shell-mode-hook-for-hydra-zoom ()
  (define-key sh-mode-map (kbd "C-c +") 'hydra-zoom/text-scale-increase)
  (define-key sh-mode-map (kbd "C-c -") 'hydra-zoom/text-scale-decrease))

(add-hook 'sh-mode-hook 'my-shell-mode-hook-for-hydra-zoom)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defvar rectangle-mark-mode)

(defun hydra-ex-point-mark ()
  "Exchange point and mark."
  (interactive)
  (if rectangle-mark-mode
      (rectangle-exchange-point-and-mark)
    (let ((mk (mark)))
      (rectangle-mark-mode 1)
      (goto-char mk))))


(eval-after-load 'helm
  '(progn
     (require 'helm-config)
     (require 'helm-command)
     (setq helm-M-x-fuzzy-match t)
     (define-key helm-map (kbd "DEL") 'helm-backspace)))

(defun helm-backspace ()
  "Forward to `backward-delete-char'. On error (read-only), quit
without selecting."
  (interactive)
  (condition-case nil
      (backward-delete-char 1)
    (error (helm-keyboard-quit))))


(use-package dirtree
  :commands dirtree)


(use-package unbound
  :commands describe-unbound-keys)


(use-package sunrise-commander
  :commands sunrise sunrise-cd
  :init
  (global-set-key (kbd "C-<f3>") 'sunrise)
  (global-set-key (kbd "M-<f3>") 'sunrise-cd)
  :config
  (define-key sr-mode-map (kbd "C-<prior>") 'elscreen-previous)
  (require 'sunrise-x-tree)
  (require 'sunrise-x-modeline))




(defvar my-blinking-p nil)

(defun my-blink-a-bit ()
  (interactive)
  (unless my-blinking-p
    (blink-cursor-mode 1)
    (set-cursor-color "red")
    (setf my-blinking-p t)
    (run-at-time 2.2 nil
      (lambda ()
        (setf my-blinking-p nil)
        (set-cursor-color "white")
        (blink-cursor-mode 0)))
    nil))

(defun my-recenter-and-blink ()
  (recenter)
  (my-blink-a-bit))

(advice-add 'pop-to-mark-command :after #'my-recenter-and-blink)
(advice-add 'xref-pop-marker-stack :after #'my-recenter-and-blink)

(advice-add 'recenter-top-bottom :after #'my-blink-a-bit)

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


(eval-after-load "info"
  '(require 'info+))

(eval-after-load "help"
  '(progn
     (require 'help-macro+)
     (require 'help-fns+)
     (require 'help+)
     (require 'help-mode+)))

(autoload 'ag/dwim-at-point "ag"
  "If there's an active selection, return that.
Otherwise, get the symbol at point.")

(defun my-info-apropos (str)
  (interactive (list (read-from-minibuffer "Search manuals for: " (ag/dwim-at-point))))
  (Info-index-entries-across-manuals str nil '("Elisp")))

(define-key help-map (kbd "I") 'my-info-apropos)

(eval-after-load "thingatpt"
  '(require 'thingatpt+))


(defun my-dired-back-to-top ()
  (interactive)
  (beginning-of-buffer)
  (dired-next-line 4))

(defun my-dired-jump-to-bottom ()
  (interactive)
  (end-of-buffer)
  (dired-next-line -1))

(autoload 'sr-dired-prev-subdir "sunrise-commander" "" t)

(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map [remap beginning-of-buffer] 'my-dired-back-to-top)
     (define-key dired-mode-map [remap end-of-buffer] 'my-dired-jump-to-bottom)
     (define-key dired-mode-map (kbd "C-<up>") 'sr-dired-prev-subdir)
     (require 'dired-x)
     (require 'dired+)))



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
;;                       ___ _            __  __
;;                      |_ _| |__  _   _ / _|/ _| ___ _ __
;;                       | || '_ \| | | | |_| |_ / _ \ '__|
;;                       | || |_) | |_| |  _|  _|  __/ |
;;                      |___|_.__/ \__,_|_| |_|  \___|_|
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ibuffer)

(defun ibuffer-end ()
  (interactive)
  (goto-char (point-max))
  (forward-line -1)
  (ibuffer-skip-properties '(ibuffer-summary ibuffer-filter-group-name) -1))

(defun ibuffer-beginning ()
  (interactive)
  (goto-char (point-min))
  (ibuffer-skip-properties '(ibuffer-title ibuffer-filter-group-name) 1))

;; Override - there was no simple way of changing the behavior to display diff
;; in another window.
(defun ibuffer-diff-with-file ()
  "View the differences between marked buffers and their associated files.
If no buffers are marked, use buffer at point.
This requires the external program \"diff\" to be in your `exec-path'."
  (interactive)
  (require 'diff)
  (let ((marked-bufs (ibuffer-get-marked-buffers)))
    (when (null marked-bufs)
      (setq marked-bufs (list (ibuffer-current-buffer t))))
    (with-current-buffer (get-buffer-create "*Ibuffer Diff*")
      (setq buffer-read-only nil)
      (buffer-disable-undo (current-buffer))
      (erase-buffer)
      (buffer-enable-undo (current-buffer))
      (diff-mode)
      (dolist (buf marked-bufs)
	(unless (buffer-live-p buf)
	  (error "Buffer %s has been killed" buf))
	(ibuffer-diff-buffer-with-file-1 buf))
      (setq buffer-read-only t)))
  (switch-to-buffer-other-window "*Ibuffer Diff*"))


;; (advice-add 'ibuffer-diff-with-file :before 'my-ibuffer-diff-with-file-advice)
;; (defun ad-ibuffer+find-file-noselect (&rest args)
;;   (message "ad-ibuffer+find-file-noselect: %s" args)
;;   (with-current-buffer "*Ibuffer*"
;;     (ibuffer-update nil)))

;; (advice-add 'find-file :after 'ad-ibuffer+find-file-noselect)
;; (advice-remove 'find-file 'ad-ibuffer+find-file-noselect)


(defun my-ibuffer-mode-hook ()
  "Customized/added in ibuffer-mode-hook custom option."
  ;; see also ibuffer-formats for columns config
  (define-key ibuffer-mode-map (kbd "M-f")    'ibuffer-jump-to-buffer) ; TODO: use HELM here!!
  (define-key ibuffer-mode-map (kbd "<down>") 'ibuffer-forward-line)
  (define-key ibuffer-mode-map (kbd "<up>")   'ibuffer-backward-line)

  ;; (define-key ibuffer-mode-map (kbd "C-/")    nil)
  (define-key ibuffer-mode-map (kbd "/")      'hydra-ibuffer-filters/body)
  (define-key ibuffer-mode-map (kbd "m")      'hydra-ibuffer-marking/ibuffer-mark-forward)
  (define-key ibuffer-mode-map (kbd ".")      'hydra-ibuffer-marking/body)
  (define-key ibuffer-mode-map (kbd "*")      'hydra-ibuffer-marking/body)

  (define-key ibuffer-mode-map (kbd "<insert>") 'ibuffer-mark-forward)

  (define-key ibuffer-mode-map [remap beginning-of-buffer] 'ibuffer-beginning)
  (define-key ibuffer-mode-map [remap end-of-buffer] 'ibuffer-end)

  (wrap-region-mode 0)                 ; made ibuffer filtering keys unavailable
  (hl-line-mode)                       ; TODO: change to more contrasting color
  )



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


(define-key ctl-x-map (kbd "b")     'helm-buffers-list)
(define-key ctl-x-map (kbd "M-b")   'ido-switch-buffer-other-window)

(defun my-switch-buffer-other-elscreen ()
  (interactive)
  (elscreen-create)
  (call-interactively 'helm-buffers-list))

(defun my-find-file-other-elscreen ()
  (interactive)
  (elscreen-create)
  (call-interactively 'helm-find-files))

;; (define-key ctl-x-map (kbd "C-M-b")   'my-switch-buffer-other-elscreen)
(define-key ctl-x-map (kbd "C-M-b")   'ibuffer-other-window)

;; (define-key ctl-x-map (kbd "C-M-f")   'my-find-file-other-elscreen)
(define-key ctl-x-map (kbd "C-M-f")   'ido-find-file-other-window)

(define-key ctl-x-map (kbd "f")   'helm-find-files)
;; previously: (define-key ctl-x-map (kbd "f")   'ido-find-file)

;; Use ibuffer rather than whatever Emacs uses by default...
(define-key ctl-x-map (kbd "C-b")   'ibuffer)


(global-set-key (kbd "M-x")      'helm-M-x)
;; (global-set-key (kbd "s-x")      'smex)
;; (global-set-key (kbd "M-X")      'smex-major-mode-commands)



(defun my-dirtree ()
  (interactive)
  (dirtree (f-dirname (buffer-file-name (current-buffer))) t))

(global-set-key (kbd "C-<f1>")   'neotree-toggle)
(global-set-key (kbd "C-M-<f1>") 'my-dirtree)
(global-set-key (kbd "C-<f2>")   'helm-recentf)



(global-set-key (kbd "<escape>")   'keyboard-quit)


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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; quickly opening buffers of some kind (for scribbling) with key bindings
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar my-openers (list))

(defmacro make-buffer-opener (name key ext path)
  (let*
      ((name (symbol-name name))
       (defun-name (intern (concat "my-new-" name "-buffer")))
       (mode-name (intern (concat name "-mode"))))
    `(progn
       (defun ,defun-name (&optional arg)
         (interactive "P")
         (let
             ((switcher (if (not arg) 'switch-to-buffer-other-window)))
           (funcall switcher ,(concat name "1" ext))
           (,mode-name)
           (cd ,path)))
       (define-key my-new-buffer-map ,key ',defun-name)
       (push '(,name .  ,defun-name) my-openers)
       nil)))

(defvar my-new-buffer-map (make-sparse-keymap))
(global-set-key (kbd "C-n") my-new-buffer-map)

;;                  type            key       file ext     default path
(make-buffer-opener text         (kbd "C-n")    ".txt"     "~/poligon/")
(make-buffer-opener sh           (kbd "C-s")    ".sh"      "~/poligon/")
(make-buffer-opener python       (kbd "C-p")    ".py"      "~/poligon/python/")
(make-buffer-opener livescript   (kbd "C-j")    ".ls"      "~/poligon/lscript/")
(make-buffer-opener org          (kbd "C-o")    ".org"     "~/todo/")
(make-buffer-opener artist       (kbd "C-a")    ".txt"     "~/poligon/")
(make-buffer-opener racket       (kbd "C-r")    ".rkt"     "~/poligon/rkt/")
(make-buffer-opener emacs-lisp   (kbd "C-l")    ".el"      "~/.emacs.d/config/")
(make-buffer-opener erlang       (kbd "C-o")    ".erl"     "~/poligon/")
(make-buffer-opener elixir       (kbd "C-x")    ".ex"      "~/poligon/")
(make-buffer-opener ocaml        (kbd "C-m")    ".ml"      "~/poligon/")
;; (make-buffer-opener ocaml        (kbd "C-m")    ".ml"      "~/poligon/")
;; (make-buffer-opener ocaml        (kbd "C-m")    ".ml"      "~/poligon/")




(defvar my-new-buffer-helm-source
  `((name       . "Buffer types")
    (candidates . ,my-openers)
    (action     . (lambda (candidate) (funcall candidate)))))

(defun my-new-buffer-helm ()
  (interactive)
  (helm :sources '(my-new-buffer-helm-source)))

(global-set-key (kbd "M-n") 'my-new-buffer-helm)

(provide 'my-generic-ui-config)
