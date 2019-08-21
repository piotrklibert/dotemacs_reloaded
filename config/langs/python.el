;; Emacs IPython Notebook
;; (require 'ein)
;; (setq ein:use-auto-complete t)
(require 'use-package)

(require 'jedi-autoloads)
(require 'python-django-autoloads)
(require 'elpy-autoloads)


(defvar elpy-rpc--timeout)
(setq elpy-rpc--timeout 5)           ; new version is a bit slower than it was


(add-hook 'python-mode-hook 'my-elpy-mode-setup)
(add-hook 'pyvenv-post-activate-hooks 'elpy-rpc--disconnect)


;; (eval-after-load 'elpy
;;   '(elpy-use-ipython))


(defun python-shell-send-line-or-region (&optional num)
  "Sends either a line given by NUM or current line to Python shell."
  (interactive)
  (if (use-region-p)
      (progn
        (python-shell-send-region (region-beginning)
                                  (region-end)))
    (when num
      (goto-line num))
    (python-shell-send-region (line-beginning-position)
                              (line-end-position))))


(use-package flycheck-pycheckers
  :after flycheck)

(use-package flycheck
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-pycheckers-setup))

;; (global-flycheck-mode 1)


(defun my-elpy-mode-setup ()
  "Setting up Python things."

  (jedi:setup)
  (eldoc-mode 1)
  (elpy-mode)
  (flymake-mode -1)

  (setq ac-sources
        (-distinct (append '(ac-source-filename ac-source-jedi-direct)
                           ac-sources)))

  (define-key inferior-python-mode-map (kbd "C-c C-z") 'elpy-shell-switch-to-buffer)

  (local-set-key (kbd "<M-,>")  'pop-tag-mark)
  (local-set-key (kbd "C-x C-e")  'python-shell-send-line-or-region)
  (local-set-key (kbd "C-<return>")  'python-shell-send-line-or-region)

  ;; (setq ac-sources (cons 'ac-source-yasnippet ac-sources))
  (local-set-key (kbd "C-M->") 'python-indent-shift-right)
  (local-set-key (kbd "C-M-<") 'python-indent-shift-left)

  (define-key elpy-mode-map (kbd "<M-left>")  'backward-sexp) ;; 'python-nav-backward-sexp
  (define-key elpy-mode-map (kbd "<M-right>") 'forward-sexp) ;; 'python-nav-forward-sexp

  (define-key mode-specific-map (kbd "<prior>") 'python-nav-backward-up-list)
  (define-key mode-specific-map (kbd "C-<up>") 'python-nav-backward-up-list)
  ;; (define-key mode-specific-map (kbd "C-<up>") 'python-nav-backward-up-list)
  (define-key mode-specific-map (kbd "C-g") 'magit-status)

  (local-set-key (kbd "<M-up>")    'backward-quarter-page)
  (local-set-key (kbd "<M-down>")  'forward-quarter-page)

  (local-set-key (kbd "C-{") 'python-nav-backward-defun)
  (local-set-key (kbd "C-}") 'python-nav-forward-defun)
  )



(defconst venv-dir-names '(".venv" "venv" "env" ".env"))

(defun my-switch-venv (dir)
  (when dir
    (jedi:stop-server)
    (pyvenv-activate dir)
    (elpy-rpc-restart)
    (jedi:setup)
    dir))

(defun my-search-venv (dir)
  (let
      ((res (cl-loop for x in venv-dir-names
                     for p = (f-join dir x)
                     if (f-exists? p) return p)))
    (if res
        res
      (when (f-parent dir)
        (my-search-venv (f-parent dir))))))

;; (my-switch-venv (my-search-venv "/home/cji/projects/truststamp/naea/backend/corn/"))
;; (my-switch-venv (my-search-venv "/home/cji/priv/klibert_pl/build/"))


(defun aac ()
  (interactive)
  (let*
      ((buf-dir (-> (current-buffer) buffer-file-name f-parent))
       (env (-> buf-dir my-search-venv my-switch-venv)))
    (if env
        (message "Found env: %s; activated!" env)
      (message "Virtualenv not found!"))))
