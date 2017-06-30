(defalias 'yes-or-no-p 'y-or-n-p)

(defun y-or-n-p (prompt)
  "Ask user a \"y or n\" question.  Return t if answer is \"y\".
  PROMPT is the string to display to ask the question.  It should
  end in a space; `y-or-n-p' adds \"(y or n) \" to it.

  No confirmation of the answer is requested; a single character is
  enough.  SPC also means yes, and DEL means no.

  To be precise, this function translates user input into responses
  by consulting the bindings in `query-replace-map
  '; see the
  documentation of that variable for more information.  In this
  case, the useful bindings are `act', `skip', `recenter',
  `scroll-up', `scroll-down', and `quit'.
  An `act' response means yes, and a `skip' response means no.
  A `quit' response means to invoke `keyboard-quit'.
  If the user enters `recenter', `scroll-up', or `scroll-down'
  responses, perform the requested window recentering or scrolling
  and ask again.

  Under a windowing system a dialog box will be used if `last-nonmenu-event'
  is nil and `use-dialog-box' is non-nil."
  ;; ¡Beware! when I tried to edebug this code, Emacs got into a weird state
  ;; where all the keys were unbound (i.e. it somehow got triggered
  ;; within read-key, apparently).  I had to kill it.
  (let ((answer 'recenter))
    (cond
     (noninteractive
      (setq prompt (concat prompt
                           (if (eq ?\s (aref prompt (1- (length prompt))))
                               "" " ")
                           "(<return> or n) "))
      (let ((temp-prompt prompt))
        (while (not (memq answer '(act skip)))
          (let ((str (read-string temp-prompt)))
            (cond
             ((member str '("y" "Y")) (setq answer 'act))
             ((member str '("n" "N")) (setq answer 'skip))
             (t (setq temp-prompt (concat "Please answer <return> or n. "
                                          prompt))))))))

     ((and (display-popup-menus-p) (listp last-nonmenu-event) use-dialog-box)
      (setq answer
            (x-popup-dialog t `(,prompt ("Yes" . act) ("No" . skip)))))

     (t
      (setq prompt (concat prompt
                           (if (eq ?\s (aref prompt (1- (length prompt))))
                               "" " ")
                           "(<return> or n) "))
      (while
          (let*
              ((scroll-actions '(recenter
                                 scroll-up scroll-down
                                 scroll-other-window
                                 scroll-other-window-down))
               (key
                (let ((cursor-in-echo-area t))
                  (when minibuffer-auto-raise
                    (raise-frame (window-frame (minibuffer-window))))

                  (read-key
                   (propertize
                    (if (memq answer scroll-actions)
                        prompt
                      (concat "Please answer <return> or n.  " prompt))

                    'face 'minibuffer-prompt)))))

            (setq answer (lookup-key query-replace-map (vector key) t))
            (cond
             ((or (memq answer '(skip act))
                  (let
                      ((is-return (equal answer 'exit)))
                    (when is-return
                      (setq answer 'act))
                    is-return))
              nil)

             ((eq answer 'recenter)
              (recenter) t)

             ((eq answer 'scroll-up)
              (ignore-errors (scroll-up-command)) t)

             ((eq answer 'scroll-down)
              (ignore-errors (scroll-down-command)) t)

             ((eq answer 'scroll-other-window)
              (ignore-errors (scroll-other-window)) t)

             ((eq answer 'scroll-other-window-down)
              (ignore-errors (scroll-other-window-down)) t)

             ((or (memq answer '(exit-prefix quit)) (eq key ?\e))
              (signal 'quit nil) t)

             (t t)))
        (ding)
        (discard-input))))
    (let ((ret (eq answer 'act)))
      (unless noninteractive
        ;; FIXME this prints one too many spaces, since prompt
        ;; already ends in a space.  Eg "... (y or n)  y".
        (message "%s %s" prompt (if ret "y" "n")))
      ret)))


(eval-after-load 'sunrise-commander
  '(defun sr-y-n-or-a-p (prompt)
     "Ask the user with PROMPT for an answer y/n/a ('a' stands for 'always').
Returns t if the answer is y/Y, nil if the answer is n/N or the
symbol `ALWAYS' if the answer is a/A."
     (setq prompt (concat prompt "([y]es/<return>, [n]o or [a]lways)"))
     (let ((resp -1))
       (while (not (memq resp '(?y ?Y ?n ?N ?a ?A 10 return)))
         (setq resp (read-event prompt))
         (setq prompt "Please answer [y]es/<return>, [n]o or [a]lways "))
       (if (and (numberp resp) (>= resp 97))
           (setq resp (- resp 32)))
       (case resp
         (?Y t)
         (10 t)
         ('return t)
         (?A 'ALWAYS)
         (t nil)))))

(provide 'my-minibuf-prompt)
