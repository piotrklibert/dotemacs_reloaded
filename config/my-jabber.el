;; JABBER
(require 'jabber-autoloads)

(eval-after-load 'jabber
  '(progn
     (require 'jabber-alert)
     (require 'jabber-keepalive)
     (require 'autosmiley)

     (define-jabber-alert stumpwm
       "Displays message using the Slime connection to StumpWM instance in bottom-left corner of the screen."
       'jabber-stumpwm-display-message)

     (defvar *last-jabber-msg* "")
     (defun jabber-stumpwm-display-message (text &optional title)
       (setf *last-jabber-msg* title)
       (slime-eval-list `(let ((stumpwm:*message-window-gravity* :bottom-left))
                      (stumpwm:message ,text))))

     ;; (jabber-stumpwm-display-message "asdasdS" "sdf")


     (define-jabber-alert stumpwm-presence
       "Displays message using the Slime connection to StumpWM instance in top-right corner of the screen."
       'jabber-stumpwm-display-presence)

     (defun jabber-stumpwm-display-presence (who msg &rest rest)
       (setf msg (substring-no-properties msg))
       (slime-eval-list `(stumpwm:message ,msg)))


     ))

(defun my-start-jabber ()
  (interactive)
  (require 'jabber)
  (define-key jabber-chat-mode-map (kbd "<f5>") 'jabber-reconnect)
  (define-key jabber-roster-mode-map (kbd "<f5>") 'jabber-reconnect)
  (jabber-connect-all)
  (jabber-whitespace-ping-start)
  (jabber-keepalive-start))

;; INIT: start a Jabber client in the background, 30 seconds after Emacs starts
;; (run-at-time "30 sec" nil 'my-start-jabber)

;; (add-hook 'jabber-chat-mode-hook 'autosmiley-mode)


(defun jabber-reconnect ()
  "Disconnect and then reconnect to all XMPP account."
  (interactive)
  (jabber-disconnect)
  (jabber-connect-all))




(defadvice jabber-display-roster (after switch-to-roster activate)
  (switch-to-buffer "*-jabber-roster-*"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                   ALERTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun slime-eval-list (sexp)
  "Eval a given sexp, in the form of a list, in current SLIME/SWANK environment."
  (slime-eval `(swank:interactive-eval
                ,(format "%S" sexp))))

(defun my-jabber-message-default-message (from buffer text)
  (when (or jabber-message-alert-same-buffer
            (not (memq (selected-window) (get-buffer-window-list buffer))))
    (if (jabber-muc-sender-p from)
        (format "Private message from %s in %s"
                (jabber-jid-resource from)
                (jabber-jid-displayname (jabber-jid-user from)))
      (format "Message from %s: %s" (jabber-jid-displayname from) text))))
