;;               ____  _____ __  __    _    _   _ _____ ___ ____
;;              / ___|| ____|  \/  |  / \  | \ | |_   _|_ _/ ___|
;;              \___ \|  _| | |\/| | / _ \ |  \| | | |  | | |
;;               ___) | |___| |  | |/ ___ \| |\  | | |  | | |___
;;              |____/|_____|_|  |_/_/   \_\_| \_| |_| |___\____|
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'my-utils)

(defun my-load-tagasauris-dbs ()
 (loop for file in (directory-files "~/.emacs.d/semanticdb" t)
       if (string-match "tagasauris" file)
       do (semanticdb-load-database file)))

(defun my-create-tagasauris-dbs ()
  (let* ((root "/usr/www/tagasauris/tagasauris/")
         (tag-dirs (walk-dirs root))
         (cls semanticdb-project-database-file))
    (--map (semanticdb-create-database cls it) tag-dirs)))

(defvar tag-databases (--filter (semanticdb-get-database-tables it)
                                (my-create-tagasauris-dbs)))
(defvar tag-tables (--mapcat (semanticdb-get-database-tables it)
                             tag-databases))

(defun my-semantic-completions (prefix)
  (let ((tags (-mapcat (my-format-tags prefix) tag-tables)))
    (--filter it tags)))

(defun my-format-tags (prefix)
  (lambda (tbl)
    (--map (my-get-tag-properties it (semanticdb-full-filename tbl))
           (my-get-matching-tags tbl prefix))))

(defun my-get-matching-tags (table str)
  (--filter (and (string-match str (semantic-tag-name it))
                 (member (semantic-tag-class it)
                         '(type function variable code)))
            (semanticdb-get-tags table)))

(defun my-get-tag-properties (tag fname)
  (let ((name (semantic-tag-name tag))
        (cls  (semantic-tag-class tag))
        (bounds (semantic-tag-bounds tag)))
    (list name cls fname bounds)))














(when nil
  (semanticdb-current-database-list "/usr/www/tagasauris/tagasauris")

  (loop for db in semanticdb-database-list
        for fname = (semanticdb-full-filename db)
        if (and fname (string-match "tagasauris" fname))
        collect (semanticdb-load-database fname))

  (setq paths
        (list "~/.emacs.d/semanticdb/!usr!www!tagasauris!tagasauris!accounts!semantic.cache"
              "~/.emacs.d/semanticdb/!usr!www!tagasauris!tagasauris!data!semantic.cache"
              "/root/.emacs.d/semanticdb/!usr!www!tagasauris!tagasauris!msgs!semantic.cache"))

  ;; primitive loading
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (eieio-persistent-read (expand-file-name (cadr paths))
                         semanticdb-project-database-file)
  (semanticdb-load-database (expand-file-name (car paths)))

  (with-current-buffer  (get-buffer-create "asdasd")
    (insert-file (nth 3 paths))
    (eval (read (buffer-string))))

  (eieio-slot-name-index semanticdb-project-database-file nil 'tables)
  (setq example-db (car (semanticdb-current-database-list)) )
  (object-slots example-db)
  (slot-value example-db 'tables)
  (slot-value (car (semanticdb-get-database-tables example-db)) 'file)
  (semanticdb-full-filename example-db)

  (semantic-tag-get-attribute (car (my-semantic-complete)) :documentation)
  (semantic-tag-file-name (car (my-semantic-complete)))
  (semantic-tag-name (car xxx))
  (semantic-tag-file-name (car xxx))
  (semanticdb-find-tags-by-name "MediaObject")


  ;; database lists
  (-map 'semanticdb-full-filename semanticdb-database-list)
  (length semanticdb-database-list)

  (-map 'semanticdb-full-filename (semanticdb-current-database-list))
  (length (semanticdb-current-database-list))


  (semanticdb-find-tags-for-completion "my-" example-db)

  (let*
      ((root "/usr/www/tagasauris/tagasauris/msgs/")
       (cls semanticdb-project-database-file))
    (setq xxx (loop for d in (semanticdb-get-database-tables
                              (semanticdb-create-database cls root))
                    for completions = (semantic-find-tags-for-completion "Pa" d)
                    if completions
                    collect completions))))
