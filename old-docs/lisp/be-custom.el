
(when (or noninteractive
          (equalp (getenv "USER") nil)) ; ie. inside Docker
  ;; Switch from default to theme-ified in default font faces (fg/bg colors)
  (load-theme 'wombat t)
  (custom-set-variables
   '(enable-local-variables :all)
   '(delete-auto-save-files t)
   '(delete-old-versions 'other)
   '(eval-expression-print-length nil)
   '(org-babel-js-cmd "/usr/local/bin/node")
   '(org-babel-load-languages '((emacs-lisp . t) (python . t) (js . t) (shell . t)))
   '(org-babel-noweb-wrap-end ">=")
   '(org-babel-noweb-wrap-start "=<")
   '(org-babel-process-comment-text 'org-remove-indentation nil nil "smc")
   '(org-babel-shell-names '("sh" "bash" "csh" "ash" "dash" "ksh" "mksh" "posh" "zsh"))
   '(org-babel-tangle-uncomment-comments t)
   '(org-confirm-babel-evaluate nil)
   '(org-default-notes-file "~/todo/notes")
   '(org-emphasis-alist
     '(("*" bold                "<b>" "</b>")
       ("/" italic              "<i>" "</i>")
       ("_" underline           "<span style=\"text-decoration:underline;\">" "</span>")
       ("=" org-code            "<code>" "</code>" verbatim)
       ("`" org-code            "<code>" "</code>" verbatim)
       ("~" org-verbatim        "<code>" "</code>" verbatim)
       ("+" (:strike-through t) "<del>" "</del>")))
   '(org-export-coding-system 'utf-8)
   '(org-export-use-babel t)
   '(org-html-htmlize-font-prefix "")
   '(org-html-htmlize-output-type 'inline-css)
   '(org-html-keep-old-src t)
   '(org-html-postamble t)
   '(org-html-postamble-format
     '(("en" "<p class=\"author\">Author: %a (%e)</p>
            <p class=\"date\">Last updated: %C</p>
            <p class=\"copyright\">© Trust Stamp 2018</p>")))
   '(org-modules '())
   '(org-src-fontify-natively t)
   '(org-src-lang-modes
     '(("bash" . sh)
       ("elisp" . emacs-lisp)
       ("shell" . sh)
       ("html" . web)))
   '(org-use-sub-superscripts nil)
   '(scroll-conservatively 100)
   '(shell-file-name "/bin/bash")
   '(version-control nil)))

(provide 'be-custom)
