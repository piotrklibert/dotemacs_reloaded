(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu 0.3)
 '(ac-comphist-file "~/.emacs.d/data/ac-comphist.dat")
 '(ac-disable-faces nil)
 '(ac-modes
   '(elixir-mode erlang-mode emacs-lisp-mode lisp-interaction-mode c-mode cc-mode c++-mode java-mode clojure-mode scala-mode scheme-mode coffee-mode ocaml-mode tuareg-mode perl-mode cperl-mode python-mode ruby-mode ecmascript-mode livescript-mode javascript-mode js-mode js2-mode php-mode css-mode makefile-mode sh-mode fortran-mode f90-mode ada-mode xml-mode sgml-mode racket-mode geiser-repl-mode elixir-mode2 lisp-mode slime-repl-mode scala-mode txr-mode racket-mode groovy-mode))
 '(ac-quick-help-delay 0.4)
 '(ac-quick-help-prefer-pos-tip t)
 '(ag-highlight-search t)
 '(ag-reuse-buffers t)
 '(auto-hscroll-mode 'current-line)
 '(auto-indent-backward-delete-char-behavior 'untabify)
 '(auto-indent-blank-lines-on-move nil)
 '(auto-mark-ignore-move-on-sameline nil)
 '(auto-revert-interval 2)
 '(auto-revert-mode-text " AR")
 '(auto-revert-verbose nil)
 '(auto-save-file-name-transforms '(("\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'" "/tmp/\\2" t)))
 '(auto-save-no-message t)
 '(auto-save-visited-file-name nil)
 '(avy-background t)
 '(avy-highlight-first t)
 '(avy-timeout-seconds 0.3)
 '(aw-ignored-buffers '("*Calc Trail*" "*LV*" "*elscreen-tabs*"))
 '(aw-keys '(102 100 115 104 106 107 97 108))
 '(backup-by-copying t)
 '(backup-by-copying-when-linked nil)
 '(backup-directory-alist '(("." . "~/.emacs.d/backups")))
 '(blink-cursor-mode nil)
 '(blink-matching-paren-distance nil)
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(bookmark-default-file "~/.emacs.d/data/bookmarks")
 '(browse-url-browser-function 'browse-url-firefox)
 '(calendar-date-style 'european)
 '(calendar-week-start-day 1)
 '(cider-inspector-page-size 50)
 '(cider-pprint-fn 'pprint)
 '(cider-preferred-build-tool "lein")
 '(cider-prompt-for-symbol nil)
 '(cider-repl-use-pretty-printing t)
 '(coffee-tab-width 4)
 '(column-highlight-mode nil)
 '(column-number-mode t)
 '(comint-process-echoes t)
 '(comint-prompt-read-only t)
 '(company-backends
   '(company-files
     (company-capf :with company-dabbrev company-dabbrev-code company-keywords company-yasnippet)))
 '(company-dabbrev-code-everywhere t)
 '(company-dabbrev-downcase nil)
 '(company-dabbrev-ignore-case nil)
 '(company-idle-delay t)
 '(company-minimum-prefix-length 2)
 '(company-tooltip-align-annotations t)
 '(company-transformers '(company-sort-by-backend-importance))
 '(completion-ignored-extensions
   '(".o" "~" ".bin" ".lbin" ".so" ".a" ".ln" ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".svn/" ".hg/" ".git/" ".bzr/" "CVS/" "_darcs/" "_MTN/" ".fmt" ".tfm" ".class" ".fas" ".lib" ".mem" ".x86f" ".sparcf" ".dfsl" ".pfsl" ".d64fsl" ".p64fsl" ".lx64fsl" ".lx32fsl" ".dx64fsl" ".dx32fsl" ".fx64fsl" ".fx32fsl" ".sx64fsl" ".sx32fsl" ".wx64fsl" ".wx32fsl" ".fasl" ".ufsl" ".fsl" ".dxl" ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".cp" ".fn" ".ky" ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo"))
 '(completion-styles '(basic partial-completion emacs22 flex substring))
 '(css-indent-offset 4)
 '(debug-on-error nil)
 '(debug-on-quit nil)
 '(delete-auto-save-files t)
 '(delete-old-versions t)
 '(delete-selection-mode nil)
 '(dired-hide-details-hide-symlink-targets nil)
 '(dired-kept-versions 20)
 '(dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..+$")
 '(dired-use-ls-dired 'unspecified)
 '(diredp-hide-details-initially-flag nil)
 '(direx:closed-icon "▶ ")
 '(direx:leaf-icon "- ")
 '(direx:open-icon "▼ ")
 '(dylan-continuation-indent 4)
 '(dylan-indent 4)
 '(ecb-auto-activate nil)
 '(ecb-layout-name "left3")
 '(ecb-maximize-ecb-window-after-selection nil)
 '(ecb-options-version "2.50")
 '(ecb-process-non-semantic-files t)
 '(ecb-tip-of-the-day nil)
 '(ecb-use-speedbar-instead-native-tree-buffer nil)
 '(ecb-vc-enable-support t)
 '(ecb-windows-width 0.13)
 '(ede-project-directories '("~/.emacs.d/config"))
 '(ediff-keep-variants nil)
 '(ediff-make-buffers-readonly-at-startup nil)
 '(ediff-merge-split-window-function 'split-window-horizontally)
 '(ediff-no-emacs-help-in-control-buffer t)
 '(ediff-split-window-function 'split-window-horizontally)
 '(eldoc-idle-delay 0.2)
 '(elpy-default-minor-modes
   '(eldoc-mode flymake-mode yas-minor-mode auto-complete-mode))
 '(elpy-modules
   '(elpy-module-eldoc elpy-module-flymake elpy-module-pyvenv elpy-module-yasnippet elpy-module-sane-defaults))
 '(elpy-rpc-backend "jedi")
 '(elpy-rpc-python-command "python3")
 '(elscreen-default-buffer-name "*scratch*")
 '(elscreen-tab-display-kill-screen nil)
 '(enable-recursive-minibuffers t)
 '(epa-file-cache-passphrase-for-symmetric-encryption nil)
 '(epg-debug t)
 '(epg-gpg-home-directory "~/.gnupg/")
 '(epg-gpg-program "gpg2")
 '(epg-pinentry-mode 'loopback)
 '(eshell-cannot-leave-input-list
   '(beginning-of-line-text beginning-of-line move-to-column move-to-left-margin move-to-tab-stop forward-char backward-char delete-char delete-backward-char backward-delete-char backward-delete-char-untabify kill-paragraph backward-kill-paragraph kill-sentence backward-kill-sentence kill-sexp backward-kill-sexp kill-word backward-kill-word kill-region forward-list backward-list forward-page backward-page forward-point forward-paragraph backward-paragraph backward-prefix-chars forward-sentence backward-sentence forward-sexp backward-sexp forward-to-indentation backward-to-indentation backward-up-list forward-word backward-word next-line forward-visible-line forward-comment forward-thing))
 '(eval-expression-print-length nil)
 '(expand-region-guess-python-mode t)
 '(fast-but-imprecise-scrolling t)
 '(fic-highlighted-words
   '("FIXME" "TODO" "BUG" "REDFLAG" "XXX" "HACK" "NOTE" "WARN" "WARNING"))
 '(file-precious-flag t)
 '(fill-column 80)
 '(flycheck-checkers
   '(python-pycheckers fsharp-fsautocomplete fsharp-fsautocomplete-lint ada-gnat asciidoctor asciidoc c/c++-clang c/c++-gcc c/c++-cppcheck cfengine chef-foodcritic coffee coffee-coffeelint coq css-csslint css-stylelint d-dmd dockerfile-hadolint elixir-dogma erlang-rebar3 erlang emacs-lisp eruby-erubis fortran-gfortran go-gofmt go-golint go-vet go-build go-test go-errcheck go-unconvert go-gosimple groovy haml handlebars haskell-stack-ghc haskell-ghc haskell-hlint html-tidy javascript-eslint javascript-jshint javascript-jscs javascript-standard json-jsonlint json-python-json less less-stylelint lua-luacheck lua perl perl-perlcritic php php-phpmd php-phpcs processing protobuf-protoc pug puppet-parser puppet-lint python-flake8 python-pylint python-pycompile r-lintr racket rpm-rpmlint markdown-mdl nix rst-sphinx rst ruby-rubocop ruby-reek ruby-rubylint ruby ruby-jruby rust-cargo rust scala scala-scalastyle scheme-chicken scss-lint scss-stylelint sass/scss-sass-lint sass scss sh-bash sh-posix-dash sh-posix-bash sh-zsh sh-shellcheck slim slim-lint sql-sqlint systemd-analyze tex-chktex tex-lacheck texinfo typescript-tslint verilog-verilator xml-xmlstarlet xml-xmllint yaml-jsyaml yaml-ruby))
 '(flycheck-clang-include-path '("/usr/local/include/cjson"))
 '(flycheck-clang-language-standard nil)
 '(flycheck-display-errors-delay 0.5)
 '(flycheck-emacs-lisp-load-path 'inherit)
 '(flycheck-pycheckers-checkers '(flake8 mypy3))
 '(flycheck-pycheckers-ignore-codes
   '("C0411" "C0413" "C0103" "C0111" "W0142" "W0201" "W0232" "W0403" "W0511" "E1002" "E1101" "E1103" "R0201" "R0801" "R0903" "R0904" "R0914" "E241"))
 '(flycheck-pycheckers-max-line-length 220)
 '(flycheck-python-mypy-args '("--strict-optional" "--follow-imports=normal"))
 '(flymake-checkers-checkers
   '(flymake-checkers-coffee flymake-checkers-emacs-lisp flymake-checkers-php flymake-checkers-python-flake8 flymake-checkers-python-pyflakes flymake-checkers-ruby flymake-checkers-php flymake-checkers-sh flymake-checkers-sh-bash flymake-checkers-sh-zsh flymake-checkers-tex))
 '(flymake-no-changes-timeout 2)
 '(flymake-start-syntax-check-on-newline t)
 '(fringe-mode '(10 . 8) nil (fringe))
 '(fuzzy-accept-error-rate 0.2)
 '(geiser-mode-auto-p nil)
 '(generic-ignore-files-regexp "[GPS]*[Tt][Aa][Gg][Ss]\\'")
 '(git-commit-summary-max-length 76)
 '(global-auto-revert-non-file-buffers t)
 '(global-linum-mode nil)
 '(global-visible-mark-mode-exclude-alist nil)
 '(global-visual-line-mode nil)
 '(gnus-article-sort-functions '(gnus-article-sort-by-date))
 '(gnus-asynchronous t)
 '(gnus-group-mode-hook '(gnus-agent-mode gnus-topic-mode))
 '(gnus-summary-same-subject "(same)")
 '(gnus-thread-sort-functions '(gnus-thread-sort-by-most-recent-date))
 '(golden-ratio-exclude-buffer-names '(" *MINIMAP*"))
 '(golden-ratio-mode nil)
 '(helm-M-x-always-save-history t)
 '(helm-adaptive-mode t nil (helm-adaptive))
 '(helm-ag-ignore-patterns '("#*"))
 '(helm-ag-insert-at-point 'sexp)
 '(helm-ag-use-agignore t)
 '(helm-ag-use-grep-ignore-list t)
 '(helm-bookmark-show-location t)
 '(helm-buffer-skip-remote-checking t)
 '(helm-findutils-search-full-path t)
 '(helm-imenu-fuzzy-match t)
 '(helm-split-window-default-side 'below)
 '(helm-split-window-inside-p t)
 '(help-at-pt-display-when-idle 'never nil (help-at-pt))
 '(help-at-pt-timer-delay 3)
 '(hs-hide-comments-when-hiding-all nil)
 '(hs-isearch-open t)
 '(ibuffer-default-shrink-to-minimum-size nil)
 '(ibuffer-default-sorting-mode 'filename/process)
 '(ibuffer-deletion-char 215)
 '(ibuffer-deletion-face 'web-mode-comment-keyword-face)
 '(ibuffer-elide-long-columns t)
 '(ibuffer-expert t)
 '(ibuffer-formats
   '((mark modified read-only " "
           (name 28 28 :left :elide)
           " "
           (size 9 -1 :right)
           " "
           (mode 16 16 :left :elide)
           " " filename-and-process)
     (mark " "
           (name 16 -1)
           " " filename)))
 '(ibuffer-jump-offer-only-visible-buffers t)
 '(ibuffer-load-hook nil)
 '(ibuffer-mode-hook '(my-ibuffer-mode-hook))
 '(ibuffer-old-time 2)
 '(ibuffer-saved-filter-groups nil)
 '(ibuffer-saved-filters
   '(("modified"
      (not starred-name)
      (modified))
     ("asdasd"
      (name . "org"))
     ("programming"
      (or
       (derived-mode . prog-mode)
       (mode . ess-mode)
       (mode . compilation-mode)))
     ("text document"
      (and
       (derived-mode . text-mode)
       (not
        (starred-name))))
     ("TeX"
      (or
       (derived-mode . tex-mode)
       (mode . latex-mode)
       (mode . context-mode)
       (mode . ams-tex-mode)
       (mode . bibtex-mode)))
     ("web"
      (or
       (derived-mode . sgml-mode)
       (derived-mode . css-mode)
       (mode . javascript-mode)
       (mode . js2-mode)
       (mode . scss-mode)
       (derived-mode . haml-mode)
       (mode . sass-mode)))
     ("gnus"
      (or
       (mode . message-mode)
       (mode . mail-mode)
       (mode . gnus-group-mode)
       (mode . gnus-summary-mode)
       (mode . gnus-article-mode)))))
 '(ibuffer-view-ibuffer t)
 '(icicle-Completions-max-columns 1)
 '(icicle-Completions-text-scale-decrease 0.0)
 '(icicle-files-ido-like-flag t)
 '(icicle-mode t)
 '(icicle-show-Completions-initially-flag nil)
 '(ido-create-new-buffer 'always)
 '(ido-enable-flex-matching t)
 '(ido-save-directory-list-file "~/.emacs.d/data/ido.last")
 '(image-dired-external-viewer "/usr/bin/pinta")
 '(image-dired-thumb-height 250)
 '(image-dired-thumb-size 250)
 '(image-dired-thumb-width 250)
 '(imenu-sort-function 'imenu--sort-by-name)
 '(imenu-use-popup-menu nil)
 '(indicate-buffer-boundaries nil)
 '(indicate-empty-lines t)
 '(inferior-lisp-program "/bin/sbcl" t)
 '(initial-scratch-message ";; **SCRATCH BUFFER **

