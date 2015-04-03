;;;
;; (defadvice next-line (before wuxch-next-line (arg))
;;   (let ((pos
;;          (save-excursion
;;            (forward-line arg)
;;            (point))))
;;     (if (not (pos-visible-in-window-p pos))
;;         (scroll-up 1))))
;; (ad-activate 'next-line)

;; (defadvice previous-line (before wuxch-previous-line (arg))
;;   (let ((pos
;;          (save-excursion
;;            (forward-line (* -1 arg))
;;            (point))))
;;     (if (not (pos-visible-in-window-p pos))
;;         (scroll-down 1))))
;; (ad-activate 'previous-line)

;; ¹ØÓÚpage
;; (require 'pager)
;; (global-set-key [next] 	   'pager-page-down)
;; (global-set-key [prior]	   'pager-page-up)
;; (global-set-key [(meta up)]    'pager-row-up)
;; (global-set-key [(meta down)]  'pager-row-down)


(provide 'wuxch-page)
