
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; quickly opening buffers of some kind (for scribbling) with key bindings
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar my-openers (list))
(defvar my-new-buffer-map (make-sparse-keymap))

(defmacro make-buffer-opener (name key ext path)
  (let*
      ((name (symbol-name name))
       (defun-name (intern (concat "my-new-" name "-buffer")))
       (mode-name (intern (concat name "-mode"))))
    `(progn
       (defun ,defun-name (&optional arg)
         (interactive "P")
         (let
             ((switcher (if (not arg) 'switch-to-buffer-other-window)))
           (funcall switcher ,(concat name "1" ext))
           (,mode-name)
           (cd ,path)))
       (define-key my-new-buffer-map ,key ',defun-name)
       (push '(,name .  ,defun-name) my-openers)
       nil)))

;;                  type            key       file ext     default path
(make-buffer-opener text         (kbd "C-n")    ".txt"     "~/poligon/")
(make-buffer-opener sh           (kbd "C-s")    ".sh"      "~/poligon/")
(make-buffer-opener python       (kbd "C-p")    ".py"      "~/poligon/python/")
(make-buffer-opener livescript   (kbd "C-j")    ".ls"      "~/poligon/lscript/")
(make-buffer-opener org          (kbd "C-o")    ".org"     "~/todo/")
(make-buffer-opener artist       (kbd "C-a")    ".txt"     "~/poligon/")
(make-buffer-opener racket       (kbd "C-r")    ".rkt"     "~/poligon/rkt/")
(make-buffer-opener emacs-lisp   (kbd "C-l")    ".el"      "~/.emacs.d/config/")
(make-buffer-opener erlang       (kbd "C-o")    ".erl"     "~/poligon/")
(make-buffer-opener elixir       (kbd "C-x")    ".ex"      "~/poligon/")
(make-buffer-opener ocaml        (kbd "C-m")    ".ml"      "~/poligon/")
;; (make-buffer-opener ocaml        (kbd "C-m")    ".ml"      "~/poligon/")

(defvar my-new-buffer-helm-source
  `((name       . "Buffer types")
    (candidates . ,my-openers)
    (action     . (lambda (candidate) (funcall candidate)))))

(defun my-new-buffer-helm ()
  (interactive)
  (helm :sources '(my-new-buffer-helm-source)))

(provide 'my-new-buffers)