")
 '(ivy-display-style 'fancy)
 '(ivy-height 10)
 '(ivy-wrap t)
 '(jabber-account-list
   '(("klibertpiotr@10clouds.xmpp.slack.com"
      (:disabled . t)
      (:password . "10clouds.Cixe46iDhcqIeU0hj7SO")
      (:network-server . "10clouds.xmpp.slack.com")
      (:connection-type . starttls))
     ("cji@direct.klibert.pl"
      (:password . "cji")
      (:network-server . "direct.klibert.pl")
      (:connection-type . starttls))))
 '(jabber-alert-info-message-hooks '(jabber-info-stumpwm jabber-info-beep jabber-info-echo))
 '(jabber-alert-message-function 'my-jabber-message-default-message)
 '(jabber-alert-message-hooks
   '(jabber-message-stumpwm-presence jabber-message-echo jabber-message-scroll))
 '(jabber-alert-muc-hooks '(jabber-muc-stumpwm jabber-muc-echo jabber-muc-scroll))
 '(jabber-alert-presence-hooks '(jabber-presence-stumpwm-presence))
 '(jabber-auto-reconnect t)
 '(jabber-backlog-days 300)
 '(jabber-backlog-number 80)
 '(jabber-chat-foreign-prompt-format "[%t] %n>
