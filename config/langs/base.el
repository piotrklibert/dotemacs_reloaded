(require 'nim-mode)
(require 'elixir-mode)
(require 'nginx-mode)
(require 'tuareg) ;; OCaml
(require 'haxe-mode)
(require 'nxml-mode)
(require 'web-mode)

;;
;; HTML & Django templates mode
;;
(setq-default web-mode-engine "django")

;; The only problem with web-mode is that it stops highlighting the buffer after
;; any edit. I have no idea why could this be, given what little I know about
;; font-lock and friends...
(defun my-web-mode-hook ()
  (define-key web-mode-map (kbd "C-c C-s") 'web-mode-scan-buffer)
  (hs-minor-mode -1)
  (fci-mode -1))


(defun my-sgml-mode-hook ()
  (hs-minor-mode -1)
  (fci-mode -1)
  (auto-complete-mode t)
  (linum-mode 1))


(add-hook 'sgml-mode-hook 'my-sgml-mode-hook)
(add-to-list 'auto-mode-alist '("\\.html\\'" . sgml-mode))

(add-to-list 'auto-mode-alist '("Dockerfile\\'" . conf-mode))

;; somehow flymake doesn't want to work for me
(delete '("\\.html?\\'" flymake-xml-init) flymake-allowed-file-name-masks)





(require 'lua-mode)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))




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

(put 'font-lock-add-keywords 'lisp-indent-function 1)
(put 'indent/tag-for-modes 'lisp-indent-function 1)

(font-lock-add-keywords 'emacs-lisp-mode
  '(("eval-after-load" . font-lock-keyword-face)
    ("defstruct"       . font-lock-keyword-face)
    ("\bfunctionp?"    . font-lock-keyword-face)
    ("\bit\b"          . font-lock-builtin-face)))


;; no idea where or why I overriden default <return> function in isearch...
(define-key isearch-mode-map (kbd "<return>") 'isearch-exit)

(defun my-interactive-byte-compile ()
  (interactive)
  (byte-compile-file (buffer-file-name)))

(defun my-eval-last-sexp (arg)
  (interactive "P")
  (cond
   ((not arg) (call-interactively 'eval-last-sexp))
   ;; TODO: add ability for inserting result without pp via C-u C-u
   (t (call-interactively 'pp-eval-last-sexp))))


(defun my-elisp-mode-setup ()
  (paredit-mode 1)
  (local-set-key (kbd "C-M-d") 'duplicate-line-or-region)

  (define-key mode-specific-map (kbd "C-b") 'my-interactive-byte-compile)
  (define-key mode-specific-map (kbd "C-j") 'eval-print-last-sexp)
  (define-key mode-specific-map (kbd "C-f") 'find-function)

  (define-key
    paredit-mode-map (kbd "M-S-<left>")  'backward-word)
  (define-key paredit-mode-map (kbd "M-?")         'paredit-convolute-sexp)
  (define-key paredit-mode-map (kbd "M-S-<right>") 'forward-word)
  (define-key paredit-mode-map (kbd "C-c C-j")     'eval-print-last-sexp)
  (define-key paredit-mode-map (kbd "C-M-d")       'duplicate-line-or-region)

  (global-set-key [remap eval-last-sexp] 'my-eval-last-sexp)

  )


(require 'subr-x)
(defalias '-> 'thread-first)
(defalias '->> 'thread-last)


(add-hook 'emacs-lisp-mode-hook 'my-elisp-mode-setup)


;;
;; SQL interactions mode
;;
;; (require 'sql-completion)
;; (setq sql-interactive-mode-hook
;;       (lambda ()
;;         (define-key sql-interactive-mode-map "\t" 'comint-dynamic-complete)
;;         (sql-mysql-completion-init)))


;;
;; Markdown support
;;
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
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
(require 'erlang)
(require 'distel)

(add-to-list 'auto-mode-alist '("\\.erl\\'" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.hrl\\'" . erlang-mode))

(add-to-list 'ac-modes 'erlang-mode)

(defun my-erlang-newline ()
  (interactive)
  (erlang-electric-newline)
  (erlang-indent-line))

(define-key erlang-mode-map (kbd "") 'my-erlang-newline)

(defun my-erlang-mode-hook ()
  (linum-mode t)
  (distel-setup))

(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)


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
(require 'json-mode)

;; CoffeeScript
(require 'coffee-mode)

;;
;; LiveScript - requiring is enough. no need to add-to-list
;;
(require 'livescript-mode)


;; Scheme and Racket
;;
;; BTW, in Racket mode:
;; insert lambda char: C-M-y or C-c C-\
;; start geiser:       C-c C-z or C-c C-a
;;


(require 'scheme)

(defun indent/tag-for-modes (modes tags)
  (loop for tag in tags
        do (loop for mode in modes
                 do (put (car tag) mode (cdr tag)))))



(indent/tag-for-modes
    '(scheme-indent-function racket-indent-function)
  '((serve/servlet . 1)
    (~> . 1)
    (call-with-semaphore . 1)
    (response/full . 3)
    (with-semaphore . 1)))


(loop for mode in '(scheme-mode racket-mode)
      do (font-lock-add-keywords mode
           '(("prog1" . font-lock-keyword-face)
             )))

(defun my-scheme-hook ()
  (paredit-mode)
  (rainbow-mode 1)
  (undo-tree-mode)
  (hs-minor-mode)
  )

(add-hook 'scheme-mode-hook 'my-scheme-hook)

(require 'racket-mode)

;; Geiser config
;; (require 'geiser)
;; (setq geiser-active-implementations '(racket))
;; (setq geiser-racket-binary           (f-expand "~/portless/racket/racket/bin/racket"))
;; (setq geiser-mode-company-p t)          ; not sure if it's needed
;; (setq geiser-repl-company-p t)          ; not sure if it's needed
;; (add-hook 'geiser-repl-mode-hook 'my-geiser-repl-hook)
;; (defun my-geiser-repl-hook () (auto-complete-mode 1))


(defvar racket-file-exts '("\\.rkt\\'" "\\.rktd\\'"))

(defun my-sanitize-auto-modes-racket ()
  (setq auto-mode-alist
        (--remove  (string-match ".rkt" (car it)) auto-mode-alist))
  ;; add racket-mode to auto-mode-alist
  (loop for ext in racket-file-exts
        do (push `(,ext . racket-mode) auto-mode-alist)))

;; (assoc "\\.rkt\\'" auto-mode-alist)

;; geiser uses autoloads and sets auto-mode-alist then, so we need to change it
;; back when it happens
(eval-after-load "geiser-autoloads" '(my-sanitize-auto-modes-racket))
(eval-after-load "geiser"           '(my-sanitize-auto-modes-racket))
;; But even if Geiser never loads we still want racket-mode in auto-mode-alist,
;; so we set it right now too.
(my-sanitize-auto-modes-racket)


(defun my-racket-hook ()
  (paredit-mode))

(defun my-racket-repl-hook ()
  (paredit-mode)
  (define-key racket-repl-mode-map (kbd "C-w") my-wnd-keys))


(add-hook 'racket-mode-hook 'my-racket-hook)
(add-hook 'racket-mode-repl-hook 'my-racket-repl-hook)

(eval-after-load "paredit" '(define-key paredit-mode-map (kbd "M-[") 'paredit-wrap-square))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Smalltalk: but it's rather poor; need to see Shampoo
(require 'smalltalk-mode)
(push '("\\.st\\'" . smalltalk-mode)  auto-mode-alist)


(require 'io-mode)


(defun save-nginx-conf-hook ()
  (when (and nil (s-contains? "nginx" (buffer-file-name)))
    (deferred:$
      (deferred:process-shell "sudo" "nginx -s reload")
      (deferred:nextc it
        (lambda ()
          (message "Restarted nginx"))))))

;; (add-hook 'after-save-hook 'save-nginx-conf-hook)

;; (require 'dime)
;; (dime-setup '(dime-dylan dime-repl dime-compiler-notes-tree))
;; (setq dime-dylan-implementations
;;       '((opendylan ("/usr/local/bin/dswank")
;;                    :env ("OPEN_DYLAN_USER_REGISTRIES=/home/cji/portless/dylan/sources/registry/:/home/cji/poligon/hello-dylan/registry"))))

;; Clojure & ClojureScript
;; (require 'cider-autoloads)
;; (require 'clojure-mode-autoloads)
;; (add-hook 'clojure-mode-hook 'paredit-mode)
;; (put-clojure-indent 'om-transact 1)



(require 'prolog)
(defun flymake-prolog-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "swipl" (list "-q" "-t" "halt" "-s " local-file))))


(defun my-prolog-hook ()
  (require 'flymake)
  (make-local-variable 'flymake-allowed-file-name-masks)
  (make-local-variable 'flymake-err-line-patterns)
  (setq flymake-err-line-patterns
        '(("ERROR: (?\\(.*?\\):\\([0-9]+\\)" 1 2)
          ("Warning: (\\(.*\\):\\([0-9]+\\)" 1 2)))
  (setq flymake-allowed-file-name-masks '(("\\.pl\\'" flymake-prolog-init)))
  (flymake-mode 1))


(push '("\\.pl\\'" . prolog-mode)  auto-mode-alist)
(add-hook 'prolog-mode-hook 'my-prolog-hook)


(defun my-eshell-hook ()
  (define-key eshell-mode-map (kbd "C-v") 'eshell-kill-input)
  (define-key eshell-mode-map (kbd "<up>") 'previous-line)
  (define-key eshell-mode-map (kbd "<down>") 'next-line)
  (define-key eshell-mode-map [remap kill-whole-line] 'eshell-kill-input)
  )
(add-hook 'eshell-mode-hook 'my-eshell-hook)

;;
;;  COMMON LISP
;;
(setq inferior-lisp-program "/home/cji/ccl/lx86cl64")
(setq slime-contribs '(slime-fancy))
(require 'slime-autoloads)

(defun my-lisp-hook ()
  (interactive)
  (paredit-mode 1))

(add-hook 'lisp-mode-hook 'my-lisp-hook)
