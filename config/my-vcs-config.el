(require 'git)
(require 'git-blame)

(require 'magit)
(require 'magit-blame)

(define-key magit-mode-map    (kbd "C-w")  my-wnd-keys)
(define-key mode-specific-map (kbd "C-g") 'magit-status)     ; C-c C-g
