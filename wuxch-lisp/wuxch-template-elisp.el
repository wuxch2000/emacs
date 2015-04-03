;;;;;;;;;;;;;;;;;;;;   template for lisp  ;;;;;;;;;;;;;;;;;;;;;
;; sample:(upcase-initials (tempo-lookup-named 'var))

(tempo-define-snippet "defun_"
  '("(defun " (p "func-name" func) " ()"
    n> "\"" (s func) ":\""
    n> "(interactive)"
    n> (p "")
    n> ")"
    )
  )
(define-abbrev emacs-lisp-mode-abbrev-table "defun_" "" 'tempo-template-defun_)

(tempo-define-snippet "msg_"
  '("(message \"" (p "output" str) "\" " (p "" var) ")"
    )
  )
(define-abbrev emacs-lisp-mode-abbrev-table "msg_" "" 'tempo-template-msg_)

(tempo-define-snippet "progn_"
  '("(progn"
    n> (p "")
    n> ")"
    )
  )
(define-abbrev emacs-lisp-mode-abbrev-table "progn_" "" 'tempo-template-progn_)

(tempo-define-snippet "let_"
  '("(let " "((" (p "var" var) "))"
    n> (p "")
    n> ")"
    )
  )
(define-abbrev emacs-lisp-mode-abbrev-table "let_" "" 'tempo-template-let_)

(tempo-define-snippet "custom_"
  '("(custom-set-variables"
    n> "'(" (p "variable" variable) " " (p "value" value) ")"
    n> ")"
    )
  )
(define-abbrev emacs-lisp-mode-abbrev-table "custom_" "" 'tempo-template-custom_)

(tempo-define-snippet "if_"
  '("(if " (p "cond" cond)
    n> "(progn"
    n> "(" (p "" true-exp) ")"
    n> ")"
    n> ")")
  )

(define-abbrev emacs-lisp-mode-abbrev-table "if_" "" 'tempo-template-if_)

(tempo-define-snippet "ifelse_"
  '("(if " (p "cond" condition)
    n> "(progn"
    n> "(" (p "true-exp" true-exp) ")"
    n> ")"
    n> "(progn"
    n> "(" (p "false-exp" false-exp) ")"
    n> ")"
    n> ")")
  )

(define-abbrev emacs-lisp-mode-abbrev-table "ifelse_" "" 'tempo-template-ifelse_)

(tempo-define-snippet "addhook_"
  '(
    "(add-hook '" (p "hook-name" hook-name) "-hook " "'wuxch-" (s hook-name) "-hook)"
    n
    n "(defun wuxch-" (s hook-name) "-hook ()"
    n> (p "" exp)
    n> ")"
    )
  )
(define-abbrev emacs-lisp-mode-abbrev-table "addhook_" "" 'tempo-template-addhook_)

(provide 'wuxch-template-elisp)

