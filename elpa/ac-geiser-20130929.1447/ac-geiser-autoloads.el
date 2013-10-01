;;; ac-geiser-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads (ac-geiser-setup) "ac-geiser" "ac-geiser.el" (21065
;;;;;;  31016 0 0))
;;; Generated autoloads from ac-geiser.el

(defvar ac-source-geiser '((candidates . ac-source-geiser-candidates) (symbol . "g") (document . ac-geiser-documentation)) "\
Source for geiser completion")

(autoload 'ac-geiser-setup "ac-geiser" "\
Add the geiser completion source to the front of `ac-sources'.
This affects only the current buffer.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("ac-geiser-pkg.el") (21065 31016 354448
;;;;;;  825000))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; ac-geiser-autoloads.el ends here
