(provide 'setup-help)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE: Info+                     ;;
;;                                    ;;
;; GROUP: Help -> Info+               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'info+)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE: discover-my-major         ;;
;;                                    ;;
;; GROUP: Help -> discover-my-major   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A quick major mode help with discover-my-major
(global-unset-key (kbd "C-h h"))        ; original "C-h h" displays "hello world" in different languages
(define-key 'help-command (kbd "h m") 'discover-my-major)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE: rainbow-mode              ;;
;;                                    ;;
;; GROUP: Help -> Rainbow             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'html-mode-hook 'rainbow-mode)
(add-hook 'css-mode-hook 'rainbow-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package: help+                     ;;
;;                                    ;;
;; GROUP: Help                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'help+)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package: help-fns+                 ;;
;;                                    ;;
;; GROUP: Help                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'help-fns+)