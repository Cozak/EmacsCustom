;;*** simple indent/unindent just like other editors
;; unlike emacs' default settings, this would not use syntax-based indent, but:
;;  - if region selected, indent/unindent the region (tab-width)
;;    * the region mark would not deactivated automatically
;;  - if no region selected, <TAB> would
;;    * if cursor lies in line leading, always indent tab-width
;;    * if cursor lies in word ending and `tab-always-indent' is `complete', try complete
;;    * otherwise, always insert a TAB char or SPACEs
;;  - if no region selected, <S-TAB> would
;;    * if cursor lies in line leading, always unindent tab-width 
;;    * otherwise, the cursor would move backwards (tab-width)
;; Note: this implementation would hornor `tab-always-indent', `indent-tabs-mode' and `tab-with'.

(provide 'sublime-style)

(defun abs-indent (arg)
  "Absolutely indent current line or region. Mimic other editors' indent."
  (interactive "P")
  (let ( (width (or arg tab-width)) )
  (if mark-active
      ;;DONE: how to restore region after `indent-rigidly'
      (let ( (deactivate-mark nil) )
        (indent-rigidly (region-beginning) (region-end) width))
    (let ( (pt           (point))
           (pt-bol       (line-beginning-position))
           (pt-bol-nonws (save-excursion (back-to-indentation) (point))) )
      (if (<= pt pt-bol-nonws)  ;;in leading whitespaces
          (progn
            (back-to-indentation)
            (if (looking-at "$")  ;;all chars in this line are whitespaces or tabs
                  (indent-to (+ (current-column) width))
                (progn
                  (indent-rigidly pt-bol (line-end-position) width)
                  (back-to-indentation))))
        (if (and (eq tab-always-indent 'complete)
                 (looking-at "\\>"))
            (call-interactively abs-indent-complete-function)
          (if indent-tabs-mode
              (insert-char ?\t 1)
            (insert-char ?  width))))))))
 
(defvar abs-indent-complete-function 'dabbrev-expand
  "The function used in `abs-indent' for completion.")
(make-variable-buffer-local 'abs-indent-complete-function)
 
(defun abs-unindent (arg)
  "Absolutely unindent current line or region."
  (interactive "P")
  (if mark-active
      (let ( (deactivate-mark nil) )
        (indent-rigidly (region-beginning) (region-end) (- tab-width)))
    (let ( (pt           (point))
           (pt-bol       (line-beginning-position))
           (pt-bol-nonws (save-excursion (back-to-indentation) (point))) )
      (if (> pt pt-bol-nonws)  ;;in content
          (move-to-column (max 0 (- (current-column) tab-width)))
        (progn
          (back-to-indentation)
          (backward-delete-char-untabify (min tab-width (current-column))))))))
		  

		  
;;;; Move while marking region
;; [UP] [DOWN] [LEFT] [RIGHT] [END] [BEGIN]
(defun sblmyl-previous-line (arg)
  "move cursor to previous line and deactivate mark if any"
  (interactive "P")
  (if mark-active
    (deactivate-mark))
  (previous-line))
(defun sblmyl-next-line (arg)
  "move cursor to next line and deactivate mark if any"
  (interactive "P")
  (if mark-active
    (deactivate-mark))
  (next-line))
(defun sblmyl-forward-char (arg)
  "move cursor to forward char and deactivate mark if any"
  (interactive "P")
  (if mark-active
    (deactivate-mark))
  (forward-char))
(defun sblmyl-backward-char (arg)
  "move cursor to backward char and deactivate mark if any"
  (interactive "P")
  (if mark-active
    (deactivate-mark))
  (backward-char))
(defun sblmyl-end-of-line (arg)
  "move cursor to the end of line and deactivate mark if any"
  (interactive "P")
  (if mark-active
    (deactivate-mark))
  (move-end-of-line nil))
(defun sblmyl-beginning-of-line (arg)
  "move cursor to the beginning of line and deactivate mark if any"
  (interactive "P")
  (if mark-active
    (deactivate-mark))
  (move-beginning-of-line nil))
;; [Shift-UP] [Shift-DOWN] [Shift-LEFT] [Shift-RIGHT] [Shift-END] [Shift-BEGIN]
(defun sblmyl-S-previous-line (arg)
  "activate mark while moving cursor to previous line"
  (interactive "P")
  (if (not mark-active)
    (set-mark-command nil))
  (previous-line))
(defun sblmyl-S-next-line (arg)
  "activate mark while moving cursor to next line"
  (interactive "P")
  (if (not mark-active)
    (set-mark-command nil))
  (next-line))
(defun sblmyl-S-forward-char (arg)
  "activate mark while moving cursor to forward char"
  (interactive "P")
  (if (not mark-active)
    (set-mark-command nil))
  (forward-char))
(defun sblmyl-S-backward-char (arg)
  "activate mark while moving cursor to backward char"
  (interactive "P")
  (if (not mark-active)
    (set-mark-command nil))
  (backward-char))
(defun sblmyl-S-end-of-line (arg)
  "activate mark while moving cursor to the end of line"
  (interactive "P")
  (if (not mark-active)
    (set-mark-command nil))
  (move-end-of-line nil))		  
(defun sblmyl-S-beginning-of-line (arg)
  "activate mark while moving cursor to the beginning of line"
  (interactive "P")
  (if (not mark-active)
    (set-mark-command nil))
  (move-beginning-of-line nil))
		  
		  
;; Minor Mode
(defvar sblmyl-mode-map
  (let ( (map (make-sparse-keymap)) )
	;; tab control
    (define-key map (kbd "<tab>")        'abs-indent) 
    (define-key map (kbd "<backtab>")    'abs-unindent)
	;; mark control p n f b e a
	(define-key map (kbd "C-p")        'sblmyl-previous-line)
	(define-key map (kbd "C-n")        'sblmyl-next-line)
	(define-key map (kbd "C-f")        'sblmyl-forward-char)
	(define-key map (kbd "C-b")        'sblmyl-backward-char)
	(define-key map (kbd "C-e")        'sblmyl-end-of-line)
	(define-key map (kbd "C-a")        'sblmyl-beginning-of-line)
	(define-key map (kbd "C-S-p")        'sblmyl-S-previous-line)
	(define-key map (kbd "C-S-n")        'sblmyl-S-next-line)
	(define-key map (kbd "C-S-f")        'sblmyl-S-forward-char)
	(define-key map (kbd "C-S-b")        'sblmyl-S-backward-char)
	(define-key map (kbd "C-S-e")        'sblmyl-S-end-of-line)
	(define-key map (kbd "C-S-a")        'sblmyl-S-beginning-of-line)
	;; mark control <up> <down> <right> <left> <end> <home>
	(define-key map (kbd "<up>")        'sblmyl-previous-line)
	(define-key map (kbd "<down>")        'sblmyl-next-line)
	(define-key map (kbd "<right>")        'sblmyl-forward-char)
	(define-key map (kbd "<left>")        'sblmyl-backward-char)
	(define-key map (kbd "<end>")        'sblmyl-end-of-line)
	(define-key map (kbd "<home>")        'sblmyl-beginning-of-line)
	(define-key map (kbd "<S-up>")        'sblmyl-S-previous-line)
	(define-key map (kbd "<S-down>")        'sblmyl-S-next-line)
	(define-key map (kbd "<S-right>")        'sblmyl-S-forward-char)
	(define-key map (kbd "<S-left>")        'sblmyl-S-backward-char)
	(define-key map (kbd "<S-end>")        'sblmyl-S-end-of-line)
	(define-key map (kbd "<S-home>")        'sblmyl-S-beginning-of-line)
	(define-key map (kbd "C-c C-c") 		'comment-or-uncomment-region)
    map)
  "keymap for `sblmyl-mode-map'.")

(define-minor-mode sblmyl-mode
  "indent in sublime style."
  ;:global t
  :keymap sblmyl-mode-map
  (if sblmyl-mode
      t
    t))
	
;; Global Minor
(define-global-minor-mode global-sblmyl-mode sblmyl-mode nil)

;; default config
(defun sblmyl-config-default ()
  (add-hook 'prog-mode-hook (lambda () (sblmyl-mode t)))
  (add-hook 'text-mode-hook (lambda () (sblmyl-mode t)))
  ;(add-hook 'c-mode-common-hook (lambda () (sblmyl-mode t)))
  )