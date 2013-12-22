;; ____   _____        ___   _ _     ___    _    ____    ____   _    ____ _____
;;|  _ \ / _ \ \      / / \ | | |   / _ \  / \  |  _ \  |  _ \ / \  / ___| ____|
;;| | | | | | \ \ /\ / /|  \| | |  | | | |/ _ \ | | | | | |_) / _ \| |  _|  _|
;;| |_| | |_| |\ V  V / | |\  | |__| |_| / ___ \| |_| | |  __/ ___ \ |_| | |___
;;|____/ \___/  \_/\_/  |_| \_|_____\___/_/   \_\____/  |_| /_/   \_\____|_____|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'thingatpt)

(defun my-fetch-page (page-url)
  "Fetch a HTTP page and insert it's body at point.

Useful for fetching Emacs plugins from github - just 'copy url'
to 'RAW' file and paste it to this function."
  (interactive
   (list
    (let*
        ((prompt    "Enter url (default: %s): ")
         (at-point  (thing-at-point 'url t))
         (input     (read-string (format prompt (or at-point ""))))
         (got-input (not (equal input ""))))
      (if (and (not got-input)
               (not at-point))
          (error "No url given")
        (if got-input input at-point)))))
  (lexical-let ((target (current-buffer)))
    (url-retrieve
     page-url
     (lambda (status)
       (search-forward "\n\n")
       (let
           ((body (buffer-substring (point) (point-max))))
         (message "%s" target)
         (with-current-buffer target
           (if current-prefix-arg
               (goto-char (point-max))
             (end-of-line))
           (newline)
           (insert body)))))))

(provide 'my-download-page)
