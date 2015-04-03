

(defun find-phone-number (people-name)
  ""
  (interactive "sName:")
  (find-file wuxch-phone-file-name)
  (font-lock-mode -1)
  (widen)
  (goto-char (point-min))
  ;; (show-paren-mode -1)
  (let ((prompt-str))
    (if (eq 0 (length people-name))
        (progn
          (setq prompt-str "null string, just open phone file")
          )
      (if  (search-forward people-name nil t)
          (progn
            (copy-face 'font-lock-function-name-face  'phone-number-face)
            (wuxch-enlarge-face phone-number-face)
            (copy-face 'font-lock-keyword-face        'mobile-number-face)
            (wuxch-enlarge-face mobile-number-face)
            (copy-face 'font-lock-constant-face       'speed-dial-face)
            (wuxch-enlarge-face speed-dial-face)

            ;; (overlay-put (make-overlay (- (match-beginning 0) (length "<name>"))
            ;;                                      (+ (match-end 0) (+ 1(length "<name>")))
            ;;                                      (current-buffer)) 'face 'hi-black-hb)
            ;; �ڲ��绰
            (if (re-search-forward "<phone>\\([0-9 -]+\\)" nil t)
                (overlay-put (make-overlay (match-beginning 1) (match-end 1) (current-buffer))
                             'face 'phone-number-face)
              )
            ;; (message "match:%s" (match-string 0))
            ;; �ֻ�
            (if (re-search-forward "<mobile>\\([0-9 -]+\\)" nil t)
                (let ((clipboard (match-string 1))
                      (match-begin-pos (match-beginning 1))
                      (match-end-pos (match-end 1))
                      )
                  (kill-new clipboard)
                  (setq prompt-str (format "found \"%s\", copy mobile number \"%s\" to clipboard."
                                           people-name clipboard))
                  (overlay-put (make-overlay match-begin-pos match-end-pos (current-buffer))
                               'face 'mobile-number-face)
                  )
              )
            (if (re-search-forward "<mobile-speed-dail>\\([0-9\* -]+\\)" nil t)
                (overlay-put (make-overlay (match-beginning 1) (match-end 1) (current-buffer))
                             'face 'speed-dial-face)
              )
            (beginning-of-line)
            (narrow-to-item)
            (setq prompt-str (concat prompt-str " Use \"C-x n w\" to widen"))
            )
        (progn
          (setq prompt-str (format "can not find \"%s\"" people-name))
          )
        )
      )
    (message "%s" prompt-str)
    )
  )

(defun narrow-to-item ()
  "narrow-to-item:"
  (interactive)
  (let ((original-pos (point))(start)(end))
    (forward-line -7)
    (beginning-of-line)
    (recenter-top-bottom 0)
    (setq start (point))
    (forward-line 8)
    (end-of-line)
    (setq end (point))
    (narrow-to-region start end)
    (goto-char (point-min))
    )
  )

(global-set-key [(f1)] 'ignore)
(global-set-key [(f1)] 'find-phone-number)

(defun max-speed-dail ()
  ""
  (interactive)
  (occur "\\*\\*[9][0-9]")
  )

(provide 'wuxch-phone)