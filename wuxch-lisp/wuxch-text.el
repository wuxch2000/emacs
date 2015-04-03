(defun my-text-mode-hook()
  (modify-syntax-entry ?_ "w")
  ;; org-mode的table很好用，确认加上。
  ;; (turn-on-orgtbl)
  ;; (local-set-key [(f4)] 'highlight-current-line-toogle)
  ;; (local-set-key [(f5)] 'kmacro-end-and-call-macro)
  )
(add-hook 'text-mode-hook 'my-text-mode-hook)

(provide 'wuxch-text)
