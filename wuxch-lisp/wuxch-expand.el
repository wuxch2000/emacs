;;; 把meta-/ 绑定到 hippie-expand，而不是dabbrev-expand
;; (global-set-key [(meta ?/)] 'hippie-expand)
;; (setq hippie-expand-try-functions-list
;;       '(
;;         try-expand-dabbrev-visible
;;         try-expand-dabbrev
;;         try-expand-dabbrev-all-buffers
;;         try-expand-dabbrev-from-kill
;;         try-complete-file-name-partially
;;         try-complete-file-name
;;         try-expand-all-abbrevs
;;         try-expand-list
;;         try-expand-line
;;         try-complete-lisp-symbol-partially
;;         try-complete-lisp-symbol))

(require 'dabbrev-expand-multiple)
(global-set-key "\M-/" 'dabbrev-expand-multiple)

(provide 'wuxch-expand)
