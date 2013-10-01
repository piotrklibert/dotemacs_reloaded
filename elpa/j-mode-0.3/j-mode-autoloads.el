;;; j-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (j-shell j-mode) "j-mode" "j-mode.el" (20881 4126))
;;; Generated autoloads from j-mode.el

(autoload 'j-mode "j-mode" "\
Major mode for editing J files. This mode offers:

  1. syntax highlighting

  2. execution of J code:
     - \\[j-shell] to start J
     - \\[j-execute-buffer] to execute the whole buffer
     - \\[j-execute-explicit-definition] to execute the current explicit definition
     - \\[j-execute-region] to execute the active region
     - \\[j-execute-line] to execute the current line

  3. auto-indenting:
     - \\[newline-and-indent] to
     - \\[j-indent-line]
     - \\[indent-region]

  4. Jumping to definitions (via `imenu'), marking (\\[j-mark-defun])
     and moving up (\\[j-beginning-of-explicit-definition]) and down (\\[j-end-of-explicit-definition])
     explicit definitions.

  5. Access to online help (\\[j-describe-voc\\], `j-browse-help-foreign',
     `j-browse-help-vocabulary')

Summary of keybindings:
\\{j-mode-map}

\(fn)" t nil)

(autoload 'j-shell "j-mode" "\
Start the J interpreter.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("j-mode-pkg.el") (20881 4126 606606))

;;;***

(provide 'j-mode-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; j-mode-autoloads.el ends here
