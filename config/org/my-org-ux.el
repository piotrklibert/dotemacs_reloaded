(require 'my-ox-html-styles)

(use-package org
  :commands org-mode orgtbl-mode org-capture
  :bind (("C-c c" . org-capture)
         ("C-c l" . org-store-link)
         ("C-c C-l" . org-insert-link))

  :config
  (require 'org-table)
  (require 'org-agenda)
  (require 'org-tempo)
  (require 'org-goto)

  ;; format: [[elisp-symbol:path::symbol]]
  (require 'ol-elisp-symbol)
  (require 'ox-md)
  (require 'ox-html)
  (require 'ob-shell)

  (require 'helm-org)
  (require 'helm-occur)

  (require 'my-org-babel)
  (require 'my-org-custom-id)

  )


(defun my-org-clear-subtree ()
  (interactive)
  (org-mark-subtree) ;; mark the current subtree
  (kill-region (region-beginning) (region-end))) ;; delete the rest


(defun my-org-fold-current ()
  (interactive)
  (unless (save-excursion
            (goto-char (line-beginning-position))
            (looking-at (rx bol (1+ ?*) " ")))
    (org-previous-visible-heading 1))
  (outline-hide-subtree))

(defun my-org-show-next-heading-tidily ()
  "Show next entry, keeping other entries closed."
  (interactive)
  (if (save-excursion (end-of-line) (outline-invisible-p))
      (progn (org-show-entry) (outline-show-children))
    (outline-next-heading)
    (unless (and (bolp) (org-at-heading-p))
      (org-up-heading-safe)
      (outline-hide-subtree)
      (error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (outline-show-children)))

(defun my-org-show-previous-heading-tidily ()
  "Show previous entry, keeping other entries closed."
  (interactive)
  (let ((pos (point)))
    (outline-previous-heading)
    (unless (and (< (point) pos) (bolp) (org-at-heading-p))
      (goto-char pos)
      (outline-hide-subtree)
      (error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (outline-show-children)))

(defun my-org-show-current-heading-tidily ()
  "Show next entry, keeping other entries closed."
  (interactive)
  (if (save-excursion (end-of-line) (outline-invisible-p))
      (progn
        (message "invis")
        (org-show-entry)
        (outline-show-subtree))
    (message "visible")
    (outline-back-to-heading)
    (unless (and (bolp) (org-at-heading-p))
      (org-up-heading-safe)
      (outline-hide-subtree)
      (error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (outline-show-subtree)
    (recenter)))


(declare-function my-split-window-below "my-windows-config")

(defun my-open-notes ()
  (interactive)
  (my-split-window-below)
  (find-file (expand-file-name "~/todo/nowe.org")))

(global-set-key (kbd "C-c r") #'my-open-notes)


(defun my-org-jump-to-heading (heading)
  (interactive
   (list (completing-read "Value: "
                          (mapcar 'list (org-property-values "CUSTOM_ID")))))
  (org-match-sparse-tree nil (concat "CUSTOM_ID=\"" heading "\"")))


(defun swap-cells ()
  (interactive)
  (org-table-previous-field)
  (let
      ((val (org-table-get-field nil "")))
    (org-table-next-field)
    (insert val)
    (org-table-recalculate)))


(defun my-org-occur-headers ()
  "Preconfigured Occur for Org headers."
  (interactive)
  (let* ((helm-org-show-filename t)
         (bufs (org-buffer-list))
         (heading-source (helm-make-source "Org Headings"
                             'helm-org-headings-class
                           :filtered-candidate-transformer 'helm-org-startup-visibility
                           :parents nil
                           :follow 1
                           :requires-pattern 2
                           :candidates bufs))
         (occur-sources (helm-occur-build-sources bufs)))
    (helm-set-local-variable 'helm-occur--buffer-list bufs
                             'helm-occur--buffer-tick (mapcar 'buffer-chars-modified-tick bufs))
    (helm :sources (cons heading-source occur-sources)
          :candidate-number-limit helm-occur-candidate-number-limit
          :preselect (helm-org-in-buffer-preselect)
          :truncate-lines helm-org-truncate-lines
          :buffer "*helm org inbuffer*")))


(require 'browse-url)



;; (org-clock-persistence-insinuate)

;; More example capture templates:
;; ("r" "respond" entry (file "~/todo/refile.org")
;;  "* NEXT Respond to %:from on %:subject SCHEDULED: %t %U %a "
;;  :clock-in t :clock-resume t :immediate-finish t)
;; ("j" "Journal" entry (file+datetree "~/todo/notes.org")
;;  (jl "* %?" "  %U" "") :clock-in t :clock-resume t)
;; ("m" "Meeting" entry (file "~/todo/refile.org")
;;  "* MEETING with %? :MEETING: %U" :clock-in t :clock-resume t)
;; ("p" "Phone call" entry (file "~/todo/refile.org")
;;  "* PHONE %? :PHONE: %U" :clock-in t :clock-resume t)
;; ("h" "habit" entry (file "~/todo/refile.org")
;;  (jl "* NEXT %?"
;;      "  :PROPERTIES:"
;;      "  :STYLE: habit"
;;      "  :REPEAT_TO_STATE: NEXT"
;;      "  :END:"
;;      "  SCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")"
;;      "  %U"
;;      "  %a"))

;;
;; Special properties - for display in column view, clock reports, agenda:
;;
;; ‘ALLTAGS’	All tags, including inherited ones.
;; ‘BLOCKED’	t if task is currently blocked by children or siblings.
;; ‘CATEGORY’	The category of an entry.
;; ‘CLOCKSUM’	The sum of CLOCK intervals in the subtree. org-clock-sum
;;              must be run first to compute the values in the current buffer.
;; ‘CLOCKSUM_T’	The sum of CLOCK intervals in the subtree for today.
;; 	            org-clock-sum-today must be run first to compute the
;; 	            values in the current buffer.
;; ‘CLOSED’	    When was this entry closed?
;; ‘DEADLINE’	The deadline time string, without the angular brackets.
;; ‘FILE’	    The filename the entry is located in.
;; ‘ITEM’	    The headline of the entry.
;; ‘PRIORITY’	The priority of the entry, a string with a single letter.
;; ‘SCHEDULED’	The scheduling timestamp, without the angular brackets.
;; ‘TAGS’	    The tags defined directly in the headline.
;; ‘TIMESTAMP’	The first keyword-less timestamp in the entry.
;;
;; NOTE: My "Added: [timestamp]" is in this TIMESTAMP_IA category
;; ‘TIMESTAMP_IA’	The first inactive timestamp in the entry.
;;
;; ‘TODO’	The TODO keyword of the entry.


(defvar alchemist-mode-map)
(eval-after-load "alchemist"
  '(define-key alchemist-mode-map (kbd "C-c c") 'org-capture))

;; org-goto-interface
;; org-goto-auto-isearch
;; helm-org-in-buffer-headings

(eval-after-load "org"
  '(add-hook 'org-mode-hook 'my-org-hook))

(defun my-in-regexp (regexp)
  (catch :exit
    (let ((pos (point))
          (eol (line-end-position)))
      (save-excursion
	    (beginning-of-line)
	    (while (and (re-search-forward regexp eol t)
		            (<= (match-beginning 0) pos))
	      (when (>= (match-end 0) pos)
	        (throw :exit t)))))))

(defconst my-noweb-ref-re (rx (seq "=<"
                                   (group (1+ (in alnum "-")))
                                   (? "(" (0+ any) ")")
                                   ">=")))

(cl-defun my-org-goto-def ()
  (interactive)
  (save-match-data
    (when (my-in-regexp my-noweb-ref-re)
      (org-babel-goto-named-src-block (match-string-no-properties 1))
      (recenter)
      (cl-return-from my-org-goto-def)))

  (org-open-at-point))

;; (defalias 'org-reveal 'my-org-show-context)
(require 'hydra)
(defhydra hydra-org-jump ()
  "jump"
  ("<up>" my-org-show-previous-heading-tidily "prev")
  ("<down>" my-org-show-next-heading-tidily "next"))


(defun my-org-ring-goto ()
  (interactive)
  (org-mark-ring-goto)
  (recenter))

(defun my-org-hook ()
  (define-key org-mode-map (kbd "<return>")     'org-return-indent)
  (define-key org-mode-map (kbd "C-j")          'org-return)

  (define-key org-mode-map (kbd "M-,")          'my-org-ring-goto)
  (define-key org-mode-map (kbd "M-.")          'my-org-goto-def)

  (define-key org-mode-map (kbd "C-c <up>")     'org-previous-visible-heading)
  (define-key org-mode-map (kbd "C-c <down>")   'org-next-visible-heading)

  (define-key org-mode-map (kbd "C-c C-<up>")   'org-backward-heading-same-level)
  (define-key org-mode-map (kbd "C-c C-<down>") 'org-forward-heading-same-level)

  (define-key org-mode-map (kbd "<backtab>")    'my-org-fold-current)

  (define-key org-mode-map (kbd "s-c")          'my-tangle-and-run)

  (define-key org-mode-map (kbd "C-f C-m")      'my-org-occur-headers)

  (define-key org-mode-map (kbd "C-c a")        'org-agenda)
  (define-key org-mode-map (kbd "C-c l")        'org-store-link)
  (define-key org-mode-map (kbd "C-c +")        'hydra-zoom/text-scale-increase)
  (define-key org-mode-map (kbd "C-c -")        'hydra-zoom/text-scale-decrease)
  (define-key org-mode-map (kbd "C-c =")        'hydra-zoom/body)

  (define-key org-mode-map (kbd "C-c M-=")      'my-org-show-current-heading-tidily)
  (define-key org-mode-map (kbd "C-c M-<up>")   'hydra-org-jump/my-org-show-prev-heading-tidily)
  (define-key org-mode-map (kbd "C-c M-<down>") 'hydra-org-jump/my-org-show-next-heading-tidily)

  ;; KILL, CUT & COPY whole subtrees
  ;; (define-key org-mode-map (kbd "C-c C-k")      'my-org-clear-subtree) - Org uses C-c C-k to dismiss/close dialogs
  (define-key org-mode-map (kbd "C-c C-M-w")    'my-org-clear-subtree)

  (define-key org-mode-map (kbd "C-c M-w")      (lambda ()
                                                  (interactive)
                                                  (read-only-mode 1)
                                                  (ignore-errors
                                                    (my-org-clear-subtree))
                                                  (read-only-mode 0)
                                                  (message "Subtree copied"))))
