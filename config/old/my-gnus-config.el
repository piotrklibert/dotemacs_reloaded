(require 'gnus)

;; Not really sure if it's needed?
(setq user-mail-address "piotrklibert@emailhosting.com"
      user-full-name "Piotr Klibert")


(setq gnus-select-method
      '(nnimap "main-mail"
               (nnimap-address "imap.mailanyone.net")
               (nnimap-server-port 993)
               (nnimap-stream ssl)))

(add-to-list 'gnus-secondary-select-methods
             '(nnimap "praca"
                      (nnimap-address "imap.gmail.com")
                      (nnimap-server-port 993)
                      (nnimap-stream ssl)))

;; Gmail's default groups match Gnus default ignored groups. This pattern does
;; not and so Gmail groups are visible.
(setq gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")

(setq send-mail-function 'smtpmail-send-it)
(setq message-send-mail-function 'smtpmail-send-it)

(setq smtpmail-smtp-server "smtp.mailanyone.net")
(setq smtpmail-default-smtp-server "smtp.mailanyone.net")
(setq smtpmail-smtp-service 2500)


;; http://groups.google.com/group/gnu.emacs.gnus/browse_thread/thread/a673a74356e7141f
(when window-system
  (setq gnus-sum-thread-tree-indent "  ")
  (setq gnus-sum-thread-tree-root "") ;; "● ")
  (setq gnus-sum-thread-tree-false-root "") ;; "◯ ")
  (setq gnus-sum-thread-tree-single-indent "") ;; "◎ ")
  (setq gnus-sum-thread-tree-vertical        "│")
  (setq gnus-sum-thread-tree-leaf-with-other "├─► ")
  (setq gnus-sum-thread-tree-single-leaf     "╰─► "))

(setq gnus-summary-line-format
      (concat
       "%0{%U%R%z%}"
       "%3{│%}" "%1{%d%}" "%3{│%}" ;; date
       "  "
       "%4{%-20,20f%}"               ;; name
       "  "
       "%3{│%}"
       " "
       "%1{%B%}"
       "%s\n"))

(setq gnus-group-line-format "%M%L%p%P%10R/%4T/%5y:     %B%(%g%)
")

(setq gnus-summary-display-arrow t)



(global-set-key (kbd "<f12>") 'my-toggle-gnus)

(defun my-toggle-gnus ()
  "Check if Gnus is running, start it if not, exit if it is."
  (interactive)
  (if (eq major-mode 'gnus-group-mode)
      (gnus-group-exit-noninteractive)
    (gnus)))

(defun gnus-group-exit-noninteractive ()
  (interactive)
  (let ((gnus-interactive-exit nil))
    (gnus-group-exit)))
