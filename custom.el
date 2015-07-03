(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-auto-show-menu 0.3)
 '(ac-comphist-file "~/.emacs.d/data/ac-comphist.dat")
 '(ac-disable-faces nil)
 '(ac-modes
   (quote
    (erlang-mode emacs-lisp-mode lisp-interaction-mode c-mode cc-mode c++-mode java-mode clojure-mode scala-mode scheme-mode coffee-mode ocaml-mode tuareg-mode perl-mode cperl-mode python-mode ruby-mode ecmascript-mode livescript-mode javascript-mode js-mode js2-mode php-mode css-mode makefile-mode sh-mode fortran-mode f90-mode ada-mode xml-mode sgml-mode racket-mode geiser-repl-mode elixir-mode2 scala-mode)))
 '(ac-quick-help-delay 0.4)
 '(ac-quick-help-prefer-pos-tip t)
 '(ag-highlight-search t)
 '(ag-reuse-buffers t)
 '(auto-mark-ignore-move-on-sameline nil)
 '(auto-revert-interval 2)
 '(auto-revert-mode-text " AR")
 '(auto-revert-verbose nil)
 '(auto-save-visited-file-name nil)
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(bookmark-default-file "~/.emacs.d/data/bookmarks")
 '(coffee-tab-width 4)
 '(company-backends
   (quote
    (company-files
     (company-capf :with company-dabbrev company-dabbrev-code company-keywords company-yasnippet))))
 '(company-dabbrev-code-everywhere t)
 '(company-dabbrev-downcase nil)
 '(company-dabbrev-ignore-case nil)
 '(company-idle-delay t)
 '(company-minimum-prefix-length 2)
 '(company-transformers (quote (company-sort-by-backend-importance)))
 '(completion-ignored-extensions
   (quote
    (".o" "~" ".bin" ".lbin" ".so" ".a" ".ln" ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".svn/" ".hg/" ".git/" ".bzr/" "CVS/" "_darcs/" "_MTN/" ".fmt" ".tfm" ".class" ".fas" ".lib" ".mem" ".x86f" ".sparcf" ".dfsl" ".pfsl" ".d64fsl" ".p64fsl" ".lx64fsl" ".lx32fsl" ".dx64fsl" ".dx32fsl" ".fx64fsl" ".fx32fsl" ".sx64fsl" ".sx32fsl" ".wx64fsl" ".wx32fsl" ".fasl" ".ufsl" ".fsl" ".dxl" ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".cp" ".fn" ".ky" ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo")))
 '(css-indent-offset 4)
 '(debug-on-quit nil)
 '(delete-selection-mode nil)
 '(dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..+$")
 '(dired-use-ls-dired (quote unspecified))
 '(direx:closed-icon "▶ ")
 '(direx:leaf-icon "- ")
 '(direx:open-icon "▼ ")
 '(dylan-continuation-indent 4)
 '(dylan-indent 4)
 '(ecb-auto-activate t)
 '(ecb-layout-name "left3")
 '(ecb-maximize-ecb-window-after-selection nil)
 '(ecb-options-version "2.40")
 '(ecb-process-non-semantic-files t)
 '(ecb-tip-of-the-day nil)
 '(ecb-use-speedbar-instead-native-tree-buffer nil)
 '(ecb-vc-enable-support t)
 '(ecb-windows-width 0.13)
 '(ede-project-directories (quote ("~/.emacs.d/config")))
 '(ediff-keep-variants nil)
 '(ediff-make-buffers-readonly-at-startup nil)
 '(ediff-merge-split-window-function (quote split-window-horizontally))
 '(ediff-no-emacs-help-in-control-buffer t)
 '(ediff-split-window-function (quote split-window-horizontally))
 '(eldoc-idle-delay 0.2)
 '(elpy-default-minor-modes
   (quote
    (eldoc-mode flymake-mode yas-minor-mode auto-complete-mode)))
 '(elpy-modules
   (quote
    (elpy-module-eldoc elpy-module-flymake elpy-module-pyvenv elpy-module-yasnippet elpy-module-sane-defaults)))
 '(elpy-rpc-backend "jedi")
 '(enable-recursive-minibuffers t)
 '(eshell-cannot-leave-input-list
   (quote
    (beginning-of-line-text beginning-of-line move-to-column move-to-left-margin move-to-tab-stop forward-char backward-char delete-char delete-backward-char backward-delete-char backward-delete-char-untabify kill-paragraph backward-kill-paragraph kill-sentence backward-kill-sentence kill-sexp backward-kill-sexp kill-word backward-kill-word kill-region forward-list backward-list forward-page backward-page forward-point forward-paragraph backward-paragraph backward-prefix-chars forward-sentence backward-sentence forward-sexp backward-sexp forward-to-indentation backward-to-indentation backward-up-list forward-word backward-word next-line forward-visible-line forward-comment forward-thing)))
 '(eval-expression-print-length nil)
 '(expand-region-guess-python-mode t)
 '(fast-but-imprecise-scrolling t)
 '(fic-highlighted-words (quote ("FIXME" "TODO" "BUG" "REDFLAG" "XXX")))
 '(fill-column 80)
 '(flymake-checkers-checkers
   (quote
    (flymake-checkers-coffee flymake-checkers-emacs-lisp flymake-checkers-php flymake-checkers-python-flake8 flymake-checkers-python-pyflakes flymake-checkers-ruby flymake-checkers-php flymake-checkers-sh flymake-checkers-sh-bash flymake-checkers-sh-zsh flymake-checkers-tex)))
 '(flymake-no-changes-timeout 5)
 '(flymake-start-syntax-check-on-newline t)
 '(fuzzy-accept-error-rate 0.2)
 '(geiser-mode-auto-p nil)
 '(git-commit-mode-hook
   (quote
    (turn-on-auto-fill flyspell-mode my-magit-commit-hook)) t)
 '(git-commit-summary-max-length 76)
 '(global-auto-revert-non-file-buffers t)
 '(global-git-commit-mode t)
 '(global-linum-mode t)
 '(gnus-article-sort-functions (quote (gnus-article-sort-by-date)))
 '(gnus-asynchronous t)
 '(gnus-group-mode-hook (quote (gnus-agent-mode gnus-topic-mode)))
 '(gnus-summary-same-subject "(same)")
 '(gnus-thread-sort-functions (quote (gnus-thread-sort-by-most-recent-date)))
 '(golden-ratio-exclude-buffer-names (quote (" *MINIMAP*")))
 '(golden-ratio-mode nil)
 '(helm-M-x-always-save-history t)
 '(helm-adaptive-mode t nil (helm-adaptive))
 '(helm-bookmark-show-location t)
 '(helm-buffer-skip-remote-checking t)
 '(helm-imenu-fuzzy-match t)
 '(help-at-pt-display-when-idle (quote never) nil (help-at-pt))
 '(help-at-pt-timer-delay 3)
 '(ibuffer-default-sorting-mode (quote major-mode))
 '(ibuffer-deletion-char 88)
 '(ibuffer-elide-long-columns t)
 '(ibuffer-expert t)
 '(ibuffer-formats
   (quote
    ((mark modified read-only " "
           (name 28 28 :left :elide)
           " "
           (size 9 -1 :right)
           " "
           (mode 16 16 :left :elide)
           " " filename-and-process)
     (mark " "
           (name 16 -1)
           " " filename))))
 '(ibuffer-jump-offer-only-visible-buffers t)
 '(ibuffer-load-hook nil)
 '(ibuffer-mode-hook (quote (my-ibuffer-mode-hook)))
 '(ibuffer-old-time 2)
 '(ibuffer-view-ibuffer t)
 '(icicle-Completions-max-columns 1)
 '(icicle-Completions-text-scale-decrease 0.0)
 '(icicle-files-ido-like-flag t)
 '(icicle-mode t)
 '(icicle-show-Completions-initially-flag nil)
 '(ido-create-new-buffer (quote always))
 '(ido-enable-flex-matching t)
 '(ido-save-directory-list-file "~/.emacs.d/data/ido.last")
 '(imenu-sort-function (quote imenu--sort-by-name))
 '(imenu-use-popup-menu nil)
 '(inferior-lisp-program "/home/cji/ccl/lx86cl64" t)
 '(initial-scratch-message ";; **SCRATCH BUFFER **

