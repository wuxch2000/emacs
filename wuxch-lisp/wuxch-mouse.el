;; 双击鼠标点亮单词后不进行copy
(setq mouse-drag-copy-region nil)

;; (global-unset-key (kbd "C-<down-mouse-1>"))
;; 设置shift click选择区域
(global-set-key (kbd "<S-down-mouse-1>") 'ignore)
(global-set-key (kbd "<S-mouse-1>") 'mouse-set-mark)

(provide 'wuxch-mouse)
