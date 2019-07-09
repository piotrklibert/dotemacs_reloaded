## LightCorn API specification

1. The docs (ie. [index.html](./index.html)) are normally served by WhiteNoise
   at `/docs/` URL. This is set up in `wsgi.py` and bypasses Django URL config.

   In production they should be served with Nginx - this is a pending **TODO**,
   as we don't have a proper production yet.

2. The main file here is [flow.org](./flow.org). It is written in a format
   called [Org](https://orgmode.org), which is a markup format with
   characteristics between
   [ReST](http://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html)
   and [Markdown](https://daringfireball.net/projects/markdown/syntax) - it's
   simpler than the first one but more complex than the second. See this
   [quick reference](https://gist.github.com/wdkrnls/1990839) and
   [Org to ReST](https://github.com/msnoigrs/ox-rst) for help.

3. `flow.org` has to be manually converted to HTML using the `make build`
   command. Use `make help` for more info, or see the [Makefile](./Makefile).

4. During the export the shell scripts given as examples in `flow.org` are
   executed, to make sure they are correct. The build fails if any of them
   fails.

5. The shell scripts are also dumped into `./scripts/run_*.sh` (ie.
   `./scripts/run_farro.sh`) to make it easy to re-run them later.

7. To execute correctly, the examples need to know the *URL of test instance*
   and *credentials* used obtain authentication token. This info is stored in a
   `./creds.el` file, which is **not in Git** and **you have to create** it
   yourself. Credentials for test accounts on test instances (should you need
   them) should be put in LastPass.

8. The creds file has the following format (please mind the parens and make sure
   they're balanced; whitespace is not significant):

        (("test_instance" . "URL, may be localhost")
         ("test_username" . "")
         ("test_password" . ""))

9. `make edit` uses Emacs' ability to run in a terminal to open `flow.org` - but
   please don't try to actually *edit* it that way. Use your main editor for
   editing and use `make edit` as a viewer and script runner.

   Use `<TAB>` to fold/unfold current segment or `<SHIFT+TAB>` to fold/unfold
   all segments at once.

   Tapping `<Ctrl + C>` *twice* will run the currently focused code block and
   paste the results below it. Pressing first `<Ctrl + C>`, then `<Ctrl + V>`
   and finally just `v` will show the expanded code block body (ie. without
   other blocks' references and with `{{{macros}}}` substituted).

   Press `<Ctrl + X>` then `<Ctrl + S>` to save and `<Ctrl + X>, <Ctrl + C>` to
   close.

10. NOTE: It's not that editing is impossible (see above), but the experience
   will suck greatly, to the point you'd never think possible. Seriously. If you
   insist, though - contact me (Piotr Klibert) and we'll get it configured for
   you.
