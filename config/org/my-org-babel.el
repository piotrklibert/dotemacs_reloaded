(require 's)
(require 'ox-html)
(require 'ob-tangle)


(setq org-babel-load-languages
      (cl-loop for lang in '(emacs-lisp python js shell scheme io)
               collect (cons lang t)))

(eval-after-load "org"
  '(progn
     (require 'ob-ls)
     (add-to-list 'org-src-lang-modes '("ls" . livescript))))

(eval-after-load "org"
  '(setq org-babel-default-header-args
         (append `((:noweb . "yes")
                   (:eval . "no-export")
                   (:tangle-mode . ,(identity #o755)))
                 (->> org-babel-default-header-args
                   (assq-delete-all :noweb)
                   (assq-delete-all :eval)
                   (assq-delete-all :tangle-mode)))))

(defun export-lightcorn-docs ())
(defun export-lightcorn-docs-1 ()
  (interactive)
  (let ((fname (buffer-file-name)))
    (when (and (s-contains-p "lightcorn/docs" fname)
               (s-ends-with-p ".org" fname))
      ;; force Org to format dates properly
      (let ((system-time-locale "en_GB.utf8"))
        (org-html-export-to-html)
        (org-babel-tangle)
        (letf
            ((default-directory "/home/cji/projects/lightcorn/docs/"))
          (shell-command "scp ./index.html vps:www/statics/lc.html"))))))

(add-hook 'after-save-hook 'export-lightcorn-docs)

(require 'org)

(setf org-link-parameters (assq-delete-all "elisp-symbol" org-link-parameters))

;; (pp org-link-parameters)
(org-link-set-parameters "defun"
 :store 'org-defun-store-link
 :follow 'org-defun-open)

(defun org-defun-open (link)
  (find-function-other-window  (intern link)))

(defun org-defun-store-link ()
  (when (eq major-mode 'emacs-lisp-mode)
    (let ((fname (save-excursion
                   (forward-line 1)
                   (re-search-backward "^ *\(defun +\\\(.*?\\\) ")
                   (match-string-no-properties 1))))

      (org-store-link-props
       :type "defun"
       :link (concat "defun:" fname)
       :description fname)))
)


;; (setq org-html-htmlize-output-type 'inline-css)
;; (setq org-html-htmlize-font-prefix "")

(provide 'my-org-babel)
