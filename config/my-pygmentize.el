


(defun pygmentize (lexer)
  "Produces highlighted HTML representation of a selected source code region."
  ;; TODO: make it into `(list (ido-completing-read ...))' with supported-langs
  (interactive "sLang? ")
  (let
      ((command (concat "pygmentize -l " lexer " -f html -P encoding=utf8 -O linenos=inline" )))
    (if (use-region-p)
        (shell-command-on-region (region-beginning)
                                 (region-end)
                                 command
                                 nil t) ; t - replace the region with cmd result
      (message "I'm only working with regions"))))



(defun pygmentize-buffer (lexer)
  ;; TODO: make it into `(list (ido-completing-read ...))' with supported-langs
  (interactive "sLang? ")
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
      (shell-command-on-region (point-min)
                               (point-max)
                               (format pygmentize-cmd lexer)
                               buf t)
      (goto-char (point-min))
      (insert pygmentize-styles)
      (write-file (concat file-name ".html"))
      (kill-buffer buf))))



(setq supported-langs (list "abap" "ada" "ada95ada2005" "agda" "ahk" "autohotkey" "alloy" "antlr-as"
                            "antlr-actionscript" "antlr-cpp" "antlr-csharp" "antlr-c#" "antlr-java"
                            "antlr-objc" "antlr-perl" "antlr-python" "antlr-ruby" "antlr-rb" "antlr"
                            "apacheconf" "aconf" "apache" "apl" "applescript" "as" "actionscript" "as3"
                            "actionscript3" "aspectj" "aspx-cs" "aspx-vb" "asy" "asymptote" "at"
                            "ambienttalk" "ambienttalk/2" "autoit" "awk" "gawk" "mawk" "nawk" "basemake"
                            "bash" "sh" "ksh" "bat" "batch" "dosbatch" "winbatch" "bbcode" "befunge"
                            "blitzbasic" "b3d" "bplus" "blitzmax" "bmax" "boo" "brainfuck" "bf" "bro" "bugs"
                            "winbugs" "openbugs" "c-objdump" "c" "ca65" "cbmbas" "ceylon" "cfc" "cfengine3"
                            "cf3" "cfm" "cfs" "chai" "chaiscript" "chapel" "chpl" "cheetah" "spitfire"
                            "cirru" "clay" "clojure" "clj" "clojurescript" "cljs" "cmake" "cobol"
                            "cobolfree" "coffee-script" "coffeescript" "coffee" "common-lisp" "cl" "lisp"
                            "elisp" "emacs" "emacs-lisp" "console" "control" "debcontrol" "coq" "cpp" "c++"
                            "cpp-objdump" "c++-objdumb" "cxx-objdump" "croc" "cryptol" "cry" "csharp" "c#"
                            "css+django" "css+jinja" "css+erb" "css+ruby" "css+genshitext" "css+genshi"
                            "css+lasso" "css+mako" "css+myghty" "css+php" "css+smarty" "css" "cucumber"
                            "gherkin" "cuda" "cu" "cypher" "cython" "pyx" "pyrex" "d-objdump" "d" "dart"
                            "delphi" "pas" "pascal" "objectpascal" "dg" "diff" "udiff" "django" "jinja"
                            "docker" "dockerfile" "dpatch" "dtd" "duel" "jbst" "jsonml+bst" "dylan-console"
                            "dylan-repl" "dylan-lid" "lid" "dylan" "ebnf" "ec" "ecl" "eiffel" "elixir" "ex"
                            "exs" "erb" "erl" "erlang" "evoque" "factor" "fan" "fancy" "fy" "felix" "flx"
                            "fortran" "foxpro" "vfp" "clipper" "xbase" "fsharp" "gap" "gas" "asm" "genshi"
                            "kid" "xml+genshi" "xml+kid" "genshitext" "glsl" "gnuplot" "go" "golo"
                            "gooddata-cl" "gosu" "groff" "nroff" "man" "groovy" "gst" "haml" "handlebars"
                            "haskell" "hs" "haxeml" "hxml" "html+cheetah" "html+spitfire" "htmlcheetah"
                            "html+django" "html+jinja" "htmldjango" "html+evoque" "html+genshi" "html+kid"
                            "html+handlebars" "html+lasso" "html+mako" "html+myghty" "html+php"
                            "html+smarty" "html+velocity" "html" "http" "hx" "haxe" "hxsl" "hybris" "hy"
                            "hylang" "i6t" "idl" "idris" "idr" "iex" "igor" "igorpro" "inform6" "i6"
                            "inform7" "i7" "ini" "cfg" "dosini" "io" "ioke" "ik" "irc" "jade" "jags"
                            "jasmin" "jasminxt" "java" "jlcon" "js+cheetah" "javascript+cheetah"
                            "js+spitfire" "javascript+spitfire" "js+django" "javascript+django" "js+jinja"
                            "javascript+jinja" "js+erb" "javascript+erb" "js+ruby" "javascript+ruby"
                            "js+genshitext" "js+genshi" "javascript+genshitext" "javascript+genshi"
                            "js+lasso" "javascript+lasso" "js+mako" "javascript+mako" "js+myghty"
                            "javascript+myghty" "js+php" "javascript+php" "js+smarty" "javascript+smarty"
                            "js" "javascript" "json" "jsp" "julia" "jl" "kal" "kconfig" "menuconfig"
                            "linux-config" "kernel-config" "koka" "kotlin" "lagda" "literate-agda" "lasso"
                            "lassoscript" "lcry" "literate-cryptol" "lcryptol" "lhs" "literate-haskell"
                            "lhaskell" "lidr" "literate-idris" "lidris" "lighty" "lighttpd" "limbo" "liquid"
                            "live-script" "livescript" "llvm" "logos" "logtalk" "lsl" "lua" "make"
                            "makefile" "mf" "bsdmake" "mako" "maql" "mask" "mason" "mathematica" "mma" "nb"
                            "matlab" "matlabsession" "minid" "modelica" "modula2" "m2" "monkey" "moocode"
                            "moo" "moon" "moonscript" "mql" "mq4" "mq5" "mql4" "mql5" "mscgen" "msc" "mupad"
                            "mxml" "myghty" "mysql" "nasm" "nemerle" "nesc" "newlisp" "newspeak" "nginx"
                            "nimrod" "nim" "nixos" "nix" "nsis" "nsi" "nsh" "numpy" "objdump-nasm" "objdump"
                            "objective-c++" "objectivec++" "obj-c++" "objc++" "objective-c" "objectivec"
                            "obj-c" "objc" "objective-j" "objectivej" "obj-j" "objj" "ocaml" "octave" "ooc"
                            "opa" "openedge" "abl" "progress" "pan" "pawn" "perl" "pl" "perl6" "pl6" "php"
                            "php3" "php4" "php5" "pig" "pike" "plpgsql" "postgresql" "postgres" "postscript"
                            "postscr" "pot" "po" "pov" "powershell" "posh" "ps1" "psm1" "prolog"
                            "properties" "jproperties" "protobuf" "proto" "psql" "postgresql-console"
                            "postgres-console" "puppet" "py3tb" "pycon" "pypylog" "pypy" "pytb" "python"
                            "py" "sage" "python3" "py3" "qbasic" "basic" "qml" "racket" "rkt" "ragel-c"
                            "ragel-cpp" "ragel-d" "ragel-em" "ragel-java" "ragel-objc" "ragel-ruby"
                            "ragel-rb" "ragel" "raw" "rb" "ruby" "duby" "rbcon" "irb" "rconsole" "rout" "rd"
                            "rebol" "red" "red/system" "redcode" "registry" "rexx" "arexx" "rhtml"
                            "html+erb" "html+ruby" "robotframework" "rql" "rsl" "rst" "rest"
                            "restructuredtext" "rust" "sass" "scala" "scaml" "scheme" "scm" "scilab" "scss"
                            "shell-session" "slim" "smali" "smalltalk" "squeak" "st" "smarty" "sml" "snobol"
                            "sourceslist" "sources.list" "debsources" "sp" "sparql" "spec" "splus" "s" "r"
                            "sql" "sqlite3" "squidconf" "squid.conf" "squid" "ssp" "stan" "swift" "swig"
                            "systemverilog" "sv" "tcl" "tcsh" "csh" "tea" "tex" "latex" "text" "todotxt"
                            "trac-wiki" "moin" "treetop" "ts" "urbiscript" "vala" "vapi" "vb.net" "vbnet"
                            "vctreestatus" "velocity" "verilog" "v" "vgl" "vhdl" "vim" "xml+cheetah"
                            "xml+spitfire" "xml+django" "xml+jinja" "xml+erb" "xml+ruby" "xml+evoque"
                            "xml+lasso" "xml+mako" "xml+myghty" "xml+php" "xml+smarty" "xml+velocity" "xml"
                            "xquery" "xqy" "xq" "xql" "xqm" "xslt" "xtend" "yaml+jinja" "salt" "sls" "yaml"
                            "zephir"))



(setq pygmentize-cmd (concat "pygmentize"
                             " -l %s"
                             " -f html"
                             " -P encoding=utf8"
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
