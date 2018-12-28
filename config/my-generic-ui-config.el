(require 'generic-x)
(require 'avy-autoloads)
(require 'helm-autoloads)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Text scaling using Hydra; activated by C-c =
;;
(require 'hydra)
(require 'linum)

(defhydra hydra-zoom (global-map "C-c =")
  "zoom"
  ("+" text-scale-increase "in")
  ("=" text-scale-increase "in")
  ("-" text-scale-decrease "out")
  ("_" text-scale-decrease "out")
  ("0"
   (lambda ()
     (interactive)
     (text-scale-set 0)
     (when linum-mode
       (linum-mode -1)
       (linum-mode t)))
   "zero"))

(define-key mode-specific-map (kbd "+") 'hydra-zoom/text-scale-increase)
(define-key mode-specific-map (kbd "-") 'hydra-zoom/text-scale-decrease)

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

(require 'unbound-autoloads)
(require 'sunrise-autoloads)

(eval-after-load 'sunrise-commander
  '(progn
     (message "Loading Sunrise plugins...")
     (require 'sunrise-x-tree)
     (require 'sunrise-x-modeline)))

(require 'my-powerline-config)


(defadvice pop-to-mark-command (after recenter-after-pop activate)
  (recenter))



;; Frame TITLE (displayed on StumpWM mode-line (or on the title bar))
(setf frame-title-format
      '("Emacs - "
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
 ido-handle-duplicate-virtual-buffers    2
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
  (define-key ibuffer-mode-map [remap end-of-buffer] 'ibuffer-end)
  (hl-line-mode))



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

(define-key ctl-x-map (kbd "C-M-b")   'my-switch-buffer-other-elscreen)

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

(global-set-key (kbd "C-<f3>")   'sunrise)
(global-set-key (kbd "M-<f3>")   'sunrise-cd)

(global-set-key (kbd "<escape> <escape>")   'keyboard-quit)


(defun my-eshell-other-window (args)
  (interactive "P")
  (split-window-right)
  (windmove-right)
  (eshell))


(define-key mode-specific-map  (kbd "C-e") 'eshell)
(define-key mode-specific-map  (kbd "C-s") 'shell-here)
(define-key mode-specific-map  (kbd "M-e") 'my-eshell-other-window)

(defun my-shell-mode-hook ()
  (local-set-key (kbd "C-l") 'comint-clear-buffer))
(add-hook 'shell-mode-hook 'my-shell-mode-hook)

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
(make-buffer-opener org          (kbd "C-o")    ".org"     "~/todo/")
(make-buffer-opener text         (kbd "C-n")    ".txt"     "~/poligon/")
(make-buffer-opener artist       (kbd "C-a")    ".txt"     "~/poligon/")
(make-buffer-opener python       (kbd "C-p")    ".py"      "~/poligon/python/")
(make-buffer-opener racket       (kbd "C-r")    ".rkt"     "~/poligon/rkt/")
(make-buffer-opener livescript   (kbd "C-j")    ".ls"      "~/poligon/lscript/")
(make-buffer-opener emacs-lisp   (kbd "C-l")    ".el"      "~/.emacs.d/config/")
(make-buffer-opener erlang       (kbd "C-o")    ".erl"     "~/poligon/")
(make-buffer-opener elixir       (kbd "C-x")    ".ex"      "~/poligon/")
(make-buffer-opener ocaml        (kbd "C-m")    ".ml"      "~/poligon/")


(defvar my-new-buffer-helm-source `((name       . "Buffer types")
                                    (candidates . ,my-openers)
                                    (action     . (lambda (candidate) (funcall candidate)))))

(defun my-new-buffer-helm ()
  (interactive)
  (helm :sources '(my-new-buffer-helm-source)))

(global-set-key (kbd "M-n") 'my-new-buffer-helm)

(provide 'my-generic-ui-config)
