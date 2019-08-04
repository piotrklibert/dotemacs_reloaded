;; (require 'rx)
;; (require 'auto-complete)

;; (defalias 'ap 'apply-partially)

;; (defconst txr-sample "
;; @(define x (y))
;; @(bind y @(flatten
;;            (mapcar
;;             [chain cdr package-symbols]
;;             (package-alist))))
;; @(end)
;; @(x z)
;; @(output)
;; @(rep)@z @(end)
;; @()
;; @(end)
;; ")

;; (setq txr-docs
;;       (with-temp-buffer
;;         (insert-file "/home/cji/poligon/txr-mode/txr-docs/txr-mode-docs.el")
;;         (beginning-of-buffer)
;;         (read (current-buffer))))


;; (defun ac-source-txr-candidates ()
;;   txr-mode-keywords)

;; (defun txr-document-symbol (symbol)
;;   (let ((x (assoc (or (and (stringp symbol) symbol)
;;                       (symbol-name symbol))
;;                   txr-docs)))
;;     (when x
;;       (concat "    " (nth 2 x) "\n\n" (nth 3 x)))))


;; (defconst ac-source-txr
;;   `((candidates . ac-source-txr-candidates)
;;     (document . txr-document-symbol)))


;; (defconst txr-mode-quoted-string-re
;;   (rx
;;    (group
;;     (or  (char ?\")
;;          (char ?`))
;;     (minimal-match
;;      (zero-or-more
;;       (or (seq ?\\ ?\\)
;;           (seq ?\\ ?\")
;;           (seq ?\\ (not (any ?\" ?\\)))
;;           (not (any ?\" ?\\)))))
;;     (or (char ?\")
;;         (char ?`)))))


;; (defconst txr-mode-regexp-re
;;   (rx
;;    (group
;;     "/"
;;     (minimal-match (zero-or-more
;;                     (not (any "/"))))
;;     "/")))


;; (defconst get-symbols-txr
;;   '(prinl
;;     (flatten
;;      (mapcar [chain cdr package-symbols]
;;              (package-alist)))))

;; (defconst get-symbols-command
;;   (concat "txr -e " (format "'%s'" get-symbols-txr)))

;; (defun txr-sort-keywords (keywords)
;;   (sort keywords
;;         (lambda (a b)
;;           (> (length a) (length b)))))

;; (defconst txr-mode-keywords
;;   (let
;;       ((txr-symbols (shell-command-to-string get-symbols-command))
;;        (extra-keywords '(out output chain repeat rep end collect col rep repeat)))
;;     (->> (read txr-symbols)
;;       (append extra-keywords)
;;       (mapcar (ap 'format "%s"))
;;       txr-sort-keywords)))

;; (defconst txr-mode-builtins-re
;;   (let
;;       ((keyword-regexps (--map (concat "\\<" it "\\>") txr-mode-keywords)))
;;     (concat "\\(" (s-join "\\|" keyword-regexps) "\\)")))


;; (defconst txr-mode-comment-re
;;   (rx
;;    (group
;;     (seq "@;"
;;          (minimal-match
;;           (one-or-more any))
;;          line-end))))


;; (defconst txr-mode-var-re
;;   (rx
;;    (seq "@" (optional "{")
;;         (group
;;          (one-or-more (any alnum "_")))
;;         (or "}" eow))))


;; (defconst txr-mode-kwargs-re
;;   (rx (group ":"(one-or-more alphanumeric))))


;; (defconst txr-font-lock-keywords
;;   (list
;;    (list txr-mode-quoted-string-re   1 font-lock-string-face)
;;    (list txr-mode-regexp-re          1 font-lock-string-face)
;;    (list txr-mode-var-re             1 font-lock-constant-face)
;;    (list txr-mode-comment-re         1 font-lock-comment-face)
;;    (list txr-mode-builtins-re        1 font-lock-keyword-face)
;;    (list txr-mode-kwargs-re          1 font-lock-constant-face)))

;; (defun txr--insert-at ()
;;   (interactive)
;;   (insert "@()")
;;   (backward-char))

;; (define-derived-mode txr-mode lisp-mode "TXR"
;;   "Major mode for editing TXR scripts"
;;   (modify-syntax-entry ?@ " " txr-mode-syntax-table)
;;   (modify-syntax-entry ?[ "(" txr-mode-syntax-table)
;;   (modify-syntax-entry ?] ")" txr-mode-syntax-table)
;;   (define-key txr-mode-map (kbd "@") 'txr--insert-at)
;;   (set (make-local-variable 'font-lock-defaults)
;;        '(txr-font-lock-keywords t))
;;   (add-to-list 'ac-sources 'ac-source-txr))


;; ;;;###autoload
;; (add-to-list 'auto-mode-alist '("\\.txr$" . txr-mode))


;; (provide 'txr-mode)
;; ;;; txr-mode.el ends here
