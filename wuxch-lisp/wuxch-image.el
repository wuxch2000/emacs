(require 'image-mode)

(defun wuxch-image-mode-hook ()
  ""
  (define-key image-mode-map "q" 'quit-window)
  (define-key image-mode-map [return] 'wuxch-open-this-image-by-default)
  )


(add-hook 'image-mode-hook 'wuxch-image-mode-hook)

(defun wuxch-open-this-image-by-default ()
  ""
  (interactive)
  (let ((file (buffer-file-name)))
    ;; (message "file is %s" file)
    (w32-browser (dired-replace-in-string "/" "\\" file))
    )
  )


(provide 'wuxch-image)
