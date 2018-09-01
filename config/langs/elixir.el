(eval-when-compile
  (require 'use-package))


(use-package alchemist
  :commands alchemist-mode)

(ac-define-source filtered-words-in-same-mode-buffers
  '((init . ac-update-word-index)
    (candidates . (->> (ac-word-candidates
                        (lambda (buffer)
                          (derived-mode-p (buffer-local-value 'major-mode buffer))))
                    (-filter (lambda (word)
                               (not (s-contains? "end" (s-downcase word)))))))))

(defun my-elixir-dialyzer-run ()
  (interactive)
  (save-buffer)
  (alchemist-report-run
   "mix dialyzer" "*dialyzer*" alchemist-mix-buffer-name 'alchemist-mix-mode
   (lambda (status buffer)
     (with-current-buffer buffer
       (goto-char 1)
       (read-only-mode -1)
       (search-forward "done in")
       ;; (delete-region 1 (point)))
       (delete-region 1 (line-beginning-position)))
       (read-only-mode 1)
     (alchemist-mix-display-mix-buffer)
     (message "Finito!"))
   t))

(defun my-elixir-init ()
  (alchemist-mode)
  (setf ac-sources '(ac-source-alchemist
                     ac-source-filename
                     ac-source-abbrev
                     ac-source-semantic
                     ac-source-yasnippet
                     ac-source-filtered-words-in-same-mode-buffers))
  (auto-complete-mode t)

  ;; (define-key elixir-mode-map (kbd "<tab>") 'ac-start)
  (define-key alchemist-iex-mode-map (kbd "<tab>") 'ac-start)

  (define-key elixir-mode-map (kbd "C-c d") 'alchemist-help-search-at-point)
  (define-key elixir-mode-map (kbd "C-c c") 'alchemist-iex-compile-this-buffer)
  (define-key elixir-mode-map (kbd "C-c z") 'my-elixir-dialyzer-run)
  (define-key elixir-mode-map (kbd "C-c C-z") 'my-elixir-dialyzer-run)

  (define-key alchemist-iex-mode-map (kbd "C-c d") 'alchemist-help-search-at-point)


  (setq alchemist-goto-erlang-source-dir "/home/cji/portless/otp_src_20.3/")
  (setq alchemist-goto-elixir-source-dir "/home/cji/portless/elixir/"))


(use-package elixir-mode
  :mode  "\\.exs?\\'"
  :config
  (add-hook 'elixir-mode-hook #'my-elixir-init)
  (add-hook 'alchemist-iex-mode-hook #'my-elixir-init))
