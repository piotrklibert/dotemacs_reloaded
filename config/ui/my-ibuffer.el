;; -*- mode: emacs-lisp -*-
(require 'ibuffer)

(defun ibuffer-end ()
  (interactive)
  (goto-char (point-max))
  (forward-line -1)
  (ibuffer-skip-properties '(ibuffer-summary ibuffer-filter-group-name) -1))

(defun ibuffer-beginning ()
  (interactive)
  (goto-char (point-min))
  (ibuffer-skip-properties '(ibuffer-title ibuffer-filter-group-name) 1))

;; Override - there was no simple way of changing the behavior to display diff
;; in another window.
(defun ibuffer-diff-with-file ()
  "View the differences between marked buffers and their associated files.
If no buffers are marked, use buffer at point.
This requires the external program \"diff\" to be in your `exec-path'."
  (interactive)
  (require 'diff)
  (let ((marked-bufs (ibuffer-get-marked-buffers)))
    (when (null marked-bufs)
      (setq marked-bufs (list (ibuffer-current-buffer t))))
    (with-current-buffer (get-buffer-create "*Ibuffer Diff*")
      (setq buffer-read-only nil)
      (buffer-disable-undo (current-buffer))
      (erase-buffer)
      (buffer-enable-undo (current-buffer))
      (diff-mode)
      (dolist (buf marked-bufs)
	(unless (buffer-live-p buf)
	  (error "Buffer %s has been killed" buf))
	(ibuffer-diff-buffer-with-file-1 buf))
      (setq buffer-read-only t)))
  (switch-to-buffer-other-window "*Ibuffer Diff*"))


;; (advice-add 'ibuffer-diff-with-file :before 'my-ibuffer-diff-with-file-advice)
;; (defun ad-ibuffer+find-file-noselect (&rest args)
;;   (message "ad-ibuffer+find-file-noselect: %s" args)
;;   (with-current-buffer "*Ibuffer*"
;;     (ibuffer-update nil)))

;; (advice-add 'find-file :after 'ad-ibuffer+find-file-noselect)
;; (advice-remove 'find-file 'ad-ibuffer+find-file-noselect)


(defun my-ibuffer-mode-hook ()
  "Customized/added in ibuffer-mode-hook custom option."
  ;; see also ibuffer-formats for columns config
  (define-key ibuffer-mode-map (kbd "M-f")    'ibuffer-jump-to-buffer) ; TODO: use HELM here!!
  (define-key ibuffer-mode-map (kbd "<down>") 'ibuffer-forward-line)
  (define-key ibuffer-mode-map (kbd "<up>")   'ibuffer-backward-line)

  ;; (define-key ibuffer-mode-map (kbd "C-/")    nil)
  (define-key ibuffer-mode-map (kbd "/")      'hydra-ibuffer-filters/body)
  (define-key ibuffer-mode-map (kbd "m")      'hydra-ibuffer-marking/ibuffer-mark-forward)
  (define-key ibuffer-mode-map (kbd ".")      'hydra-ibuffer-marking/body)
  (define-key ibuffer-mode-map (kbd "*")      'hydra-ibuffer-marking/body)

  (define-key ibuffer-mode-map (kbd "<insert>") 'ibuffer-mark-forward)

  (define-key ibuffer-mode-map [remap beginning-of-buffer] 'ibuffer-beginning)
  (define-key ibuffer-mode-map [remap end-of-buffer] 'ibuffer-end)

  (wrap-region-mode 0)                 ; made ibuffer filtering keys unavailable
  (hl-line-mode)                       ; TODO: change to more contrasting color
  )


(provide 'my-ibuffer)
