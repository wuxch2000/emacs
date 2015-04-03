
(defun synchronize ()
  "synchronize my files"
  (interactive)
  ;; (shell-command sync-exec-string)
  (wuxch-shell-command-background sync-exec-string)
  )

(provide 'wuxch-shadow)
