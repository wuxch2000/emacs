;; define some c language syntax

;; 基本定义（字母开始，后面可以是多个字母、数字和下划线和::）
(defconst list-func-c-symbol "[[:alpha:]_][[:alnum:]_:~<>+-[]*")
;; 星号,用于指针定义
(defconst list-func-starpound "[\\*&]+")
;; 指针类型,中间无空格,如:Type*
(defconst list-func-c-symbol-and-starpound (concat list-func-c-symbol list-func-starpound))
;; 函数名、变量名定义，支持星号，匹配："Type" "*" "Type*"
(defconst list-func-c-symbols (concat "\\(" list-func-c-symbol "\\|" list-func-starpound "\\|" list-func-c-symbol-and-starpound "\\)"))

;; 空格(一个或者多个)
(defconst list-func-blank "[[:blank:]]+")
;; (defconst list-func-blank "[ \t\n]+")

;; 空格(没有或者或者多个)
(defconst list-func-blank-or-not "[[:blank:]]*")
;; (defconst list-func-blank-or-not "[ \t\n]*")

(defconst list-func-retrun-or-not "[ \t\n]*")

;; 空格+注释
;; (defconst list-func-blank-or-not-with-comment "[[:blank:]]*\\(/\\*.*\\*/\\)*[[:blank:]]*")

;; 左右括号、逗号，包括前后可选空格
(defconst list-func-c-left-parentheses (concat list-func-blank-or-not "(" list-func-blank-or-not))
(defconst list-func-c-right-parentheses (concat list-func-blank-or-not ")" list-func-blank-or-not))
;; (defconst list-func-c-right-parentheses (concat list-func-blank-or-not ")" list-func-blank-or-not-with-comment))
(defconst list-func-c-comma (concat list-func-blank-or-not "," list-func-blank-or-not))
;; (defconst list-func-c-comma (concat list-func-retrun-or-not "," list-func-retrun-or-not))

;; 参数名，匹配："value" "*value"
(defconst list-func-c-parameter-name (concat "\\(" list-func-starpound "\\)*" list-func-c-symbol ))
;; 参数声明，匹配："Prefix1 Type" "Prefix1 Type *" "Prefix1 Type*"
(defconst list-func-c-parameter-declare (concat list-func-c-symbols "\\(" list-func-blank list-func-c-symbols "\\)" "*" ))
;; 一组参数的声明和参数名，匹配:"Prefix1 Type value"等，，或者没有参数
(defconst list-func-c-parameter (concat list-func-c-parameter-declare "\\(" list-func-blank list-func-c-parameter-name "\\)" "?"))
;; 多组参数的声明和参数名，中间以逗号分割，或者是什么申明和参数都没有
(defconst list-func-c-parameters (concat "\\(" list-func-c-parameter "\\(" (concat list-func-c-comma list-func-c-parameter "\\)*" "\\)?")))

(defconst list-func-c-comment "\\(/\\*.*\\*/\\)")
(defconst list-func-cpp-comment "\\(//.*\\)")
(defconst list-func-c-and-cpp-comment (concat "\\(" list-func-c-comment "\\|" list-func-cpp-comment "\\)*"))


;; 参数结束，函数定义完毕后直接以换行(可能有多个空格)，如果是函数声明，考虑添加分号。
;; 支持c++初始化方式，如： aaa():i(0)
(defconst list-func-c-colon-and-others (concat "\\(" ":.*" "\\)?"))

(defconst list-func-c-parameters-over (concat list-func-c-colon-and-others list-func-c-and-cpp-comment "$"))

;; 整个参数声明，如：(prifix1 Type1 value1, prifix2 Type2 * value2)
(defconst list-func-c-parameters-express (concat "\\(" list-func-c-left-parentheses list-func-c-parameters list-func-c-right-parentheses list-func-c-parameters-over "\\)" ))

;; 函数名,添加""\\(" "\\)"用于匹配后引用
(defconst list-func-c-function-name (concat "\\("  list-func-c-symbol "\\)" ))

;; 宏方式，匹配：EXPORT(int)
(defconst list-func-c-micro-name (concat list-func-c-parameter-declare "\\(" list-func-c-left-parentheses list-func-c-parameter-declare list-func-blank-or-not list-func-c-right-parentheses "\\)?"))
;; 函数返回值的定义，借用宏方式，考虑有的函数返回值是EXPORT(INT)样式
(defconst list-func-c-function-return-type list-func-c-micro-name)


;; 函数声明语句
(defconst list-func-c-whole-regexp (concat "^" "\\(" list-func-c-function-return-type list-func-blank "\\)?" list-func-c-function-name list-func-c-parameters-express))

;;(setq list-func-c-whole-regexp "^[[:alpha:]_][[:alnum:]_]*[[:blank:]]+[[:alpha:]_][[:alnum:]_]*[[:blank:]]*([[:blank:]]*[[:alpha:]_][[:alnum:]_]*\\([[:blank:]]*\\*\\)?\\([[:blank:]]+[[:alpha:]_][[:alnum:]_]*\\([[:blank:]]*\\*\\)?\\)*\\([[:blank:]]*,[[:blank:]]*[[:alpha:]_][[:alnum:]_]*\\([[:blank:]]*\\*\\)?\\([[:blank:]]+[[:alpha:]_][[:alnum:]_]*\\([[:blank:]]*\\*\\)?\\)*[[:blank:]]*\\)*[[:blank:]]*)$")


(provide 'wuxch-list-func-c-regex)
