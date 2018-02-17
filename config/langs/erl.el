;;
;; Erlang and Distel (Erlang shell integration) config
;;
(defun my-erlang-newline ()
  (interactive)
  (erlang-electric-newline)
  (erlang-indent-line))

(defun my-erlang-mode-hook ()
  (linum-mode t)
  (require 'distel)
  (distel-setup))

(use-package erlang
  :mode ("\\.\\(erl\\|hrl\\)\\'" . erlang-mode)
  :load-path "~/.emacs.d/pkg-langs/distel/elisp/"
  :config
  (define-key erlang-mode-map (kbd "") 'my-erlang-newline)
  (add-hook 'erlang-mode-hook 'my-erlang-mode-hook)
  (add-to-list 'ac-modes 'erlang-mode))
