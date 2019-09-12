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


(defun my-ibuffer-diff-with-file ()
  "Same as original but in new window"
  (interactive)
  (letf
      ;; replace
      (((symbol-function 'switch-to-buffer)
        (symbol-function 'switch-to-buffer-other-window)))
    (ibuffer-diff-with-file)))


(defun my-ibuffer-mode-hook ()
  "Customized/added in ibuffer-mode-hook custom option."
  ;; see also ibuffer-formats for columns config
  (define-key ibuffer-mode-map (kbd "M-f")    'ibuffer-jump-to-buffer) ; TODO: use HELM here!!
  (define-key ibuffer-mode-map (kbd "<down>") 'ibuffer-forward-line)
  (define-key ibuffer-mode-map (kbd "<up>")   'ibuffer-backward-line)
  (define-key ibuffer-mode-map (kbd "=")   'my-ibuffer-diff-with-file)

  ;; (define-key ibuffer-mode-map (kbd "C-/")    nil)
  (define-key ibuffer-mode-map (kbd "/")      'my-hydra-ibuffer-filters/body)
  (define-key ibuffer-mode-map (kbd "m")      'hydra-ibuffer-marking/ibuffer-mark-forward)
  (define-key ibuffer-mode-map (kbd ".")      'hydra-ibuffer-marking/body)
  (define-key ibuffer-mode-map (kbd "*")      'hydra-ibuffer-marking/body)

  (define-key ibuffer-mode-map (kbd "<insert>") 'ibuffer-mark-forward)

  (define-key ibuffer-mode-map [remap beginning-of-buffer] 'ibuffer-beginning)
  (define-key ibuffer-mode-map [remap end-of-buffer] 'ibuffer-end)

  (wrap-region-mode 0)                 ; made ibuffer filtering keys unavailable
  (hl-line-mode)                       ; TODO: change to more contrasting color
  )


(defvar my-ibuffer-refreshing-p nil
  "Set to t when refreshing is in progress, nil otherwise.")

(defun my-refresh-ibuffer (&optional buf)
  (interactive)
  (unless (typep buf 'string)
    (setq buf (buffer-name buf)))
  (unless (or (not buf)
              my-ibuffer-refreshing-p
              (or (s-contains-p "helm" buf)
                  (s-prefix-p " " buf)))
    ;; (message "Refresh Ibuffer: %s" buf)
    (let ((my-ibuffer-refreshing-p t))
      (save-window-excursion
        (cl-loop
         for buf in (buffer-list)
         when (s-prefix-p "*Ibuffer*" (buffer-name buf))
         do (with-current-buffer buf
              (let ((p (point)))
                (ibuffer-update nil t)
                (goto-char (min p (point-max)))))))))
  )

;; This is a HACK, it works solely by accident - neither hook nor advice
;; actually passes buffer object or buffer name to the function; apparently some
;; buffer is then randomly selected (via ido for some reason) and the function
;; proceedes with it.
(progn
  (advice-add 'kill-buffer :after 'my-refresh-ibuffer)
  (add-hook 'find-file-hook 'my-refresh-ibuffer))

(when nil
  (advice-remove 'kill-buffer 'my-refresh-ibuffer)
  (remove-hook 'find-file-hook 'my-refresh-ibuffer))


(provide 'my-ibuffer)
