;;; configure about java-script.

(defun my-js-mode-hook()
  (setq tab-width 4 indent-tabs-mode nil)
  ;; 设置"_"是word的一部分
  (modify-syntax-entry ?_ "w")
  (setq c-tab-always-indent nil)

  (turn-on-show-trailing-whitespace)

  (my-c-java-style)
  )

(add-hook 'js-mode-hook 'my-js-mode-hook)

(provide 'wuxch-javascript)
