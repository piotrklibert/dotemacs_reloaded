;;; fsharp-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads (fsharp-mode) "fsharp-mode" "fsharp-mode.el" (21135
;;;;;;  31144 0 0))
;;; Generated autoloads from fsharp-mode.el

(add-to-list 'auto-mode-alist '("\\.fs[iylx]?$" . fsharp-mode))

(autoload 'fsharp-mode "fsharp-mode" "\
Major mode for editing fsharp code.

\\{fsharp-mode-map}

\(fn)" t nil)

;;;***

;;;### (autoloads (run-fsharp) "inf-fsharp-mode" "inf-fsharp-mode.el"
;;;;;;  (21135 31144 0 0))
;;; Generated autoloads from inf-fsharp-mode.el

(autoload 'run-fsharp "inf-fsharp-mode" "\
Run an inferior fsharp process.
Input and output via buffer `*inferior-fsharp*'.

\(fn &optional CMD)" t nil)

;;;***

;;;### (autoloads nil nil ("fsharp-doc.el" "fsharp-mode-completion.el"
;;;;;;  "fsharp-mode-font.el" "fsharp-mode-indent.el" "fsharp-mode-pkg.el")
;;;;;;  (21135 31144 264456 402000))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; fsharp-mode-autoloads.el ends here
