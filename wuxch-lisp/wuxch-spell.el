;;;


(setq ispell-process-directory "c:/Program Files/Aspell/bin/")

(setq ispell-program-name (concat ispell-process-directory "aspell.exe"))

(setq ispell-dictionary "american")


;; 在这样的模式下，右键修改为处理错误输入。
(setq flyspell-mouse-map
  (let ((map (make-sparse-keymap)))
    (define-key map (if (featurep 'xemacs) [button3] [down-mouse-3])
      #'flyspell-correct-word)
    map)
  )

;; 进入fly-spell:M-x ispell-minor-mode

;; 令flyspell忽略全大写单词
(defun flyspell-ignore-uppercase (beg end &rest rest)
  (while (and (< beg end)
              (let ((c (char-after beg)))
                (not (= c (downcase c)))))
    (setq beg (1+ beg)))
  (= beg end))

(add-hook 'flyspell-incorrect-hook 'flyspell-ignore-uppercase)

(provide 'wuxch-spell)
