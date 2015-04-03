;; define some c language syntax

;; �������壨��ĸ��ʼ����������Ƕ����ĸ�����ֺ��»��ߺ�::��
(defconst list-func-c-symbol "[[:alpha:]_][[:alnum:]_:~<>+-[]*")
;; �Ǻ�,����ָ�붨��
(defconst list-func-starpound "[\\*&]+")
;; ָ������,�м��޿ո�,��:Type*
(defconst list-func-c-symbol-and-starpound (concat list-func-c-symbol list-func-starpound))
;; �����������������壬֧���Ǻţ�ƥ�䣺"Type" "*" "Type*"
(defconst list-func-c-symbols (concat "\\(" list-func-c-symbol "\\|" list-func-starpound "\\|" list-func-c-symbol-and-starpound "\\)"))

;; �ո�(һ�����߶��)
(defconst list-func-blank "[[:blank:]]+")
;; (defconst list-func-blank "[ \t\n]+")

;; �ո�(û�л��߻��߶��)
(defconst list-func-blank-or-not "[[:blank:]]*")
;; (defconst list-func-blank-or-not "[ \t\n]*")

(defconst list-func-retrun-or-not "[ \t\n]*")

;; �ո�+ע��
;; (defconst list-func-blank-or-not-with-comment "[[:blank:]]*\\(/\\*.*\\*/\\)*[[:blank:]]*")

;; �������š����ţ�����ǰ���ѡ�ո�
(defconst list-func-c-left-parentheses (concat list-func-blank-or-not "(" list-func-blank-or-not))
(defconst list-func-c-right-parentheses (concat list-func-blank-or-not ")" list-func-blank-or-not))
;; (defconst list-func-c-right-parentheses (concat list-func-blank-or-not ")" list-func-blank-or-not-with-comment))
(defconst list-func-c-comma (concat list-func-blank-or-not "," list-func-blank-or-not))
;; (defconst list-func-c-comma (concat list-func-retrun-or-not "," list-func-retrun-or-not))

;; ��������ƥ�䣺"value" "*value"
(defconst list-func-c-parameter-name (concat "\\(" list-func-starpound "\\)*" list-func-c-symbol ))
;; ����������ƥ�䣺"Prefix1 Type" "Prefix1 Type *" "Prefix1 Type*"
(defconst list-func-c-parameter-declare (concat list-func-c-symbols "\\(" list-func-blank list-func-c-symbols "\\)" "*" ))
;; һ������������Ͳ�������ƥ��:"Prefix1 Type value"�ȣ�������û�в���
(defconst list-func-c-parameter (concat list-func-c-parameter-declare "\\(" list-func-blank list-func-c-parameter-name "\\)" "?"))
;; ��������������Ͳ��������м��Զ��ŷָ������ʲô�����Ͳ�����û��
(defconst list-func-c-parameters (concat "\\(" list-func-c-parameter "\\(" (concat list-func-c-comma list-func-c-parameter "\\)*" "\\)?")))

(defconst list-func-c-comment "\\(/\\*.*\\*/\\)")
(defconst list-func-cpp-comment "\\(//.*\\)")
(defconst list-func-c-and-cpp-comment (concat "\\(" list-func-c-comment "\\|" list-func-cpp-comment "\\)*"))


;; ��������������������Ϻ�ֱ���Ի���(�����ж���ո�)������Ǻ���������������ӷֺš�
;; ֧��c++��ʼ����ʽ���磺 aaa():i(0)
(defconst list-func-c-colon-and-others (concat "\\(" ":.*" "\\)?"))

(defconst list-func-c-parameters-over (concat list-func-c-colon-and-others list-func-c-and-cpp-comment "$"))

;; ���������������磺(prifix1 Type1 value1, prifix2 Type2 * value2)
(defconst list-func-c-parameters-express (concat "\\(" list-func-c-left-parentheses list-func-c-parameters list-func-c-right-parentheses list-func-c-parameters-over "\\)" ))

;; ������,���""\\(" "\\)"����ƥ�������
(defconst list-func-c-function-name (concat "\\("  list-func-c-symbol "\\)" ))

;; �귽ʽ��ƥ�䣺EXPORT(int)
(defconst list-func-c-micro-name (concat list-func-c-parameter-declare "\\(" list-func-c-left-parentheses list-func-c-parameter-declare list-func-blank-or-not list-func-c-right-parentheses "\\)?"))
;; ��������ֵ�Ķ��壬���ú귽ʽ�������еĺ�������ֵ��EXPORT(INT)��ʽ
(defconst list-func-c-function-return-type list-func-c-micro-name)


;; �����������
(defconst list-func-c-whole-regexp (concat "^" "\\(" list-func-c-function-return-type list-func-blank "\\)?" list-func-c-function-name list-func-c-parameters-express))

;;(setq list-func-c-whole-regexp "^[[:alpha:]_][[:alnum:]_]*[[:blank:]]+[[:alpha:]_][[:alnum:]_]*[[:blank:]]*([[:blank:]]*[[:alpha:]_][[:alnum:]_]*\\([[:blank:]]*\\*\\)?\\([[:blank:]]+[[:alpha:]_][[:alnum:]_]*\\([[:blank:]]*\\*\\)?\\)*\\([[:blank:]]*,[[:blank:]]*[[:alpha:]_][[:alnum:]_]*\\([[:blank:]]*\\*\\)?\\([[:blank:]]+[[:alpha:]_][[:alnum:]_]*\\([[:blank:]]*\\*\\)?\\)*[[:blank:]]*\\)*[[:blank:]]*)$")


(provide 'wuxch-list-func-c-regex)
