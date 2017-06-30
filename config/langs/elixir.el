(require 'elixir-mode-autoloads)                  ;

(defun my-elixir-hook ()
  (require 'alchemist))
(eval-after-load 'elixir-mode
  '(add-hook 'elixir-mode-hook  'my-elixir-hook))
