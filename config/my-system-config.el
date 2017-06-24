(require 's)
(require 'f)
(require 'cl)
(require 'dash)

;; TODO: maybe make it into `cond-hostname' ?
(defmacro if-hostname (name &rest body)
  "Example usage:
\(if-hostname urkaja2
  \(set some-var some-value\)
  \(set other-var other-val\)
  ... \)"
  (declare (indent defun))
  (if (equal (or (and (symbolp name) (symbol-name name))
                 (and (stringp name) name))
             (s-trim (shell-command-to-string "hostname")))
      `(progn ,@body)
    '(list 1)))

(defun add-subdirs-to-path (&rest dirs)
  "Add given directory and all it's (immediate) subdirectories to load-path."
  (dolist (dir dirs)
    (add-to-list 'load-path dir)
    (let
        ((default-directory dir))
      (normal-top-level-add-subdirs-to-load-path))))
(put 'add-subdirs-to-path 'lisp-indent-function 0)

;; (defmacro add-subdirs-to-path (&rest dirs)
;;   "Add given directory and all it's (immediate) subdirectories to load-path."
;;   ;; TODO: rewrite this as a proper macro (could be a function as it is now)
;;   `(dolist (dir (list ,@dirs))
;;      (add-to-list 'load-path dir)
;;      (let
;;        ((default-directory dir))
;;        (normal-top-level-add-subdirs-to-load-path))))

(require 'edit-server)
(edit-server-start t)

(defun my-edit-server-hook ()
  (elscreen-toggle-display-tab))

(add-hook 'edit-server-edit-mode-hook 'delete-other-windows)
(add-hook 'edit-server-edit-mode-hook 'my-edit-server-hook)


(defconst modules-list
  '(ack-autoloads
    auto-indent-mode-autoloads
    buffer-stack-autoloads
    clips-mode-autoloads
    cm-mode-autoloads
    col-highlight-autoloads
    crontab-mode-autoloads
    deferred-autoloads
    dired+-autoloads
    epoch-view-autoloads
    eshell-manual-autoloads
    fic-ext-mode-autoloads
    fill-column-indicator-autoloads
    find-file-in-git-repo-autoloads
    flymake-easy-autoloads
    flymake-jshint-autoloads
    flymake-python-pyflakes-autoloads
    fuzzy-autoloads
    gitconfig-mode-autoloads
    highlight-autoloads
    highlight-indentation-autoloads
    highline-autoloads
    hl-line+-autoloads
    ;; hl-sentence-autoloads
    hl-sexp-autoloads
    idle-highlight-mode-autoloads
    ;; ido-load-library-autoloads
    ido-ubiquitous-autoloads
    idomenu-autoloads
    iedit-autoloads
    ipython-autoloads
    jira-autoloads
    js2-mode-autoloads
    less-css-mode-autoloads
    levenshtein-autoloads
    list-utils-autoloads
    logito-autoloads
    loop-autoloads
    macrostep-autoloads
    nose-autoloads
    nurumacs-autoloads
    paredit-autoloads
    paredit-everywhere-autoloads
    paredit-menu-autoloads
    project-autoloads
    pycomplete-autoloads
    pyflakes-autoloads
    pylint-autoloads
    pymacs-autoloads
    python-django-autoloads
    python-pylint-autoloads
    pyvirtualenv-autoloads
    quack-autoloads
    rainbow-delimiters-autoloads
    rainbow-mode-autoloads
    rust-mode-autoloads
    shell-here-autoloads
    smex-autoloads
    sr-speedbar-autoloads
    tidy-autoloads
    unbound-autoloads
    undo-tree-autoloads
    xml-rpc-autoloads
    yaml-mode-autoloads
    zencoding-mode-autoloads
    ;; plugins2-autoloads
    )
  "Modules which provide their own autoloads")

(require 'pcache)
(require 'persistent-soft)

(defconst plugins2-list
  (list 'ac-company
        'align-by-current-symbol
        'align-regexp
        'align-string
        'auto-mark
        'bm
        'bookmark+
        'bookmark+-1
        'bookmark+-1
        'bookmark+-bmu
        'bookmark+-chg
        'bookmark+-doc
        'bookmark+-key
        'bookmark+-lit
        'bookmark+-mac
        'browse-kill-ring
        'buffer-move
        'columnize
        'edit-server
        'elisp-format
        'elscreen
        'etags-update
        'fixmee
        'fuzzy
        'fuzzy-find-in-project
        'git
        'git-blame
        'golden-ratio
        'help+
        'help-fns+
        'help-macro+
        'help-mode+
        'ido-vertical-mode
        'info+
        'iy-go-to-char
        'mark-lines
        'mo-git-blame
        'mysql
        'place-windows
        'plugins2-autoloads
        'powerline
        'relative-linum
        'revbufs
        'slurp
        'speedbar-extension
        'sticky-windows
        'sunrise-commander
        'sunrise-x-buttons
        'sunrise-x-checkpoints
        'sunrise-x-loop
        'sunrise-x-mirror
        'sunrise-x-modeline
        'sunrise-x-old-checkpoints
        'sunrise-x-popviewer
        'sunrise-x-tabs
        'sunrise-x-tree
        'sunrise-x-w32-addons
        'synonyms
        'textobjects
        'thingatpt+
        'tiling
        'title-time
        'vc+
        'vc-
        'visible-mark
        'winring)
  "Modules which have their autoloads in plugins2-autoloads")

(loop for x in modules-list
      if (condition-case err
             (progn (require x) t)
           (error (message "Failed to load: %s (%s)" x err)
                  nil))
      collect x)
