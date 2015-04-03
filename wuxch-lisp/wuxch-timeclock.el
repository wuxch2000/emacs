;;; config for timeclock
(require 'timeclock-x)
(timeclock-modeline-display 0) ;; if you want modline display
;; (timeclock-initialize)
(timeclock-initialize)
(timeclock-setup-keys)

;; (setq timeclock-multiline-comments nil)

;; (custom-set-variables
;;  '(timeclock-multiple-jobs nil)
;;  '(timeclock-query-project-interval 5)
;;  )

;; (custom-set-variables
;;  '(timeclock-job-list  '("mail" "java"))
;;  )

;; (add-hook 'kill-emacs-query-functions 'timeclock-query-out)

;; (defun wuxch-timeclock-done-hook ()
;;   ""
;;   (let ((seconds timeclock-last-period)
;;         (minutes)
;;         (hours))
;;     (setq minutes (/ seconds 60.0))
;;     (setq hours (/ seconds 3600.0))
;;     (message "last project cost :%d second(s), or %.2f minute(s), or %.2f[copied to clipboard] hour(s)" seconds minutes hours)
;;     (kill-new (format "%.2f" hours))
;;     )
;;   )

;; (add-hook 'timeclock-done-hook 'wuxch-timeclock-done-hook)
;; (add-hook 'timeclock-out-hook 'wuxch-timeclock-done-hook)

(provide 'wuxch-timeclock)
