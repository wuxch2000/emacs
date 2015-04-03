;;;;;;;;;;;;;;;;;;;;   template for xml  ;;;;;;;;;;;;;;;;;;;;;

(tempo-define-snippet "xml_"
  '("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
    n "<" (p "root" root) ">"
    n (p "")
    n "</" (s root) ">"
    )
  )
(define-abbrev sgml-mode-abbrev-table "xml_" "" 'tempo-template-xml_)

(tempo-define-snippet "xsl_"
  '("<xsl:stylesheet version=\"2.0\""
    n "                xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">"
    n (p "")
    n "</xsl:stylesheet>"
    )
  )
(define-abbrev sgml-mode-abbrev-table "xsl_" "" 'tempo-template-xsl_)

(tempo-define-snippet "outputhtml_"
  '("  <xsl:output method=\"html\" version=\"4.0\" indent=\"yes\""
    n "              doctype-public=\"-//W3C//DTD HTML 4.01//EN\" />"
    )
  )
(define-abbrev sgml-mode-abbrev-table "outputhtml_" "" 'tempo-template-outputhtml_)

(tempo-define-snippet "temp_"
  '("  <xsl:template match=\"" (p "match" match) "\">"
    n> (p "")
    n "  </xsl:template>"
    )
  )
(define-abbrev sgml-mode-abbrev-table "temp_" "" 'tempo-template-temp_)

(tempo-define-snippet "elem_"
  '("  <xsl:element name=\"" (p "name" name) "\">"
    n> (p "")
    n "  </xsl:element>"
    )
  )
(define-abbrev sgml-mode-abbrev-table "elem_" "" 'tempo-template-elem_)

(tempo-define-snippet "attr_"
  '("<xsl:attribute name=\"" (p "name" name) "\">" (p "value" value) "</xsl:attribute>"
    )
  )
(define-abbrev sgml-mode-abbrev-table "attr_" "" 'tempo-template-attr_)

(tempo-define-snippet "appl_"
  '("<xsl:apply-templates select=\"" (p "selector" selector) "\"/>"
    )
  )
(define-abbrev sgml-mode-abbrev-table "appl_" "" 'tempo-template-appl_)

(tempo-define-snippet "for_"
  '("  <xsl:for-each select=\"" (p "selector" selector) "\">"
    n> (p "")
    n "  </xsl:for-each>"
    )
  )
(define-abbrev sgml-mode-abbrev-table "for_" "" 'tempo-template-for_)

(tempo-define-snippet "valu_"
  '("<xsl:value-of select=\"" (p "selector" selector) "\"/>"
    )
  )
(define-abbrev sgml-mode-abbrev-table "valu_" "" 'tempo-template-valu_)

(tempo-define-snippet "text_"
  '("<xsl:text>" (p "text" text) "</xsl:text>"
    )
  )
(define-abbrev sgml-mode-abbrev-table "text_" "" 'tempo-template-text_)

(tempo-define-snippet "htmlhead_"
  '("  <xsl:template match=\"/\">"
    n "    <xsl:element name=\"html\">"
    n "      <xsl:element name=\"head\">"
    n "        <xsl:element name=\"title\">"
    n "          <xsl:text>" (p "title" title) "</xsl:text>"
    n "        </xsl:element>"
    n "      </xsl:element>"
    n
    n "      <xsl:element name=\"link\">"
    n "        <xsl:attribute name=\"rel\">stylesheet</xsl:attribute>"
    n "        <xsl:attribute name=\"href\">" (p "css-file" css-file) "</xsl:attribute>"
    n "        <xsl:attribute name=\"type\">text/css</xsl:attribute>"
    n "      </xsl:element>"
    n
    n "      <xsl:element name=\"body\">"
    n "        <xsl:apply-templates select=\"" (p "root-element" root-element) "\"/>"
    n "      </xsl:element>"
    n
    n "    </xsl:element>"
    n "  </xsl:template>"
    )
  )
(define-abbrev sgml-mode-abbrev-table "htmlhead_" "" 'tempo-template-htmlhead_)

(provide 'wuxch-template-xml)
