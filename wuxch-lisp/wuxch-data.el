;; 这里设定所有的全局确认数据，特别是和驱动路径相关的数据
(defconst SPACE " ")

(defconst program-file-dir "e:\\\"Program Files\"\\")

;; application
(defconst excel-exec-string (concat "d:\\\"Program Files\"\\" "\"Microsoft Office\"\\Office12\\EXCEL.exe "))

(defconst my-java-code-directory "d:/work/code/java")

;; related with emacs
(defconst emacs-program-dir (concat program-file-dir "emacs_nt\\"))
(defconst emacs-bin-dir (concat emacs-program-dir "bin\\"))
(defconst emacs-lisp-dir (concat emacs-program-dir "lisp\\"))
(defconst emacs-dictionary-dir (concat emacs-program-dir "dictionary\\"))

(defconst emacs-home-dir "d:/wuxch/emacs_home/")
(defconst emacs-data-dir (concat emacs-home-dir "data/"))
(defconst emacs-wuxch-lisp-dir (concat emacs-home-dir "wuxch-lisp/"))
(defconst emacs-wuxch-lisp-dir-without-last-slash (concat emacs-home-dir "wuxch-lisp"))
(defconst emacs-site-lisp-dir-without-last-slash (concat emacs-home-dir "site-lisp"))
(defconst emacs-emacs-lisp-dir-without-last-slash (concat "\"c:/Program Files/emacs_nt/lisp\""))
(defconst emacs-site-lisp-dir (concat emacs-home-dir "site-lisp/"))

(defconst find-exec-file (concat "gfind.exe"))
(defconst find-elisp-file-para (concat "-regex \".*\.\\(el\\)\""))

;; (defconst org-table-to-excel-file-name "c:\\org-table-to-excel-file.cvs")
(defconst org-table-to-excel-file-name (concat emacs-data-dir "org-table-to-excel-file.cvs"))

;; use ctags instead of etags, add option: -e to enable emacs mode
(defconst etags-exec-file (concat "ctags.exe"))
(defconst etags-exec-para (concat " -a -e -R -o"))
;; (defconst etags-exec-para (concat "-e --recurse -o"))

(defconst etags-exec-command (concat etags-exec-file SPACE etags-exec-para))
(defconst tag-file (concat emacs-data-dir "TAGS"))

(setq tags-table-list
      (list emacs-data-dir))

(defconst ange-ftp-ftp-program-name (concat "gftp.exe"))
;; java
(defconst java-open-source-path '("d:/work/code/java" "D:/Program Files/Java/jdk1.6.0/src"))

;; 设置相关文件的路径
(setq todo-file-do "~/emacs/todo/do")
(setq todo-file-done "~/emacs/todo/done")
(setq todo-file-top "~/emacs/todo/top")
(setq diary-file "~/diary/diary")
(setq diary-mail-addr "wuxch2000@gmail.com")

(setq abbrev-file-name "~/.abbrev_defs")
;; (add-hook 'diary-hook 'appt-make-list)

(setq ORGANIZATION "Wu Xiaochun")


(defun my-holiday ()
  (setq calendar-holidays '((holiday-fixed 1 1 "元旦")
                            (holiday-fixed 5 1 "劳动节")
                            (holiday-fixed 12 25 "圣诞节")
                            (holiday-fixed 5 26 "Dad birthday")
                            (holiday-fixed 6 25 "Mother birthday")
                            (holiday-fixed 6 7 "端午节")
                            (holiday-fixed 6 8 "端午节")
                            (holiday-fixed 6 9 "端午节")
                            )
        )
  )


(setq org-agenda-directory "d:/work/org-mode-files/")
(setq org-agenda-files (list "d:/work/work.org"
                             "d:/work/org-mode-files/pccw.org"
                             "d:/work/org-mode-files/pccw-phase2a.org"
                             ))


;; phone-name-file
(defconst wuxch-phone-file-name "d:/work/phone.xml")

(defconst wuxch-vocabulary-file-name "~/vocabulary/vocabulary.bib")

(provide 'wuxch-data)
