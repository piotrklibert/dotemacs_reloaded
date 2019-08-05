(eval-when-compile
  (require 'use-package))

(load-many "~/.emacs.d/config/langs/lang-utils.el"
           "~/.emacs.d/config/langs/misc.el"
           "~/.emacs.d/config/langs/ac-elixir.el"
           "~/.emacs.d/config/langs/el.el"
           "~/.emacs.d/config/langs/io.el"
           "~/.emacs.d/config/langs/rkt.el"
           "~/.emacs.d/config/langs/txr.el"
           "~/.emacs.d/config/langs/cl.el"
           "~/.emacs.d/config/langs/erl.el"
           "~/.emacs.d/config/langs/elixir.el"
           "~/.emacs.d/config/langs/prolog.el"
           "~/.emacs.d/config/langs/c.el"
           "~/.emacs.d/config/langs/clj.el"
           "~/.emacs.d/config/langs/html.el"
           "~/.emacs.d/config/langs/python.el"
           "~/.emacs.d/config/langs/nim.el")

;; (message "2>>>>>>>>>>>>>>>> %s" (loop for x in auto-mode-alist
;;                                       when (s-contains? "rkt" (car x))
;;                                       collect x))