")
 '(jabber-chat-local-prompt-format "[%t] %n>
")
 '(jabber-connection-ssl-program 'openssl)
 '(jabber-groupchat-prompt-format "[%t] %n>
")
 '(jabber-history-enabled t)
 '(jabber-invalid-certificate-servers '("klibert.pl" "direct.klibert.pl"))
 '(jabber-reconnect-delay 15)
 '(jedi:complete-on-dot t)
 '(js-indent-level 2)
 '(js2-basic-offset 2)
 '(kept-new-versions 20)
 '(kept-old-versions 20)
 '(less-css-indent-level 4)
 '(linum-delay t)
 '(livescript-tab-width 2)
 '(lua-indent-level 4)
 '(lua-indent-string-contents t)
 '(magit-push-always-verify nil)
 '(magit-visit-ref-behavior '(create-branch checkout-branch))
 '(mouse-avoidance-threshold 10)
 '(mumamo-background-colors nil)
 '(neo-auto-indent-point t)
 '(neo-autorefresh nil)
 '(neo-create-file-auto-open t)
 '(neo-cwd-line-style 'text)
 '(neo-hidden-regexp-list '("^\\." "\\.pyc$" "~$" "^#.*#$" "\\.elc$" "_build"))
 '(neo-hide-cursor nil)
 '(neo-vc-integration '(face))
 '(ns-alternate-modifier 'super)
 '(ns-auto-hide-menu-bar nil)
 '(ns-command-modifier 'meta)
 '(nxhtml-menu-mode t)
 '(nxhtml-skip-welcome t)
 '(nxhtml-validation-header-mumamo-modes nil)
 '(org-agenda-dim-blocked-tasks t)
 '(org-agenda-files '("nowe.org" "praca.org"))
 '(org-archive-location "todo.archive::datetree/* From %s")
 '(org-babel-js-cmd "/usr/local/bin/node")
 '(org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (scheme . t)
     (js . t)
     (io . t)
     (ditaa . t)
     (awk . t)))
 '(org-babel-noweb-wrap-end ">=")
 '(org-babel-noweb-wrap-start "=<")
 '(org-babel-process-comment-text 'org-remove-indentation nil nil "smc")
 '(org-babel-shell-names '("sh" "bash" "csh" "ash" "dash" "ksh" "mksh" "posh" "zsh"))
 '(org-babel-tangle-uncomment-comments nil)
 '(org-capture-templates
   '(("c" "task" entry
      (file+headline "" "INCOMING")
      "* TODO %?
  Added: %U
  Origin: %a

  %i" :empty-lines 1)
     ("C" "work task" entry
      (file+headline "praca.org" "CURRENT")
      "* TODO %?
  Added: %U
  Origin: %a

  %i" :empty-lines 1 :prepend t)
     ("s" "scheduled event" entry
      (file+headline "" "EVENTS")
      "* TODO %? :EVENT:
  Added: %U
  SCHEDULED: %^T
  Origin: %a" :empty-lines 1)
     ("S" "scheduled work event" entry
      (file+headline "praca.org" "EVENTS")
      "* TODO %? :EVENT:
  Added: %U
  SCHEDULED: %^T
  Origin: %a" :empty-lines 1)
     ("n" "note" entry
      (file+headline "" "Notes")
      "* %? :NOTE:
  Added: %U
  Origin: %a

  %i" :empty-lines 1 :prepend t)))
 '(org-catch-invisible-edits 'smart)
 '(org-clock-into-drawer t)
 '(org-clock-persist 'clock)
 '(org-columns-default-format
   "%38ITEM(Details) %6TAGS(Context) %7TODO(To Do) %5Effort(Time){:} %6CLOCKSUM(Total) %16SCHEDULED(Scheduled)")
 '(org-confirm-babel-evaluate nil)
 '(org-default-notes-file "~/todo/nowe.org")
 '(org-directory "~/todo/")
 '(org-drawers '("PROPERTIES" "CLOCK" "LOGBOOK" "RESULTS" "NOTES"))
 '(org-edit-src-auto-save-idle-delay 5)
 '(org-emphasis-alist
   '(("*" bold "<b>" "</b>")
     ("/" italic "<i>" "</i>")
     ("_" underline "<span style=\"text-decoration:underline;\">" "</span>")
     ("=" org-code "<code>" "</code>" verbatim)
     ("`" org-code "<code>" "</code>" verbatim)
     ("~" org-verbatim "<code>" "</code>" verbatim)
     ("+"
      (:strike-through t)
      "<del>" "</del>")))
 '(org-enforce-todo-checkbox-dependencies t)
 '(org-enforce-todo-dependencies t)
 '(org-export-backends '(ascii html latex md odt org))
 '(org-export-coding-system 'utf-8)
 '(org-export-creator-string "")
 '(org-export-use-babel t)
 '(org-export-with-statistics-cookies nil)
 '(org-global-properties
   '(("Effort_ALL" . "0:05 0:15 0:30 1:00 1:30 2:00 4:00 6:00 8:00")))
 '(org-goto-interface 'outline-path-completion)
 '(org-habit-graph-column 60)
 '(org-habit-show-habits-only-for-today nil)
 '(org-hide-leading-stars t)
 '(org-hide-macro-markers nil)
 '(org-hierarchical-todo-statistics t)
 '(org-html-infojs-options
   '((path . "http://orgmode.org/org-info.js")
     (view . "info")
     (toc . :with-toc)
     (ftoc . "0")
     (tdepth . "max")
     (sdepth . "max")
     (mouse . "underline")
     (buttons . "0")
     (ltoc . "1")
     (up . :html-link-up)
     (home . :html-link-home)))
 '(org-html-keep-old-src t)
 '(org-html-klipse-js
   "https://storage.googleapis.com/app.klipse.tech/plugin_prod/js/klipse_plugin.min.js")
 '(org-html-klipsify-src nil)
 '(org-html-postamble t)
 '(org-html-postamble-format
   '(("en" "<p class=\"author\">Author: %a (%e)</p>
