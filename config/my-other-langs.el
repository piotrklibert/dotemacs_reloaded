;;
;; Django templates mode
;;

;; Alternative (does not work very well):
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(setq-default  web-mode-engine "django")
(add-hook 'web-mode-hook (lambda ()
                           (define-key web-mode-map (kbd "C-c C-s") 'web-mode-scan-buffer)
                           (electric-pair-mode -10)
                           (hs-minor-mode -1)))

;; (add-to-list 'load-path "path-to/django-mode/")
;; (require 'django-html-mode)
;; ;; (yas/load-directory "path-to/django-mode/snippets")
;; (add-to-list 'auto-mode-alist '("\\.html$" . django-html-mode))

;; MUCH too slow/quirky.
;; https://answers.launchpad.net/nxhtml/+question/225782
;; (load "~/.emacs.d/pkg-langs/nxhtml/autostart.el")
;; (eval-after-load 'nxhtml
;;   '(nxhtml-toggle-visible-warnings))
;; (setq mumamo-background-colors nil)
;; (setq auto-mode-alist
;;       (append '(("\\.html?$" . django-html-mumamo-mode)) auto-mode-alist))
;; (add-to-list 'auto-mode-alist '("\\.html$" . django-html-mumamo-mode))


;;
;; Emacs Lisp mode tweaks
;;
(require 'paredit-autoloads)

(global-set-key (kbd "C-c C-f")        'find-function)
(defun my-elisp-mode-setup ()
  (paredit-mode 1)
  (local-set-key (kbd "C-M-d") 'duplicate-line)
  (local-set-key (kbd "C-c C-b") (lambda ()
                                   (interactive)
                                   (byte-compile-file (buffer-file-name))))
  (local-set-key (kbd "C-c C-j") 'eval-print-last-sexp)
  (define-key paredit-mode-map (kbd "M-S-<left>") 'backward-word)
  (define-key paredit-mode-map (kbd "M-S-<right>") 'forward-word)
  (define-key paredit-mode-map (kbd "C-c C-j") 'eval-print-last-sexp)
  (define-key paredit-mode-map (kbd "C-M-d") 'duplicate-line))

(add-hook 'emacs-lisp-mode-hook 'my-elisp-mode-setup)




;; TODO: make it better or use a plugin (auto-compile elisp)
;; (add-hook 'after-save-hook
;;  (lambda ()
;;    (message (buffer-file-name))
;;    (when (s-ends-with-p ".el" (buffer-file-name))
;;      (let
;;          ((font-lock-verbose nil)
;;           (byte-compile-verbose nil))
;;        (byte-compile-file (buffer-file-name) t)
;;        (run-at-time 0.3 nil
;;                     (lambda ()
;;                       (delete-window
;;                        (get-buffer-window
;;                         (get-buffer "*Compile-Log*")))))))))


;;
;; SQL interactions mode
;;
(require 'sql-completion)
(setq sql-interactive-mode-hook
      (lambda ()
        (define-key sql-interactive-mode-map "\t" 'comint-dynamic-complete)
        (sql-mysql-completion-init)))

;;
;; Markdown support
;;
(autoload
  'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))


;; Julia mode does not provide autoloads at this point and I don't use it yet,
;; so importing it on emacs start is not jusifiable.
;; (require 'julia-mode)

(require 'rust-mode-autoloads)


;;
;; Erlang and Distel (Erlang shell integration) config
;;
;; (require 'erlang-start)
(require 'erlang-autoloads)

(add-to-list 'auto-mode-alist '("\\.erl\\'" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.hrl\\'" . erlang-mode))

(add-to-list 'ac-modes 'erlang-mode)

(add-hook 'erlang-mode-hook
          (lambda ()
            (require 'distel)
            (distel-setup)))


;;
;; YAML mode
;;
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))


;;
;; JavaScript mode
;;
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; js2-mode refuses to work with autopair-mode, so we need to switch it off
;; (add-hook 'js2-mode-hook (lambda ()
;;                            (autopair-mode -1)))


;;
;; Racket and Geiser (Racket shell integration) config
;;
(require 'quack)  ; better syntax highlighting

(defun my-set-ctrl-meta-l ()
  (local-set-key (kbd "C-M-l") (lambda ()
                                  (interactive)
                                  (ucs-insert #x3BB))))

(add-hook 'racket-mode-hook 'my-set-ctrl-meta-l)

(if-bsd
 (setq geiser-racket-binary "/usr/local/bin/racket"))

;; TODO:
;; use company to auto-complete bridge to get autocompletions in geiser
;; ac-company.el
(setq
 geiser-mode-company-p nil
 geiser-repl-company-p nil)

(setq geiser-eval--get-module-function       'geiser-racket--get-module)
(setq geiser-eval--get-impl-module           'geiser-racket--get-module)
(setq geiser-eval--geiser-procedure-function 'geiser-racket--geiser-procedure)

;; Make Geiser use Racket as a default REPL
(setq geiser-active-implementations '(racket))
