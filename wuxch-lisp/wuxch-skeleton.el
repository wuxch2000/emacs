(require 'template)
(template-initialize)

(define-skeleton skeleton-java-class
  "Inserts a java class skeleton into current buffer."
  "Class Name: "
  "/**\n"
  "* @author Wuxch\n"
  "*/\n\n"
  "import java.util.*;\n\n"
  "public class "str"\n"
  "{\n"
  "    public static void main(String[] args)\n"
  "    {\n"
  "        " _ "\n"
  "        return;\n"
  "    }\n"
  "}\n")

(setq skeleton-pair t)
(global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "{") 'skeleton-pair-insert-maybe)


(provide 'wuxch-skeleton)
