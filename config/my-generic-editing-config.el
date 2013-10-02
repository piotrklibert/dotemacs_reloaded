(require 's)
(require 'recentf)

(require 'delim-col)


;; TODO: figure out why it was disabled ;)
;; Thesaurus support
;;    (setq synonyms-file        <name & location of mthesaur.txt>)
;;    (setq synonyms-cache-file  <name & location of your cache file>)
;;    (require 'synonyms)

(require 'auto-mark)
(require 'mark-lines)
(require 'visible-mark)

(require 'fill-column-indicator)        ; vertical line on the 'fill' col
(require 'undo-tree)                    ; visualisation of undo/redo
(require 'browse-kill-ring)             ; visualisation of kill-ring


(require 'iedit)

(setq mc/list-file "~/.emacs.d/data/mc-lists.el")
(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

(recentf-mode 1)
(global-auto-mark-mode 1)
(global-visible-mark-mode 1)
(browse-kill-ring-default-keybindings)


;;                           _  _________   ______
;;                          | |/ / ____\ \ / / ___|
;;                          | ' /|  _|  \ V /\___ \
;;                          | . \| |___  | |  ___) |
;;                          |_|\_\_____| |_| |____/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "C-x C-d")    'ido-dired)

(global-set-key (kbd "C-<f2>")     'recentf-open-files)
(global-set-key (kbd "C-x C-k")    'kill-region)
(global-set-key (kbd "C-c C-k")    'kill-region)
(global-set-key (kbd "M-<right>")  'forward-sexp)
(global-set-key (kbd "M-<left>")   'backward-sexp)

(global-set-key (kbd "M-V")        'mark-lines-next-line)
(global-set-key (kbd "C-M-<SPC>")  'just-one-space)
(global-set-key (kbd "C-{")        'backward-paragraph)
(global-set-key (kbd "C-}")        'forward-paragraph)


;; My little ponies (I mean defuns):
(global-set-key (kbd "C-M-d")          'duplicate-line)
(global-set-key (kbd "M-S-<down>")     'move-text-down)
(global-set-key (kbd "M-S-<up>")       'move-text-up)
(global-set-key (kbd "C-v")            'kill-whole-line)
(global-set-key (kbd "M-j")            'join-region)
(define-key my-toggle-keys (kbd "C-c") 'unix-line-endings)



;;                        _   _  ___   ___  _  ______
;;                       | | | |/ _ \ / _ \| |/ / ___|
;;                       | |_| | | | | | | | ' /\___ \
;;                       |  _  | |_| | |_| | . \ ___) |
;;                       |_| |_|\___/ \___/|_|\_\____/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun my-text-mode-hook ()
  ;; I'm leaving this disabled for now, because:
  ;; a) it conflicts with table mode
  ;; b) I don't really use it that often anyways
  ;; (require 'flyspell)
  ;; (turn-on-flyspell)
  (delete-selection-mode 1)
  (undo-tree-mode 1)
  (turn-on-auto-fill)

  ;; This fucks up empty lines display in text modes, so
  ;; it's disabled
  (fci-mode -1)
 )

(add-hook 'text-mode-hook 'my-text-mode-hook)


;;    __  ____   __       _____ _   _ _   _  ____ _____ ___ ___  _   _ ____
;;   |  \/  \ \ / /      |  ___| | | | \ | |/ ___|_   _|_ _/ _ \| \ | / ___|
;;   | |\/| |\ V /       | |_  | | | |  \| | |     | |  | | | | |  \| \___ \
;;   | |  | | | |        |  _| | |_| | |\  | |___  | |  | | |_| | |\  |___) |
;;   |_|  |_| |_|        |_|    \___/|_| \_|\____| |_| |___\___/|_| \_|____/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'my-indent-config)
(require 'my-move-lines)

;; iedit has something for editing rectangles visually: C-<return>
;; NOTE: this is becoming less and less important as I learn rectangle functions
;; of Emacs.
(require 'my-rectangular-editing)

(defun renumber (&optional num)
  "Renumber the list items in the current paragraph,starting at point."
  (interactive)
  (setq num (or num 1))
  (let ((end (region-end))
        (m (mark)))
    (save-excursion
      (when (> (point) (mark)) (exchange-point-and-mark))
      (while (re-search-forward "^\\([;# ]*\\)[0-9]+" end t)
        (replace-match  (concat "\\1" (number-to-string num)))
        (setq num (1+ num))))
    (set-mark m)
    (setq deactivate-mark nil)))


(defun duplicate-line()
  "Insert a copy of current line below it. Leaves point at the
end of the second line."
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank))

(defun join-region()
  "Remove indentation and newline characters from a region."
  (interactive)
  (let
      ((beg (region-beginning)))
    (goto-char (region-end))
    (while (>  (line-beginning-position) beg)
      (delete-indentation))))

(defun unix-line-endings ()
  (interactive)
  (when (not (s-contains? "unix" (symbol-name buffer-file-coding-system)))
    (set-buffer-file-coding-system 'utf-8-unix)))
