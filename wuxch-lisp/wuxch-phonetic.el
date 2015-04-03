;;;

;; using \usepackage{phonetic}

(defvar wuxch-latex-phonetic-map '(("ə" . ("\\schwa" . t))
                                   ("ɚ" . ("\\schwa" . t))
                                   ("ˈ" . ("\\textprimstress" . t))
                                   ("ˌ" . ("\\textsecstress" . t))
                                   ("ð" . ("\\eth" . t))
                                   ("θ" . ("\\texttheta" . t))
                                   ("ŋ" . ("\\engma" . t))
                                   ("ɑ" . ("\\vara" . t))
                                   (":" . ("\\textlengthmark" . t))
                                   ("æ" . ("\\ae" . t))
                                   ("ʒ" . ("\\yogh" . t))
                                   ("ʌ" . ("\\pwedge" . t))
                                   ("ʃ" . ("\\esh" . t))
                                   ("ɛ" . ("\\epsi" . t))
                                   ("ɔ" . ("\\openo" . t))
                                   ("ɪ" . ("i" . nil))
                                   ("[" . ("$[$" . nil))
                                   ("]" . ("$]$" . nil))
                                   ))

(defun wuxch-get-data-from-list (first-arg var-list)
  (cdr (assoc first-arg var-list))
  )

(defun wuxch-get-1-data-from-list (first-arg var-list)
  (car (wuxch-get-data-from-list first-arg var-list))
  )

(defun wuxch-get-2-data-from-list (first-arg var-list)
  (cdr (wuxch-get-data-from-list first-arg var-list))
  )

(defun phonetic-translate (string-word)
  ""
  (interactive "sWord:")
  (let ((string-latex (do-phonetic-translate string-word)))
    (kill-new string-latex)
    (message "string-latex is(copied to clipboard):%s" string-latex)
    )
  )

(defun do-phonetic-translate (phonetic)
  ""
  (let ((len (length phonetic))
        (i 0)
        (ch-phonetic)
        (ch-latex)
        (string-latex)
        (ch-latex-used nil))
    (while (< i len)
      (setq ch-phonetic (substring phonetic i (+ i 1)))
      (setq i (+ i 1))

      (setq ch-latex (wuxch-get-1-data-from-list ch-phonetic wuxch-latex-phonetic-map))

      ;; 如果不是特殊符号，就直接使用原符号
      ;; 需要注意，如果上一次使用转义符号，下一次是普通字符，那么需要添加一个空格
      (if ch-latex
          (progn
            (setq string-latex (concat string-latex ch-latex))
            (setq ch-latex-used (wuxch-get-2-data-from-list ch-phonetic wuxch-latex-phonetic-map))
            )
        (progn
          (if ch-latex-used
              (setq string-latex (concat string-latex " "))
            )
          (setq string-latex (concat string-latex ch-phonetic))
          (setq ch-latex-used nil)
          )
        )

      )
    string-latex
    )
  )


(provide 'wuxch-phonetic)
