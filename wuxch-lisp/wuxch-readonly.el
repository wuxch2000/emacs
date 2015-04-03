;;;

(setq view-read-only t)

(defun wuxch-view-mode-hook()
  "wuxch-view-mode-hook:"
  (local-set-key "n" 'next-line)
  (local-set-key "p" 'previous-line)
  )


(add-hook 'view-mode-hook 'wuxch-view-mode-hook)

(provide 'wuxch-readonly)
