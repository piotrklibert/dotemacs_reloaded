;;   ____ ___  __  __ ____  _     _____ _____ _____ ____  ____
;;  / ___/ _ \|  \/  |  _ \| |   | ____|_   _| ____|  _ \/ ___|
;; | |  | | | | |\/| | |_) | |   |  _|   | | |  _| | |_) \___ \
;; | |__| |_| | |  | |  __/| |___| |___  | | | |___|  _ < ___) |
;;  \____\___/|_|  |_|_|   |_____|_____| |_| |_____|_| \_\____/
;;
;;
;; 2* integrate hippie with auto-complete - it's a very nice completion engine
;; 4* carefully check where which completion is active (config of auto-complete)
;; make TAB work sensibly (write down the ideas on how it should work)

;; (require 'auto-complete)
;; (require 'auto-complete-config)


(require 'company)


(require 'yasnippet)
(require 'hippie-exp)
(require 'readline-complete)

(add-hook 'company-completion-started-hook
          (function (lambda (&optional arg)
                      (fci-mode -1))))


(add-hook 'company-completion-finished-hook
          (function (lambda (&optional arg)
                      (fci-mode 1))))


(let ((backends '(company-files (company-capf :with company-dabbrev-code company-keywords company-yasnippet))))
 (make-variable-buffer-local 'company-backends)
 (setq-default company-backends backends)
 (setq company-backends backends))



;; ~/.emacs.d/custom.el



;; Keys bound here:
(global-set-key (kbd "C-c .") 'hippie-expand)
(global-set-key (kbd "C-c /") 'yas-expand)
;; by default:
;; (global-set-key (kbd "M-/") 'dabbrev-expand)
;; also auto-complete binds to <tab>


;; (ac-config-default)
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
;; (add-to-list 'ac-sources 'ac-source-semantic)

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

;;       ____      _    ____ _  _______ _____   __  __  ___  ____  _____
;;      |  _ \    / \  / ___| |/ / ____|_   _| |  \/  |/ _ \|  _ \| ____|
;;      | |_) |  / _ \| |   | ' /|  _|   | |   | |\/| | | | | | | |  _|
;;      |  _ <  / ___ \ |___| . \| |___  | |   | |  | | |_| | |_| | |___
;;      |_| \_\/_/   \_\____|_|\_\_____| |_|   |_|  |_|\___/|____/|_____|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ac-geiser)
(add-hook 'geiser-mode-hook 'ac-geiser-setup)
(add-hook 'geiser-repl-mode-hook 'ac-geiser-setup)
(add-to-list 'ac-modes 'geiser-repl-mode)



;;          _    ____ __   __   ____ ___  __  __ ____   _    _   ___   __
;;         / \  / ___/ /   \ \ / ___/ _ \|  \/  |  _ \ / \  | \ | \ \ / /
;;        / _ \| |  / /_____\ \ |  | | | | |\/| | |_) / _ \ |  \| |\ V /
;;       / ___ \ |__\ \_____/ / |__| |_| | |  | |  __/ ___ \| |\  | | |
;;      /_/   \_\____\_\   /_/ \____\___/|_|  |_|_| /_/   \_\_| \_| |_|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (require 'ac-company)
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




;; (company-yasnippet company-readline company-bbdb company-nxml company-css
;;                    company-eclim company-semantic company-clang company-xcode
;;                    company-ropemacs company-cmake company-capf
;;                    (company-dabbrev-code company-gtags company-etags company-keywords)
;;                    company-oddmuse company-files company-dabbrev)
