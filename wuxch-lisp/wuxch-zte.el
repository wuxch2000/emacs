;;;Copyright (C) 2007 by Wu Xiaochun

(defun define-ec-const ()
  "start from 1"
  (defconst EC-COLUMN-STATUS 2)
  (defconst EC-COLUMN-HAPPEN 3)
  (defconst EC-COLUMN-TITLE 4)
  (defconst EC-COLUMN-ISSUE-PEOPLE 5)
  (defconst EC-COLUMN-ISSUE-DATE 7)
  (defconst EC-COLUMN-ACTIVITY-NO 8)
  (defconst EC-COLUMN-ACTIVITY-VERSION 9)
  )

(defun ec-do-build-ec-xml (req-no input-org-buffer output-xml-buffer)
  (define-ec-const)
  (switch-to-buffer output-xml-buffer)
  (erase-buffer)
  (insert "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n")
  (insert "<EC>\n")
  (insert "<变更请求>\n")
  (insert "<编号>")(insert req-no)(insert "</编号>\n")
  (ec-output-tag-field EC-COLUMN-STATUS "状态" input-org-buffer output-xml-buffer)
  (ec-output-tag-field EC-COLUMN-HAPPEN "发现活动" input-org-buffer output-xml-buffer)

  (ec-do-output-title input-org-buffer output-xml-buffer)

  (ec-output-tag-field EC-COLUMN-ISSUE-PEOPLE "提交人" input-org-buffer output-xml-buffer)
  (ec-output-tag-field EC-COLUMN-ISSUE-DATE "提交日期" input-org-buffer output-xml-buffer)

  (ec-do-output-all-activities req-no input-org-buffer output-xml-buffer)
  (insert "</变更请求>\n")
  (insert "</EC>\n")
  )


(defun ec-do-output-all-activities (req-no input-org-buffer output-xml-buffer)
  (ec-do-output-activity  input-org-buffer output-xml-buffer)
  (while (with-current-buffer input-org-buffer (search-forward req-no nil t))
    (ec-do-output-activity  input-org-buffer output-xml-buffer)
    )
  )

(defun ec-do-output-activity (input-org-buffer output-xml-buffer)
  (ec-do-insert-tag-begin "变更活动" output-xml-buffer)
  (with-current-buffer output-xml-buffer (insert "\n"))
  (ec-output-tag-field EC-COLUMN-ACTIVITY-NO "编号" input-org-buffer output-xml-buffer)
  (ec-do-output-version input-org-buffer output-xml-buffer)
  (ec-do-insert-tag-end "变更活动" output-xml-buffer)
  )

(defun ec-do-output-version (input-org-buffer output-xml-buffer)
  "ec-do-output-version:"
  (let ((tag "入库版本")
        (field nil)
        )
    (ec-do-insert-tag-begin tag output-xml-buffer)
    (with-current-buffer output-xml-buffer
      (insert (ec-do-process-version
               (ec-do-get-field EC-COLUMN-ACTIVITY-VERSION input-org-buffer))))
    (ec-do-insert-tag-end tag output-xml-buffer)
    )
  )

(defun ec-do-process-version (version-str)
  "ec-do-process-version:"
  (if (string-match ".*ZXSS10.* V2\\.01\\.\\([a-z0-9\\.]+\\).*" version-str)
      (progn
        (substring version-str (match-beginning 1) (match-end 1))
        )
    (progn
      version-str
      )
    )
  )

(defun ec-do-output-title (input-org-buffer output-xml-buffer)
  "从主题中提取RCS序号"
  (let ((tag-title "主题")
        (tag-rcs "RCS")
        (field nil)
        (pair nil)
        )
    (setq pair (ec-process-title (ec-do-get-field EC-COLUMN-TITLE input-org-buffer)))

    (ec-do-insert-tag-begin tag-title output-xml-buffer)
    (with-current-buffer output-xml-buffer (insert (car pair)))
    (ec-do-insert-tag-end tag-title output-xml-buffer)

    (ec-do-insert-tag-begin tag-rcs output-xml-buffer)
    (with-current-buffer output-xml-buffer(insert (cdr pair)))
    (ec-do-insert-tag-end tag-rcs output-xml-buffer)
    )
  )

