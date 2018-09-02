;; Make indent operations leave region active when done. It's a pain to press
;; C-x C-x after indenting a block just to be able indent it a bit more.

(require 'my-utils)




(defvar my-auto-mark-excludes
  '((indent-region-or-line               . ignore)
    (indent-for-tab-command              . ignore)
    (python-indent-shift-right           . ignore)
    (python-indent-shift-left            . ignore)
    (my-indent                           . ignore)
    (my-dedent                           . ignore)
    (open-rectangle                      . ignore)
    (comment-or-uncomment-region-or-line . ignore)
    (duplicate-line-or-region            . ignore)))

;; auto-mark sets the mark *AFTER* the command was executed (on
;; post-command-hook) which makes it impossible to maintain selection. We need
;; to exclude our functions from auto-mark so that it stops interfering.
(setq auto-mark-command-class-alist (-union auto-mark-command-class-alist
                                            my-auto-mark-excludes))


(global-set-key (kbd "C-M->") 'my-indent)
(global-set-key (kbd "C-M-<") 'my-dedent)

(defun ensure-mark-active ()
  "Force mark to be active, even if something tried to deactivate
it before."
  (setq deactivate-mark nil)
  (setq mark-active t))

(defadvice indent-rigidly (after indent-rigidly-keep-region activate)
  (setq deactivate-mark nil))

(defadvice indent-for-tab-command (around indent-for-tab-keep-region activate)
  ;; ie. TAB in elisp mode
  (let ((region-info (my-get-region-or-line-bounds)))
    ad-do-it
    (when (car region-info)
     (setq deactivate-mark nil)
     (setq mark-active t))))

(defconst my-indent-varnames-alist
  '((apache-mode apache-indent-level)
    (awk-mode c-basic-offset)
    (c++-mode c-basic-offset)
    (c-mode c-basic-offset)
    (cmake-mode cmake-tab-width)
    (coffee-mode coffee-tab-width)
    (cperl-mode cperl-indent-level)
    (crystal-mode crystal-indent-level)
    (css-mode css-indent-offset)
    (emacs-lisp-mode lisp-indent-offset)
    (erlang-mode erlang-indent-level)
    (ess-mode ess-indent-offset)
    (feature-mode feature-indent-offset feature-indent-level)
    (fsharp-mode fsharp-continuation-offset fsharp-indent-level fsharp-indent-offset)
    (groovy-mode groovy-indent-offset)
    (haskell-mode haskell-indent-spaces)
    (idl-mode c-basic-offset)
    (jade-mode jade-tab-width)
    (java-mode c-basic-offset)
    (js-mode js-indent-level)
    (js-jsx-mode js-indent-level sgml-basic-offset)
    (js2-mode js2-basic-offset)
    (js2-jsx-mode js2-basic-offset sgml-basic-offset)
    (js3-mode js3-indent-level)
    (json-mode js-indent-level)
    (julia-mode julia-indent-offset)
    ;; (latex-mode . editorconfig-set-indentation/latex-mode)
    (lisp-mode lisp-indent-offset)
    (livescript-mode livescript-tab-width)
    (lua-mode lua-indent-level)
    (matlab-mode matlab-indent-level)
    (mustache-mode mustache-basic-offset)
    (nginx-mode nginx-indent-level)
    (nxml-mode nxml-child-indent)
    (objc-mode c-basic-offset)
    (octave-mode octave-block-offset)
    (perl-mode perl-indent-level)
    (php-mode c-basic-offset)
    (pike-mode c-basic-offset)
    (ps-mode ps-mode-tab)
    (pug-mode pug-tab-width)
    (puppet-mode puppet-indent-level)
    (python-mode . python-indent-offset)
    (ruby-mode ruby-indent-level)
    (rust-mode rust-indent-offset)
    (scala-mode scala-indent:step)
    (scss-mode css-indent-offset)
    (sgml-mode sgml-basic-offset)
    (sh-mode sh-basic-offset sh-indentation)
    (slim-mode slim-indent-offset)
    (tcl-mode tcl-indent-level tcl-continued-indent-level)
    (typescript-mode typescript-indent-level)
    (web-mode web-mode-indent-style)
    (yaml-mode yaml-indent-offset)))

(defun my-indent-rigidly (dir &optional arg)
  (unless arg
    (setq arg (if-let (mm-indent-varname (car (alist-get major-mode my-indent-varnames-alist)))
                  (if (or (eq major-mode 'emacs-lisp-mode)
                          (eq major-mode 'lisp-interaction-mode))
                      2
                    4)
                (symbol-value mm-indent-varname))))
  (destructuring-bind
      (region-was-active? start end) (my-get-region-or-line-bounds)
    (indent-rigidly start end (funcall dir arg))))

;; (defvar my-indent-width 4)
;; (make-variable-buffer-local 'my-indent-width)

(defun my-indent (&optional arg)
  (interactive "P")
  (my-indent-rigidly '+ arg))

(defun my-dedent (&optional arg)
  (interactive "P")
  (my-indent-rigidly '- arg))


(defun align-line-cont-chars (col)
  (interactive "n")
  (save-excursion
    (goto-char (1- (line-end-position)))
    (insert-char ?\   (- col (length (buffer-line))))))


(provide 'my-indent-config)
