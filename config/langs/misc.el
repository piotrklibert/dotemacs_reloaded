(require 'js2-mode-autoloads)
(require 'rust-mode-autoloads)


(add-to-list 'auto-mode-alist '("Dockerfile\\'" . conf-mode))


(use-package yaml-mode
  :mode (("\\.yaml\\'" . yaml-mode)
         ("\\.yml\\'" . yaml-mode))
  :hook (yaml-mode-hook . electric-pair-local-mode))

(defvar markdown-mode-map)
(use-package markdown-mode
  :mode "\\.\\(text\\|markdown\\|md\\)\\'"
  :bind (:map markdown-mode-map
         ("M-<left>" . backward-sexp)
         ("M-<right>" . forward-sexp)
         ("C-<left>" . left-word)
         ("C-<right>" . right-word)))

(use-package tidy       :commands (tidy-buffer))
(use-package js2-mode   :commands (js2-mode js2-minor-mode))
(use-package paredit    :commands (paredit-mode))
(use-package paredit-menu :after (paredit))


;; (let ((re (rx  "/" (any "Cc") (any "Mm") "ake" (any "Ll") "ists" (optional ".txt") eos))) (string-match re "/CMakeLists.txt"))
(use-package cmake-mode      :mode "/\\(?:[Cc][Mm]ake[Ll]ists\\(?:\\.txt\\)?\\)\\'")

(use-package clips-mode      :mode ("\\.clp\\'" . clips-mode))
(use-package crontab-mode    :mode ("\\.pl\\'" . crontab-mode))
(use-package fsharp-mode     :mode "\\.\\(fs\\|fsi\\|fsx\\)\\'")
(use-package gitconfig-mode  :mode ("\\.gitconfig\\'" . gitconfig-mode))
(use-package groovy-mode     :mode "\\.groovy\\'")
(use-package haxe-mode       :mode "\\.hx\\'")
(use-package json-mode       :mode "\\.json\\'")
(use-package julia-mode      :mode "\\.jl\\'")
(use-package less-css-mode   :mode ("\\.less\\'" . less-css-mode))
(use-package livescript-mode :mode "\\.ls\\'" :interpreter "lsc")
(use-package lua-mode        :mode "\\.lua$"  :interpreter "lua")
(use-package nginx-mode      :mode ".*nginx.*\\.conf\\'")
(use-package rst             :mode "\\.rst\\'")
(use-package rust-mode       :mode ("\\.rs\\'" . rust-mode))
(use-package smalltalk-mode  :mode ("\\.st\\'" . smalltalk-mode))
(use-package tuareg          :mode ("\\.\\(ml\\|mli\\)\\'" . tuareg-mode)) ; OCaml

;; SQL interactions mode
;; (require 'sql-completion)
;; (setq sql-interactive-mode-hook
;;       (lambda ()
;;         (define-key sql-interactive-mode-map "\t" 'comint-dynamic-complete)
;;         (sql-mysql-completion-init)))

;; OpenDYLAN
;; (require 'dime)
;; (dime-setup '(dime-dylan dime-repl dime-compiler-notes-tree))
;; (setq dime-dylan-implementations '((opendylan ("/usr/local/bin/dswank") :env ("OPEN_DYLAN_USER_REGISTRIES=/home/cji/portless/dylan/sources/registry/:/home/cji/poligon/hello-dylan/registry"))))
