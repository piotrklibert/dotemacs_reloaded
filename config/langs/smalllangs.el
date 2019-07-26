(use-package nginx-mode
  :mode ".*nginx.*\\.conf\\'")


;; (let ((re (rx  "/" (any "Cc") (any "Mm") "ake"
;;                    (any "Ll") "ists" (optional ".txt")
;;                eos)))
;;   (string-match re "/CMakeLists.txt"))
(use-package cmake-mode
  :mode "/\\(?:[Cc][Mm]ake[Ll]ists\\(?:\\.txt\\)?\\)\\'")




(use-package json-mode       :mode "\\.json\\'")
(use-package yaml-mode       :mode "\\.\\(yml\\|yaml\\)\\'")


(use-package rst :mode "\\.rst\\'")

(use-package markdown-mode
  :mode "\\.\\(text\\|markdown\\|md\\)\\'"
  :bind (:map markdown-mode-map
         ("M-<left>" . backward-sexp)
         ("M-<right>" . forward-sexp)
         ("C-<left>" . left-word)
         ("C-<right>" . right-word)))
