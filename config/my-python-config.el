;; no idea what needs tramp here...
(require 'tramp)

;; TODO:
;; make python, python-mode and elpy work together (auto-completion,
;; editing, etc.)
;; try jedi.el and the other plugin from jedi author (class tree visualiser or
;; something)
;; clean this mess up!

;;
; Basic imports
;;

;; load better, newer version of python-mode
;;(load "~/.emacs.d/plugins2/python.el")
;; import elpy - a package that implements many nice things for python editing
(require 'elpy)
;; import additional utilities for Django prjects
(require 'python-django)


;;
;; Configuration
;;

;; (add-hook 'python-mode-hook
;;           (lambda ()
;;             (elpy-enable)))

(elpy-enable)
;; (elpy-use-ipython)

;; python-mode shell configuration
;; M-x python-shell-switch-to-shell -- open shell
(setq python-shell-interpreter "python")
;;  python-shell-interpreter-args ""
;;  python-shell-prompt-regexp "In \\[[0-9]+\\]: "
;;  python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
;;  python-shell-completion-setup-code
;;    "from IPython.core.completerlib import module_completion"
;;  python-shell-completion-module-string-code
;;    "';'.join(module_completion('''%s'''))\n"
;;  python-shell-completion-string-code
;;    "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")



;;
;; Linters configuration
;;

;; TODO:
;; convince flycheckers/flycheck-mode to use only pyflakes and not pylint
;; (as a default at least)

(require 'flymake)
(add-hook 'prog-mode-hook 'flymake-mode)

(require 'flymake-checkers)

(defun start-checkers()
  (when flymake-is-running
    (flymake-mode -1))
  (require 'flymake-checkers)
  (flycheck-mode -1)
  (flymake-mode 1))
(add-hook 'elpy-mode-hook 'start-checkers)


;;
;;                           Additional keybindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-elpy-mode-setup ()
   (local-set-key (kbd "C-M->") 'python-indent-shift-right)
   (local-set-key (kbd "C-M-<") 'python-indent-shift-left))

(add-hook 'elpy-mode-hook 'my-elpy-mode-setup)
