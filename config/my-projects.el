(require 'fuzzy-find-in-project)

;; fuzzy-find configuration, defines named directory groups for easy changing
;; between them and current/default group for use before the root is changed
;; explicitly


(ffip-defroots 'my-projects
  ("~/secure/" "~/todo/" "~/.stumpwm.d/" "~/.emacs.d/config/" "~/mgmnt/")

  (lanchat     . ("~/poligon/lanchat/"))
  (klibertpl   . ("~/priv/klibert_pl/"))
  (mtr         . ("~/poligon/mtr/io/"))
  (em          . ("~/.emacs.d/forked-plugins/"
                  "~/.emacs.d/plugins/"
                  "~/.emacs.d/plugins2/"))
  (my-projects . ("~/.emacs.d/pkg-langs/elpy/"
                  "~/.emacs.d/plugins2/"
                  "~/.emacs.d/pkg-langs/"

                  ;; "~/poligon/prolog/"
                  ;; "/home/cji/poligon/car-sales-app/"
                  ;; "~/projects/open-resty/"
                  ;; "~/projects/images/my-base/"
                  ;; "~/projects/reqplayer/dpath/"
                  ;; "~/poligon/rozcode/"
                  ;; "~/poligon/bookm/"
                  "~/poligon/slock/"
                  "~/poligon/mangi/"
                  "~/poligon/adnoter/"
                  ;; "~/poligon/lscript/"
                  ))


  ;; (rq          . ("~/projects/reqviewer/"
  ;;                 "~/projects/reqplayer/"))
  ;; (pl          . ("~/poligon/planties/"))
  (ts          . ("~/projects/lightcorn/"))
  ;; WORK RELATED
  ;; (nlu         . ("~/projects/nlu"))
  ;; (bu          . ("~/projects/bunsen"))
  ;; (sn          . ("~/projects/snowboy"))
  ;; (ion         . ("~/projects/ion/"))
  ;; (an          . ("~/projects/tenclouds-analytics/"))
  ;; (sp          . ("~/projects/sp/"))
  ;; (eb          . ("~/projects/ebundler/backend/" "~/projects/ebundler/frontend/" "~/projects/ebundler/ansible_deploy/"))
  ;; (dn          . ("~/projects/donorship/backend/"
  ;;                 "~/projects/donorship/frontend/"))
  (na          . ("~/projects/truststamp/naea/"))
  (lg          . ("~/projects/anthill/" "~/projects/lightcorn/"))
)




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
