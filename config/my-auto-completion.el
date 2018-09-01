;;   ____ ___  __  __ ____  _     _____ _____ _____ ____  ____
;;  / ___/ _ \|  \/  |  _ \| |   | ____|_   _| ____|  _ \/ ___|
;; | |  | | | | |\/| | |_) | |   |  _|   | | |  _| | |_) \___ \
;; | |__| |_| | |  | |  __/| |___| |___  | | | |___|  _ < ___) |
;;  \____\___/|_|  |_|_|   |_____|_____| |_| |_____|_| \_\____/
;;
;;
;; TODO: hippie, company
;; 2* integrate hippie with auto-complete - it's a very nice completion engine
;; 4* carefully check where which completion is active (config of auto-complete)
;;
;; use-package auto-complete
;; :commands ac-start auto-complete-mode global-auto-complete-mode
;; :config

(require 'auto-complete)
(require 'auto-complete-config)
(require 'ac-company)
(ac-config-default)

(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict/")
(add-to-list 'ac-modes 'io-mode)

(let*
    ((last-sources '(ac-source-semantic ac-source-yasnippet))
     (start-sources '(ac-source-filename))
     (default-sources (-distinct (append start-sources
                                         ac-sources
                                         last-sources))))
  (setq-default ac-sources default-sources))

(define-key popup-menu-keymap (kbd "<return>") 'popup-select)

(when (boundp 'ac-completing-map)
  ;; elpy modifies (rightly) ac-completing-map so that <return> inserts newline;
  ;; but this makes ac-complete unavailable, so here it is remapped
  (define-key ac-completing-map (kbd "C-<return>") 'ac-complete))


;(require 'readline-complete)
(require 'yasnippet)
;; most snippets for YAS are here:
;; " ~/.emacs.d/forked-plugins/yasnippet/snippets"
(yas-global-mode 1)


(require 'hippie-exp)

;; Keys bound here:
;; (global-set-key (kbd "C-c /") 'yas-expand)
(define-key global-map (kbd "C-c .")   'hippie-expand)
(define-key global-map (kbd "C-<tab>") 'ac-start)
(define-key global-map (kbd "C-M-/")   'helm-dabbrev)

;; by default:
;; (global-set-key (kbd "M-/") 'dabbrev-expand)
;; also auto-complete binds to <tab>

(eval-after-load "slime"
  '(progn
     (require 'ac-slime)
     (add-hook 'slime-mode-hook 'set-up-slime-ac)
     (add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
     (eval-after-load "auto-complete"
       '(add-to-list 'ac-modes 'slime-repl-mode)))  )

;;
;; YASnippet completions config
;;

;; NOTE: my version of yasnippet (from git) had to be gutted of TAB bindings
;; (yas-load-directory "~/.emacs.d/forked-plugins/yasnippet/snippets")
;; (setq yas-snippet-dirs
;;       (remove-if (lambda (x)
;;                    (string= x "~/.emacs.d/snippets"))
;;                  yas-snippet-dirs))




;;       ____      _    ____ _  _______ _____   __  __  ___  ____  _____
;;      |  _ \    / \  / ___| |/ / ____|_   _| |  \/  |/ _ \|  _ \| ____|
;;      | |_) |  / _ \| |   | ' /|  _|   | |   | |\/| | | | | | | |  _|
;;      |  _ <  / ___ \ |___| . \| |___  | |   | |  | | |_| | |_| | |___
;;      |_| \_\/_/   \_\____|_|\_\_____| |_|   |_|  |_|\___/|____/|_____|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'ac-geiser)
;; (add-hook 'geiser-mode-hook 'ac-geiser-setup)
;; (add-hook 'geiser-repl-mode-hook 'ac-geiser-setup)
;; (add-to-list 'ac-modes 'geiser-repl-mode)



;;          _    ____ __   __   ____ ___  __  __ ____   _    _   ___   __
;;         / \  / ___/ /   \ \ / ___/ _ \|  \/  |  _ \ / \  | \ | \ \ / /
;;        / _ \| |  / /_____\ \ |  | | | | |\/| | |_) / _ \ |  \| |\ V /
;;       / ___ \ |__\ \_____/ / |__| |_| | |  | |  __/ ___ \| |\  | | |
;;      /_/   \_\____\_\   /_/ \____\___/|_|  |_|_| /_/   \_\_| \_| |_|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; (ac-company-define-source ac-source-company-elisp company-elisp)
;; (add-hook 'emacs-lisp-mode-hook
;;        (lambda ()
;;          (add-to-list 'ac-sources 'ac-source-company-elisp)))
;;
;; You can overrides attributes. For example, if you want to add
;; symbol to ac-source-company-elisp, put following:
;;
;; (ac-company-define-source ac-source-company-elisp company-elisp
;;                           (symbol . "s"))


;;                       _   _ ___ ____  ____ ___ _____
;;                      | | | |_ _|  _ \|  _ \_ _| ____|
;;                      | |_| || || |_) | |_) | ||  _|
;;                      |  _  || ||  __/|  __/| || |___
;;                      |_| |_|___|_|   |_|  |___|_____|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; TODO: make it work or check if it's not provided with ac by default
;; (defun check-hippie-completion ()
;;   (let
;;       ((this-command 'my-hippie-expand-completions)
;;        (last-command last-command)
;;        (buffer-modified (buffer-modified-p))
;;        (hippie-expand-function 'hippie-expand))
;;     (cl-letf ((ding))
;;       (while (progn
;;                (funcall hippie-expand-function nil)
;;                (setq last-command 'my-hippie-expand-completions)
;;                (not (equal he-num -1)))))
;;     (set-buffer-modified-p buffer-modified) ; restore buffer state
;;     (delete he-search-string (reverse he-tried-table))))

;; (ac-define-source "hippie"
;;   '((candidates . check-hippie-completion)))
;; (add-to-list 'ac-sources ac-source-hippie)



;;       ______   _______ _   _  ___  _   _   __  __  ___  ____  _____
;;      |  _ \ \ / /_   _| | | |/ _ \| \ | | |  \/  |/ _ \|  _ \| ____|
;;      | |_) \ V /  | | | |_| | | | |  \| | | |\/| | | | | | | |  _|
;;      |  __/ | |   | | |  _  | |_| | |\  | | |  | | |_| | |_| | |___
;;      |_|    |_|   |_| |_| |_|\___/|_| \_| |_|  |_|\___/|____/|_____|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (defun check-py-shell-completion ()
;;   (let* ((pos (copy-marker (point)))
;;          (beg (save-excursion (skip-chars-backward "a-zA-Z0-9_.('") (point)))
;;          (end (point))
;;          (word (buffer-substring-no-properties beg end))
;;          (shell (py-choose-shell))
;;          my-completions)
;;     (flet ((py-shell-complete-finally () (setq my-completions completions)))
;;       (py-shell-complete-intern word beg end shell '()  (or (get-process shell)
;;                                                         (get-buffer-process (py-shell nil nil shell nil t))))
;;       my-completions)))

;; (ac-define-source "py-shell"
;;   '((candidates . check-py-shell-completion)))

;; (defun my-setup-py-shell ()
;;   (add-to-list 'ac-sources ac-source-py-shell)
;;   (auto-complete-mode 1))

;; (add-hook 'py-shell-hook 'my-setup-py-shell)
