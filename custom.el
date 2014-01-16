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
 '(ac-quick-help-prefer-x t)
 '(ag-highlight-search t)
 '(ag-reuse-buffers t)
 '(auto-mark-ignore-move-on-sameline nil)
 '(auto-revert-interval 2)
 '(auto-revert-mode-text " AR")
 '(auto-revert-verbose nil)
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(bookmark-default-file "~/.emacs.d/data/bookmarks")
 '(coffee-tab-width 4)
 '(completion-ignored-extensions
   (quote
    (".o" "~" ".bin" ".lbin" ".so" ".a" ".ln" ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".svn/" ".hg/" ".git/" ".bzr/" "CVS/" "_darcs/" "_MTN/" ".fmt" ".tfm" ".class" ".fas" ".lib" ".mem" ".x86f" ".sparcf" ".dfsl" ".pfsl" ".d64fsl" ".p64fsl" ".lx64fsl" ".lx32fsl" ".dx64fsl" ".dx32fsl" ".fx64fsl" ".fx32fsl" ".sx64fsl" ".sx32fsl" ".wx64fsl" ".wx32fsl" ".fasl" ".ufsl" ".fsl" ".dxl" ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".cp" ".fn" ".ky" ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo")))
 '(css-indent-offset 4)
 '(debug-on-quit nil)
 '(delete-selection-mode nil)
 '(dired-use-ls-dired (quote unspecified))
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
 '(elpy-default-minor-modes
   (quote
    (eldoc-mode flymake-mode yas-minor-mode auto-complete-mode)))
 '(elpy-rpc-backend "jedi")
 '(enable-recursive-minibuffers t)
 '(eval-expression-print-length nil)
 '(fic-highlighted-words (quote ("FIXME" "TODO" "BUG" "REDFLAG" "XXX")))
 '(fill-column 80)
 '(flymake-no-changes-timeout 5)
 '(flymake-start-syntax-check-on-newline t)
 '(fuzzy-accept-error-rate 0.2)
 '(git-commit-mode-hook
   (quote
    (turn-on-auto-fill flyspell-mode my-magit-commit-hook)))
 '(git-commit-summary-max-length 70)
 '(global-auto-revert-non-file-buffers t)
 '(gnus-article-sort-functions (quote (gnus-article-sort-by-date)))
 '(gnus-asynchronous t)
 '(gnus-group-mode-hook (quote (gnus-agent-mode gnus-topic-mode)))
 '(gnus-summary-same-subject "(same)")
 '(gnus-thread-sort-functions (quote (gnus-thread-sort-by-most-recent-date)))
 '(help-at-pt-display-when-idle t nil (help-at-pt))
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
 '(initial-scratch-message ";; **SCRATCH BUFFER **

")
 '(less-css-indent-level 4)
 '(livescript-tab-width 4)
 '(mouse-avoidance-threshold 10)
 '(mumamo-background-colors nil)
 '(nxhtml-menu-mode t)
 '(nxhtml-skip-welcome t)
 '(nxhtml-validation-header-mumamo-modes nil)
 '(org-agenda-files (quote ("~/todo/")))
 '(org-archive-location "todo.archive::datetree/* From %s")
 '(org-columns-default-format
   "%38ITEM(Details) %6TAGS(Context) %7TODO(To Do) %5Effort(Time){:} %6CLOCKSUM(Total) %16SCHEDULED(Scheduled)")
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
     ("BLOG" . 98))))
 '(org-tags-column -90)
 '(org-todo-keywords
   (quote
    ((sequence "TODO(t!)" "NEXT(n!)" "WAITING(w@)" "|" "DONE(d@)" "CANCELED(c@)")
     (sequence "INACTIVE(i!)" "ACTIVE(a@)" "SUSPENDED(u@)" "|" "FINISHED(f@)"))))
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/")
     ("marmalade" . "http://marmalade-repo.org/packages/"))))
 '(proced-auto-update-flag t)
 '(proced-auto-update-interval 2)
 '(quack-programs
   (quote
    ("mzscheme" "bigloo" "csi" "csi -hygienic" "gosh" "gracket" "gsi" "gsi ~~/syntax-case.scm -" "guile" "kawa" "mit-scheme" "racket" "racket -il typed/racket" "rs" "scheme" "scheme48" "scsh" "sisc" "stklos" "sxi")))
 '(recentf-auto-cleanup (quote never))
 '(recentf-max-menu-items 100)
 '(recentf-max-saved-items 100)
 '(recentf-menu-action (quote find-file))
 '(recentf-save-file "~/.emacs.d/data/recentf")
 '(safe-local-variable-values
   (quote
    ((python-shell-completion-string-code . "';'.join(get_ipython().Completer.all_completions('''%s'''))
")
     (python-shell-completion-module-string-code . "';'.join(module_completion('''%s'''))
")
     (python-shell-completion-setup-code . "from IPython.core.completerlib import module_completion")
     (python-shell-interpreter-args . "/usr/www/tagasauris/tagasauris/manage.py shell")
     (python-shell-interpreter . "python")
     (whitespace-line-column . 80))))
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
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify))
 '(uniquify-separator ":")
 '(uniquify-strip-common-suffix t)
 '(uniquify-trailing-separator-p t)
 '(visible-mark-max 3)
 '(web-mode-code-indent-offset 4)
 '(web-mode-comment-style 2)
 '(web-mode-css-indent-offset 4)
 '(web-mode-disable-auto-pairing nil)
 '(web-mode-disable-css-colorization t)
 '(web-mode-enable-block-faces nil)
 '(web-mode-enable-current-element-highlight t)
 '(web-mode-markup-indent-offset 4)
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
 '(hl-line ((t (:background "gray10"))))
 '(magit-item-highlight ((t (:background "gray19" :underline nil))))
 '(table-cell ((t (:background "gray20" :foreground "gray90" :inverse-video nil))))
 '(visible-mark-face ((t (:background "gray26")))))

(toggle-diredp-find-file-reuse-dir 1)

(put 'narrow-to-region 'disabled nil)
(put 'upcase-region    'disabled nil)
(put 'set-goal-column  'disabled nil)
(put 'erase-buffer     'disabled nil)
