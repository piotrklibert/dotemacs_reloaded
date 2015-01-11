(require 'fuzzy-find-in-project)

;; fuzzy-find configuration, defines named directory groups for easy changing
;; between them and current/default group for use before the root is changed
;; explicitly


(ffip-defroots 'prv ("~/todo/" "~/priv/" "~/.emacs.d/config/")
  ;; (prv         . ( ))
  (my-projects . ("~/mgmnt/"
                  ;; "~/projects/open-resty/"
                  ;; "~/projects/images/my-base/"
                  "~/projects/klibert_pl/"
                  "~/projects/reqplayer/dpath/"
                  "~/poligon/plnizator/"
                  "~/poligon/luzem/"
                  "~/poligon/lscript/"
                  ))
  (emacs       . ("~/.emacs.d/pkg-langs/elpy/"
                  "~/.emacs.d/plugins2/" "~/.emacs.d/pkg-langs/"))

  ;; WORK RELATED
  (ion         . ("~/projects/ion/"))

  (sp          . ("~/projects/images/sp/"
                  "~/projects/reqviewer/"
                  "~/projects/reqplayer/"))

  (tag         . ("/usr/www/tagasauris/tagasauris/"
                  "/usr/www/tagasauris/src/tenclouds/tenclouds/"
                  "/usr/www/tagasauris/control/"
                  "/usr/www/tagasauris/config/"
                  "/usr/www/tagasauris/doc/"))

  (10c         . ("~/projects/images/repo/")))

;; There's a bit of a mess in my "misc projects" folder, and some of its
;; directories have much too many files in them, so I need to prune them before
;; adding them to `fuzzy-find-roots'.
(require 'f)

(defun my-absolutize (path dirname)
  (f-expand (f-join path dirname)))

(lexical-let*
    ((ignored (--map (f-expand (f-join "~/poligon/" it))
                     '("books-dedup" "django-debug-toolbar"
                       "django-rest-framework" "haxe"
                       "old_web_app_template" "poligon")))
     (subdirs (f-directories (f-expand "~/poligon/")
                             (lambda (path)
                               (not (-contains? ignored path)))))
     (new-ffip-dirs (append (util-get-alist 'my-projects fuzzy-find-roots)
                            subdirs)))
  (util-put-alist 'my-projects new-ffip-dirs fuzzy-find-roots)
  ;; make FFIP notice the change in in dirs
  (fuzzy-find-choose-root-set "prv"))
