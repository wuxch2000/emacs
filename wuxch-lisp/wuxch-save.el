;;; wuxch-save


(defun wuxch-save-hook ()
  "��Ӳ�����������ǰ��λ�õ�mark-ring������control-s�����趨mark-ring"
  (indent-dwim)
  (push-mark)
  )
(add-hook 'before-save-hook 'wuxch-save-hook)

(global-set-key [(control s)] 'ignore)
(global-set-key [(control s)] 'save-buffer)

;; (defun wuxch-save-buffer ()
;;   (interactive)
;;   (indent-current-function)
;;   (push-mark)
;;   (save-buffer)
;;   )



;; (defun wuxch-elisp-save-buffer ()
;;   "wuxch-elisp-save-buffer:"
;;   (interactive)
;;   (wuxch-save-buffer)
;;   (emacs-lisp-byte-compile-and-load)
;;   )

;; (global-set-key [(control s)] 'ignore)
;; (global-set-key [(control s)] 'wuxch-save-buffer)

(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (flet ((process-list ())) ad-do-it))

(provide 'wuxch-save)
