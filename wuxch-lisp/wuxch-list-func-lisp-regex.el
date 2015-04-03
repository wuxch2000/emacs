(require 'wuxch-list-func-c-regex)


;; 以下是lisp的定义
;; for example: (defun function-name ()
(defconst list-func-lisp-function-name-pos 2)

(defconst list-func-lisp-parameters-express
  (concat "\\(" list-func-c-left-parentheses ".*" list-func-c-right-parentheses"\\)"))

(defconst list-func-lisp-prefix-name
  "\\(defun\\|defconst\\)")

(defconst list-func-lisp-whole-regexp
  (concat "^" "(" list-func-lisp-prefix-name list-func-blank "\\(" "[a-zA-Z0-9-^]+" "\\)" ".*"))


(provide 'wuxch-list-func-lisp-regex)
