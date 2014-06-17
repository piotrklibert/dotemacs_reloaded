(setq my-sc-desc
      '("First, select which set of directories we consider a 'project'"
        "I selected a 'prv' directory set, which has my .emacs.d among other."
        "Now to open my general configuration file."
        "As we saw, I have a couple of files with 'generic' in the filename."))

(defun my-sc-next-desc ()
  (interactive)
  (save-excursion
    (goto-char (point-max))
    (insert "\n\n" (pop my-sc-desc))))

(my-sc-next-desc)
