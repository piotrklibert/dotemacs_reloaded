(require 'fuzzy-find-in-project)

;; fuzzy-find configuration, defines named directory groups for easy changing
;; between them and current/default group for use before the root is changed
;; explicitly


(ffip-defroots 'my-projects ("~/todo/"
                             "~/secure/"
                             "~/.emacs.d/config/")

  (my-projects . ("~/mgmnt/"
                  "~/projects/klibert_pl/"
                  "~/poligon/prolog/"
                  "/home/cji/poligon/car-sales-app/"
                  ;; "~/projects/open-resty/"
                  ;; "~/projects/images/my-base/"
                  ;; "~/projects/reqplayer/dpath/"
                  ;; "~/poligon/luzem/"
                  ;; "~/poligon/lscript/"
                  ))
  (klibertpl   . ("/home/cji/projects/klibert_pl/"))

  (emacs       . ("~/.emacs.d/pkg-langs/elpy/"
                  "~/.emacs.d/plugins2/"
                  "~/.emacs.d/pkg-langs/"))

  (rq          . ("~/projects/reqviewer/"
                  "~/projects/reqplayer/"))

  ;; WORK RELATED
  (ion         . ("~/projects/ion/"))

  (sp          . ("~/projects/sp/"))

  (10c         . ("~/projects/images/repo/")))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; NOTE: disabled for now because my "misc projects" folder became TOO MUCH of
;; a mess...
;;
;; ;; There's a bit of a mess in my "misc projects" folder, and some of its
;; ;; directories have much too many files in them, so I need to prune them before
;; ;; adding them to `fuzzy-find-roots'.
;; (require 'f)
;; (defun my-absolutize (path dirname)
;;   (f-expand (f-join path dirname)))
;; (lexical-let*
;;     ((ignored (--map (f-expand (f-join "~/poligon/" it))
;;                      '("books-dedup" "django-debug-toolbar"
;;                        "django-rest-framework" "haxe"
;;                        "old_web_app_template" "poligon")))
;;      (subdirs (f-directories (f-expand "~/poligon/")
;;                              (lambda (path)
;;                                (not (-contains? ignored path)))))
;;      (new-ffip-dirs (append (util-get-alist 'my-projects fuzzy-find-roots)
;;                             subdirs)))
;;   (util-put-alist 'my-projects new-ffip-dirs fuzzy-find-roots)
;;   ;; make FFIP notice the change in in dirs
;;   (fuzzy-find-choose-root-set "my-projects"))
