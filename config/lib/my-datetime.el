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


(provide 'my-datetime)
