(defun pygmentize (lang)
  "Produces highlighted HTML representation of a selected source code region."
  (interactive "sLang? ")
  (let
      ((command (concat "pygmentize -l " lang " -f html")))
    (if (use-region-p)
        (shell-command-on-region (region-beginning) (region-end)
                                 command nil t)
      (message "I'm only working with regions"))))


(defun pygmentize-buffer ()
  (interactive)
  (let
      ((buf (get-buffer-create "*pygmentize*"))
       (file-name (car (reverse (s-split "/" (buffer-file-name)))))
       pygmentized-source source)

    (setq source (buffer-substring-no-properties (point-min)
                                                 (point-max)))

    (save-current-buffer
      (set-buffer buf)
      (erase-buffer)
      (insert source)
      (shell-command-on-region (point-min) (point-max) pygmentize-cmd buf t)
      (goto-char (point-min))
      (insert pygmentize-styles)
      (write-file (concat file-name ".html"))
      (kill-buffer buf))))


(setq pygmentize-cmd (concat "pygmentize"
                               " -l livescript"
                               " -f html"
                               " -O linenos=table"
                               " -O lineanchors=lineno"
                               " -O linespans=line"
                               " -O anchorlinenos"))

(setq pygmentize-styles "
<style>
    body { background-color: black; }
    .highlighttable { width: 670px; margin: auto; }
    .linenos a, .linenos a:visited, .linenos a:active  {
        color: yellow;
        padding-right: 6px;
        text-decoration: none;
    }

    .hll { background-color: #49483e }
    .c { color: #75715e } /* Comment */
    .err { color: #960050; background-color: #1e0010 } /* Error */
    .k { color: #66d9ef } /* Keyword */
    .l { color: #ae81ff } /* Literal */
    .n { color: #f8f8f2 } /* Name */
    .o { color: #f92672 } /* Operator */
    .p { color: #f8f8f2 } /* Punctuation */
    .cm { color: #75715e } /* Comment.Multiline */
    .cp { color: #75715e } /* Comment.Preproc */
    .c1 { color: #75715e } /* Comment.Single */
    .cs { color: #75715e } /* Comment.Special */
    .ge { font-style: italic } /* Generic.Emph */
    .gs { font-weight: bold } /* Generic.Strong */
    .kc { color: #66d9ef } /* Keyword.Constant */
    .kd { color: #66d9ef } /* Keyword.Declaration */
    .kn { color: #f92672 } /* Keyword.Namespace */
    .kp { color: #66d9ef } /* Keyword.Pseudo */
    .kr { color: #66d9ef } /* Keyword.Reserved */
    .kt { color: #66d9ef } /* Keyword.Type */
    .ld { color: #e6db74 } /* Literal.Date */
    .m { color: #ae81ff } /* Literal.Number */
    .s { color: #e6db74 } /* Literal.String */
    .na { color: #a6e22e } /* Name.Attribute */
    .nb { color: #f8f8f2 } /* Name.Builtin */
    .nc { color: #a6e22e } /* Name.Class */
    .no { color: #66d9ef } /* Name.Constant */
    .nd { color: #a6e22e } /* Name.Decorator */
    .ni { color: #f8f8f2 } /* Name.Entity */
    .ne { color: #a6e22e } /* Name.Exception */
    .nf { color: #a6e22e } /* Name.Function */
    .nl { color: #f8f8f2 } /* Name.Label */
    .nn { color: #f8f8f2 } /* Name.Namespace */
    .nx { color: #a6e22e } /* Name.Other */
    .py { color: #f8f8f2 } /* Name.Property */
    .nt { color: #f92672 } /* Name.Tag */
    .nv { color: #f8f8f2 } /* Name.Variable */
    .ow { color: #f92672 } /* Operator.Word */
    .w { color: #f8f8f2 } /* Text.Whitespace */
    .mf { color: #ae81ff } /* Literal.Number.Float */
    .mh { color: #ae81ff } /* Literal.Number.Hex */
    .mi { color: #ae81ff } /* Literal.Number.Integer */
    .mo { color: #ae81ff } /* Literal.Number.Oct */
    .sb { color: #e6db74 } /* Literal.String.Backtick */
    .sc { color: #e6db74 } /* Literal.String.Char */
    .sd { color: #e6db74 } /* Literal.String.Doc */
    .s2 { color: #e6db74 } /* Literal.String.Double */
    .se { color: #ae81ff } /* Literal.String.Escape */
    .sh { color: #e6db74 } /* Literal.String.Heredoc */
    .si { color: #e6db74 } /* Literal.String.Interpol */
    .sx { color: #e6db74 } /* Literal.String.Other */
    .sr { color: #e6db74 } /* Literal.String.Regex */
    .s1 { color: #e6db74 } /* Literal.String.Single */
    .ss { color: #e6db74 } /* Literal.String.Symbol */
    .bp { color: #f8f8f2 } /* Name.Builtin.Pseudo */
    .vc { color: #f8f8f2 } /* Name.Variable.Class */
    .vg { color: #f8f8f2 } /* Name.Variable.Global */
    .vi { color: #f8f8f2 } /* Name.Variable.Instance */
    .il { color: #ae81ff } /* Literal.Number.Integer.Long */
</style>

")

(provide 'my-pygmentize)
