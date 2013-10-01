;;   ____ ___  __  __ ____  _     _____ _____ _____ ____  ____
;;  / ___/ _ \|  \/  |  _ \| |   | ____|_   _| ____|  _ \/ ___|
;; | |  | | | | |\/| | |_) | |   |  _|   | | |  _| | |_) \___ \
;; | |__| |_| | |  | |  __/| |___| |___  | | | |___|  _ < ___) |
;;  \____\___/|_|  |_|_|   |_____|_____| |_| |_____|_| \_\____/
;;
;;
;; TODO:
;; 2* integrate hippie with auto-complete - it's a very nice completion engine
;; 3* instead of geiser completion below use company<->auto-complete layer
;; 4* carefully check where which completion is active (config of auto-complete)
;;
(require 'auto-complete)
(require 'auto-complete-config)
(require 'readline-complete)
(require 'hippie-exp)
(require 'yasnippet)



;; Keys bound here:
(global-set-key (kbd "C-c .") 'hippie-expand)
(global-set-key (kbd "C-c /") 'yas-expand)
;; and auto-complete binds to <tab>


(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(add-to-list 'ac-sources 'ac-source-semantic)

;;
;; YASnippet completions config
;;

;; NOTE: my version of yasnippet (from git) had to be gutted of TAB bindings
(yas-load-directory "~/.emacs.d/plugins2/yasnippet/snippets")
(setq yas-snippet-dirs
      (remove-if (lambda (x)
                   (string= x "~/.emacs.d/snippets"))
                 yas-snippet-dirs))

(yas-global-mode 1)
;; (add-to-list 'ac-sources 'ac-source-semantic)

;; for future auto-complete source using yasnippet
(defun list-yas-templates () (let ((m (if (eq major-mode 'lisp-interaction-mode) 'emacs-lisp-mode major-mode)) (h yas--tables)) (yas--table-all-keys (gethash m h))))



;;
;; Completion for Racket, must have working Racket interpreter started.
;;
(defun check-geiser-completion ()
  (setq geiser-eval--get-module-function       'geiser-racket--get-module)
  (setq geiser-eval--get-impl-module           'geiser-racket--get-module)
  (setq geiser-eval--geiser-procedure-function 'geiser-racket--geiser-procedure)
  (geiser-eval--send/result `(:eval (:ge completions ,ac-prefix))
                            1000
                            (current-buffer)))

(ac-define-source "geiser"
  '((candidates . check-geiser-completion)))

;; Doesn't work at the moment. (because of newer geiser version)
;;
;; (add-hook 'scheme-mode-hook
;;           (lambda ()
;;             (add-to-list 'ac-sources
;;                          ac-source-geiser)))




;;
;; Completions with built-in hippie-expand
;;
;; FIXME: not working right now!
;;
(defun check-hippie-completion ()
  (let
      ((this-command 'my-hippie-expand-completions)
       (last-command last-command)
       (buffer-modified (buffer-modified-p))
       (hippie-expand-function 'hippie-expand))
    (cl-letf ((ding))
      (while (progn
               (funcall hippie-expand-function nil)
               (setq last-command 'my-hippie-expand-completions)
               (not (equal he-num -1)))))
    (set-buffer-modified-p buffer-modified) ; restore buffer state
    (delete he-search-string (reverse he-tried-table))))

(ac-define-source "hippie"
  '((candidates . check-hippie-completion)))
;; disabled for now
;; (add-to-list 'ac-sources ac-source-hippie)

(defun check-py-shell-completion ()
  (let* ((pos (copy-marker (point)))
         (beg (save-excursion (skip-chars-backward "a-zA-Z0-9_.('") (point)))
         (end (point))
         (word (buffer-substring-no-properties beg end))
         (shell (py-choose-shell))
         my-completions)
    (flet ((py-shell-complete-finally () (setq my-completions completions)))
      (py-shell-complete-intern word beg end shell '()  (or (get-process shell)
                                                        (get-buffer-process (py-shell nil nil shell nil t))))
      my-completions)))

(ac-define-source "py-shell"
  '((candidates . check-py-shell-completion)))


(defun my-setup-py-shell ()
  (add-to-list 'ac-sources ac-source-py-shell)
  (auto-complete-mode 1))

(add-hook 'py-shell-hook 'my-setup-py-shell)
