(require 'visual-basic-mode)

(setq auto-mode-alist (append '(("\\.\\(frm\\|bas\\|vbs\\|cls\\)$" .
                                  visual-basic-mode)) auto-mode-alist))

(provide 'wuxch-vb)
