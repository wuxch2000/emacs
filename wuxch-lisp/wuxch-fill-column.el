;;; customize of fill column command, especially for chinese characters.

(setq sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
;; 不要在 fill 时在句号后加空格
(setq sentence-end-double-space nil)

;; 直接设定fill-column好像没有用，必须用 custom-set-variables方式
;; (setq fill-column 120)

(defconst wuxch-fill-column-value 100)

(custom-set-variables
 '(fill-column wuxch-fill-column-value)
 )

(defun wuxch-fill-buffer ()
  "fill the whole buffer"
  (interactive)
  (fill-region (point-min) (point-max))
  )

(defun wuxch-fill-dwim ()
  "fill current paragraph and move to next or mark region is there is a region"
  (interactive)
  (if mark-active
      (progn
        (fill-region (region-beginning) (region-end))
        )
    (progn
      (fill-paragraph t)
      ;; (push-mark)
      (forward-paragraph)
      (next-line)
      (move-beginning-of-line nil)
      )
    )
  )

(global-set-key [(meta q)] 'wuxch-fill-dwim)

(defun wuxch-unfill-dwim ()
  "wuxch-unfill-dwim:"
  (interactive)
  (let ((long-enough-value 9999))
    (custom-set-variables
     '(fill-column long-enough-value)
     )
    (wuxch-fill-dwim)
    (custom-set-variables
     '(fill-column wuxch-fill-column-value)
     )
    )
  )

(global-set-key [(control c)(meta q)] 'wuxch-unfill-dwim)

(defun double-endl ()
  "double \n in order to use fill-paragraph"
  (interactive)
  (let ((current-pos (point)))
    (goto-char (point-min))
    (while (re-search-forward "[\n]+" nil t)
      (replace-match "\n\n")
      )
    (goto-char current-pos)
    )
  )

;; (setq paragraph-start "\f\\|[ \t]*$")
;; (setq paragraph-separate "[^ \t\f]*$")

(provide 'wuxch-fill-column)
