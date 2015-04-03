(require 'meta-mode)

(defun wuxch-metapost-mode-hook ()
  (make-local-variable 'skeleton-pair-alist)
  (setq skeleton-pair-alist  '(
                               (?\(  _ ")")
                               (?\[  _ "]")
                               (?\" _ "\"")
                               (?\'  _ "'")
                               (?{ \n > _ \n ?} >)))

  (setq skeleton-pair t)
  ;; (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)

  (local-set-key [(tab)] 'indent-or-complete)
  (local-set-key [(home)] 'back-to-indentation-or-beginning-of-line)
  (local-set-key [(shift home)] 'back-to-indentation-or-beginning-of-line-with-shift)

  (local-set-key [(return)]    'newline-and-indent)

  (set (make-local-variable 'compile-command) "make -s -r")
  (local-set-key [(f7)] 'compile)
  (local-set-key [(control c)(control v)] 'wuxch-metapost-view-pdf-file)

  (wuxch-metapost-add-keyword)
  )

(add-hook 'metapost-mode-hook 'wuxch-metapost-mode-hook)

(defun wuxch-metapost-add-keyword ()
  "wuxch-metapost-add-keyword:"
  (font-lock-add-keywords
   'metapost-mode
   '(
     ;; function
     ("\bdraw\b"         . font-lock-function-name-face)
     ("drawarrow"         . font-lock-function-name-face)
     ("pickup"       . font-lock-function-name-face)
     ("show"         . font-lock-function-name-face)
     ("label"        . font-lock-function-name-face)
     ("dotlabel"     . font-lock-function-name-face)
     ("btex"         . font-lock-function-name-face)
     ("etex"         . font-lock-function-name-face)
     ("fill"         . font-lock-function-name-face)
     ;; type
     ("path"         . font-lock-type-face)
     ("\\bcolor\\b"        . font-lock-type-face)
     ("pair"         . font-lock-type-face)
     ("string"       . font-lock-type-face)
     ;; variable
     ("pencircle"    . font-lock-variable-name-face)
     ;; buildin
     ("scaled"       . font-lock-builtin-face)
     ("withcolor"       . font-lock-builtin-face)
     ("rotated"      . font-lock-builtin-face)
     ("cycle"        . font-lock-builtin-face)
     ("controls"     . font-lock-builtin-face)
     ("whatever"     . font-lock-builtin-face)
     ("defaultscale"    . font-lock-builtin-face)
     ("defaultfont"     . font-lock-builtin-face)
     ;; constant
     ("[0-9\\.]+\\(pt\\|in\\)"     . font-lock-constant-face)
     ("[ ]\\(lft\\|rt\\|top\\|bot\\|ulft\\|urt\\|llft\\|lrt\\)[ ]" . font-lock-constant-face)
     ))
  )

(defun wuxch-metapost-view-pdf-file ()
  "wuxch-metapost-get-pdf-file:"
  (interactive)
  (let ((pdf-file (wuxch-change-file-name-suffix (wuxch-metapost-get-master-file) "pdf"))
        (pdf-dir (file-name-directory (buffer-file-name))))
    (w32-browser (dired-replace-in-string "/" "\\" (concat pdf-dir pdf-file)))
    )
  )

(defun wuxch-metapost-get-master-file ()
  "wuxch-metapost-get-master-file:"
  (let ((original-pos (point))
        (master-file nil)
        (tag-string "% master=")
        (ret))
    (goto-char (point-min))
    (setq ret (search-forward-regexp tag-string nil t))
    (if (not (eq ret nil))
        (progn
          (setq ret (search-forward-regexp ".*\\..*" nil t))
          (if (not (eq ret nil))
              (progn
                (setq master-file (match-string 0))
                )
            )
          )
      )
    (goto-char original-pos)
    master-file
    )
  )


(provide 'wuxch-metapost)