<p class=\"date\">Last updated: %T</p>
<p class=\"copyright\">© Trust Stamp 2019</p>")))
 '(org-imenu-depth 4)
 '(org-link-elisp-confirm-function nil)
 '(org-link-keep-stored-after-insertion t)
 '(org-link-shell-confirm-function nil)
 '(org-log-done 'note)
 '(org-log-into-drawer t)
 '(org-log-repeat 'note)
 '(org-log-states-order-reversed nil)
 '(org-loop-over-headlines-in-active-region 'start-level)
 '(org-lowest-priority 68)
 '(org-mark-ring-length 100)
 '(org-modules
   '(org-bbdb org-bibtex org-docview org-gnus org-habit org-id org-info org-inlinetask org-mouse org-tempo org-w3m org-eshell org-elisp-symbol org-eval org-toc))
 '(org-priority-start-cycle-with-default nil)
 '(org-refile-targets '((nil :maxlevel . 3) (org-agenda-files :maxlevel . 1)))
 '(org-return-follows-link nil)
 '(org-reverse-note-order t)
 '(org-show-siblings '((default . t) (isearch t)))
 '(org-special-ctrl-a/e t)
 '(org-special-ctrl-k t)
 '(org-src-ask-before-returning-to-edit-buffer nil)
 '(org-src-fontify-natively t)
 '(org-src-lang-modes
   '(("ls" . livescript)
     ("C" . c)
     ("C++" . c++)
     ("asymptote" . asy)
     ("bash" . sh)
     ("beamer" . latex)
     ("calc" . fundamental)
     ("cpp" . c++)
     ("ditaa" . artist)
     ("dot" . fundamental)
     ("elisp" . emacs-lisp)
     ("ocaml" . tuareg)
     ("screen" . shell-script)
     ("shell" . sh)
     ("sqlite" . sql)
     ("html" . web)))
 '(org-structure-template-alist
   '(("a" . "export ascii")
     ("c" . "center")
     ("C" . "comment")
     ("e" . "example")
     ("E" . "export")
     ("h" . "export html")
     ("l" . "export latex")
     ("q" . "quote")
     ("s" . "src")
     ("v" . "verse")
     ("n" . "note")))
 '(org-tag-alist
   '(("note" . 110)
     ("link" . 108)
     ("project" . 112)
     ("maybe" . 109)))
 '(org-tag-persistent-alist nil)
 '(org-tags-column -90)
 '(org-tags-sort-function 'org-string-collate-lessp)
 '(org-todo-keywords
   '((sequence "TODO(t!)" "NEXT(n!)" "WAITING(w@)" "|" "DONE(d@)" "CANCELED(c@)")))
 '(org-treat-S-cursor-todo-selection-as-state-change t)
 '(org-use-sub-superscripts nil)
 '(package-archives
   '(("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/")
     ("marmalade" . "https://marmalade-repo.org/packages/")
     ("elpy" . "https://jorgenschaefer.github.io/packages/")))
 '(package-directory-list
   '("~/.emacs.d/forked-plugins" "/usr/local/share/emacs/27.0.50/site-lisp/elpa" "/usr/local/share/emacs/site-lisp/elpa"))
 '(package-enable-at-startup nil)
 '(package-selected-packages
   '(project-root git-gutter-fringe+ gitignore-mode ox-minutes ox-slimhtml ox-rst orgalist ecb ess color-theme epl ghub flycheck-pycheckers flycheck-mypy commenter flycheck-clang-analyzer flycheck bookmark+ with-editor groovy-mode function-args cmake-mode nasm-mode plantuml-mode alpha avy ace-window ac-geiser ac-js2 ac-slime ace-jump-buffer ack ag alchemist auto-complete-nxml auto-indent-mode buffer-stack cider clips-mode clj-mode clojure-mode coffee-mode col-highlight company-inf-python crontab-mode dired+ ein elixir-mode elnode epc epoch-view eshell-manual f fic-ext-mode fill-column-indicator find-file-in-git-repo find-file-in-project flymake-jshint flymake-python-pyflakes fringe-helper fsharp-mode fuzzy ggtags gh git-auto-commit-mode git-commit-mode git-rebase-mode gitconfig-mode haxe-mode highlight highlight-indentation highline hl-line+ hl-sentence hl-sexp hy-mode idle-highlight-mode ido-load-library ido-ubiquitous idomenu iedit ipython iy-go-to-char j-mode jabber jade-mode jira json-mode less-css-mode levenshtein livescript-mode loop macrostep main-line mmm-mode mo-git-blame neotree nginx-mode nose nurumacs occur-default-current-word occur-x outline-magic outlined-elisp-mode paredit-everywhere paredit-menu parenface parenface-plus pcre2el peg pep8 phi-rectangle phi-search-mc project pycomplete pyflakes pylint pymacs python-django python-pylint pyvirtualenv quack rainbow-delimiters rainbow-mode regex-dsl register-list rust-mode scala-mode2 sentence-highlight shampoo shell-here slamhound slime smex sr-speedbar synosaurus tidy tuareg unbound undo-tree virtualenv w3m xml-rpc yaml-mode zencoding-mode))
 '(powerline-default-separator 'rounded)
 '(powerline-height nil)
 '(powerline-text-scale-factor 1.9)
 '(proced-auto-update-flag t)
 '(proced-auto-update-interval 1)
 '(prolog-electric-colon-flag t)
 '(prolog-electric-dot-flag t)
 '(prolog-indent-width 4)
 '(python-check-command "flake8")
 '(python-environment-virtualenv '("virtualenv" "--system-site-packages" "--quiet"))
 '(python-flymake-command '("flake8"))
 '(python-shell-buffer-name "python repl")
 '(python-shell-interpreter "python3")
 '(quack-programs
   '("csi -:c" "mzscheme" "bigloo" "csi" "csi -hygienic" "gosh" "gracket" "gsi" "gsi ~~/syntax-case.scm -" "guile" "kawa" "mit-scheme" "racket" "racket -il typed/racket" "rs" "scheme" "scheme48" "scsh" "sisc" "stklos" "sxi"))
 '(racket-program "/home/cji/portless/racket/racket/bin/racket")
 '(racket-racket-program "/home/cji/portless/racket/racket/bin/racket")
 '(racket-raco-program "/home/cji/portless/racket/racket/bin/raco")
 '(racket-use-company-mode nil)
 '(recentf-auto-cleanup 'never)
 '(recentf-max-menu-items 500)
 '(recentf-max-saved-items 1000)
 '(recentf-menu-action 'find-file)
 '(recentf-save-file "~/.emacs.d/data/recentf")
 '(safe-local-variable-values
   '((checkdoc-symbol-words "top-level" "major-mode" "macroexpand-all" "print-level" "print-length")
     (eval add-hook 'after-save-hook 'org-babel-tangle nil t)
     (eval append-creds-to-macro-templates)
     (eval require 'batch-export)
     (eval add-to-list 'load-path
           (expand-file-name "lisp/"))
     (be-secrets-file-name . "creds.el")
     (my-macro-templates quote
                         ("creds.el"))
     (macro-templates quote nil)
     (Log . clx\.log)
     (Package . Xlib)
     (Package . CL-FAD)
     (Package . ASDF)
     (Package . CL-User)
     (Package . FSet)
     (Syntax . ANSI-Common-Lisp)
     (bug-reference-bug-regexp . "#\\(?2:[0-9]+\\)")
     (cider-cljs-lein-repl . "(do (dev) (go) (cljs-repl))")
     (cider-refresh-after-fn . "reloaded.repl/resume")
     (cider-refresh-before-fn . "reloaded.repl/suspend")
     (checkdoc-package-keywords-flag)
     (bug-reference-bug-regexp . "#\\(?2:[[:digit:]]+\\)")
     (checkdoc-package-keywords-flag)
     (mangle-whitespace . t)
     (Lowercase . Yes)
     (Syntax . Common-lisp)
     (Lowercase . YES)
     (Base . 10)
     (Syntax . COMMON-LISP)
     (Package . XLIB)
     (eval setq org-html-postamble nil)
     (python-shell-completion-string-code . "';'.join(get_ipython().Completer.all_completions('''%s'''))
")
     (python-shell-completion-module-string-code . "';'.join(module_completion('''%s'''))
")
     (python-shell-completion-setup-code . "from IPython.core.completerlib import module_completion")
     (python-shell-interpreter-args . "/usr/www/tagasauris/tagasauris/manage.py shell")
     (python-shell-interpreter . "python")
     (whitespace-line-column . 80)))
 '(scheme-program-name "csi -:c")
 '(scroll-conservatively 108)
 '(semantic-c-dependency-system-include-path
   '("/usr/include" "/usr/local/include/cjson" "/usr/local/include" "/usr/include/opencv"))
 '(semantic-default-submodes
   '(global-semantic-highlight-func-mode global-semantic-idle-scheduler-mode global-semanticdb-minor-mode global-semantic-idle-summary-mode global-semantic-mru-bookmark-mode global-semantic-idle-local-symbol-highlight-mode))
 '(semanticdb-project-roots '("/home/cji/projects" "/home/cji/poligon"))
 '(set-mark-command-repeat-pop t)
 '(sgml-basic-offset 2)
 '(shell-completion-execonly nil)
 '(shell-file-name "/bin/zsh")
 '(shell-input-autoexpand t)
 '(show-paren-mode t)
 '(show-paren-style 'expression)
 '(slime-enable-evaluate-in-emacs t)
 '(slime-repl-history-file "~/.emacs.d/data/slime-history.eld")
 '(slime-repl-history-remove-duplicates t)
 '(slime-repl-history-trim-whitespaces t)
 '(speedbar-default-position 'left)
 '(speedbar-hide-button-brackets-flag t)
 '(speedbar-show-unknown-files t)
 '(speedbar-tag-regroup-maximum-length 4)
 '(speedbar-verbosity-level 1)
 '(sr-confirm-kill-viewer nil)
 '(sr-speedbar-auto-refresh nil)
 '(sr-speedbar-right-side nil)
 '(sr-use-commander-keys t)
 '(sr-windows-locked nil)
 '(srecode-map-save-file "~/.emacs.d/data/srecode-map.el")
 '(starttls-extra-arguments '("--insecure"))
 '(synosaurus-choose-method 'popup)
 '(tab-stop-list
   '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))
 '(tags-revert-without-query t)
 '(tool-bar-mode nil)
 '(tramp-backup-directory-alist '(("." . "~/.saves")))
 '(tramp-syntax 'default nil (tramp))
 '(tramp-verbose 5 nil (tramp))
 '(truncate-lines t)
 '(truncate-partial-width-windows nil)
 '(undo-tree-auto-save-history t)
 '(undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo-history")))
 '(uniquify-buffer-name-style 'post-forward nil (uniquify))
 '(uniquify-separator ":")
 '(uniquify-strip-common-suffix t)
 '(uniquify-trailing-separator-p t)
 '(vc-make-backup-files t)
 '(version-control t)
 '(visible-mark-max 3)
 '(visual-line-fringe-indicators '(nil nil))
 '(web-mode-code-indent-offset 4)
 '(web-mode-comment-style 1)
 '(web-mode-css-indent-offset 2)
 '(web-mode-disable-auto-pairing nil)
 '(web-mode-disable-css-colorization t)
 '(web-mode-enable-block-faces nil)
 '(web-mode-enable-current-element-highlight t)
 '(web-mode-markup-indent-offset 2)
 '(web-mode-script-padding 4)
 '(web-mode-style-padding 4)
 '(web-mode-tag-auto-close-style 2)
 '(x-gtk-use-system-tooltips nil)
 '(yas-snippet-dirs
   '("/home/cji/.emacs.d/snippets" "/home/cji/.emacs.d/forked-plugins/yasnippet/snippets/snippets" "/home/cji/.emacs.d/forked-plugins/yasnippet/snippets/")))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(avy-goto-char-timer-face ((t (:inherit highlight :background "black"))))
 '(avy-lead-face ((t (:foreground "violet" :underline t :weight bold))))
 '(avy-lead-face-0 ((t (:foreground "purple" :underline t :weight bold))))
 '(avy-lead-face-1 ((t (:background "red" :foreground "green"))))
 '(aw-leading-char-face ((t (:foreground "red" :height 3.0))))
 '(bmkp-local-directory ((t (:foreground "dark orange"))))
 '(bmkp-local-file-without-region ((t (:foreground "cyan"))))
 '(col-highlight ((t (:background "dark gray"))))
 '(css-selector ((t (:inherit font-lock-function-name-face :foreground "deep sky blue"))))
 '(ediff-even-diff-B ((t (:background "CadetBlue4"))))
 '(ediff-even-diff-C ((t (:background "dark slate blue"))))
 '(ediff-odd-diff-B ((t (:background "royal blue"))))
 '(elscreen-tab-current-screen-face ((t (:background "wheat2" :foreground "black"))))
 '(elscreen-tab-other-screen-face ((t (:background "SkyBlue3" :foreground "black" :underline t))))
 '(font-lock-fic-face ((t (:background "wheat4" :foreground "cyan" :weight bold))))
 '(helm-ff-file ((t (:inherit nil))))
 '(hl-line ((t (:background "gray18"))))
 '(hl-sexp-face ((t (:background "gray23"))))
 '(j-verb-face ((t (:foreground "dark cyan"))))
 '(link ((t (:foreground "#8ac6f2" :underline nil))))
 '(magit-item-highlight ((t (:background "gray19" :underline nil))))
 '(minimap-active-region-background ((t (:background "gray24"))))
 '(minimap-semantic-function-face ((t (:inherit (font-lock-function-name-face minimap-font-face) :background "#202414" :box (:line-width 1 :color "white") :height 4.75))))
 '(minimap-semantic-type-face ((t (:inherit (font-lock-type-face minimap-font-face) :background "gray10" :box (:line-width 1 :color "white") :height 4.75))))
 '(minimap-semantic-variable-face ((t (:inherit (font-lock-variable-name-face minimap-font-face) :background "gray10" :box (:line-width 1 :color "white") :height 3.15))))
 '(mode-line ((t (:background "#444444" :foreground "#f6f3e8" :height 1.0))))
 '(neo-banner-face ((t (:foreground "SeaGreen3" :weight bold))))
 '(next-error ((t (:background "#AAAA33"))))
 '(org-block-begin-line ((t (:foreground "#9ED5D5"))))
 '(org-block-end-line ((t (:foreground "#9ED5D5"))))
 '(org-level-1 ((t (:inherit outline-1))))
 '(org-level-2 ((t (:inherit outline-2))))
 '(powerline-active1 ((t (:inherit mode-line :background "gray22"))))
 '(powerline-active2 ((t (:inherit mode-line :background "gray40"))))
 '(powerline-inactive1 ((t (:inherit mode-line-inactive :background "gray11"))))
 '(powerline-inactive2 ((t (:inherit mode-line-inactive :background "gray20"))))
 '(pulse-highlight-start-face ((t (:background "#AAAA33"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "cadet blue"))))
 '(semantic-idle-symbol-highlight ((t (:inherit region))))
 '(show-paren-match ((t nil)))
 '(show-paren-match-expression ((t (:inherit show-paren-match :background "gray18"))))
 '(sr-active-path-face ((t (:background "deep sky blue" :foreground "navy" :height 130))))
 '(swiper-line-face ((t (:inherit highlight :background "black"))))
 '(swiper-match-face-1 ((t (:inherit isearch-lazy-highlight-face :background "black"))))
 '(swiper-match-face-2 ((t (:inherit isearch :background "black"))))
 '(swiper-match-face-3 ((t (:inherit match :background "black"))))
 '(table-cell ((t (:background "gray20" :foreground "gray90" :inverse-video nil))))
 '(visible-mark-face ((t (:background "gray26")))))

(toggle-diredp-find-file-reuse-dir 1)

(put 'narrow-to-region 'disabled nil)
(put 'upcase-region    'disabled nil)
(put 'set-goal-column  'disabled nil)
(put 'erase-buffer     'disabled nil)
