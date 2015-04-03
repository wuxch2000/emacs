;;;;;;;;;;;;;;;;;;;;   template for cc  ;;;;;;;;;;;;;;;;;;;;;
(tempo-define-snippet "if_"
  '("if( " (p "cond" cond) " ) {"
    n> (p "" exp)
    n> "}"
    )
  )
(define-abbrev c-mode-abbrev-table "if_" "" 'tempo-template-if_)
(define-abbrev c++-mode-abbrev-table "if_" "" 'tempo-template-if_)

(tempo-define-snippet "for_"
  '("for( " (p "exp1" exp1) " ; " (p "exp2" exp2) " ; " (p "exp3" exp3)" ) {"
    n> (p "" exp)
    n> "}"
    )
  )
(define-abbrev c-mode-abbrev-table "for_" "" 'tempo-template-for_)
(define-abbrev c++-mode-abbrev-table "for_" "" 'tempo-template-for_)

(tempo-define-snippet "class_"
  '("class " (p "class-name" class-name) "{"
    n> "private:"
    n> "protected:"
    n> "public:"
    n> (s class-name) "() {"
    n> (p "" cursor)
    n> "}"
    n> "virtual ~"(s class-name) "() {"
    n> "}"
    n> "};"
    )
  )
(define-abbrev c++-mode-abbrev-table "class_" "" 'tempo-template-class_)

(tempo-define-snippet "inc_"
  '("#include <" (p "head-file" head-file) ">"
    n> (p "" cursor)
    )
  )
(define-abbrev c-mode-abbrev-table "inc_" "" 'tempo-template-inc_)
(define-abbrev c++-mode-abbrev-table "inc_" "" 'tempo-template-inc_)

(tempo-define-snippet "main_"
  '("int main(int argc, char *argv[])"
    n "{"
    n> (p "" cursor)
    n> "return 0;"
    n "}"
    )
  )
(define-abbrev c-mode-abbrev-table "main_" "" 'tempo-template-main_)
(define-abbrev c++-mode-abbrev-table "main_" "" 'tempo-template-main_)



(provide 'wuxch-template-cc)
