;;; configuration of font-lock setting.

;; ������ʾ�ؼ���
(global-font-lock-mode t)
;; (setq font-lock-support-mode 'lazy-lock-mode)

(custom-set-variables
 '(font-lock-maximum-size 64000000))

(setq font-lock-support-mode 'jit-lock-mode)
(setq jit-lock-stealth-time 16
      jit-lock-defer-contextually t
      jit-lock-stealth-nice 0.5)
(setq-default font-lock-multiline t)

;; ��˵���Լӿ��ٶȣ�
(setq font-lock-maximum-decoration 2)

(provide 'wuxch-fontlock)
