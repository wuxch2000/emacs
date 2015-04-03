;;; configures and codes for sgml mode.
(require 'sgml-mode)

(defun sgml-save-hook ()
  "sgml-save-hook:"
  (delete-trailing-whitespace)
  (compress-xml-empty-element)
  )

(defun my-sgml-style()
  (add-hook 'before-save-hook 'sgml-save-hook)

  (turn-on-show-trailing-whitespace)

  ;;输入左边的括号，就会自动补全右边的部分.包括(), "", [] , {} , 等等。
  (make-local-variable 'skeleton-pair-alist)
  (setq skeleton-pair-alist  '(
                               (?\(  _ ")")
                               (?\[  _ "]")
                               (?{  _ "}")
                               (?\" _ "\"")
                               (?\'  _ "'")
                               ))

  (setq skeleton-pair t)

  (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)

  (setq require-final-newline t)

  (local-set-key [(tab)] 'indent-or-complete)
  (local-set-key [(home)] 'back-to-indentation-or-beginning-of-line)
  (local-set-key [(shift home)] 'back-to-indentation-or-beginning-of-line-with-shift)

  (local-set-key [(f7)] 'compile)

  (modify-syntax-entry ?_ "w")
  (modify-syntax-entry ?- "w")

  (setq sgml-markup-faces '(
                            (start-tag . font-lock-keyword-face)
                            (end-tag . font-lock-keyword-face)
                            (comment . font-lock-comment-face)
                            (pi . font-lock-constant-face) ;; <?xml?>
                            (sgml . font-lock-type-face)
                            (doctype . bold)
                            (entity . italic)
                            (shortref . font-lock-reference-face)))

  )

(defun my-sgml-mode-hook ()
  ""
  (my-sgml-style)
  (abbrev-mode)
  )

(add-hook 'sgml-mode-hook 'my-sgml-mode-hook)

(defun compress-xml-empty-element ()
  "compress-xml-empty-element: search empty element and using compact fromat"
  ;; (interactive)
  (let ((current-pos (point))
        (element nil)
        )
    (goto-char (point-min))
    (while (search-forward-regexp
            "<\\([[:graph:]]+\\)\\(\\([[:blank:]]+[[:graph:]]+=\"[[:graph:]]+\"[[:blank:]]*\\)*\\)>[[:space:]]*</\\1>"
            nil t)
      (setq element (match-string-no-properties 1))
      (replace-match "<\\1\\2/>")
      (message "compress-xml-empty-element:element \"%s\"" element)
      (setq current-pos (point))
      )
    (goto-char current-pos)
    )
  )

(provide 'wuxch-sgml)
