(require 'clojure-mode)
(require 'cider)
(require 'slamhound)

(defun my-clojure-hook ()
  (define-key mode-specific-map (kbd "n") 'slamhound)
  (paredit-mode 1))

(add-hook 'clojure-mode-hook 'my-clojure-hook)
(add-hook 'cider-repl-mode-hook 'my-clojure-hook)

(define-clojure-indent
  (throw-error-info 1))


(defun cider-quick-reconnect ()
  (interactive)
  (save-window-excursion
    (cider-connect "127.0.0.1" 12121)))

;; (define-key clojure-mode-map (kbd "M-.") 'my-cider-goto-var)

;; (defun my-cider-goto-var () )

;; (cider-prompt-for-symbol)
