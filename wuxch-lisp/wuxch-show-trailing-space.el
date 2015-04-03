;; ;; ��ʾû���õ�whitespace������delete-trailing-whitespace����ɾ����Щwhitespace
;; (custom-set-variables
;;  '(show-trailing-whitespace t)
;;  )

(defun toggle-show-trailing-whitespace ()
  "Toggles the highlighting of trailing whitespace."
  (interactive)
  (set-variable 'show-trailing-whitespace (not show-trailing-whitespace)))

(defalias 'toggle-trailing-whitespace 'toggle-show-trailing-whitespace)

;; ;; ��ʾû���õ�whitespace������delete-trailing-whitespace����ɾ����Щwhitespace
(defun turn-on-show-trailing-whitespace ()
  "Turnes on the highlighting of trailing whitespace."
  (set-variable 'show-trailing-whitespace t))

(defun turn-off-show-trailing-whitespace ()
  "Turnes off the highlighting of trailing whitespace."
  (set-variable 'show-trailing-whitespace nil))

(provide 'wuxch-show-trailing-space)
