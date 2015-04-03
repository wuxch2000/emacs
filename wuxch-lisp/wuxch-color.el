;;; tools of color

(defun rgb-color-by-html-color-string ()
  "rgb-color-by-html-color-string:"
  (interactive)
  (let ((pos (point))
        (html-str)
        (rgb-str))
    (beginning-of-line)
    (if (re-search-forward "[#]?[abcdef0-9]\\{6\\}" (line-end-position) t)
        (progn
          (setq html-str (match-string 0))
          (setq rgb-str (html-color-to-rgb-string html-str ","))
          (kill-new rgb-str)
          (message "get RGB string \"%s\" by \"%s\", put it to clipboard." rgb-str html-str)
          )
      (progn
        (message "can not find html color string")
        )
      )
    (goto-char pos)
    )
  )

;; html-color format:#d82d2d
(defun html-color-to-rgb-string (html-color &optional separator)
  "html-color-to-rgb-string:"
  (let ((str-r)(str-g)(str-b)(sep-str)
        )
    (if separator
        (setq sep-str separator)
      (setq sep-str " ")
      )
    (setq str-r (substring html-color 1 3))
    (setq str-g (substring html-color 3 5))
    (setq str-b (substring html-color 5 7))

    (concat (format "%.4f" (/ (float (string-to-number str-r 16)) (float 255)))
            sep-str
            (format "%.4f" (/ (float (string-to-number str-g 16)) (float 255)))
            sep-str
            (format "%.4f" (/ (float (string-to-number str-b 16)) (float 255)))
            )
    ;; string-to-number
    ;; number-to-string
    )
  )

(provide 'wuxch-color)
