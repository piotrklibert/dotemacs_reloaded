(require 's)

(require 'recentf)
(recentf-mode 1)

;; spelling corrections in text mode
(require 'flyspell)
(setq ispell-program-name "ispell")

;; Thesaurus support
;;    (setq synonyms-file        <name & location of mthesaur.txt>)
;;    (setq synonyms-cache-file  <name & location of your cache file>)
;;    (require 'synonyms)

(require 'mark-lines)

(require 'visible-mark)
(global-visible-mark-mode 1)

(require 'auto-mark)
(global-auto-mark-mode 1)

;; shows a vertical bar on the 'fill' (wrap) line
;; NOTE: this fucks up display of empty lines in text modes
(require 'fill-column-indicator)
(add-hook 'text-mode-hook 'fci-mode)

;; visualisation of undo/redo
(require 'undo-tree)
(add-hook 'text-mode-hook 'undo-tree-mode)

;; visualisation of kill-ring
(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

(require 'iedit)
(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)



;;                           _  _________   ______
;;                          | |/ / ____\ \ / / ___|
;;                          | ' /|  _|  \ V /\___ \
;;                          | . \| |___  | |  ___) |
;;                          |_|\_\_____| |_| |____/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "C-x C-d") 'ido-dired)

(global-set-key (kbd "C-<f2>")     'recentf-open-files)
(global-set-key (kbd "C-x C-k")    'kill-region)
(global-set-key (kbd "C-c C-k")    'kill-region)
(global-set-key (kbd "C-M-d")      'duplicate-line)
(global-set-key (kbd "M-<right>")  'forward-sexp)
(global-set-key (kbd "M-<left>")   'backward-sexp)

(global-set-key (kbd "M-S-<down>") 'move-text-down)
(global-set-key (kbd "M-S-<up>")   'move-text-up)

(global-set-key (kbd "M-V")        'mark-lines-next-line)
(global-set-key (kbd "C-v")        'kill-whole-line)
(global-set-key (kbd "C-M-<SPC>")  'just-one-space)
(global-set-key (kbd "C-{")        'backward-paragraph)
(global-set-key (kbd "C-}")        'forward-paragraph)
(global-set-key (kbd "M-j")        'join-region)


(define-key my-toggle-keys (kbd "C-c") 'unix-line-endings)
;; got from: http://www.emacswiki.org/emacs/ElectricHelp
;; seems it's garbage
;; (global-set-key "\C-h" 'ehelp-command)


;;
;; TEXT MODE HOOKS
;;

(defun my-text-mode-hook ()
  (turn-on-auto-fill)
  (turn-on-flyspell)
  (delete-selection-mode 1))

(add-hook 'text-mode-hook 'my-text-mode-hook)


;;  __  ____   __       _____ _   _ _   _  ____ _____ ___ ___  _   _ ____
;; |  \/  \ \ / /      |  ___| | | | \ | |/ ___|_   _|_ _/ _ \| \ | / ___|
;; | |\/| |\ V /       | |_  | | | |  \| | |     | |  | | | | |  \| \___ \
;; | |  | | | |        |  _| | |_| | |\  | |___  | |  | | |_| | |\  |___) |
;; |_|  |_| |_|        |_|    \___/|_| \_|\____| |_| |___\___/|_| \_|____/
;;

;; (defun insert-newline ()
;;   (interactive)
;;   (newline-and-indent))
;; (global-set-key (kbd "C-<return>") 'insert-newline)

(require 'my-indent-config)
(require 'my-move-lines)

;; iedit has something for editing rectangles visually: C-<return>
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
  (interactive)
  (move-beginning-of-line 1)
  (kill-line) (yank)
  (open-line 1) (next-line 1) (yank))

(defun join-region()
  (interactive)
  (let
      ((beg (region-beginning)))
    (goto-char (region-end))
    (while (>  (line-beginning-position) beg)
      (delete-indentation))))

(defun upcase-word-or-region ()
  (interactive)
  (if (use-region-p)
      (upcase-region (region-beginning) (region-end))
    (save-excursion
      (let
          ((bounds (bounds-of-thing-at-point 'word)))
        (goto-char (car bounds))
        (upcase-word 1)))))


(defun unix-line-endings ()
  (interactive)
  (when (not (s-contains? "unix" (symbol-name buffer-file-coding-system)))
    (set-buffer-file-coding-system 'utf-8-unix)))
