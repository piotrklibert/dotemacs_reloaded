(defun make-local-hook (&rest things)
  "Something somewhere calls this obsolete function; I couldn't
  find it by grepping the sources so I decided to mock it to get
  rid of annoying warnings.")

(require 'ido)
(require 'idomenu)
(require 'ido-vertical-mode)

(require 'helm)
(require 'helm-config)

(require 'direx)
(require 'generic-x)
(require 'smex)
(require 'sr-speedbar)
(require 'edmacro)
(require 'unbound)

(require 'sunrise-commander)
(require 'sunrise-x-tree)
(require 'sunrise-x-modeline)

(defun sr-y-n-or-a-p (prompt)
    "Ask the user with PROMPT for an answer y/n/a ('a' stands for 'always').
Returns t if the answer is y/Y, nil if the answer is n/N or the
symbol `ALWAYS' if the answer is a/A."
    (setq prompt (concat prompt "([y]es/<return>, [n]o or [a]lways)"))
    (let ((resp -1))
      (while (not (memq resp '(?y ?Y ?n ?N ?a ?A 10 return)))
        (setq resp (read-event prompt))
        (setq prompt "Please answer [y]es/<return>, [n]o or [a]lways "))
      (if (and (numberp resp) (>= resp 97))
          (setq resp (- resp 32)))
      (case resp
        (?Y t)
        (10 t)
        ('return t)
        (?A 'ALWAYS)
        (t nil))))

(define-key dired-mode-map (kbd "C-<up>") 'sr-dired-prev-subdir)

;; Whenever a file that Emacs is editing has been changed by another
;; program the user normally has to execute the command `revert-buffer'
;; to load the new content of the file into Emacs.
(require 'autorevert)                   ; customize-group available


(global-auto-revert-mode 1)
(global-auto-composition-mode -1)       ; for entering strange chars, not needed
(mouse-avoidance-mode 'exile)           ; should move mouse away from point
(auto-compression-mode 1)               ; transparent editing of compressed files
(file-name-shadow-mode 1)               ; no idea :)
(savehist-mode 1)                       ; save the minibuffer history on exit


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


;; Smex - built on top of IDo M-x replacement.
;; http://www.emacswiki.org/emacs/Smex
(setq smex-save-file (concat user-emacs-directory "data/smex-items")
      smex-history-length 100)
(smex-initialize)

(setq helm-M-x-fuzzy-match t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            ____  _ _
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
  (define-key ibuffer-mode-map [remap end-of-buffer] 'ibuffer-end))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;               ____ ___ _   _ ____ ___ _   _  ____ ____                      ;
;;              | __ )_ _| \ | |  _ \_ _| \ | |/ ___/ ___|                     ;
;;              |  _ \| ||  \| | | | | ||  \| | |  _\___ \                     ;
;;              | |_) | || |\  | |_| | || |\  | |_| |___) |                    ;
;;              |____/___|_| \_|____/___|_| \_|\____|____/                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define-key my-bookmarks-keys (kbd "C-b") 'bookmark-set)
(define-key my-bookmarks-keys (kbd "C-l") 'helm-bookmarks)
(define-key my-bookmarks-keys (kbd "C-t") 'bm-toggle)

;; Use iDo for fast buffer switching
(define-key ctl-x-map (kbd "b")     'ido-switch-buffer)
(define-key ctl-x-map (kbd "M-b")   'ido-switch-buffer-other-window)

;; Use ibuffer rather than whatever Emacs uses by default...
(define-key ctl-x-map (kbd "C-b")   'ibuffer)

;; There are some alternatives to ibuffer, I'm currently testing helm
;; (define-key ctl-x-map (kbd "C-M-b") 'bs-show)
;; (define-key ctl-x-map (kbd "C-M-b") 'electric-buffer-listw)
(define-key ctl-x-map (kbd "C-M-b") 'helm-buffers-list)

(global-set-key (kbd "M-X")      'smex-major-mode-commands)
(global-set-key (kbd "M-x")      'smex)
(global-set-key (kbd "s-x")      'helm-M-x)

(global-set-key (kbd "C-<f1>")   'sr-speedbar-toggle)
(global-set-key (kbd "C-<f2>")   'helm-recentf)

(global-set-key (kbd "C-<f3>")   'sunrise)
(global-set-key (kbd "M-<f3>")   'sunrise-cd)


(defun my-eshell-other-window (args)
  (interactive "P")
  (split-window-right)
  (windmove-right)
  (eshell))



(define-key mode-specific-map  (kbd "C-e") 'eshell)
(define-key mode-specific-map  (kbd "M-e") 'my-eshell-other-window)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; quickly opening buffers of some kind (for scribbling) with key binds
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

;;                   type            key       file ext     default path
(make-buffer-opener text         (kbd "C-n")    ".txt"     "~/todo/")
(make-buffer-opener org          (kbd "C-o")    ".org"     "~/todo/")
(make-buffer-opener python       (kbd "C-p")    ".py"      "~/poligon/python/")
(make-buffer-opener emacs-lisp   (kbd "C-l")    ".el"      "~/.emacs.d/")
(make-buffer-opener artist       (kbd "C-a")    ".art.txt" "~/poligon/")
(make-buffer-opener livescript   (kbd "C-j")    ".ls"      "~/poligon/lscript/")


(setq my-new-buffer-helm-source
      `((name . "Byffer types")
        (candidates . ,my-openers)
        (action . (lambda (candidate) (funcall candidate)))))

(defun my-new-buffer-helm ()
  (interactive)
  (helm :sources '(my-new-buffer-helm-source)))

(global-set-key (kbd "M-n") 'my-new-buffer-helm)
