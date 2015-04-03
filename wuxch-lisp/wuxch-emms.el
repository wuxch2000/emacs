;;; config file for emms

(add-to-list 'load-path (concat emacs-site-lisp-dir "emms"))

(require 'emms-setup)
(emms-standard)
(emms-default-players)

(provide 'wuxch-emms)
