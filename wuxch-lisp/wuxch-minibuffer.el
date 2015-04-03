
;; (require 'minibuffer-complete-cycle)
;; (setq minibuffer-complete-cycle t)

;; 自动关闭Completions buffer
(add-hook 'minibuffer-exit-hook
          (lambda ()
            (and (get-buffer "*Completions*") (kill-buffer "*Completions*"))))

;; Mini buffer 不要自动调整大小
(setq resize-mini-windows nil)

;; minibuffer可以重用
(setq enable-recursive-minibuffers t)


(provide 'wuxch-minibuffer)
