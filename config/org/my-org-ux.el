(require 'org)
(require 'org-table)
(require 'org-agenda)
(require 'helm)
(require 'helm-regexp)


(defun my-org-clear-subtree ()
  (interactive)
  (org-mark-subtree) ;; mark the current subtree
  (kill-region (region-beginning) (region-end))) ;; delete the rest


(defadvice org-shifttab (after org-shifttab-recenter activate)
  (recenter nil))


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


;; Stolen from: http://www.emacswiki.org/cgi-bin/wiki/Journal
;; because on my FreeBSD Org crashed with C-c C-s...

(defun my-now ()
  "Insert string for the current time formatted like '2:34 PM'."
  (format-time-string "%H:%M"))

(defun my-today ()
  (format-time-string "%Y-%m-%d"))

(defun my-insert-now ()
  (interactive)
  (insert (concat "<" (my-now) ">")))

(defun my-insert-datetime ()
  "Insert string for today's date in English, no matter what
locale is set."
  (interactive)
  (let ((system-time-locale "en_GB.utf8"))
    (insert (format-time-string "<%Y-%m-%d %a %H:%M>"))))


(defvar my-dt-delims '("<" . ">")
  "Date or datetime will be wrapped in these when inserted")

(defun my-get-today ()
  (let ((date (format-time-string "%Y-%m-%d") )
        (my-dt-delims '("[" . "]")))
    (concat (car my-dt-delims) date (cdr my-dt-delims))))

(defun my-insert-today ()
  (interactive)
  (insert (my-get-today)))


(defvar my-toggle-keys)
(define-key my-toggle-keys (kbd "C-t") 'my-insert-datetime)
(define-key my-toggle-keys (kbd "M-t") 'my-insert-today)
(define-key my-toggle-keys (kbd "t") 'my-insert-now)

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
  (helm-occur-init-source)
  (let
      ((bufs (list (buffer-name (current-buffer)))))

    (helm-attrset 'moccur-buffers bufs helm-source-occur)
    (helm-set-local-variable 'helm-multi-occur-buffer-list bufs)
    (helm-set-local-variable 'helm-multi-occur-buffer-tick
                             (cl-loop for b in bufs
                                      collect (buffer-chars-modified-tick (get-buffer b)))))
  (helm :sources 'helm-source-occur
        :buffer "*helm occur*"
        :input "^\\*\\*? "
        :history 'helm-occur-history
        :preselect (and (memq 'helm-source-occur helm-sources-using-default-as-input)
                        (format "%s:%d:" (regexp-quote (buffer-name))
                                (line-number-at-pos (point))))
        :truncate-lines helm-moccur-truncate-lines))


(require 'browse-url)

;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)


;; (org-clock-persistence-insinuate)
;; (require 'ol-elisp-symbol)
;; (ol-elisp-symbol)

;; (setq org-capture-templates nil)

(when nil
  (cl-flet
      ((jl (&rest args) (s-join "\n" args))
       (tmpl (key desc dest tmpl &rest plist)
             (let ((dest (cons 'file+headline (s-split "::" dest))))
               `(,key ,desc entry ,dest ,tmpl :empty-lines 1 ,@plist))))
    (let ((todo-tmpl (jl "* TODO %?"
                         "  Added: %U"
                         "  Origin: %a"
                         ""
                         "  %i"))
          (event-tmpl (jl "* TODO %? :EVENT:"
                          "  Added: %U"
                          "  SCHEDULED: %^T"
                          "  Origin: %a"))
          (note-tmpl (jl "* %? :NOTE:"
                         "  Added: %U"
                         "  Origin: %a"
                         ""
                         "  %i")))
      (customize-save-variable
       'org-capture-templates
       (list (tmpl "c" "task" "::INCOMING" todo-tmpl)
             (tmpl "C" "work task" "praca.org::CURRENT" todo-tmpl :prepend t)
             (tmpl "s" "scheduled event" "::EVENTS" event-tmpl)
             (tmpl "S" "scheduled work event" "praca.org::EVENTS" event-tmpl)
             (tmpl "n" "note" "::Notes" note-tmpl :prepend t)))    )))



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

;; (global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(defvar alchemist-mode-map)
(eval-after-load "alchemist"
  '(define-key alchemist-mode-map (kbd "C-c c") 'org-capture))
;; (require 'remember)
;; org-goto-interface
;; org-goto-auto-isearch

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

(defun my-org-hook ()
  (require 'org)
  (require 'ox-md)
  (require 'ox-html)
  (require 'ob-shell)
  (require 'org-tempo)
  (require 'org-goto)
  (require 'my-org-babel)
  (require 'my-org-custom-id)

  (define-key org-mode-map (kbd "<return>")     'org-return-indent)
  (define-key org-mode-map (kbd "C-j")          'org-return)

  (define-key org-mode-map (kbd "M-,") (lambda ()
                                         (interactive)
                                         (org-mark-ring-goto)
                                         (recenter)))
  (define-key org-mode-map (kbd "M-.") 'my-org-goto-def)

  (define-key org-mode-map (kbd "C-c <up>")     'org-previous-visible-heading)
  (define-key org-mode-map (kbd "C-c <down>")   'org-next-visible-heading)

  ;; Commented out because I don't have keypad on the keayboard anymore... ☻
  ;; (define-key org-mode-map (kbd "<kp-up>")      'org-previous-visible-heading)
  ;; (define-key org-mode-map (kbd "<kp-down>")    'org-next-visible-heading)
  ;; (define-key org-mode-map (kbd "C-<kp-up>")    'org-previous-block)
  ;; (define-key org-mode-map (kbd "C-<kp-down>")  'org-next-block)

  (define-key org-mode-map (kbd "C-c C-<up>")   'org-backward-heading-same-level)
  (define-key org-mode-map (kbd "C-c C-<down>") 'org-forward-heading-same-level)

  (define-key org-mode-map (kbd "<backtab>")    'my-org-fold-current)

  ;; (define-key org-mode-map (kbd "C-c M-<up>")   'my-org-clear-subtree)
  ;; (define-key org-mode-map (kbd "C-c C-h")      'my-org-jump-to-heading)
  ;; (define-key org-mode-map (kbd "s-c")          'my-tangle-and-run)

  (define-key org-mode-map (kbd "C-c C-j")      'my-org-occur-headers)
  (define-key org-mode-map (kbd "C-c l")        'org-store-link)
  (global-set-key (kbd "C-c l") 'org-store-link)
  (global-set-key (kbd "C-c C-l") 'org-insert-link)

  (define-key org-mode-map (kbd "C-c +")        'hydra-zoom/text-scale-increase)
  (define-key org-mode-map (kbd "C-c -")        'hydra-zoom/text-scale-decrease)
  (define-key org-mode-map (kbd "C-c =")        'hydra-zoom/body)

  (define-key org-mode-map (kbd "C-c M-=")      'my-org-show-current-heading-tidily)
  (define-key org-mode-map (kbd "C-c M-<up>")   'hydra-org-jump/my-org-show-prev-heading-tidily)
  (define-key org-mode-map (kbd "C-c M-<down>") 'hydra-org-jump/my-org-show-next-heading-tidily)

  ;; KILL, CUT & COPY whole subtrees
  (define-key org-mode-map (kbd "C-c C-k")      'my-org-clear-subtree)
  (define-key org-mode-map (kbd "C-c C-M-w")    'my-org-clear-subtree)
  (define-key org-mode-map (kbd "C-c M-w")      (lambda ()
                                                  (interactive)
                                                  (read-only-mode 1)
                                                  (ignore-errors
                                                    (my-org-clear-subtree))
                                                  (read-only-mode 0)
                                                  (message "Subtree copied")))
  )



(defconst org-html-style-default
  "<style type=\"text/css\">
 <!--/*--><![CDATA[/*><!--*/
  .title  { text-align: center;
             margin-bottom: .2em; }
  .subtitle { text-align: center;
              font-size: medium;
              font-weight: bold;
              margin-top:0; }
  .todo   { font-family: monospace; color: red; }
  .done   { font-family: monospace; color: green; }
  .priority { font-family: monospace; color: orange; }
  .tag    { background-color: #eee; font-family: monospace;
            padding: 2px; font-size: 80%; font-weight: normal; }
  .timestamp { color: #bebebe; }
  .timestamp-kwd { color: #5f9ea0; }
  .org-right  { margin-left: auto; margin-right: 0px;  text-align: right; }
  .org-left   { margin-left: 0px;  margin-right: auto; text-align: left; }
  .org-center { margin-left: auto; margin-right: auto; text-align: center; }
  .underline { text-decoration: underline; }
  #postamble p, #preamble p { font-size: 90%; margin: .2em; }
  p.verse { margin-left: 3%; }
  pre {
    border: 1px solid #ccc;
    box-shadow: 3px 3px 3px #eee;
    padding: 8pt;
    font-family: monospace;
    overflow: auto;
    margin: 1.2em;
  }
  pre.src {
    position: relative;
    overflow: visible;
    padding-top: 1.2em;
  }
  pre.src:before {
    display: none;
    position: absolute;
    background-color: white;
    top: -10px;
    right: 10px;
    padding: 3px;
    border: 1px solid black;
  }
  pre.src:hover:before { display: inline;}
  /* Languages per Org manual */
  pre.src-asymptote:before { content: 'Asymptote'; }
  pre.src-awk:before { content: 'Awk'; }
  pre.src-json:before { content: 'JSON'; }
  pre.src-C:before { content: 'C'; }
  /* pre.src-C++ doesn't work in CSS */
  pre.src-clojure:before { content: 'Clojure'; }
  pre.src-css:before { content: 'CSS'; }
  pre.src-D:before { content: 'D'; }
  pre.src-ditaa:before { content: 'ditaa'; }
  pre.src-dot:before { content: 'Graphviz'; }
  pre.src-calc:before { content: 'Emacs Calc'; }
  pre.src-emacs-lisp:before { content: 'Emacs Lisp'; }
  pre.src-fortran:before { content: 'Fortran'; }
  pre.src-gnuplot:before { content: 'gnuplot'; }
  pre.src-haskell:before { content: 'Haskell'; }
  pre.src-hledger:before { content: 'hledger'; }
  pre.src-java:before { content: 'Java'; }
  pre.src-js:before { content: 'Javascript'; }
  pre.src-latex:before { content: 'LaTeX'; }
  pre.src-ledger:before { content: 'Ledger'; }
  pre.src-lisp:before { content: 'Lisp'; }
  pre.src-lilypond:before { content: 'Lilypond'; }
  pre.src-lua:before { content: 'Lua'; }
  pre.src-matlab:before { content: 'MATLAB'; }
  pre.src-mscgen:before { content: 'Mscgen'; }
  pre.src-ocaml:before { content: 'Objective Caml'; }
  pre.src-octave:before { content: 'Octave'; }
  pre.src-org:before { content: 'Org mode'; }
  pre.src-oz:before { content: 'OZ'; }
  pre.src-plantuml:before { content: 'Plantuml'; }
  pre.src-processing:before { content: 'Processing.js'; }
  pre.src-python:before { content: 'Python'; }
  pre.src-R:before { content: 'R'; }
  pre.src-ruby:before { content: 'Ruby'; }
  pre.src-sass:before { content: 'Sass'; }
  pre.src-scheme:before { content: 'Scheme'; }
  pre.src-screen:before { content: 'Gnu Screen'; }
  pre.src-sed:before { content: 'Sed'; }
  pre.src-sh:before { content: 'shell'; }
  pre.src-sql:before { content: 'SQL'; }
  pre.src-sqlite:before { content: 'SQLite'; }
  /* additional languages in org.el's org-babel-load-languages alist */
  pre.src-forth:before { content: 'Forth'; }
  pre.src-io:before { content: 'IO'; }
  pre.src-J:before { content: 'J'; }
  pre.src-makefile:before { content: 'Makefile'; }
  pre.src-maxima:before { content: 'Maxima'; }
  pre.src-perl:before { content: 'Perl'; }
  pre.src-picolisp:before { content: 'Pico Lisp'; }
  pre.src-scala:before { content: 'Scala'; }
  pre.src-shell:before { content: 'Shell Script'; }
  pre.src-ebnf2ps:before { content: 'ebfn2ps'; }
  /* additional language identifiers per \"defun org-babel-execute\"
       in ob-*.el */
  pre.src-cpp:before  { content: 'C++'; }
  pre.src-abc:before  { content: 'ABC'; }
  pre.src-coq:before  { content: 'Coq'; }
  pre.src-groovy:before  { content: 'Groovy'; }
  /* additional language identifiers from org-babel-shell-names in
     ob-shell.el: ob-shell is the only babel language using a lambda to put
     the execution function name together. */
  pre.src-bash:before  { content: 'bash'; }
  pre.src-csh:before  { content: 'csh'; }
  pre.src-ash:before  { content: 'ash'; }
  pre.src-dash:before  { content: 'dash'; }
  pre.src-ksh:before  { content: 'ksh'; }
  pre.src-mksh:before  { content: 'mksh'; }
  pre.src-posh:before  { content: 'posh'; }
  /* Additional Emacs modes also supported by the LaTeX listings package */
  pre.src-ada:before { content: 'Ada'; }
  pre.src-asm:before { content: 'Assembler'; }
  pre.src-caml:before { content: 'Caml'; }
  pre.src-delphi:before { content: 'Delphi'; }
  pre.src-html:before { content: 'HTML'; }
  pre.src-idl:before { content: 'IDL'; }
  pre.src-mercury:before { content: 'Mercury'; }
  pre.src-metapost:before { content: 'MetaPost'; }
  pre.src-modula-2:before { content: 'Modula-2'; }
  pre.src-pascal:before { content: 'Pascal'; }
  pre.src-ps:before { content: 'PostScript'; }
  pre.src-prolog:before { content: 'Prolog'; }
  pre.src-simula:before { content: 'Simula'; }
  pre.src-tcl:before { content: 'tcl'; }
  pre.src-tex:before { content: 'TeX'; }
  pre.src-plain-tex:before { content: 'Plain TeX'; }
  pre.src-verilog:before { content: 'Verilog'; }
  pre.src-vhdl:before { content: 'VHDL'; }
  pre.src-xml:before { content: 'XML'; }
  pre.src-nxml:before { content: 'XML'; }
  /* add a generic configuration mode; LaTeX export needs an additional
     (add-to-list 'org-latex-listings-langs '(conf \" \")) in .emacs */
  pre.src-conf:before { content: 'Configuration File'; }

  table { border-collapse:collapse; }
  caption.t-above { caption-side: top; }
  caption.t-bottom { caption-side: bottom; }
  td, th { vertical-align:top;  }
  th.org-right  { text-align: center;  }
  th.org-left   { text-align: center;   }
  th.org-center { text-align: center; }
  td.org-right  { text-align: right;  }
  td.org-left   { text-align: left;   }
  td.org-center { text-align: center; }
  dt { font-weight: bold; }
  .footpara { display: inline; }
  .footdef  { margin-bottom: 1em; }
  .figure { padding: 1em; }
  .figure p { text-align: center; }
  .equation-container {
    display: table;
    text-align: center;
    width: 100%;
  }
  .equation {
    vertical-align: middle;
  }
  .equation-label {
    display: table-cell;
    text-align: right;
    vertical-align: middle;
  }
  .inlinetask {
    padding: 10px;
    border: 2px solid gray;
    margin: 10px;
    background: #ffffcc;
  }
  #org-div-home-and-up
   { text-align: right; font-size: 70%; white-space: nowrap; }
  textarea { overflow-x: auto; }
  .linenr { font-size: smaller }
  .code-highlighted { background-color: #ffff00; }
  .org-info-js_info-navigation { border-style: none; }
  #org-info-js_console-label
    { font-size: 10px; font-weight: bold; white-space: nowrap; }
  .org-info-js_search-highlight
    { background-color: #ffff00; color: #000000; font-weight: bold; }
  .org-svg { width: 90%; }
  /*]]>*/-->
</style>"
  "The default style specification for exported HTML files.
You can use `org-html-head' and `org-html-head-extra' to add to
this style.  If you don't want to include this default style,
customize `org-html-head-include-default-style'."
)
