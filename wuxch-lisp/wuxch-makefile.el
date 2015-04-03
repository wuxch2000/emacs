(defun my-makefile-mode-hook ()
  (modify-syntax-entry ?_ "w")
  (make-local-variable 'skeleton-pair-alist)
  (setq skeleton-pair-alist  '(
                               (?\(  _ ")")
                               (?\[  _ "]")
                               (?\" _ "\"")
                               (?\'  _ "'")
                               (?{ \n > _ \n ?} >)))

  (setq skeleton-pair t)
  (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)

  (local-set-key [(tab)] 'indent-or-complete)
  (local-set-key [(home)] 'back-to-indentation-or-beginning-of-line)
  (local-set-key [(shift home)] 'back-to-indentation-or-beginning-of-line-with-shift)

  (local-set-key [(control c)(\,)] 'ignore)
  (local-set-key [(control c)(\.)] 'ignore)
  (local-set-key [(control c)(\,)] 'wuxch-point-stack-push)
  (local-set-key [(control c)(\.)] 'wuxch-point-stack-pop)
  (local-set-key [(f7)] 'compile)

  )
(add-hook 'makefile-mode-hook 'my-makefile-mode-hook)

(provide 'wuxch-makefile)
