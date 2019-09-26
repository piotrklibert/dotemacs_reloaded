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

(defun my-toggle-picture-mode ()
  (interactive)
  (if (eq major-mode 'picture-mode)
      (picture-mode-exit)
    (picture-mode)))

(require 'my-customization-helpers)
(defalias 'config-toggles 'hydra-toggle-simple/body)


(pretty-hydra-define hydra-toggle-simple (:hint nil :color red :quit-key "q")
  (""
   (("ww" toggle-word-wrap "word wrap" :toggle word-wrap)
    ("wv" visual-line-mode "visual line wrap" :toggle t)
    ("wl" toggle-truncate-lines "truncate lines" :toggle truncate-lines)
    ("wf" display-fill-column-indicator-mode "show FIC" :toggle t)
    ("ws" set-fill-column "set FIC" :color blue))
   ""
   (("f" auto-fill-mode :toggle t)
    ("o" overwrite-mode :toggle t )
    ("r" read-only-mode :toggle buffer-read-only)
    ("p" my-toggle-picture-mode "picture mode" :toggle (eq major-mode 'picture-mode))
    ("a" artist-mode :toggle t))
   ""
   (("hl" hl-line-mode  :toggle t)
    ("hv" vline-mode  :toggle t)
    ("hw" whitespace-mode "highlight whitespace" :toggle t))
   ""
   (("d" toggle-debug-on-error "debug errors" :toggle (symbol-value 'debug-on-error))
    ("D" toggle-debug-on-quit "debug quits" :toggle (symbol-value 'debug-on-quit))
    ("g" git-gutter+-mode :toggle t)
    ("b" my-toggle-true-false-none "cycle python T/F/None")
    ("\"" my-toggle-quotes "cycle surrounding \"/'"))
   ""
   (("t" my-insert-datetime)
    ("T" my-insert-today))
   ))



(require 'whitespace)
(assert (functionp (symbol-function 'hydra-toggle-simple/body)))
(define-key my-toggle-keys (kbd "C-s") 'config-toggles)



(require 'pretty-hydra)

(pretty-hydra-define jp-window (:foreign-keys warn  :quit-key "q")
  ("Actions"
   (("TAB" other-window "switch")
    ("x" ace-delete-window "delete")
    ("m" ace-delete-other-windows "maximize")
    ("s" ace-swap-window "swap")
    ("a" ace-select-window "select"))

   "Resize"
   (("h" move-border-left "←")
    ("j" move-border-down "↓")
    ("k" move-border-up "↑")
    ("l" move-border-right "→")
    ("n" balance-windows "balance")
    ("f" toggle-frame-fullscreen "toggle fullscreen"))

   "Split"
   (("b" split-window-right "horizontally")
    ("B" split-window-horizontally-instead "horizontally instead")
    ("v" split-window-below "vertically")
    ("V" split-window-vertically-instead "vertically instead"))

   "Zoom"
   (("+" zoom-in "in")
    ("=" zoom-in)
    ("-" zoom-out "out")
    ("0" jp-zoom-default "reset"))))


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



; Hydra for org agenda (graciously taken from Spacemacs)
(defhydra hydra-org-agenda
  (:pre (setq which-key-inhibit t) :post (setq which-key-inhibit nil) :hint none)
  "
Org agenda (_q_uit)

^Clock^      ^Visit entry^              ^Date^             ^Other^
^-----^----  ^-----------^------------  ^----^-----------  ^-----^---------
_ci_ in      _SPC_ in other window      _ds_ schedule      _gr_ reload
_co_ out     _TAB_ & go to location     _dd_ set deadline  _._  go to today
_cq_ cancel  _RET_ & del other windows  _dt_ timestamp     _gd_ go to date
_cj_ jump    _o_   link                 _+_  do later      ^^
^^           ^^                         _-_  do earlier    ^^
^^           ^^                         ^^                 ^^
^View^          ^Filter^                 ^Headline^         ^Toggle mode^
^----^--------  ^------^---------------  ^--------^-------  ^-----------^----
_vd_ day        _ft_ by tag              _ht_ set status    _tf_ follow
_vw_ week       _fr_ refine by tag       _hk_ kill          _tl_ log
_vt_ fortnight  _fc_ by category         _hr_ refile        _ta_ archive trees
_vm_ month      _fh_ by top headline     _hA_ archive       _tA_ archive files
_vy_ year       _fx_ by regexp           _h:_ set tags      _tr_ clock report
_vn_ next span  _fd_ delete all filters  _hp_ set priority  _td_ diaries
_vp_ prev span  ^^                       ^^                 ^^
_vr_ reset      ^^                       ^^                 ^^
^^              ^^                       ^^                 ^^
"
  ;; Entry
  ("hA" org-agenda-archive-default)
  ("hk" org-agenda-kill)
  ("hp" org-agenda-priority)
  ("hr" org-agenda-refile)
  ("h:" org-agenda-set-tags)
  ("ht" org-agenda-todo)
  ;; Visit entry
  ("o"   link-hint-open-link :exit t)
  ("<tab>" org-agenda-goto :exit t)
  ("TAB" org-agenda-goto :exit t)
  ("SPC" org-agenda-show-and-scroll-up)
  ("RET" org-agenda-switch-to :exit t)
  ;; Date
  ("dt" org-agenda-date-prompt)
  ("dd" org-agenda-deadline)
  ("+" org-agenda-do-date-later)
  ("-" org-agenda-do-date-earlier)
  ("ds" org-agenda-schedule)
  ;; View
  ("vd" org-agenda-day-view)
  ("vw" org-agenda-week-view)
  ("vt" org-agenda-fortnight-view)
  ("vm" org-agenda-month-view)
  ("vy" org-agenda-year-view)
  ("vn" org-agenda-later)
  ("vp" org-agenda-earlier)
  ("vr" org-agenda-reset-view)
  ;; Toggle mode
  ("ta" org-agenda-archives-mode)
  ("tA" (org-agenda-archives-mode 'files))
  ("tr" org-agenda-clockreport-mode)
  ("tf" org-agenda-follow-mode)
  ("tl" org-agenda-log-mode)
  ("td" org-agenda-toggle-diary)
  ;; Filter
  ("fc" org-agenda-filter-by-category)
  ("fx" org-agenda-filter-by-regexp)
  ("ft" org-agenda-filter-by-tag)
  ("fr" org-agenda-filter-by-tag-refine)
  ("fh" org-agenda-filter-by-top-headline)
  ("fd" org-agenda-filter-remove-all)
  ;; Clock
  ("cq" org-agenda-clock-cancel)
  ("cj" org-agenda-clock-goto :exit t)
  ("ci" org-agenda-clock-in :exit t)
  ("co" org-agenda-clock-out)
  ;; Other
  ("q" nil :exit t)
  ("gd" org-agenda-goto-date)
  ("." org-agenda-goto-today)
  ("gr" org-agenda-redo))

(defhydra hydra-window ()
   "
Movement^^        ^Split^         ^Switch^		^Resize^
----------------------------------------------------------------
_h_ ←       	_v_ertical    	_b_uffer		_q_ X←
_j_ ↓        	_x_ horizontal	_f_ind files	_w_ X↓
_k_ ↑        	_z_ undo      	_a_ce 1		_e_ X↑
_l_ →        	_Z_ reset      	_s_wap		_r_ X→
_F_ollow		_D_lt Other   	_S_ave		max_i_mize
_SPC_ cancel	_o_nly this   	_d_elete
"
   ("h" windmove-left )
   ("j" windmove-down )
   ("k" windmove-up )
   ("l" windmove-right )
   ("q" hydra-move-splitter-left)
   ("w" hydra-move-splitter-down)
   ("e" hydra-move-splitter-up)
   ("r" hydra-move-splitter-right)
   ("b" helm-mini)
   ("f" helm-find-files)
   ("F" follow-mode)
   ("a" (lambda ()
          (interactive)
          (ace-window 1)
          (add-hook 'ace-window-end-once-hook
                    'hydra-window/body))
       )
   ("v" (lambda ()
          (interactive)
          (split-window-right)
          (windmove-right))
       )
   ("x" (lambda ()
          (interactive)
          (split-window-below)
          (windmove-down))
       )
   ("s" (lambda ()
          (interactive)
          (ace-window 4)
          (add-hook 'ace-window-end-once-hook
                    'hydra-window/body)))
   ("S" save-buffer)
   ("d" delete-window)
   ("D" (lambda ()
          (interactive)
          (ace-window 16)
          (add-hook 'ace-window-end-once-hook
                    'hydra-window/body))
       )
   ("o" delete-other-windows)
   ("i" ace-maximize-window)
   ("z" (progn
          (winner-undo)
          (setq this-command 'winner-undo))
   )
   ("Z" winner-redo)
   ("SPC" nil)
   )


(defhydra hydra-rectangle (:body-pre (rectangle-mark-mode 1)
                           :color pink
                           :post (deactivate-mark))
"
  ^_k_^     _d_elete    _s_tring
_h_   _l_   _o_k        _y_ank
  ^_j_^     _n_ew-copy  _r_eset
^^^^        _e_xchange  _u_ndo
^^^^        ^ ^         _p_aste
"
  ("h" backward-char nil)
  ("l" forward-char nil)
  ("k" previous-line nil)
  ("j" next-line nil)
  ("e" exchange-point-and-mark nil)
  ("n" copy-rectangle-as-kill nil)
  ("d" delete-rectangle nil)
  ("r" (if (region-active-p)
           (deactivate-mark)
         (rectangle-mark-mode 1)) nil)
  ("y" yank-rectangle nil)
  ("u" undo nil)
  ("s" string-rectangle nil)
  ("p" kill-rectangle nil)
  ("o" nil nil))



(defhydra hydra-macro (:hint nil :color pink :pre
                             (when defining-kbd-macro
                                 (kmacro-end-macro 1)))
  "
  ^Create-Cycle^   ^Basic^           ^Insert^        ^Save^         ^Edit^
╭─────────────────────────────────────────────────────────────────────────╯
     ^_i_^           [_e_] execute    [_n_] insert    [_b_] name      [_'_] previous
     ^^↑^^           [_d_] delete     [_t_] set       [_K_] key       [_,_] last
 _j_ ←   → _l_       [_o_] edit       [_a_] add       [_x_] register
     ^^↓^^           [_r_] region     [_f_] format    [_B_] defun
     ^_k_^           [_m_] step
    ^^   ^^          [_s_] swap
"
  ("j" kmacro-start-macro :color blue)
  ("l" kmacro-end-or-call-macro-repeat)
  ("i" kmacro-cycle-ring-previous)
  ("k" kmacro-cycle-ring-next)
  ("r" apply-macro-to-region-lines)
  ("d" kmacro-delete-ring-head)
  ("e" kmacro-end-or-call-macro-repeat)
  ("o" kmacro-edit-macro-repeat)
  ("m" kmacro-step-edit-macro)
  ("s" kmacro-swap-ring)
  ("n" kmacro-insert-counter)
  ("t" kmacro-set-counter)
  ("a" kmacro-add-counter)
  ("f" kmacro-set-format)
  ("b" kmacro-name-last-macro)
  ("K" kmacro-bind-to-key)
  ("B" insert-kbd-macro)
  ("x" kmacro-to-register)
  ("'" kmacro-edit-macro)
  ("," edit-kbd-macro)
  ("q" nil :color blue))


(define-key Info-mode-map (kbd "?") #'hydra-info/body)
(defhydra hydra-info (:color blue
                      :hint nil)
      "
Info-mode:

  ^^_]_ forward  (next logical node)       ^^_l_ast (←)        _u_p (↑)                             _f_ollow reference       _T_OC
  ^^_[_ backward (prev logical node)       ^^_r_eturn (→)      _m_enu (↓) (C-u for new window)      _i_ndex                  _d_irectory
  ^^_n_ext (same level only)               ^^_H_istory         _g_oto (C-u for new window)          _,_ next index item      _c_opy node name
  ^^_p_rev (same level only)               _<_/_t_op           _b_eginning of buffer                virtual _I_ndex          _C_lone buffer
  regex _s_earch (_S_ case sensitive)      ^^_>_ final         _e_nd of buffer                      ^^                       _a_propos

  _1_ .. _9_ Pick first .. ninth item in the node's menu.

"
      ("]"   Info-forward-node)
      ("["   Info-backward-node)
      ("n"   Info-next)
      ("p"   Info-prev)
      ("s"   Info-search)
      ("S"   Info-search-case-sensitively)

      ("l"   Info-history-back)
      ("r"   Info-history-forward)
      ("H"   Info-history)
      ("t"   Info-top-node)
      ("<"   Info-top-node)
      (">"   Info-final-node)

      ("u"   Info-up)
      ("^"   Info-up)
      ("m"   Info-menu)
      ("g"   Info-goto-node)
      ("b"   beginning-of-buffer)
      ("e"   end-of-buffer)

      ("f"   Info-follow-reference)
      ("i"   Info-index)
      (","   Info-index-next)
      ("I"   Info-virtual-index)

      ("T"   Info-toc)
      ("d"   Info-directory)
      ("c"   Info-copy-current-node-name)
      ("C"   clone-buffer)
      ("a"   info-apropos)

      ("1"   Info-nth-menu-item)
      ("2"   Info-nth-menu-item)
      ("3"   Info-nth-menu-item)
      ("4"   Info-nth-menu-item)
      ("5"   Info-nth-menu-item)
      ("6"   Info-nth-menu-item)
      ("7"   Info-nth-menu-item)
      ("8"   Info-nth-menu-item)
      ("9"   Info-nth-menu-item)

      ("?"   Info-summary "Info summary")
      ("h"   Info-help "Info help")
      ("q"   Info-exit "Info exit")
      ("C-g" nil "cancel" :color blue))

;; (defhydra hydra-ibuffer-main (:color pink :hint nil)
;;   "
;; ^Mark^         ^Actions^         ^View^          ^Select^              ^Navigation^
;; _m_: mark      _D_: delete       _g_: refresh    _q_: quit             _k_:   ↑    _h_
;; _u_: unmark    _s_: save marked  _S_: sort       _TAB_: toggle         _RET_: visit
;; _*_: specific  _a_: all actions  _/_: filter     _o_: other window     _j_:   ↓    _l_
;; _t_: toggle    _._: toggle hydra _H_: help       C-o other win no-select
;; "
;;   ("m" ibuffer-mark-forward)
;;   ("u" ibuffer-unmark-forward)
;;   ("*" hydra-ibuffer-mark/body :color blue)
;;   ("t" ibuffer-toggle-marks)

;;   ("D" ibuffer-do-delete)
;;   ("s" ibuffer-do-save)
;;   ("a" hydra-ibuffer-action/body :color blue)

;;   ("g" ibuffer-update)
;;   ("S" hydra-ibuffer-sort/body :color blue)
;;   ("/" hydra-ibuffer-filter/body :color blue)
;;   ("H" describe-mode :color blue)

;;   ("h" ibuffer-backward-filter-group)
;;   ("k" ibuffer-backward-line)
;;   ("l" ibuffer-forward-filter-group)
;;   ("j" ibuffer-forward-line)
;;   ("RET" ibuffer-visit-buffer :color blue)

;;   ("TAB" ibuffer-toggle-filter-group)

;;   ("o" ibuffer-visit-buffer-other-window :color blue)
;;   ("q" quit-window :color blue)
;;   ("." nil :color blue))


;; (defhydra hydra-ibuffer-mark (:color teal :columns 5
;;                               :after-exit (hydra-ibuffer-main/body))
;;   "Mark"
;;   ("*" ibuffer-unmark-all "unmark all")
;;   ("M" ibuffer-mark-by-mode "mode")
;;   ("m" ibuffer-mark-modified-buffers "modified")
;;   ("u" ibuffer-mark-unsaved-buffers "unsaved")
;;   ("s" ibuffer-mark-special-buffers "special")
;;   ("r" ibuffer-mark-read-only-buffers "read-only")
;;   ("/" ibuffer-mark-dired-buffers "dired")
;;   ("e" ibuffer-mark-dissociated-buffers "dissociated")
;;   ("h" ibuffer-mark-help-buffers "help")
;;   ("z" ibuffer-mark-compressed-file-buffers "compressed")
;;   ("b" hydra-ibuffer-main/body "back" :color blue))

;; (defhydra hydra-ibuffer-action (:color teal :columns 4
;;                                 :after-exit
;;                                 (if (eq major-mode 'ibuffer-mode)
;;                                     (hydra-ibuffer-main/body)))
;;   "Action"
;;   ("A" ibuffer-do-view "view")
;;   ("E" ibuffer-do-eval "eval")
;;   ("F" ibuffer-do-shell-command-file "shell-command-file")
;;   ("I" ibuffer-do-query-replace-regexp "query-replace-regexp")
;;   ("H" ibuffer-do-view-other-frame "view-other-frame")
;;   ("N" ibuffer-do-shell-command-pipe-replace "shell-cmd-pipe-replace")
;;   ("M" ibuffer-do-toggle-modified "toggle-modified")
;;   ("O" ibuffer-do-occur "occur")
;;   ("P" ibuffer-do-print "print")
;;   ("Q" ibuffer-do-query-replace "query-replace")
;;   ("R" ibuffer-do-rename-uniquely "rename-uniquely")
;;   ("T" ibuffer-do-toggle-read-only "toggle-read-only")
;;   ("U" ibuffer-do-replace-regexp "replace-regexp")
;;   ("V" ibuffer-do-revert "revert")
;;   ("W" ibuffer-do-view-and-eval "view-and-eval")
;;   ("X" ibuffer-do-shell-command-pipe "shell-command-pipe")
;;   ("b" nil "back"))

;; (defhydra hydra-ibuffer-sort (:color amaranth :columns 3)
;;   "Sort"
;;   ("i" ibuffer-invert-sorting "invert")
;;   ("a" ibuffer-do-sort-by-alphabetic "alphabetic")
;;   ("v" ibuffer-do-sort-by-recency "recently used")
;;   ("s" ibuffer-do-sort-by-size "size")
;;   ("f" ibuffer-do-sort-by-filename/process "filename")
;;   ("m" ibuffer-do-sort-by-major-mode "mode")
;;   ("b" hydra-ibuffer-main/body "back" :color blue))

;; (defhydra hydra-ibuffer-filter (:color amaranth :columns 4)
;;   "Filter"
;;   ("m" ibuffer-filter-by-used-mode "mode")
;;   ("M" ibuffer-filter-by-derived-mode "derived mode")
;;   ("n" ibuffer-filter-by-name "name")
;;   ("c" ibuffer-filter-by-content "content")
;;   ("e" ibuffer-filter-by-predicate "predicate")
;;   ("f" ibuffer-filter-by-filename "filename")
;;   (">" ibuffer-filter-by-size-gt "size")
;;   ("<" ibuffer-filter-by-size-lt "size")
;;   ("/" ibuffer-filter-disable "disable")
;;   ("b" hydra-ibuffer-main/body "back" :color blue))

(defhydra hydra-dired (:hint nil :color pink)
  "
_+_ mkdir          _v_iew           _m_ark             _(_ details        _i_nsert-subdir    wdired
_C_opy             _O_ view other   _U_nmark all       _)_ omit-mode      _$_ hide-subdir    C-x C-q : edit
_D_elete           _o_pen other     _u_nmark           _l_ redisplay      _w_ kill-subdir    C-c C-c : commit
_R_ename           _M_ chmod        _t_oggle           _g_ revert buf     _e_ ediff          C-c ESC : abort
_Y_ rel symlink    _G_ chgrp        _E_xtension mark   _s_ort             _=_ pdiff
_S_ymlink          ^ ^              _F_ind marked      _._ toggle hydra   \\ flyspell
_r_sync            ^ ^              ^ ^                ^ ^                _?_ summary
_z_ compress-file  _A_ find regexp
_Z_ compress       _Q_ repl regexp

T - tag prefix
"
  ("\\" dired-do-ispell)
  ("(" dired-hide-details-mode)
  (")" dired-omit-mode)
  ("+" dired-create-directory)
  ("=" diredp-ediff)         ;; smart diff
  ("?" dired-summary)
  ("$" diredp-hide-subdir-nomove)
  ("A" dired-do-find-regexp)
  ("C" dired-do-copy)        ;; Copy all marked files
  ("D" dired-do-delete)
  ("E" dired-mark-extension)
  ("e" dired-ediff-files)
  ("F" dired-do-find-marked-files)
  ("G" dired-do-chgrp)
  ("g" revert-buffer)        ;; read all directories again (refresh)
  ("i" dired-maybe-insert-subdir)
  ("l" dired-do-redisplay)   ;; relist the marked or singel directory
  ("M" dired-do-chmod)
  ("m" dired-mark)
  ("O" dired-display-file)
  ("o" dired-find-file-other-window)
  ("Q" dired-do-find-regexp-and-replace)
  ("R" dired-do-rename)
  ("r" dired-do-rsynch)
  ("S" dired-do-symlink)
  ("s" dired-sort-toggle-or-edit)
  ("t" dired-toggle-marks)
  ("U" dired-unmark-all-marks)
  ("u" dired-unmark)
  ("v" dired-view-file)      ;; q to exit, s to search, = gets line #
  ("w" dired-kill-subdir)
  ("Y" dired-do-relsymlink)
  ("z" diredp-compress-this-file)
  ("Z" dired-do-compress)
  ("q" nil)
  ("." nil :color blue))

(define-key dired-mode-map "?" 'hydra-dired/body)


(defhydra hydra-helm (:hint nil :color pink)
        "
                                                                          ╭──────┐
   Navigation   Other  Sources     Mark             Do             Help   │ Helm │
  ╭───────────────────────────────────────────────────────────────────────┴──────╯
        ^_k_^         _K_       _p_   [_m_] mark         [_v_] view         [_H_] helm help
        ^^↑^^         ^↑^       ^↑^   [_t_] toggle all   [_d_] delete       [_s_] source help
    _h_ ←   → _l_     _c_       ^ ^   [_u_] unmark all   [_f_] follow: %(helm-attr 'follow)
        ^^↓^^         ^↓^       ^↓^    ^ ^               [_y_] yank selection
        ^_j_^         _J_       _n_    ^ ^               [_w_] toggle windows
  --------------------------------------------------------------------------------
        "
        ("<tab>" helm-keyboard-quit "back" :exit t)
        ("<escape>" nil "quit")
        ("\\" (insert "\\") "\\" :color blue)
        ("h" helm-beginning-of-buffer)
        ("j" helm-next-line)
        ("k" helm-previous-line)
        ("l" helm-end-of-buffer)
        ("g" helm-beginning-of-buffer)
        ("G" helm-end-of-buffer)
        ("n" helm-next-source)
        ("p" helm-previous-source)
        ("K" helm-scroll-other-window-down)
        ("J" helm-scroll-other-window)
        ("c" helm-recenter-top-bottom-other-window)
        ("m" helm-toggle-visible-mark)
        ("t" helm-toggle-all-marks)
        ("u" helm-unmark-all)
        ("H" helm-help)
        ("s" helm-buffer-help)
        ("v" helm-execute-persistent-action)
        ("d" helm-persistent-delete-marked)
        ("y" helm-yank-selection)
        ("w" helm-toggle-resplit-and-swap-windows)
        ("f" helm-follow-mode))

;; (define-key minibuffer-local-map "?" 'hydra-dired/body)
(define-key helm-map (kbd "C-?") 'hydra-helm/body)




;; (define-key ivy-minibuffer-map "\C-o")
(defhydra hydra-ivy (:hint nil :color pink)
  "
 Move     ^^^^^^^^^^ | Call         ^^^^ | Cancel^^ | Options^^ | Action _w_/_s_/_a_: %s(ivy-action-name)
----------^^^^^^^^^^-+--------------^^^^-+-------^^-+--------^^-+---------------------------------
 _g_ ^ ^ _k_ ^ ^ _u_ | _f_orward _o_ccur | _i_nsert | _c_alling: %-7s(if ivy-calling \"on\" \"off\") _C_ase-fold: %-10`ivy-case-fold-search
 ^↨^ _h_ ^+^ _l_ ^↕^ | _RET_ done     ^^ | _q_uit   | _m_atcher: %-7s(ivy--matcher-desc) _t_runcate: %-11`truncate-lines
 _G_ ^ ^ _j_ ^ ^ _d_ | _TAB_ alt-done ^^ | ^ ^      | _<_/_>_: shrink/grow
"
  ;; arrows
  ("j" ivy-next-line)
  ("k" ivy-previous-line)
  ("l" ivy-alt-done)
  ("h" ivy-backward-delete-char)
  ("g" ivy-beginning-of-buffer)
  ("G" ivy-end-of-buffer)
  ("d" ivy-scroll-up-command)
  ("u" ivy-scroll-down-command)
  ("e" ivy-scroll-down-command)
  ;; actions
  ("q" keyboard-escape-quit :exit t)
  ("C-g" keyboard-escape-quit :exit t)
  ("<escape>" keyboard-escape-quit :exit t)
  ("C-o" nil)
  ("i" nil)
  ("TAB" ivy-alt-done :exit nil)
  ("C-j" ivy-alt-done :exit nil)
  ;; ("d" ivy-done :exit t)
  ("RET" ivy-done :exit t)
  ("C-m" ivy-done :exit t)
  ("f" ivy-call)
  ("c" ivy-toggle-calling)
  ("m" ivy-toggle-fuzzy)
  (">" ivy-minibuffer-grow)
  ("<" ivy-minibuffer-shrink)
  ("w" ivy-prev-action)
  ("s" ivy-next-action)
  ("a" ivy-read-action)
  ("t" (setq truncate-lines (not truncate-lines)))
  ("C" ivy-toggle-case-fold)
  ("o" ivy-occur :exit t))


(defhydra hydra-avy (:exit t :hint nil)
  "
 Line^^       Region^^        Goto
----------------------------------------------------------
 [_y_] yank   [_Y_] yank      [_c_] timed char  [_C_] char
 [_m_] move   [_M_] move      [_w_] word        [_W_] any word
 [_k_] kill   [_K_] kill      [_l_] line        [_L_] end of line"
  ("c" avy-goto-char-timer)
  ("C" avy-goto-char)
  ("w" avy-goto-word-1)
  ("W" avy-goto-word-0)
  ("l" avy-goto-line)
  ("L" avy-goto-end-of-line)
  ("m" avy-move-line)
  ("M" avy-move-region)
  ("k" avy-kill-whole-line)
  ("K" avy-kill-region)
  ("y" avy-copy-line)
  ("Y" avy-copy-region))





;; TODO: unused?
;; TODO: could be useful, there are some interesting, but very rarely used,
;; commands so a hydra would be helpful.
(defvar rectangle-mark-mode)
(defun hydra-ex-point-mark ()
  "Exchange point and mark."
  (interactive)
  (if rectangle-mark-mode
      (rectangle-exchange-point-and-mark)
    (let ((mk (mark)))
      (rectangle-mark-mode 1)
      (goto-char mk))))

;; Global Bindings Starting With C-x r:
;; key             binding
;; ---             -------
;; C-x r C-@       point-to-register
;; C-x r C-y       yank-rectangle-as-text
;; C-x r ESC       Prefix Command
;; C-x r SPC       point-to-register
;; C-x r +         increment-register
;; C-x r M         bookmark-set-no-overwrite
;; C-x r N         rectangle-number-lines
;; C-x r b         bookmark-jump
;; C-x r c         clear-rectangle
;; C-x r d         delete-rectangle
;; C-x r f         frameset-to-register
;; C-x r g         insert-register
;; C-x r i         insert-register
;; C-x r j         jump-to-register
;; C-x r k         kill-rectangle
;; C-x r l         bookmark-bmenu-list
;; C-x r m         bookmark-set
;; C-x r n         number-to-register
;; C-x r o         open-rectangle
;; C-x r r         copy-rectangle-to-register
;; C-x r s         copy-to-register
;; C-x r t         string-rectangle
;; C-x r w         window-configuration-to-register
;; C-x r x         copy-to-register
;; C-x r y         yank-rectangle
;; C-x r C-SPC     point-to-register
;; C-x r M-w       copy-rectangle-as-kill

(provide 'my-hydra-stables)
