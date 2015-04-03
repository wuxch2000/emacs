;;; config for muse
(add-to-list 'load-path (concat emacs-site-lisp-dir "muse/lisp"))

(require 'muse-mode) ; load authoring mode
(require 'muse-html) ; load publishing styles I use
(require 'muse-latex)
;; (require 'muse-texinfo)
;; (require 'muse-docbook)
(require 'muse-project) ; publish files in projects
(require 'muse-wiki nil t)

(setq muse-project-alist
      `(("TD Tool" (,@(muse-project-alist-dirs "d:/work/td/release/readme")
                    :default "td")
         ,@(muse-project-alist-styles "d:/work/td/release/readme"
                                      "d:/work/td/release/html"
                                      "html")
         )))


;设置编码方式为utf-8
(setq muse-html-meta-content-type (concat "text/html; charset=utf-8"))
;; 设置发布的 html 页面的字符集
(setq muse-html-charset-default "utf-8")
;; 设置源文件的字符集
(setq muse-html-encoding-default "utf8")

(defun my-muse-mode-hook()
  (footnote-mode t)
  (local-set-key [(f3)] 'muse-colors-toggle-inline-images)
  (local-set-key [(control c)(control w)] 'publish-to-wiki)
  )

(add-hook 'muse-mode-hook 'my-muse-mode-hook)

(defconst wiki-temp-buffer "*wiki*")
(defun publish-to-wiki()
  (interactive)
  (kill-ring-save (point-min) (point-max))
  (if (get-buffer wiki-temp-buffer)
      (kill-buffer wiki-temp-buffer)
    )
  (switch-to-buffer (get-buffer-create wiki-temp-buffer))
  (text-mode)
  (yank)
  (goto-char (point-min))
  (remove-muse-pragma)
  (insert-preface)
  (process-title)
  (process-list)
  (process-jpg)
  (process-url)
  (process-emph)
  (process-footnote)
  (process-description)
  (insert-end)
  (goto-char (point-min))
  )

(defun process-description ()
  (goto-char (point-min))
  (while (re-search-forward "^\\(.*\\) :: \\(.*\\)" nil t)
    (replace-match "'''\\1'''\n\t\\2"))

  )

(defun insert-end()
  (goto-char (point-max))
  (insert "\n----\n")
  (insert "'''本文目前有[[PageComment2(countonly=1)]]条评论.'''\n")
  (insert "[[PageComment2]]")
  )

(defun remove-muse-pragma ()
  (goto-char (point-min))
  (while (re-search-forward "^#date.*\n" nil t)
    (replace-match ""))
  (goto-char (point-min))
  (while (re-search-forward "^#title.*\n" nil t)
    (replace-match ""))
  (goto-char (point-min))
  (while (re-search-forward "^#author.*\n" nil t)
    (replace-match ""))
  )

(defun insert-preface()
  (goto-char (point-min))
  (insert "##master-page:NewpageTemplate")
  (newline)
  (insert "#format wiki")
  (newline)
  (insert "#language zh")
  (newline)
  (insert "#pragma section-numbers on")
  (newline)
  (insert "[[TableOfContents([3])]]\n----\n")
  )

(defun process-footnote ()
  (goto-char (point-min))
  (while (re-search-forward "^Footnotes: " nil t)
    (replace-match "----"))
  (while (re-search-forward "^\\[\\([0-9]+\\)\\]" nil t)
    (replace-match "[[Anchor(\\1)]]\\1: "))

  (goto-char (point-min))
  (while (re-search-forward "\\[\\([0-9]+\\)\\]" nil t)
    (replace-match "[#\\1 \\1]"))
  )

(defun process-emph ()
  (goto-char (point-min))
  (while (re-search-forward "\\*\\([[:graph:]]+\\)\\*" nil t)
    (replace-match "''\\1''"))
  )


(defun process-list ()
  (goto-char (point-min))
  (while (re-search-forward "^\\([ ]+\\)- \\(.*\\)" nil t)
    (replace-match "\\1* \\2"))
  )

(defun process-url ()
  (goto-char (point-min))
  (while (re-search-forward "\\[\\[\\(http.*\\)\\]\\[\\(.*\\)\\]\\]" nil t)
    (replace-match "[\\1 \\2]"))
  )

(defun process-jpg ()
  (goto-char (point-min))
  (while (re-search-forward "\\[\\[\\./fig/\\(.*\\)\\]\\[.*\\]\\]" nil t)
    (replace-match "attachment:\\1"))
  )

(defun process-title ()
  (goto-char (point-min))
  (while (re-search-forward "^\\* \\(.*\\)" nil t)
    (replace-match "= \\1 ="))

  (goto-char (point-min))
  (while (re-search-forward "^\\*\\* \\(.*\\)" nil t)
    (replace-match "== \\1 =="))

  (goto-char (point-min))
  (while (re-search-forward "^\\*\\*\\* \\(.*\\)" nil t)
    (replace-match "=== \\1 ==="))

  (goto-char (point-min))
  (while (re-search-forward "^\\*\\*\\*\\* \\(.*\\)" nil t)
    (replace-match "==== \\1 ===="))

  )

(provide 'wuxch-muse)
