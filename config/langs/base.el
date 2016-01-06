(require 'alchemist)                    ; Elixir REPL
(require 'elixir-mode)                  ;

(require 'coffee-mode)
(require 'livescript-mode)
(require 'haxe-mode)                    ;
(require 'io-mode)
(require 'js2-mode-autoloads)
(require 'json-mode)
(require 'nginx-mode)                   ;
(require 'nim-mode)                     ;
(require 'nxml-mode)                    ;
(require 'rust-mode-autoloads)
(require 'tuareg)                       ; OCaml mode and REPL
(require 'web-mode)                     ;

(load "txr-mode.el")

(defun load/expand (fname) (load (f-expand fname)))
(defun load-many (&rest file-list) (dolist (file file-list)
                                     (load/expand file)))

(load-many
 "~/.emacs.d/config/langs/lang-utils.el"
 "~/.emacs.d/config/langs/el.el"
 "~/.emacs.d/config/langs/rkt.el"
 "~/.emacs.d/config/langs/cl.el"
 "~/.emacs.d/config/langs/prolog.el"
 "~/.emacs.d/config/langs/j.el"
 )


(add-to-list 'auto-mode-alist '("Dockerfile\\'" . conf-mode))


(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'"  . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))


;; (require 'smalltalk-mode)
;; (add-to-list 'auto-mode-alist '("\\.st\\'" . smalltalk-mode))


(require 'lua-mode)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))


;;
;; HTML & Django templates mode
;;
(setq-default web-mode-engine "django")

;; The only problem with web-mode is that it stops highlighting the buffer after
;; any edit. I have no idea why could this be, given how little I know about
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

;; somehow flymake doesn't want to work
(delete '("\\.html?\\'" flymake-xml-init) flymake-allowed-file-name-masks)


(autoload
  'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))




;;
;; Erlang and Distel (Erlang shell integration) config
(require 'erlang)
(require 'distel)

(add-to-list 'auto-mode-alist '("\\.erl\\'" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.hrl\\'" . erlang-mode))
(add-to-list 'ac-modes 'erlang-mode)

(defun my-erlang-newline ()
  (interactive)
  (erlang-electric-newline)
  (erlang-indent-line))

(defun my-erlang-mode-hook ()
  (linum-mode t)
  (distel-setup))

(define-key erlang-mode-map (kbd "") 'my-erlang-newline)
(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)


(defun save-nginx-conf-hook ()
  (when (and nil (s-contains? "nginx" (buffer-file-name)))
    (deferred:$
      (deferred:process-shell "sudo" "nginx -s reload")
      (deferred:nextc it
        (lambda ()
          (message "Restarted nginx"))))))
;; (add-hook 'after-save-hook 'save-nginx-conf-hook)




;;
;; SQL interactions mode
;;
;; (require 'sql-completion)
;; (setq sql-interactive-mode-hook
;;       (lambda ()
;;         (define-key sql-interactive-mode-map "\t" 'comint-dynamic-complete)
;;         (sql-mysql-completion-init)))
;;
;;    OpenDYLAN
;; (require 'dime)
;; (dime-setup '(dime-dylan dime-repl dime-compiler-notes-tree))
;; (setq dime-dylan-implementations
;;       '((opendylan ("/usr/local/bin/dswank")
;;                    :env ("OPEN_DYLAN_USER_REGISTRIES=/home/cji/portless/dylan/sources/registry/:/home/cji/poligon/hello-dylan/registry"))))

;; Clojure & ClojureScript
;;
;; (require 'cider-autoloads)
;; (require 'clojure-mode-autoloads)
;; (add-hook 'clojure-mode-hook 'paredit-mode)
;; (put-clojure-indent 'om-transact 1)
;;
;; Julia mode does not provide autoloads at this point and I don't use it yet,
;; so importing it on emacs start is not jusifiable.
;; (require 'julia-mode)
