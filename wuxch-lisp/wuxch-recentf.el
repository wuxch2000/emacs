;; 显示最近打来的文件列表
;; 11/26/2007 11:09:00,让出control x f
;; (global-set-key [(control x)(f)] 'ignore)
;; (global-set-key [(control x)(f)] 'recent-files)

(defvar recentf-opened nil)
(defun recent-files ()
  "load recentf libaray when call recentf-open-files"
  (interactive)
  (if (not recentf-opened)
      (progn (message "recentf-opened is false")
             (load-recentf)))
  (recentf-open-files)
  )

;; 加载最近访问文件菜单
(defun load-recentf ()
  (require 'recentf)
  (setq recentf-max-saved-items 1000)
  (setq recentf-max-menu-items 15)
  (setq recentf-exclude (quote ("Temporary Internet Files" "bm-repository")))
  (recentf-mode t)
  (setq recentf-opened t)
  (setq recentf-auto-cleanup (quote never))
  )

(provide 'wuxch-recentf)
