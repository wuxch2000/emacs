;;; config for revert functions

(defun revert-buffer-without-query ()
  "revert-buffer-without-query:"
  (interactive)
  (revert-buffer nil t t)
  )

(global-set-key [(control c)(r)] 'revert-buffer-without-query)

(provide 'wuxch-revert)
