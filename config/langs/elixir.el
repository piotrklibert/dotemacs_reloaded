(require 'elixir-mode)                  ;

(defun my-elixir-hook ()
  (require 'alchemist))

(add-hook 'elixir-mode-hook  'my-elixir-hook)
