(provide 'setup-development)

;;;; insure emacs uses Unix tools
;;; Plan A
;; Windows path
;(when (eq system-type 'windows-nt)
  ;; Make sure Unix tools are in front of `exec-path'
;  (let ((bash (executable-find "bash")))
;    (when bash
;      (push (file-name-directory bash) exec-path)))
  ;; Update PATH from exec-path
;  (let ((path (mapcar 'file-truename
;                      (append exec-path
;                              (split-string (getenv "PATH") path-separator t)))))
;    (setenv "PATH" (mapconcat 'identity (delete-dups path) path-separator))))
;;; Plan B
(add-to-list 'exec-path (getenv "CYGWIN_HOME"))
(setenv "PATH" (concat (getenv "CYGWIN_HOME") (concat ";" (getenv "PATH"))))

;; Package in a league of its own: helm
(require 'setup-development-helm)
;; Alternative to Helm: ido + ido-ubiquitous + flx-ido + smex
;(require 'setup-development-alt)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package: CEDET                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'cc-mode)
(require 'semantic)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(global-semantic-stickyfunc-mode 1)

(semantic-mode 1)

(defun alexott/cedet-hook ()
  (local-set-key "\C-c\C-j" 'semantic-ia-fast-jump)
  (local-set-key "\C-c\C-s" 'semantic-ia-show-summary))

(add-hook 'c-mode-common-hook 'alexott/cedet-hook)
(add-hook 'c-mode-hook 'alexott/cedet-hook)
(add-hook 'c++-mode-hook 'alexott/cedet-hook)

;; Enable EDE only in C/C++
(require 'ede)
(global-ede-mode)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package: function-args            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'function-args)
(fa-config-default)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GROUP: Development -> Extensions -> Eldoc  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GROUP: Development -> Internal     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start garbage collection every 100MB to improve Emacs performance
(setq gc-cons-threshold 100000000)


