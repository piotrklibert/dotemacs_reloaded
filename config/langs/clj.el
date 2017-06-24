(require 'clojure-mode)
(require 'cider)
(require 'ac-cider)
(require 'slamhound)

(ac-cider-setup)

(defun my-clojure-hook ()
  (define-key mode-specific-map (kbd "n") 'slamhound)
  (paredit-mode 1))

(add-hook 'clojure-mode-hook 'my-clojure-hook)
(add-hook 'cider-repl-mode-hook 'my-clojure-hook)

(define-clojure-indent
  (throw-error-info 1)
  (match 1)
  (-> 1)
  (->> 1)
  (fact 1)
  (facts 1)
  )


(defun cider-quick-reconnect ()
  (interactive)
  (save-window-excursion
    (cider-connect "127.0.0.1" 12121)))

(setq cider-cljs-lein-repl
      "(do (require 'figwheel-sidecar.repl-api)
           (figwheel-sidecar.repl-api/start-figwheel!)
           (figwheel-sidecar.repl-api/cljs-repl))")
