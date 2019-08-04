;; -*- lexical-binding: t -*-
;;
;; Emacs Lisp mode tweaks
;;

(require 'subr-x)
(require 'lang-utils)
(require 's)
(require 'flymake)
(require 'flycheck)
(require 'eshell)
(require 'paredit)


(indent/tag-for-modes
    '(lisp-indent-function)
  '((font-lock-add-keywords . 1)
    (run-at-time . 2)
    (define-frame-preference . 1)
    (run-with-timer . 2)
    (indent/tag-for-modes . 1)
    (propertize . 1)
    (font-lock-for-modes . 1)))


(font-lock-add-keywords 'emacs-lisp-mode
  `(("eval-after-load"           . font-lock-keyword-face)
    ("defstruct"                 . font-lock-keyword-face)
    ("\bfunctionp?"              . font-lock-keyword-face)
    ;(,(rx (or " ") "it" (or eow ")"))          . font-lock-builtin-face)
    ))

;; (font-lock-remove-keywords
;;  'emacs-lisp-mode
;;  '(("it" . font-lock-builtin-face)
;;    ("\bit[\b)]"          . font-lock-keyword-face)))

(define-key emacs-lisp-mode-map (kbd "C-c <left>") 'hs-toggle-hiding)


(defun my-interactive-byte-compile ()
  (interactive)
  (byte-compile-file (buffer-file-name)))

(defun my-eval-last-sexp (arg)
  (interactive "P")
  (cond
   ((not arg) (call-interactively 'eval-last-sexp))
   (t (call-interactively 'pp-eval-last-sexp))))



;;
;; Emacs Lisp hook
;;
(add-hook 'emacs-lisp-mode-hook 'my-elisp-mode-setup)
(add-hook 'inferior-emacs-lisp-mode-hook 'my-elisp-mode-setup) ; for ielm command

(defun my-elisp-mode-setup ()
  (paredit-mode 1)
  (delete 'elisp-flymake-checkdoc flymake-diagnostic-functions)
  (local-set-key (kbd "C-M-d") 'duplicate-line-or-region)

  (define-key mode-specific-map (kbd "C-d") 'describe-function)
  (define-key mode-specific-map (kbd "d")   'describe-function)
  (define-key mode-specific-map (kbd "C-b") 'my-interactive-byte-compile)
  (define-key mode-specific-map (kbd "C-j") 'eval-print-last-sexp)
  (define-key mode-specific-map (kbd "C-f") 'find-function)

  (define-key paredit-mode-map (kbd "M-S-<left>")  'backward-word)
  (define-key paredit-mode-map (kbd "M-?")         'paredit-convolute-sexp)
  (define-key paredit-mode-map (kbd "M-S-<right>") 'forward-word)
  (define-key paredit-mode-map (kbd "C-c C-j")     'eval-print-last-sexp)
  (define-key paredit-mode-map (kbd "C-M-d")       'duplicate-line-or-region)

  (global-set-key [remap eval-last-sexp] 'my-eval-last-sexp)
  (flycheck-mode -1))



;;
;; Eshell hook
;;
(require 'esh-mode)
(add-hook 'eshell-mode-hook 'my-eshell-hook)
(defun my-eshell-hook ()
  (define-key eshell-mode-map (kbd "C-v") 'eshell-kill-input)
  (define-key eshell-mode-map (kbd "<up>") 'previous-line)
  (define-key eshell-mode-map (kbd "<down>") 'next-line)
  (define-key eshell-mode-map [remap kill-whole-line] 'eshell-kill-input))


;; (require 'subr-x)
;; (require 'cl-lib)

;; (defun my-get-subdirs (dir)
;;   (let*
;;       ((entries (directory-files dir))
;;        (dirs (cl-remove-if (lambda (z)
;;                              (or (not (file-directory-p
;;                                        (string-join (list dir z))))
;;                                  (member z '("." ".."))))
;;                            entries)))
;;     (mapcar (lambda (x) (string-join (list dir x))) dirs)))
;; (my-get-subdirs "/home/cji/")
;; (defun add-subdirs-to-path (&rest dirs)
;;   "Add given directory and all it's (immediate) subdirectories to load-path."
;;   (declare (indent 0))
;;   (dolist (dir dirs)
;;     (let ((dir (expand-file-name dir)))
;;       ;; (message "%s" dir)
;;       (add-to-list 'load-path dir)
;;       (cl-loop for d in (my-get-subdirs dir)
;;                do (add-to-list 'load-path d)))))

(defun pp-to-cmd (obj)
  (let ((s (->> (pp-to-string obj)
             (s-replace "\n" ""))))
   (replace-regexp-in-string (rx (1+ " ")) " " s t t)))


(defun elisp-flymake-byte-compile (report-fn &rest _args)
  "A Flymake backend for elisp byte compilation.
Spawn an Emacs process that byte-compiles a file representing the
current buffer state and calls REPORT-FN when done."
  (when elisp-flymake--byte-compile-process
    (when (process-live-p elisp-flymake--byte-compile-process)
      (kill-process elisp-flymake--byte-compile-process)))
  (let ((temp-file (make-temp-file "elisp-flymake-byte-compile"))
        (source-buffer (current-buffer)))
    (save-restriction
      (widen)
      (write-region (point-min) (point-max) temp-file nil 'nomessage))
    (let*
        ((output-buffer (generate-new-buffer " *elisp-flymake-byte-compile*"))
         (eval-str (pp-to-cmd
                    '(progn
                       (load "/home/cji/.emacs.d/config/my-packages-utils.el")
                       (add-subdirs-to-path
                         "~/.emacs.d/plugins/"
                         "~/.emacs.d/forked-plugins/"
                         "~/.emacs.d/plugins2/"
                         "~/.emacs.d/pkg-langs/"
                         "~/.emacs.d/elpa/")
                       (require 'use-package))))
         (cmd (list (expand-file-name invocation-name invocation-directory)
                    "-Q"
                    "--batch"
                    ;; "--eval" "(setq load-prefer-newer t)" ; for testing
                    "--eval" eval-str
                    "-L" default-directory
                    "-f" "elisp-flymake--batch-compile-for-flymake"
                    temp-file)))
      ;; (message "%s" eval-str)
      (setq
       elisp-flymake--byte-compile-process
       (make-process
        :name "elisp-flymake-byte-compile"
        :buffer output-buffer
        :command cmd
        :connection-type 'pipe
        :sentinel
        (lambda (proc _event)
          (when (eq (process-status proc) 'exit)
            (unwind-protect
                (cond
                 ((not (and (buffer-live-p source-buffer)
                            (eq proc (with-current-buffer source-buffer
                                       elisp-flymake--byte-compile-process))))
                  (flymake-log :warning
                               "byte-compile process %s obsolete" proc))
                 ((zerop (process-exit-status proc))
                  (elisp-flymake--byte-compile-done report-fn
                                                    source-buffer
                                                    output-buffer))
                 (t
                  (funcall report-fn
                           :panic
                           :explanation
                           (format "byte-compile process %s died" proc))))
              (ignore-errors (delete-file temp-file))
              ;; (kill-buffer output-buffer)
              )))))
      :stderr null-device
      :noquery t)))
