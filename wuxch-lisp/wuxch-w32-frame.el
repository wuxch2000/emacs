;; 启动后最大化
(defun w32-restore-frame (&optional arg)
  "Restore a minimized frame"
  (interactive)
  ;;     (w32-send-sys-command 61728 arg)
  (w32-send-sys-command #xf120)
  )
(defun w32-maximize-frame (&optional arg)
  "Maximize the current frame"
  (interactive)
  ;;     (w32-send-sys-command 61488 arg)
  (w32-send-sys-command #xf030)
  )
(defun w32-minimize-frame (&optional arg)
  "Minimize the current frame"
  (interactive)
  ;;     (w32-send-sys-command 61488 arg)
  (w32-send-sys-command #xf020)
  )

(provide 'wuxch-w32-frame)