")
 '(jedi:complete-on-dot t)
 '(js-indent-level 2)
 '(less-css-indent-level 4)
 '(linum-delay t)
 '(livescript-tab-width 4)
 '(minimap-always-recenter t)
 '(minimap-hide-fringes t)
 '(minimap-highlight-line nil)
 '(minimap-major-modes (quote (prog-mode org-mode)))
 '(minimap-mode t)
 '(minimap-recreate-window nil)
 '(minimap-update-delay 0.3)
 '(mouse-avoidance-threshold 10)
 '(mumamo-background-colors nil)
 '(nxhtml-menu-mode t)
 '(nxhtml-skip-welcome t)
 '(nxhtml-validation-header-mumamo-modes nil)
 '(org-agenda-files (quote ("~/todo/")))
 '(org-archive-location "todo.archive::datetree/* From %s")
 '(org-babel-load-languages
   (quote
    ((emacs-lisp . t)
     (python . t)
     (scheme . t)
     (js . t)
     (io . t)
     (shell . t)
     (ditaa . t))))
 '(org-babel-noweb-wrap-end "->")
 '(org-babel-noweb-wrap-start "<-")
 '(org-babel-shell-names
   (quote
    ("sh" "bash" "csh" "ash" "dash" "ksh" "mksh" "posh" "zsh")))
 '(org-clock-into-drawer t)
 '(org-clock-persist (quote clock))
 '(org-columns-default-format
   "%38ITEM(Details) %6TAGS(Context) %7TODO(To Do) %5Effort(Time){:} %6CLOCKSUM(Total) %16SCHEDULED(Scheduled)")
 '(org-confirm-babel-evaluate nil)
 '(org-default-notes-file "~/todo/notes")
 '(org-directory "~/todo/")
 '(org-drawers (quote ("PROPERTIES" "CLOCK" "LOGBOOK" "RESULTS" "NOTES")))
 '(org-emphasis-alist
   (quote
    (("*" bold "<b>" "</b>")
     ("/" italic "<i>" "</i>")
     ("_" underline "<span style=\"text-decoration:underline;\">" "</span>")
     ("=" org-code "<code>" "</code>" verbatim)
     ("`" org-code "<code>" "</code>" verbatim)
     ("~" org-verbatim "<code>" "</code>" verbatim)
     ("+"
      (:strike-through t)
      "<del>" "</del>"))))
 '(org-enforce-todo-dependencies t)
 '(org-export-creator-string "")
 '(org-global-properties
   (quote
    (("Effort_ALL" . "0:05 0:15 0:30 1:00 1:30 2:00 4:00 6:00 8:00"))))
 '(org-habit-graph-column 60)
 '(org-habit-show-habits-only-for-today nil)
 '(org-hide-leading-stars t)
 '(org-hierarchical-todo-statistics nil)
 '(org-log-done (quote note))
 '(org-log-into-drawer t)
 '(org-log-repeat (quote note))
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-id org-info org-eshell org-habit org-inlinetask org-mhe org-rmail org-w3m)))
 '(org-refile-targets
   (quote
    ((nil :maxlevel . 3)
     (org-agenda-files :maxlevel . 1))))
 '(org-show-siblings (quote ((default . t) (isearch t))))
 '(org-special-ctrl-a/e t)
 '(org-special-ctrl-k t)
 '(org-tag-alist
   (quote
    ((:startgroup)
     ("WORK" . 119)
     ("HOME" . 104)
     ("SIMPLY" . 115)
     ("CASTORAMA" . 99)
     (:endgroup "")
     ("LODZ" . 108)
     ("RABIEN" . 114)
     ("BLOG" . 98)
     ("Michal" . 109))))
 '(org-tags-column -90)
 '(org-todo-keywords
   (quote
    ((sequence "TODO(t!)" "NEXT(n!)" "WAITING(w@)" "|" "DONE(d@)" "CANCELED(c@)")
     (sequence "INACTIVE(i!)" "ACTIVE(a@)" "SUSPENDED(u@)" "|" "FINISHED(f@)"))))
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/")
     ("marmalade" . "https://marmalade-repo.org/packages/")
     ("elpy" . "https://jorgenschaefer.github.io/packages/"))))
 '(package-enable-at-startup nil)
 '(package-selected-packages
   (quote
    (zencoding-mode yaml-mode xml-rpc virtualenv undo-tree unbound tuareg tidy sr-speedbar smex slime shell-here shampoo sentence-highlight scala-mode2 rust-mode register-list regex-dsl rainbow-mode rainbow-delimiters quack pyvirtualenv python-pylint python-django pymacs pylint pyflakes pycomplete project phi-search-mc phi-rectangle pep8 peg pcre2el parenface-plus parenface paredit-menu paredit-everywhere outlined-elisp-mode outline-magic occur-x occur-default-current-word nurumacs nose nginx-mode mo-git-blame mmm-mode main-line macrostep loop livescript-mode levenshtein less-css-mode json-mode jira j-mode iy-go-to-char ipython iedit idomenu ido-ubiquitous ido-load-library idle-highlight-mode hl-sexp hl-sentence hl-line+ highline highlight-indentation highlight haxe-mode gitconfig-mode git-rebase-mode git-commit-mode git-auto-commit-mode gh ggtags fuzzy fsharp-mode fringe-helper flymake-python-pyflakes flymake-jshint find-file-in-project find-file-in-git-repo fill-column-indicator fic-ext-mode f eshell-manual epoch-view epc elnode elixir-mode ein dired+ crontab-mode company-inf-python col-highlight coffee-mode clj-mode clips-mode cider buffer-stack auto-indent-mode auto-complete-nxml ag ack ace-jump-buffer ac-js2 ac-geiser)))
 '(proced-auto-update-flag t)
 '(proced-auto-update-interval 2)
 '(prolog-electric-colon-flag t)
 '(prolog-electric-dot-flag t)
 '(prolog-indent-width 4)
 '(python-check-command "pyflakes")
 '(quack-programs
   (quote
    ("csi -:c" "mzscheme" "bigloo" "csi" "csi -hygienic" "gosh" "gracket" "gsi" "gsi ~~/syntax-case.scm -" "guile" "kawa" "mit-scheme" "racket" "racket -il typed/racket" "rs" "scheme" "scheme48" "scsh" "sisc" "stklos" "sxi")))
 '(racket-use-company-mode nil)
 '(recentf-auto-cleanup (quote never))
 '(recentf-max-menu-items 100)
 '(recentf-max-saved-items 100)
 '(recentf-menu-action (quote find-file))
 '(recentf-save-file "~/.emacs.d/data/recentf")
 '(safe-local-variable-values
   (quote
    ((eval setq org-html-postamble nil)
     (python-shell-completion-string-code . "';'.join(get_ipython().Completer.all_completions('''%s'''))
")
     (python-shell-completion-module-string-code . "';'.join(module_completion('''%s'''))
")
     (python-shell-completion-setup-code . "from IPython.core.completerlib import module_completion")
     (python-shell-interpreter-args . "/usr/www/tagasauris/tagasauris/manage.py shell")
     (python-shell-interpreter . "python")
     (whitespace-line-column . 80))))
 '(scheme-program-name "csi -:c")
 '(scroll-conservatively 108)
 '(semanticdb-project-roots (quote ("/usr/www/tagasauris/")))
 '(set-mark-command-repeat-pop t)
 '(sgml-basic-offset 4)
 '(shell-file-name "/bin/bash")
 '(shell-prompt-pattern "# ")
 '(speedbar-default-position (quote left))
 '(speedbar-hide-button-brackets-flag t)
 '(speedbar-show-unknown-files t)
 '(speedbar-tag-regroup-maximum-length 4)
 '(speedbar-verbosity-level 1)
 '(sr-confirm-kill-viewer nil)
 '(sr-speedbar-auto-refresh nil)
 '(sr-speedbar-right-side nil)
 '(sr-use-commander-keys t)
 '(srecode-map-save-file "~/.emacs.d/data/srecode-map.el")
 '(tab-stop-list
   (quote
    (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120)))
 '(tags-revert-without-query t)
 '(tramp-backup-directory-alist (quote (("." . "~/.saves"))))
 '(tramp-default-host "localhost")
 '(truncate-lines t)
 '(truncate-partial-width-windows nil)
 '(undo-tree-auto-save-history t)
 '(undo-tree-history-directory-alist (quote (("." . "~/.emacs.d/undo-history"))))
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify))
 '(uniquify-separator ":")
 '(uniquify-strip-common-suffix t)
 '(uniquify-trailing-separator-p t)
 '(visible-mark-max 3)
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
 '(web-mode-tag-auto-close-style 2))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-local-directory ((t (:foreground "dark orange"))))
 '(bmkp-local-file-without-region ((t (:foreground "cyan"))))
 '(css-selector ((t (:inherit font-lock-function-name-face :foreground "deep sky blue"))))
 '(font-lock-fic-face ((t (:background "wheat4" :foreground "cyan" :weight bold))))
 '(hl-line ((t (:background "gray18"))))
 '(magit-item-highlight ((t (:background "gray19" :underline nil))))
 '(minimap-active-region-background ((t (:background "gray24"))))
 '(table-cell ((t (:background "gray20" :foreground "gray90" :inverse-video nil))) t)
 '(visible-mark-face ((t (:background "gray26")))))

(toggle-diredp-find-file-reuse-dir 1)

(put 'narrow-to-region 'disabled nil)
(put 'upcase-region    'disabled nil)
(put 'set-goal-column  'disabled nil)
(put 'erase-buffer     'disabled nil)
