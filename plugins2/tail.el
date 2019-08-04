;;; tail.el --- Tail files within Emacs

;; Copyright (C) 2000 by Benjamin Drieu

;; Author: Benjamin Drieu <bdrieu@april.org>
;; Keywords: tools

;; This file is NOT part of GNU Emacs.

;; This program as GNU Emacs are free software; you can redistribute
;; them and/or modify them under the terms of the GNU General Public
;; License as published by the Free Software Foundation; either
;; version 2, or (at your option) any later version.

;; They are distributed in the hope that they will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with them; see the file COPYING.  If not, write to the Free
;; Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
;; 02111-1307, USA.

;;; Commentary:

;;  This program displays ``tailed'' contents of files inside
;;  transients windows of Emacs.  It is primarily meant to keep an eye
;;  on logs within Emacs instead of using additional terminals.

;;; Code:

;;; Options

(defgroup tail nil
  "Tail files or commands into Emacs buffers."
  :prefix "tail-"
  :group 'environment)

(defcustom tail-volatile nil
  "Use non-nil to erase previous output"
  :options '(nil t)
  :group 'tail)

(defcustom tail-audible nil
  "Use non-nil to produce a bell when some output is displayed"
  :options '(nil t)
  :group 'tail)

(defcustom tail-raise nil
  "Use non-nil to raise current frame when some output is displayed.
This could be *very* annoying."
  :options '(nil t)
  :group 'tail)

(defcustom tail-hide-delay 5
  "Time in seconds before a tail window is deleted"
  :type 'integer
  :group 'tail)

(defcustom tail-max-size 5
  "Maximum size of the window"
  :type 'integer
  :group 'tail)

;;; Functions


(defun tail-disp-window (tail-buffer tail-msg)
  "Display some content specified by TAIL-MSG inside TAIL-BUFFER.
Create this buffer if necessary."
  (require 'electric)

  (let*
      ((tail-disp-buf (set-buffer (get-buffer-create tail-buffer))))

    (with-current-buffer tail-disp-buf
      (read-only-mode -1)
      (when tail-volatile
	    (erase-buffer))
      (goto-char (buffer-end 1))
      (insert tail-msg)
      (goto-char (buffer-end 1))
      (set-window-point (get-buffer-window tail-disp-buf t) (buffer-end 1))
      (read-only-mode 1)
      (set-buffer-modified-p nil))

    (when tail-audible
      (beep 1))))

(defun tail-hide-window (buffer)
  ;; TODO cancel timer when some output comes during that time
  (delete-window (get-buffer-window buffer t)))

(defun tail-select-lowest-window ()
  "Select the lowest window on the frame."
  (let*
      ((lowest-window (selected-window))
	   (bottom-edge (car (cdr (cdr (cdr (window-edges))))))
       (last-window (previous-window))
       (window-search t))
    (while window-search
      (let* ((this-window (next-window))
	         (next-bottom-edge (nth 3 (window-edges this-window))))
	    (when (< bottom-edge next-bottom-edge)
	      (setq bottom-edge next-bottom-edge)
	      (setq lowest-window this-window))
	    (select-window this-window)
	    (when (eq last-window this-window)
	      (select-window lowest-window)
	      (setq window-search nil))))))

(defun tail-file (file)
  "Tail FILE inside a new buffer.
FILE cannot be a remote file specified with ange-ftp syntax
because it is passed to the Unix tail command."
  (interactive "Ftail file: ")
  ;; TODO what if file is remote (i.e. via ange-ftp)
  (tail-command "tail" "-F" file))

(defun tail-command (command &rest args)
  "Tail COMMAND's output.
COMMAND is called with ARGS inside a new buffer."
  (interactive "sTail command: \neToto: ")
  (let ((proc (apply 'start-process-shell-command
	                 command
	                 (format "*Tail: %s*" (mapconcat 'identity (cons command args) " "))
                     (cons command args))))
    (set-process-filter proc 'tail-filter)
    ;; (split-window-right)
    ;; (other-window 1)
    (pop-to-buffer (process-buffer proc))))




(defun tail-filter (process line)
  "Tail filter called when some output comes."
  (tail-disp-window (process-buffer process) line))



(provide 'tail)
;;; tail.el ends here
