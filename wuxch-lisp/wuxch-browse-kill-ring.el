;;; config about brawse-kill-ring
(require 'browse-kill-ring+)

;; ²é¿´kill ring
(global-set-key [(control c)(k)] 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

(custom-set-variables
 '(browse-kill-ring-display-duplicates nil)
 )

(defun wuxch-browse-kill-ring-hook-search ()
  (interactive)
  (goto-char (point-min))
  (hl-line-mode t)
  (isearch-forward-regexp)
  (hl-line-mode -1)
  )


(defun my-browse-kill-ring-hook ()
  "my-brawse-kill-ring-hook:"
  (define-key browse-kill-ring-mode-map [down] 'browse-kill-ring-forward)
  (define-key browse-kill-ring-mode-map [(control down)] 'browse-kill-ring-forward)
  (define-key browse-kill-ring-mode-map [up] 'browse-kill-ring-previous)
  (define-key browse-kill-ring-mode-map [(control up)] 'browse-kill-ring-previous)
  (define-key browse-kill-ring-mode-map (kbd "/") 'wuxch-browse-kill-ring-hook-search)
  )
(add-hook 'browse-kill-ring-hook 'my-browse-kill-ring-hook)

(provide 'wuxch-browse-kill-ring)
