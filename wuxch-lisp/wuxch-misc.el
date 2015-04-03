;;;Copyright (C) 2007 by Wu Xiaochun

;; ��ֹҳ�����ʱ������ scroll-margin 3 �����ڿ�����Ļ����3��ʱ�Ϳ�ʼ���������ԺܺõĿ���������
;; (setq scroll-margin 1  scroll-conservatively 10000)
(setq scroll-margin 1  scroll-conservatively 10000)

;; ���ñ�������ʾ�ļ���������·����������buf��
(setq frame-title-format
      '("%S" (buffer-file-name "%f" (dired-directory dired-directory "%b"))" - Emacs"))

;;(auto-image-file-mode t)

;; ��꿿������ʱ��������Զ��ÿ�����ס����
;;(mouse-avoidance-mode 'animate) ;;����Լ���������ʱ��Ƚ���֣���ע�͡�

;; �йر����ļ�
;; �����汸���ļ�
(setq make-backup-files nil)
(setq-default make-backup-files nil)
;; (setq backup-directory-alist (quote (("." . "~/backup"))))
;; (setq version-control 'never)
;; (setq backup-directory-info '((t "~/backup" ok-create full-path)))
;; (setq backup-by-copying t)


;; ֧���Ƿ���ʾascii��
(require 'ascii)

;; Make all "yes or no" prompts show "y or n" instead
(fset 'yes-or-no-p 'y-or-n-p)

;; ;; ֧�ֶ�space/tab�ĸ��������M-x blank-mode-on��blank-mode-off
;; (require 'blank-mode)

(setq tab-stop-list (loop for i from 4 to 120 by 4 collect i))

;; (require 'highlight)

;; ;; ���speedbar��tools�˵�
;; (cond (window-system
;;        ;; Speedbar
;;        (define-key-after (lookup-key global-map [menu-bar tools])
;;          [speedbar-menu-separator] '("--" . speedbar-menu-separator) t)
;;        (define-key-after (lookup-key global-map [menu-bar tools])
;;          [speedbar] '("Speedbar" . speedbar-frame-mode) t)))


;; ;; ��ʹ���Զ�����
;; (setq auto-save-default nil)

;; ;;���˳���ʱ��ɾ���Զ������ļ�
;; (setq delete-auto-save-files t)


;; ;; ������ʷ������¼
;; ;; (require 'session)
;; ;; (add-hook 'after-init-hook 'session-initialize)

;; ;; �������� meta-x animate-birthday-present����Щ��˼��

;; ;; edebug���Է���
;; ;; �趨��Ҫ�жϵĺ�����C-u C-M-x
;; ;; �趨�ϵ�		��b
;; ;; ���е��ϵ�	: g
;; ;; ����ִ��		: n

;; ;; ʹ��register
;; ;; (global-set-key [(control x)(p)] 'point-to-register)
;; ;; (global-set-key [(control x)(j)] 'jump-to-register)
;; ;; (global-set-key [(control x)(v)] 'view-register)

;; ;; ������ʾ���ʱ�ĵ�����Ŀ
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
