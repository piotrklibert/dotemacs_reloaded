;; Emacs IPython Notebook
;; (require 'ein)
;; (setq ein:use-auto-complete t)

(require 'python-django-autoloads)

(require 'jedi-autoloads)
(eval-after-load 'jedi
  '(progn
     (require 'jedi-direx)
     (add-hook 'jedi-mode-hook 'jedi-direx:setup)))


(require 'elpy-autoloads)
(setq elpy-rpc--timeout 5)           ; new version is a bit slower than it was
(add-hook 'python-mode-hook 'my-elpy-mode-setup)
(add-hook 'pyvenv-post-activate-hooks 'elpy-rpc--disconnect)

(defun my-elpy-mode-setup ()
  (jedi:setup)
  (eldoc-mode 1)
  (elpy-mode)
  (setq ac-sources
        (-distinct (append '(ac-source-filename ac-source-jedi-direct)
                           ac-sources)))

  (define-key inferior-python-mode-map (kbd "C-c C-z") 'elpy-shell-switch-to-buffer)
  (define-key elpy-mode-map (kbd "<M-right>") nil)
  (define-key elpy-mode-map (kbd "<M-left>")  nil)
  (define-key elpy-mode-map (kbd "<M-up>")    nil)
  (define-key elpy-mode-map (kbd "<M-down>")  nil)

  (local-set-key (kbd "<M-,>")  'pop-tag-mark)

  ;; (setq ac-sources (cons 'ac-source-yasnippet ac-sources))
  (local-set-key (kbd "C-M->") 'python-indent-shift-right)
  (local-set-key (kbd "C-M-<") 'python-indent-shift-left)

  (local-set-key (kbd "M-{") 'python-nav-backward-block)
  (local-set-key (kbd "M-}") 'python-nav-forward-block)

  (local-set-key (kbd "C-{") 'python-nav-backward-defun)
  (local-set-key (kbd "C-}") 'python-nav-forward-defun))



(eval-after-load 'elpy
  '(elpy-use-ipython))


(defconst venv-dir-names
  '(".venv" "venv" "env" ".env"))

(defun my-switch-venv (dir)
  (when dir
    (jedi:stop-server)
    (pyvenv-activate dir)
    (elpy-rpc-restart)
    (jedi:setup)
    dir))

(defun my-search-venv (dir)
  (let
      ((res (loop for x in venv-dir-names
                  for p = (f-join dir x)
                  if (f-exists? p) return p)))
    (if res
        res
      (when (f-parent dir)
        (my-search-venv (f-parent dir))))))

;; (my-switch-venv (my-search-venv "/home/cji/projects/truststamp/naea/backend/corn/"))
;; (my-switch-venv (my-search-venv "/home/cji/poligon/mangi/manga/"))

(defun aac ()
  (interactive)
  (let*
      ((buf-dir (-> (current-buffer) buffer-file-name f-parent))
       (env (-> buf-dir my-search-venv my-switch-venv)))
    (if env
        (message "Found env: %s" env)
      (message "Virtualenv not found!"))))
