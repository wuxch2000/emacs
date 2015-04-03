;;; mode for edit src file

;; (defvar srt-font-lock-keywords
;;   '(("^[0-9]+$" . 'font-lock-function-name-face)))

(defvar wuxch-srt-font-lock-keywords
  '(("^[0-9]+$" . font-lock-function-name-face)
    ("^.* --> .*$" . font-lock-keyword-face)
    ))

;; font-lock-comment-face

(defvar wuxch-srt-font-lock-defaults
  '(wuxch-srt-font-lock-keywords t))

(defun wuxch-srt-go-to-next-subtitle ()
  "wuxch-srt-go-to-next-subtitle:"
  (interactive)
  (if (re-search-forward "^.* --> .*$" nil t)
      (progn
        (next-line)
        (beginning-of-line)
        )
    (progn
      (message "end of subtitle" )
      )
    )
  )

(defun wuxch-srt-go-to-prev-subtitle ()
  "wuxch-srt-go-to-next-subtitle:"
  (interactive)
  (if (re-search-backward "^.* --> .*$" nil t)
      (if (re-search-backward "^.* --> .*$" nil t)
          (progn
            (next-line)
            (beginning-of-line)
            )
        )
    (progn
      (message "begin of subtitle" )
      )
    )
  )

(defun wuxch-srt-fill-column ()
  "wuxch-srt-fill-column:"
  (interactive)
  (let ((beg-pos (point))
        (end-pos))
    (if (re-search-forward "^[0-9]+$" nil t)
        (progn
          (previous-line)
          (setq end-pos (point))
          (fill-region beg-pos end-pos)
          (goto-char beg-pos)
          )
      )
    )
  )

(defun wuxch-srt-insert-i-tag ()
  "wuxch-srt-insert-i-tag:"
  (interactive)
  (insert "<i></i>")
  (backward-char 4)
  )

(defun translate-next-item ()
  "translate-next-item:"
  (interactive)
  (wuxch-srt-go-to-next-subtitle)
  (wuxch-srt-fill-column)
  (wuxch-open-line 1)
  (recenter-top-bottom)
  )

(define-derived-mode wuxch-srt-mode text-mode "SRT"
  ;; key bindings
  (define-key wuxch-srt-mode-map [(meta n)] 'ignore)
  (define-key wuxch-srt-mode-map [(meta n)] 'wuxch-srt-go-to-next-subtitle)
  (define-key wuxch-srt-mode-map [(control n)] 'ignore)
  (define-key wuxch-srt-mode-map [(control n)] 'wuxch-srt-go-to-next-subtitle)
  (define-key wuxch-srt-mode-map [(meta p)] 'ignore)
  (define-key wuxch-srt-mode-map [(meta p)] 'wuxch-srt-go-to-prev-subtitle)
  (define-key wuxch-srt-mode-map [(control p)] 'ignore)
  (define-key wuxch-srt-mode-map [(control p)] 'wuxch-srt-go-to-prev-subtitle)
  (define-key wuxch-srt-mode-map [(meta q)] 'ignore)
  (define-key wuxch-srt-mode-map [(meta q)] 'wuxch-srt-fill-column)
  (define-key wuxch-srt-mode-map [(control x)(i)] 'ignore)
  (define-key wuxch-srt-mode-map [(control x)(i)] 'wuxch-srt-insert-i-tag)
  (define-key wuxch-srt-mode-map [(control c)(control c)] 'ignore)
  (define-key wuxch-srt-mode-map [(control c)(control c)] 'translate-next-item)

  ;; font lock
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults wuxch-srt-font-lock-defaults)
  )

(add-to-list 'auto-mode-alist '("\\.srt$" . wuxch-srt-mode))

(provide 'wuxch-srt-mode)
