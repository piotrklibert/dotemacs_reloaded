(require 'elixir-mode)
(require 'alchemist)                    ; Elixir REPL

(require 'nim-mode)
(require 'nginx-mode)
(require 'tuareg)                       ; OCaml mode and REPL
(require 'haxe-mode)

(require 'nxml-mode)
(require 'web-mode)


(defun load/expand (fname)
  (load (f-expand fname)))

(defun load-many (&rest file-list)
  (dolist (file file-list)
    (load/expand file)))

(load-many  "~/.emacs.d/config/langs/el.el"
            "~/.emacs.d/config/langs/rkt.el"
            "~/.emacs.d/config/langs/cl.el")

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
