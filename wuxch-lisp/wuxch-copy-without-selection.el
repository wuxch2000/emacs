;;; put current word, line, paragraph into killing-ring without selection.

(defun wuxch-copy-word (&optional arg)
  "Copy words at point"
  (interactive "P")
  (let ((orignal-pos (point))
        (end-line-pos (line-end-position))
        (beg (progn (if (looking-back "[a-zA-Z0-9]" 1) (backward-word 1)) (point)))
      	(end (progn (forward-word arg) (point))))
    ;; (message "end-line-pos:%d,beg:%d,end:%d" end-line-pos beg end)
    (if (< end-line-pos end )
        (setq end end-line-pos))
    ;; (message "end-line-pos:%d,beg:%d,end:%d" end-line-pos beg end)
    (if (> end beg)
        (progn
          (copy-region-as-kill beg end)
          (message "copy string \"%s\" to clipboard" (current-kill 0)))
      )
    (goto-char orignal-pos)
    )
  )

(defun wuxch-copy-line (&optional arg)
  "Save current line into Kill-Ring without mark the line "
  (interactive "P")
  (let ((beg (line-beginning-position))
      	(end (line-end-position)))
    (copy-region-as-kill beg end))
  )

(defun wuxch-copy-paragraph (&optional arg)
  "Copy paragraphes at point"
  (interactive "P")
  (let ((beg (progn (backward-paragraph 1) (point)))
      	(end (progn (forward-paragraph arg) (point))))
    (copy-region-as-kill beg end))
  )

(provide 'wuxch-copy-without-selection)