(defun ec-process-title (raw-title)
  "return list:title, rcs-no"
  (if (string-match ".*【需求开发】.*\\(RE[0-9]+-[0-9]+\\)[：: ]*\\(.*\\)" raw-title)
      (progn
        (cons (substring raw-title (match-beginning 2) (match-end 2))
              (substring raw-title (match-beginning 1) (match-end 1)))
        )
    (progn
      (cons raw-title "")
      )
    )
  )

(defun ec-output-tag-field (field-column field-tag input-org-buffer output-xml-buffer)
  (let ((tag field-tag)
        (field nil)
        )
    (ec-do-insert-tag-begin tag output-xml-buffer)
    (with-current-buffer output-xml-buffer
      (insert (ec-do-get-field field-column input-org-buffer)))
    (ec-do-insert-tag-end tag output-xml-buffer)
    )
  )

(defun ec-do-get-field (field-column input-org-buffer)
  "根据列号获取当前行对应的列值"
  (ec-trim-string (with-current-buffer input-org-buffer (org-table-get-field field-column)))
  )

(defun ec-trim-string (str)
  (if (string-match "^[[:space:]]+$" str)
      (concat "")
    (replace-regexp-in-string "[[:space:]]*\\([[:graph:]]?.*[[:graph:]]\\)[[:space:]]*" "\\1" str)
    )
  )

(defun ec-do-insert-tag-begin (tag output-xml-buffer)
  (with-current-buffer output-xml-buffer (insert (concat "<" tag ">")))
  )

(defun ec-do-insert-tag-end (tag output-xml-buffer)
  (with-current-buffer output-xml-buffer (insert (concat "</" tag ">\n")))
  )


(defun get-column-at-same-row ()

  )

(defun ec-raw-to-xml (req-no)
  "ec-raw-to-xml:"
  (interactive "sRequest No:")
  (let* ((ec-dir "d:/work/ec/")
         (output-xml-name (concat ec-dir req-no ".xml"))
         (input-org-name (concat ec-dir "ec.org"))
         (output-xml-buffer nil)
         (input-org-buffer nil)
         )
    (setq input-org-buffer (find-file-noselect input-org-name))
    (switch-to-buffer input-org-buffer)
    (goto-char (point-min))
    (if (search-forward req-no nil t)
        (progn
          (setq output-xml-buffer (find-file-noselect output-xml-name))
          (switch-to-buffer output-xml-buffer)
          (ec-do-build-ec-xml req-no input-org-buffer output-xml-buffer)
          (indent-region (point-min) (point-max))
          (goto-char (point-min))
          (save-buffer)
          )
      (progn
        (message "search for %s failed!" req-no)
        )
      )
    )
  )

(defun ec-get-version (req-no)
  "ec-raw-to-xml:"
  (interactive "sRequest No:")
  (let* ((currBuf (current-buffer))
         (ec-dir "d:/work/ec/")
         (input-org-name (concat ec-dir "ec.org"))
         (output-xml-buffer nil)
         (input-org-buffer nil)
         (ver-str-list nil)
         (ver-str nil)
         )
    (define-ec-const)
    (setq input-org-buffer (find-file-noselect input-org-name))
    (switch-to-buffer input-org-buffer)
    (goto-char (point-min))
    (while (search-forward req-no nil t)
      (setq ver-str-list (cons (ec-do-process-version
                                (ec-do-get-field EC-COLUMN-ACTIVITY-VERSION input-org-buffer))
                               ver-str-list ))
      )
    (setq ver-str (ec-get-sorted-string-from-list ver-str-list))
    (when ver-str
      (kill-new ver-str)
      (message "[%s]:%s" req-no ver-str))
    (switch-to-buffer currBuf)
    )
  )

(defun ec-get-sorted-string-from-list (str-list)
  (when (listp str-list)
    (let* ((str nil))
      (when str-list
        (setq str-list (sort str-list 'string<))
        (while str-list
          (if str
              (setq str (concat str " ")))
          (setq str (concat str (pop str-list)))
          )
        )
      str)
    )
  )

(provide 'wuxch-zte)
