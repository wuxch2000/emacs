;;;;;;;;;;;;;;;;;;;;   template for tex  ;;;;;;;;;;;;;;;;;;;;;
(tempo-define-snippet "sec_"
  '("\\section{" (p "title" title) "}"
    n (p "" content)
    n
    )
  )
(define-abbrev TeX-mode-abbrev-table "sec_" "" 'tempo-template-sec_)

(tempo-define-snippet "subsec_"
  '("\\subsection{" (p "title" title) "}"
    n (p "" content)
    )
  )
(define-abbrev TeX-mode-abbrev-table "subsec_" "" 'tempo-template-subsec_)

(tempo-define-snippet "footnote_"
  '("\\footnote{" (p "footnote" footnote) "}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "footnote_" "" 'tempo-template-footnote_)


(tempo-define-snippet "begin_"
  '("\\begin{" (p "arg" arg) "}"
    n (p "" content) "\\end{" (s arg) "}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "begin_" "" 'tempo-template-begin_)
(define-abbrev TeX-mode-abbrev-table "beg_" "" 'tempo-template-begin_)

(tempo-define-snippet "center_"
  '("\\begin{center}"
    n (p "" content)
    n "\\end{center}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "center_" "" 'tempo-template-center_)

(tempo-define-snippet "list_"
  '("\\begin{lstlisting}"
    n (p "" content)
    n "\\end{lstlisting}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "list_" "" 'tempo-template-list_)

(tempo-define-snippet "right_"
  '("\\begin{flushright}"
    n (p "" content)
    n "\\end{flushright}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "right_" "" 'tempo-template-right_)

(tempo-define-snippet "quote_"
  '("\\begin{quote}"
    n (p "" content)
    n "\\end{quote}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "quote_" "" 'tempo-template-quote_)


(tempo-define-snippet "doc_"
  '("\\documentclass[12pt,a4paper,onecolumn]{article}"
    n "\\title{" (p "TITLE" title) "}"
    n "\\author{" (p "WuXiaochun" author) "}"
    n "\\date{}"
    n
    n "\\begin{document}"
    n (p "" content)
    n "\\end{document}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "doc_" "" 'tempo-template-doc_)

(tempo-define-snippet "doccjk_"
  '("\\documentclass[12pt,a4paper,onecolumn]{article}"
    n "\\title{" (p "TITLE" title) "}"
    n "\\author{" (p "WuXiaochun" author) "}"
    n "\\date{}"
    n "\\usepackage{CJK}"
    n "\\usepackage{indentfirst}"
    n
    n "\\begin{document}"
    n "\\begin{CJK*}{GBK}{song}"
    n (p "" content)
    n "\\end{CJK*}"
    n "\\end{document}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "doccjk_" "" 'tempo-template-doccjk_)


(tempo-define-snippet "cjk_"
  '("\\usepackage{CJK}"
    n "\\usepackage{indentfirst}"
    n "\\begin{CJK*}{GBK}{song}"
    n (p "" content)
    n "\\end{CJK*}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "cjk_" "" 'tempo-template-cjk_)

;; list with number
(tempo-define-snippet "enum_"
  '("\\begin{enumerate}"
    n (p "" item) "\\end{enumerate}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "enum_" "" 'tempo-template-enum_)

;; list without number
(tempo-define-snippet "item_"
  '("\\begin{itemize}"
    n "    \\item " (p "" item)
    n "\\end{itemize}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "item_" "" 'tempo-template-item_)

(tempo-define-snippet "desc_"
  '("\\begin{description}"
    n "    \\item{}" (p "" item)
    n "\\end{description}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "desc_" "" 'tempo-template-desc_)


(tempo-define-snippet "quote_"
  '("\\begin{quote}"
    n (p "" item)
    n "\\end{quote}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "quote_" "" 'tempo-template-quote_)

(tempo-define-snippet "xetex_"
  '("\\usepackage{fontspec,xunicode,xltxtra}"
    n "\\setmainfont[Mapping=tex-text]{Georgia}"
    n "\\setsansfont[Mapping=tex-text]{Arial}"
    n "\\setsansfont[Mapping=tex-text]{Courier New}"
    n "\\usepackage{indentfirst}"
    n "\\setCJKmainfont{ËÎÌå}"
    n "\\setCJKmonofont{ºÚÌå}"
    n ""
    )
  )
(define-abbrev TeX-mode-abbrev-table "xetex_" "" 'tempo-template-xetex_)


(tempo-define-snippet "hyper_"
  '("\\usepackage[" (p "pdftex" type) "]{hyperref}  % options: dvipdfmx, pdftex "
	n "\\hypersetup{"
	n "    bookmarks=true,         % show bookmarks bar?"
	n "    bookmarksopen=true,"
	n "    pdfpagemode=" (p "UseNone" mode) ",    % options: UseNone, UseThumbs, UseOutlines, FullScreen"
	n "    pdfstartview=" (p "FitH" view) ",      % options: FitH, FitV"
	n "    pdfborder=1,"
	n "    pdfhighlight=/P,"
	n "    pdfauthor={wuxch},"
	n "    unicode="(p "false" uni) ",          % xetex should set to false"
	n "    colorlinks,             % false: boxed links; true: colored links"
	n "    linkcolor=blue,         % color of internal links"
	n "    citecolor=green,        % color of links to bibliography"
	n "    filecolor=magenta,      % color of file links"
	n "    urlcolor=cyan           % color of external links"
	n "}"
    n "\\makeindex"
    n (p "" none)
    )
  )
(define-abbrev TeX-mode-abbrev-table "hyper_" "" 'tempo-template-hyper_)

(tempo-define-snippet "toc_"
  '("\\maketitle"
    n "\\tableofcontents"
    n "\\pagebreak"
    )
  )
(define-abbrev TeX-mode-abbrev-table "toc_" "" 'tempo-template-toc_)

(tempo-define-snippet "minipage_"
  '("\\begin{minipage}[" (p "t:Top c:Center b:Bottom" pos) "]" "{" (p "Width" width) "}"
    n (p "" none)
    n "\\end{minipage}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "minipage_" "" 'tempo-template-minipage_)
(define-abbrev TeX-mode-abbrev-table "mini_" "" 'tempo-template-minipage_)

(tempo-define-snippet "makebox_"
  '("\\makebox[" (p "Width" width) "][" (p "r:Right c:Center l:left s:Spread" pos) "]{%"
    n (p "" none) "}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "makebox_" "" 'tempo-template-makebox_)

(tempo-define-snippet "framebox_"
  '("\\framebox[" (p "Width" width) "][" (p "r:Right c:Center l:left s:Spread" pos) "]{%"
    n (p "" none) "}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "framebox_" "" 'tempo-template-framebox_)


(tempo-define-snippet "tw_"
  '("\\textwidth"
    )
  )
(define-abbrev TeX-mode-abbrev-table "tw_" "" 'tempo-template-tw_)

(tempo-define-snippet "table_"
  '("\\begin{table}[htbp]"
    n "\\caption{}"
    n "\\centering"
    n "\\begin{tabular}{ccc}"
    n "\\toprule"
    n
    n "\\midrule"
    n
    n "\\bottomrule"
    n "\\end{tabular}"
    n "\\end{table}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "table_" "" 'tempo-template-table_)

(tempo-define-snippet "newcommand_"
  '("\\newcommand{\\" (p "commandname" command) "}[" (p "arg" arg) "]{%"
    n (p "")
    n "}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "newcommand_" "" 'tempo-template-newcomand_)


(tempo-define-snippet "newenvironment_"
  '("\\newenvironment{" (p "environmentname" name) "}"
    n "{"
    n (p "")
    n "}"
    n "{"
    n ""
    n "}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "newenvironment_" "" 'tempo-template-newenvironment_)

(tempo-define-snippet "columns_"
  '("\\begin{columns}[c]"
    n
    n (p "")
    n
    n "\\end{columns}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "columns_" "" 'tempo-template-columns_)

(tempo-define-snippet "column_"
  '("\\begin{column}{" (p "0.5" width) "\\textwidth}"
    n (p "")
    n "\\end{column}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "column_" "" 'tempo-template-column_)

(tempo-define-snippet "frame_"
  '("\\subsection{}"
    n "\\begin{frame}{" (p "name") "}"
    n "\\end{frame}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "frame_" "" 'tempo-template-frame_)

(tempo-define-snippet "newcommand_"
  '("\\newcommand{\\" (p "name") "}{%"
    n "}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "newcommand_" "" 'tempo-template-newcommand_)

(tempo-define-snippet "renewcommand_"
  '("\\renewcommand{\\" (p "name") "}{%"
    n "}"
    )
  )
(define-abbrev TeX-mode-abbrev-table "renewcommand_" "" 'tempo-template-renewcommand_)



(provide 'wuxch-template-tex)
