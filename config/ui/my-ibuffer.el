;; -*- mode: emacs-lisp -*-
(require 'ibuffer)

(defun ibuffer-end ()
  (interactive)
  (goto-char (point-max))
  (forward-line -1)
  (ibuffer-skip-properties '(ibuffer-summary ibuffer-filter-group-name) -1))

(defun ibuffer-beginning ()
  (interactive)
  (goto-char (point-min))
  (ibuffer-skip-properties '(ibuffer-title ibuffer-filter-group-name) 1))


(defun my-ibuffer-diff-with-file ()
  "Same as original but in new window"
  (interactive)
  (letf
      ;; replace
      (((symbol-function 'switch-to-buffer)
        (symbol-function 'switch-to-buffer-other-window)))
    (ibuffer-diff-with-file)))


(defun my-ibuffer-mode-hook ()
  "Customized/added in ibuffer-mode-hook custom option."
  ;; see also ibuffer-formats for columns config
  (define-key ibuffer-mode-map (kbd "M-f")    'ibuffer-jump-to-buffer) ; TODO: use HELM here!!
  (define-key ibuffer-mode-map (kbd "<down>") 'ibuffer-forward-line)
  (define-key ibuffer-mode-map (kbd "<up>")   'ibuffer-backward-line)
  (define-key ibuffer-mode-map (kbd "=")   'my-ibuffer-diff-with-file)

  ;; (define-key ibuffer-mode-map (kbd "C-/")    nil)
  (define-key ibuffer-mode-map (kbd "/")      'my-hydra-ibuffer-filters/body)
  (define-key ibuffer-mode-map (kbd "m")      'hydra-ibuffer-marking/ibuffer-mark-forward)
  (define-key ibuffer-mode-map (kbd ".")      'hydra-ibuffer-marking/body)
  (define-key ibuffer-mode-map (kbd "*")      'hydra-ibuffer-marking/body)

  (define-key ibuffer-mode-map (kbd "<insert>") 'ibuffer-mark-forward)

  (define-key ibuffer-mode-map [remap beginning-of-buffer] 'ibuffer-beginning)
  (define-key ibuffer-mode-map [remap end-of-buffer] 'ibuffer-end)

  (wrap-region-mode 0)                 ; made ibuffer filtering keys unavailable
  (hl-line-mode)                       ; TODO: change to more contrasting color
  )

;; ===============================================================================

(defun my-ibuffer-mark-special-buffers ()
  "Mark all buffers whose name begins and ends with `*'."
  (interactive)
  (ibuffer-mark-on-buffer
   #'(lambda (buf)
       (and (string-match "^\\*.+\\*$" (buffer-name buf))
            (not (-contains? '("*Ibuffer*" "*scratch*" "*Messages*" "*info*" "*elscreen-tabs*")
                             (buffer-name buf)))))))

(defhydra hydra-ibuffer-marking (:hint nil)
  "
Basic selection            ^^| Toggles             ^^^^^^^^^^^^^^^^^^^ | Searches
---------------------------^^+---------------------^^^^^^^^^^^^^^^^^^^-+---------------------------------
_m_: mark current            |  _s_: special       ^^^^^^^^^^^^^^^^^   |  _n_: by buffer name (regexp) | _d_: mark for deletion
_u_: unmark current          |  _e_: without file  ^^^^^^^^^^^^^^^^^   |  _f_: by filename (regexp)
_<backspace>_: unmark prev   |  _u_: unsaved       ^^^^^^^^^^^^^^^^^   |  _g_: by content (regexp)
_c_: clear all               |  _r_: read-only     ^^^^^^^^^^^^^^^^^   |  _M_: by major mode (regexp)
_t_: reverse selection       |  _._: older than %`ibuffer-old-time h
---------------------------------------------------------------------------------------------------------
"
  ;; _* /_: Mark buffers in `dired-mode'.
  ;; _* h_: Mark buffers in `help-mode', `apropos-mode', etc.
  ;; _L_: Mark all locked buffers.
  ;; _* c_: Change the mark used on marked buffers.
  ("m" ibuffer-mark-forward)
  ("d" ibuffer-mark-for-delete)
  ("u" ibuffer-unmark-forward)
  ("<backspace>" ibuffer-unmark-backward)
  ("c" ibuffer-unmark-all-marks)
  ("t" ibuffer-toggle-marks)

  ("s" my-ibuffer-mark-special-buffers)
  ("e" ibuffer-mark-dissociated-buffers)
  ("u" ibuffer-mark-unsaved-buffers)
  ("r" ibuffer-mark-read-only-buffers)
  ("." ibuffer-mark-old-buffers)

  ("n" ibuffer-mark-by-name-regexp)
  ("f" ibuffer-mark-by-file-name-regexp)
  ("g" ibuffer-mark-by-content-regexp)
  ("M" ibuffer-mark-by-mode-regexp)

  ("q" nil "dismiss")
  ("<return>" nil "dismiss")

  ;; ("L"             ibuffer-mark-by-locked)
  ;; ("*"             ibuffer-unmark-all)
  ;; ("/"             ibuffer-mark-dired-buffers)
  ;; ("M"             ibuffer-mark-by-mode)
  ;; ("c"             ibuffer-change-marks)
  ;; ("h"             ibuffer-mark-help-buffers)
  ;; ("m"             ibuffer-mark-modified-buffers)
  ;; ("z"             ibuffer-mark-compressed-file-buffers)
  )

;; Sorting:
;; s a             ibuffer-do-sort-by-alphabetic
;; s f             ibuffer-do-sort-by-filename/process
;; s i             ibuffer-invert-sorting
;; s m             ibuffer-do-sort-by-major-mode
;; s s             ibuffer-do-sort-by-size
;; s v             ibuffer-do-sort-by-recency

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'ibuf-ext)
(defun my-ibuffer-filter-by-modified ()
  (interactive)
  (setq ibuffer-filtering-qualifiers '((modified) (visiting-file)))
  (ibuffer-update nil t))


(require 'pretty-hydra)
(pretty-hydra-define my-hydra-ibuffer-filters (:hint nil :quit-key "q")
  ("Basic"
   (("a" ibuffer-filter-by-filename "path")
    ("n" ibuffer-filter-by-name "name")
    ("c" ibuffer-filter-by-content "search")
    ("." ibuffer-filter-by-file-extension "ext")
    ("e" ibuffer-filter-by-predicate "expr"))

   "Advanced"
   (("v" ibuffer-filter-by-visiting-file "file?")
    ("u" my-ibuffer-filter-by-modified "modified?")
    ("s" ibuffer-filter-by-starred-name "starred?")
    ("E" ibuffer-filter-by-process "process?")
    ("o" ibuffer-filter-by-used-mode "mode"))

   "Filters"
   (("|" ibuffer-or-filter "or")
    ("&" ibuffer-and-filter "and")
    ("!" ibuffer-negate-filter "not")
    ("p" ibuffer-pop-filter "pop")
    ("/" ibuffer-filter-disable "clear all" :color blue))

   ""
   (("fs" ibuffer-save-filters "save")
    ("fl" ibuffer-switch-to-saved-filters "load")
    ("fa" ibuffer-add-saved-filters "load++")
    ("fc" ibuffer-delete-saved-filters "del saved"))

   "Groups"
   (("gp" ibuffer-pop-filter-group "pop")
    ("gg" ibuffer-filters-to-filter-group "create")
    ("gs" ibuffer-save-filter-groups "save")
    ("gl" ibuffer-switch-to-saved-filter-groups "load")
    ("gc" ibuffer-delete-saved-filter-groups "del saved"))

   "Misc"
   (("fd" ibuffer-decompose-filter "decompose filter")
    ("gd" ibuffer-decompose-filter-group "decompose group")
    )))

;; `g' - Regenerate the list of all buffers.
;;         Prefix arg means to toggle whether buffers that match
;;         `ibuffer-maybe-show-predicates' should be displayed.

;; ``' - Change the current display format.
;; `SPC' - Move point to the next line.
;; `C-p' - Move point to the previous line.
;; `h' - This help.
;; `M-x ibuffer-diff-with-file' - View the differences between this buffer
;;         and its associated file.
;; `RET' - View the buffer on this line.
;; `o' - As above, but in another window.
;; `C-o' - As both above, but don't select
;;         the new window.
;; `b' - Bury (not kill!) the buffer on this line.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Operations on marked buffers:

;;   `S' - Save the marked buffers.
;;   `A' - View the marked buffers in the selected frame.
;;   `H' - View the marked buffers in another frame.
;;   `V' - Revert the marked buffers.
;;   `T' - Toggle read-only state of marked buffers.
;;   `L' - Toggle lock state of marked buffers.
;;   `D' - Kill the marked buffers.
;;   `M-s a C-s' - Do incremental search in the marked buffers.
;;   `M-s a C-M-s' - Isearch for regexp in the marked buffers.
;;   `r' - Replace by regexp in each of the marked
;;           buffers.
;;   `Q' - Query replace in each of the marked buffers.
;;   `I' - As above, with a regular expression.
;;   `P' - Print the marked buffers.
;;   `O' - List lines in all marked buffers which match
;;           a given regexp (like the function `occur').
;;   `X' - Pipe the contents of the marked
;;           buffers to a shell command.
;;   `N' - Replace the contents of the marked
;;           buffers with the output of a shell command.
;;   `!' - Run a shell command with the
;;           buffer's file as an argument.
;;   `E' - Evaluate a form in each of the marked buffers.  This
;;           is a very flexible command.  For example, if you want to make all
;;           of the marked buffers read-only, try using (read-only-mode 1) as
;;           the input form.
;;   `W' - As above, but view each buffer while the form
;;           is evaluated.
;;   `k' - Remove the marked lines from the *Ibuffer* buffer,
;;           but don't kill the associated buffer.
;;   `x' - Kill all buffers marked for deletion.

;; TODO: HYYYYDRAAAA!!!! (for marking and searching)



;; Disabled/alternative shortcuts:
;; (">" ibuffer-filter-by-size-gt)
;; ("<" ibuffer-filter-by-size-lt)
;; ("b" ibuffer-filter-by-basename)
;; ("M" ibuffer-filter-by-derived-mode)
;; ("t" ibuffer-exchange-filters)
;; ("<tab>" ibuffer-exchange-filters)
;; ("<return>" ibuffer-filter-by-mode)
;; ("<space>" ibuffer-clear-filter-groups)
;; ("<up>" ibuffer-pop-filter)
;; ("<S-up>" ibuffer-pop-filter-group)
;; ("|" ibuffer-or-filter)


(defvar my-ibuffer-refreshing-p nil
  "Set to t when refreshing is in progress, nil otherwise.")

(defun my-refresh-ibuffer (&optional buf)
  (interactive)
  (unless (typep buf 'string)
    (setq buf (buffer-name buf)))
  (unless (or (not buf)
              my-ibuffer-refreshing-p
              (or (s-contains-p "helm" buf)
                  (s-prefix-p " " buf)))
    ;; (message "Refresh Ibuffer: %s" buf)
    (let ((my-ibuffer-refreshing-p t))
      (save-window-excursion
        (cl-loop
         for buf in (buffer-list)
         when (s-prefix-p "*Ibuffer*" (buffer-name buf))
         do (with-current-buffer buf
              (let ((p (point)))
                (ibuffer-update nil t)
                (goto-char (min p (point-max)))))))))
  )

;; This is a HACK, it works solely by accident - neither hook nor advice
;; actually passes buffer object or buffer name to the function; apparently some
;; buffer is then randomly selected (via ido for some reason) and the function
;; proceedes with it.
(progn
  (advice-add 'kill-buffer :after 'my-refresh-ibuffer)
  (add-hook 'find-file-hook 'my-refresh-ibuffer))

(when nil
  (advice-remove 'kill-buffer 'my-refresh-ibuffer)
  (remove-hook 'find-file-hook 'my-refresh-ibuffer))


(provide 'my-ibuffer)
