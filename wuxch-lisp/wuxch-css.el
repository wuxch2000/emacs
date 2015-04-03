;; Filename:wuxch-css.el
;; Description:
;; Author:Wu Xiaochun
;; Created:周五 五月 13 15:10:14 2011 ()
;; Version:
;; Last-Updated:
;;           By:
;;     Update #: 0
;;
;;; Commentary:
;;
;;; Change log:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-css-mode-hook ()
  "my-css-mode-hook:"
  (modify-syntax-entry ?_ "w")
  (modify-syntax-entry ?- "w")

  (turn-on-show-trailing-whitespace)
  (setq require-final-newline t)
  (local-set-key [(return)]    'newline-and-indent)
  (setq skeleton-pair t)
  (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)

  )

(add-hook 'css-mode-hook 'my-css-mode-hook)

(provide 'wuxch-css)

