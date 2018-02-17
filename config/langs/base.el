(use-package groovy-mode
  :config (add-hook 'groovy-mode-hook #'linum-mode)
  :mode "\\.groovy\\'")

(use-package fsharp-mode
  :config (add-hook 'fsharp-mode-hook #'linum-mode)
  :mode "\\.\\(fs\\|fsi\\|fsx\\)\\'")

(use-package livescript-mode
  :mode "\\.ls\\'"
  :interpreter "lsc")

(use-package json-mode
  :mode "\\.json\\'")

(use-package markdown-mode
  :mode "\\.\\(text\\|markdown\\|md\\)\\'")

(use-package yaml-mode
  :mode "\\.\\(yml\\|yaml\\)\\'")

(use-package lua-mode
  :mode "\\.lua$"
  :interpreter "lua")

(use-package haxe-mode
  :mode "\\.hx\\'")

(use-package tuareg                     ; OCaml mode
  :mode ("\\.\\(ml\\|mli\\)\\'" . tuareg-mode))

(use-package nginx-mode
  :mode ".*nginx.*\\.conf\\'")

;; (let ((re (rx  "/" (any "Cc") (any "Mm") "ake" (any "Ll") "ists" (optional ".txt") eos)))
;;   (string-match re "/CMakeLists.txt"))
(use-package cmake-mode
  :mode "/\\(?:[Cc][Mm]ake[Ll]ists\\(?:\\.txt\\)?\\)\\'")

(add-to-list 'auto-mode-alist '("Dockerfile\\'" . conf-mode))



(load-many
 "~/.emacs.d/config/langs/lang-utils.el"
 "~/.emacs.d/config/langs/el.el"
 "~/.emacs.d/config/langs/io.el"
 "~/.emacs.d/config/langs/rkt.el"
 "~/.emacs.d/config/langs/txr.el"
 "~/.emacs.d/config/langs/cl.el"
 "~/.emacs.d/config/langs/erl.el"
 "~/.emacs.d/config/langs/elixir.el"
 "~/.emacs.d/config/langs/prolog.el"
 ;; "~/.emacs.d/config/langs/j.el"
 "~/.emacs.d/config/langs/c.el"
 "~/.emacs.d/config/langs/clj.el"
 "~/.emacs.d/config/langs/html.el"
 "~/.emacs.d/config/langs/python.el"
 "~/.emacs.d/config/langs/nim.el")




;; SQL interactions mode
;;
;; (require 'sql-completion)
;; (setq sql-interactive-mode-hook
;;       (lambda ()
;;         (define-key sql-interactive-mode-map "\t" 'comint-dynamic-complete)
;;         (sql-mysql-completion-init)))

;; OpenDYLAN
;; (require 'dime)
;; (dime-setup '(dime-dylan dime-repl dime-compiler-notes-tree))
;; (setq dime-dylan-implementations
;;       '((opendylan ("/usr/local/bin/dswank")
;;                    :env ("OPEN_DYLAN_USER_REGISTRIES=/home/cji/portless/dylan/sources/registry/:/home/cji/poligon/hello-dylan/registry"))))

;; (require 'julia-mode)
;; (require 'coffee-mode)

;; (require 'js2-mode-autoloads)
;; (require 'nxml-mode)
;; (require 'rust-mode-autoloads)
;; (require 'smalltalk-mode)
;; (add-to-list 'auto-mode-alist '("\\.st\\'" . smalltalk-mode))
