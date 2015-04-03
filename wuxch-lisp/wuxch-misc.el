;;;Copyright (C) 2007 by Wu Xiaochun

;; 防止页面滚动时跳动， scroll-margin 3 可以在靠近屏幕边沿3行时就开始滚动，可以很好的看到上下文
;; (setq scroll-margin 1  scroll-conservatively 10000)
(setq scroll-margin 1  scroll-conservatively 10000)

;; 设置标题栏显示文件名（包括路径）或者是buf名
(setq frame-title-format
      '("%S" (buffer-file-name "%f" (dired-directory dired-directory "%b"))" - Emacs"))

;;(auto-image-file-mode t)

;; 光标靠近鼠标的时候，让鼠标自动让开，别挡住视线
;;(mouse-avoidance-mode 'animate) ;;光标自己跳动，有时候比较奇怪，先注释。

;; 有关备份文件
;; 不保存备份文件
(setq make-backup-files nil)
(setq-default make-backup-files nil)
;; (setq backup-directory-alist (quote (("." . "~/backup"))))
;; (setq version-control 'never)
;; (setq backup-directory-info '((t "~/backup" ok-create full-path)))
;; (setq backup-by-copying t)


;; 支持是否显示ascii码
(require 'ascii)

;; Make all "yes or no" prompts show "y or n" instead
(fset 'yes-or-no-p 'y-or-n-p)

;; ;; 支持对space/tab的高亮。命令：M-x blank-mode-on和blank-mode-off
;; (require 'blank-mode)

(setq tab-stop-list (loop for i from 4 to 120 by 4 collect i))

;; (require 'highlight)

;; ;; 添加speedbar到tools菜单
;; (cond (window-system
;;        ;; Speedbar
;;        (define-key-after (lookup-key global-map [menu-bar tools])
;;          [speedbar-menu-separator] '("--" . speedbar-menu-separator) t)
;;        (define-key-after (lookup-key global-map [menu-bar tools])
;;          [speedbar] '("Speedbar" . speedbar-frame-mode) t)))


;; ;; 不使用自动保存
;; (setq auto-save-default nil)

;; ;;在退出的时候删除自动保存文件
;; (setq delete-auto-save-files t)


;; ;; 保存历史操作记录
;; ;; (require 'session)
;; ;; (add-hook 'after-init-hook 'session-initialize)

;; ;; 生日礼物 meta-x animate-birthday-present，有些意思。

;; ;; edebug调试方法
;; ;; 设定需要中断的函数：C-u C-M-x
;; ;; 设定断点		：b
;; ;; 运行到断点	: g
;; ;; 单步执行		: n

;; ;; 使用register
;; ;; (global-set-key [(control x)(p)] 'point-to-register)
;; ;; (global-set-key [(control x)(j)] 'jump-to-register)
;; ;; (global-set-key [(control x)(v)] 'view-register)

;; ;; 高亮显示单词表的单词条目
;; ;; (defun vocabulary-highlight ()
;; ;;   "high light title of vacabulary for 3gpp text"
;; ;;   (interactive)
;; ;;   (goto-char 0)
;; ;;   (highlight-regexp "^[a-z0-9].*:" "font-lock-keyword-face")
;; ;;   )

;; ;; Mouse
;; ;; (global-set-key [mouse-3] 'imenu)

;; ;; (autoload 'locdict "locdict" nil t)

;; ;; (load "hide-region")
;; ;; (load "folding")

;; (put 'narrow-to-region 'disabled nil)

;; (custom-set-variables
;;  '(message-log-max 500))

(provide 'wuxch-misc)
