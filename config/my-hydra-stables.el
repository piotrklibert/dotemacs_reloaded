(require 'my-keymaps-config)
(require 'generic-x)
(require 'avy-autoloads)
(require 'helm-autoloads)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Hydra for font size scaling; activated by C-c =
;;
(require 'hydra)
(require 'linum)


(defun text-scale-zero ()
  (interactive)
  (text-scale-set 0)
  (when linum-mode
    (linum-mode -1)
    (linum-mode t)))


(defhydra hydra-zoom (:color red)
  "zoom"
  ("q" nil) ("<esc>" nil)               ; quit/cancel
  ("+" text-scale-increase "in")
  ("=" text-scale-increase "in")
  ("-" text-scale-decrease "out")
  ("_" text-scale-decrease "out")
  ("0" text-scale-zero :color blue))

(assert (functionp (symbol-function 'hydra-zoom/body)))


(define-key mode-specific-map (kbd "-") 'hydra-zoom/text-scale-decrease)
(define-key mode-specific-map (kbd "_") 'hydra-zoom/text-scale-decrease)

(define-key mode-specific-map (kbd "=") 'hydra-zoom/text-scale-increase)
(define-key mode-specific-map (kbd "+") 'hydra-zoom/text-scale-increase)

(define-key mode-specific-map (kbd "0") #'text-scale-zero)
(define-key mode-specific-map (kbd ")") #'text-scale-zero)

;; ==============================================================================


(defalias 'config-toggles 'hydra-toggle-simple/body)
(defhydra hydra-toggle-simple (:color red :hint nil)
  "
_d_: debug-on-error - display traceback on error (%-3`debug-on-error)     ^^|    _f_: auto-fill-mode - (%-3`auto-fill-function)
_D_: debug-on-quit - display traceback on C-g (%-3`debug-on-quit) ^       ^^|    _W_: whitespace-mode (%-3`whitespace-mode)
                                                    ^    ^^^^^^^^^^^^^^^ ^^^|
_v_: visual-line - use wrapped lines for movement (%-3`visual-line-mode)    |    _\"_: my-toggle-quotes
_w_: word-wrap - wrap wrap whole words only (%-3`word-wrap)    ^^^^^^^      |    _b_: my-toggle-true-false-none
_l_: truncate-lines - DON'T wrap too long lines (%-3`truncate-lines)     ^^ |    _o_: overwrite-mode (%-3`overwrite-mode)
"
  ;; TODO: add picture-mode
  ("q" nil) ("<esc>" nil)
  ("d" toggle-debug-on-error)
  ("D" toggle-debug-on-quit)

  ("v" visual-line-mode)
  ("l" toggle-truncate-lines)
  ("w" toggle-word-wrap)

  ("f" auto-fill-mode)
  ("W" whitespace-mode)

  ("\"" my-toggle-quotes)
  ("b" my-toggle-true-false-none)
  ("o" overwrite-mode)
  )
(require 'whitespace)
(assert (functionp (symbol-function 'hydra-toggle-simple/body)))
(define-key my-toggle-keys (kbd "C-s") 'config-toggles)


;; ===============================================================================


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

  ("s" ibuffer-mark-special-buffers)
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

(defhydra hydra-ibuffer-filters (:hint nil)
  "
^Basic filters^       ^ ^               ^ ^              | ^Combining^        | ^Misc^
^^^^^^---------------------------------------------------+------------------^^+---------------------
_c_: content         _u_: unsaved       _<_: size-lt     |  _|_: logical OR   |  _/_: reset filters
_n_: buffer name     _s_: special       _>_: size-gt     |  _&_: logical AND  |  _S_: save filters
_f_: filename        _M_: derived       _e_: expression  |  _!_: negate       |  _R_: use saved
_._: extension       _v_: has file      _b_: basename    |                  ^^|  _p_: pop filter
_o_: major mode      _E_: has process                  ^^|                  ^^|
^^^^^^---------------------------------------------------+------------------^^+---------------------
"
  ("c" ibuffer-filter-by-content)          ("u" my-ibuffer-filter-by-modified)        (">" ibuffer-filter-by-size-gt)
  ("n" ibuffer-filter-by-name)             ("s" ibuffer-filter-by-starred-name)    ("<" ibuffer-filter-by-size-lt)
  ("f" ibuffer-filter-by-filename)         ("M" ibuffer-filter-by-derived-mode)    ("e" ibuffer-filter-by-predicate)
  ("." ibuffer-filter-by-file-extension)   ("v" ibuffer-filter-by-visiting-file)   ("b" ibuffer-filter-by-basename)
  ("o" ibuffer-filter-by-used-mode)        ("E" ibuffer-filter-by-process)

  ("|" ibuffer-or-filter)
  ("&" ibuffer-and-filter)
  ("!" ibuffer-negate-filter)

  ("/" ibuffer-filter-disable :color blue)
  ("S" ibuffer-save-filters :color blue)
  ("R" ibuffer-switch-to-saved-filters :color blue)

  ("q" nil "accept")
  ("<return>" nil "accept")

  ;; I never used these, and they would take a lot of space, so I'm leaving
  ;; these out of the docstring.
  ("d" ibuffer-decompose-filter)
  ("D" ibuffer-decompose-filter-group)
  ("X" ibuffer-delete-saved-filter-groups)
  ("x" ibuffer-delete-saved-filters)
  ;; ("t" ibuffer-exchange-filters)
  ("g" ibuffer-filters-to-filter-group)
  ("p" ibuffer-pop-filter)
  ;; ("a" ibuffer-add-saved-filters)
  ;; ("P" ibuffer-pop-filter-group)
  ;; ("R" ibuffer-switch-to-saved-filter-groups)
  ;; ("S" ibuffer-save-filter-groups)


  ;; Disabled alternative shortcuts:
  ;; ("<tab>" ibuffer-exchange-filters)
  ;; ("<return>" ibuffer-filter-by-mode)
  ;; ("<space>" ibuffer-clear-filter-groups)
  ;; ("<up>" ibuffer-pop-filter)
  ;; ("<S-up>" ibuffer-pop-filter-group)
  ;; ("|" ibuffer-or-filter)
  )


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


(require 'windmove)
(defhydra hydra-splitter ()
  "Resize window shortcuts"

  ("<left>" hydra-move-splitter-left)
  ("<down>" hydra-move-splitter-down)
  ("<up>" hydra-move-splitter-up)
  ("<right>" hydra-move-splitter-right)
  ("=" golden-ratio  :color blue)
  ("q" nil) ("<esc>" nil))


(defun hydra-move-splitter-left (arg)
  "Move window splitter left."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'right))
      (shrink-window-horizontally 10)
    (enlarge-window-horizontally 10)))

(defun hydra-move-splitter-right (arg)
  "Move window splitter right."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'right))
      (enlarge-window-horizontally 10)
    (shrink-window-horizontally 10)))

(defun hydra-move-splitter-up (arg)
  "Move window splitter up."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'up))
      (enlarge-window 5)
    (shrink-window 5)))

(defun hydra-move-splitter-down (arg)
  "Move window splitter down."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'up))
      (shrink-window 5)
    (enlarge-window 5)))


;; TODO: unused?
(defvar rectangle-mark-mode)
(defun hydra-ex-point-mark ()
  "Exchange point and mark."
  (interactive)
  (if rectangle-mark-mode
      (rectangle-exchange-point-and-mark)
    (let ((mk (mark)))
      (rectangle-mark-mode 1)
      (goto-char mk))))


(provide 'my-hydra-stables)
