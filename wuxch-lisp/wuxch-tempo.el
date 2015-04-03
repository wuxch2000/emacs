;;; configure file for tempo and tempo-snippets

;;; attention:
;;; If template abbrev contain lettter '_' or '-', the letter should be considered as part of word.
;;; Using (modify-syntax-entry ?- "w") to config it.

(require 'tempo)
(require 'tempo-snippets)

(setq tempo-interactive t)

(global-set-key [(meta return)] 'tempo-snippets-clear-latest)

(set-face-foreground 'tempo-snippets-auto-face "DarkBlue")
(set-face-foreground 'tempo-snippets-auto-form-face "DarkBlue")
(set-face-foreground 'tempo-snippets-editable-face "DarkBlue")
;; (set-face-background 'tempo-snippets-editable-face "DarkBlue")
(set-face-bold-p 'tempo-snippets-editable-face t)

;;;;;;;;;;;;;;;;;;;;   template for template  ;;;;;;;;;;;;;;;;;;;;;
(tempo-define-snippet "template_"
  '("(tempo-define-snippet \"" (p "template-name" template-name) "_\""
    n> "'(" (p "" content)
    n> ")"
    n> ")"
    n "(define-abbrev " (p "mode-name" mode-name) "-mode-abbrev-table \"" (s template-name) "_\" \"\" " "'tempo-template-" (s template-name) "_)"
    )
  )
(define-abbrev lisp-mode-abbrev-table "template_" "" 'tempo-template-template_)

;
(require 'wuxch-template-elisp)
(require 'wuxch-template-cc)
(require 'wuxch-template-tex)
(require 'wuxch-template-xml)

;; (defun expand-tempo-tag (expand-function)
;;   "Expand the tempo-tag before point by calling the template."
;;   (let (match templ)
;;     (undo-boundary)
;;     (if (dolist (tags tempo-local-tags)
;;           (when (setq match (tempo-find-match-string (or (cdr tags)
;;                                                          tempo-match-finder)))
;;             (when (setq templ (assoc (car match) (symbol-value (car tags))))
;;               (delete-region (cdr match) (point))
;;               (funcall (cdr templ))
;;               (return t))))
;;         ;; Return a function with 'no-self-insert to stop input.
;;         'expand-tempo-tag-alias
;;       (funcall expand-function))))
;; (fset 'expand-tempo-tag-alias 'expand-tempo-tag)
;; (put 'expand-tempo-tag 'no-self-insert t)
;; (add-hook 'abbrev-expand-functions 'expand-tempo-tag)


(provide 'wuxch-tempo)
