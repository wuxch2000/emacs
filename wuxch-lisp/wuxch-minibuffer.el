
;; (require 'minibuffer-complete-cycle)
;; (setq minibuffer-complete-cycle t)

;; �Զ��ر�Completions buffer
(add-hook 'minibuffer-exit-hook
          (lambda ()
            (and (get-buffer "*Completions*") (kill-buffer "*Completions*"))))

;; Mini buffer ��Ҫ�Զ�������С
(setq resize-mini-windows nil)

;; minibuffer��������
(setq enable-recursive-minibuffers t)


(provide 'wuxch-minibuffer)
