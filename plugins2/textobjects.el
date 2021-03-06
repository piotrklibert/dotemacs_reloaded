;;; eclim.el --- an interface to the Eclipse IDE.
;;
;; Copyright (C) 2009  Tassilo Horn <tassilo@member.fsf.org>
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
;;; Contributors
;;
;; - Alessandro Arzilli (alessandro.arzilli @ gmail com)
;; - Piotr Klibert (klibertp in the gmail.com domain)

(defun pseudo-motion-paren-ex (searched related motion-fn limit)
  (block fn
    (let ((depth-count 0)
          (case-fold-search nil))
      (while (>= depth-count 0)
        (when (= (point) limit)
          (return-from fn nil))
        (funcall motion-fn)
        (cond
         ((char-equal (char-after) related) (incf depth-count))
         ((char-equal (char-after) searched) (decf depth-count))))
      (return-from fn t))))

(defun get-paren-delimited-region (open close)
  (let ((current-point (point)) (start-point 0) (end-point 0))
    (unless (pseudo-motion-paren-ex open close 'backward-char (point-min))
      (goto-char start-pos)
      (return '()))
    (forward-char)
    (setq start-point (point))
    (goto-char current-point)
    (unless (pseudo-motion-paren-ex close open 'forward-char (point-max))
      (goto-char start-pos)
      (return '()))
    (setq end-point (point))
    (goto-char current-point)
    (cons start-point end-point)))

(defun get-regex-delimited-region (regex noerror &optional in)
  (let ((start-point 0)
        (end-point 0))
    (save-excursion
      (re-search-backward regex (line-beginning-position) noerror)
      (setq start-point (point)))
    (save-excursion
      (re-search-forward regex (line-end-position) noerror)
      (setq end-point (point)))
    (cons start-point end-point)))

(defun pseudo-motion-get-paren-info (char)
  (let ((paren-info-assoc '(
                            (?{ . (?{ . ?}))
                            (?} . (?{ . ?}))
                            (?B . (?{ . ?}))
                            (?\[ . (?\[ . ?\]))
                            (?\] . (?\[ . \]))
                            (?\( . (?\( . ?\)))
                            (?\) . (?\( . ?\)))
                            (?b . (?\( . ?\)))
                            (?< . (?< . ?>))
                            (?> . (?< . ?>))
                            ))
        (case-fold-search nil))
    (and (characterp char)
         (assoc-default char paren-info-assoc 'char-equal))))


(defun pseudo-motion-is-quoted-string-p (kind)
  (let ((case-fold-search nil))
    (and (characterp kind) (or (char-equal kind ?\")
                               (char-equal kind ?\')
                               (char-equal kind ?\`)))))

(defun get-pseudo-motion-region (kind)
  (let
      ((case-fold-search nil)
       (paren-info (pseudo-motion-get-paren-info kind)))
    (cond
     ((consp paren-info)
      (get-paren-delimited-region (car paren-info)
                                  (cdr paren-info)))

     ((pseudo-motion-is-quoted-string-p kind)
      (get-regex-delimited-region (string kind) t))

     ((stringp kind)                    ; let's assume it's a regex already
      (get-regex-delimited-region kind nil nil))

     (t (error "unknown pseudo motion")))))

(defun pseudo-motion-an-extenders (kind)
  (let ((case-fold-search nil)
        (paren-info (pseudo-motion-get-paren-info kind)))
    (cond
     ((or (char-equal kind ?W)
          (char-equal kind ?w))
      '(?\s . ?\s))
     ((consp paren-info) paren-info)
     ((pseudo-motion-is-quoted-string-p kind) (cons kind kind))
     (t (error "unknown pseudo motion")))))


(defun pseudo-motion-extend-region-an (kind region)
  (let ((an-extenders (pseudo-motion-an-extenders kind)))
    (when (char-equal (char-before (car region)) (car an-extenders))
      (decf (car region)))
    (when (char-equal (char-after (cdr region)) (cdr an-extenders))
      (incf (cdr region)))
    region))

(defun pseudo-motion-execute-command-on-region (com region)
  (funcall com (car region) (cdr region)))


(defun pseudo-motion-interactive-base-in (com kind)
  (pseudo-motion-execute-command-on-region com (get-pseudo-motion-region kind)))

(defun pseudo-motion-interactive-base-an (com kind)
  (pseudo-motion-execute-command-on-region com (pseudo-motion-extend-region-an kind (get-pseudo-motion-region kind))))

(defun mark-pseudo-motion (char kind)
  (let
      ((reg (get-pseudo-motion-region char)))
    (when kind
      (setq reg (pseudo-motion-extend-region-an char reg)))
    (push-mark (car reg) t t)
    (goto-char (cdr reg))
    (setq deactivate-mark nil)
    (setq mark-active t)))

;; TODO: make it disable itself when asked
(defun global-textobject-mark-mode (&optional arg)
  (dolist (ch '(?\( ?\[ ?\{ ?\( ?\" ?\' ?\`))
    (lexical-let ((ch ch))
      (define-key global-map
        (concat "\C-xw" (string ch))
        (lambda (&optional arg)
          (interactive "P")
          (mark-pseudo-motion ch arg)))))

  ;; "a word" pseudo motion
  (define-key global-map
    "\C-xww"
    (lambda (&optional arg)
      (interactive "P")
      (mark-pseudo-motion "\\b" nil)))
  )

(provide 'textobjects)
