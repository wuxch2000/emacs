;;;


(setq ispell-process-directory "c:/Program Files/Aspell/bin/")

(setq ispell-program-name (concat ispell-process-directory "aspell.exe"))

(setq ispell-dictionary "american")


;; ��������ģʽ�£��Ҽ��޸�Ϊ����������롣
(setq flyspell-mouse-map
  (let ((map (make-sparse-keymap)))
    (define-key map (if (featurep 'xemacs) [button3] [down-mouse-3])
      #'flyspell-correct-word)
    map)
  )

;; ����fly-spell:M-x ispell-minor-mode

;; ��flyspell����ȫ��д����
(defun flyspell-ignore-uppercase (beg end &rest rest)
  (while (and (< beg end)
              (let ((c (char-after beg)))
                (not (= c (downcase c)))))
    (setq beg (1+ beg)))
  (= beg end))

(add-hook 'flyspell-incorrect-hook 'flyspell-ignore-uppercase)

(provide 'wuxch-spell)
