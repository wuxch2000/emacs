;; ֧����ʾtabbar����tabbar�иĶ���tab button����ʽ��������ɫ
(require 'tabbar)

(global-set-key [(control prior)] 'tabbar-backward-tab)
(global-set-key [(control next)]       'tabbar-forward-tab)
(global-set-key [(meta prior)] 'tabbar-backward-group)
(global-set-key [(meta next)]       'tabbar-forward-group)
(setq tabbar-cycling-scope 'tabs)
(setq tabbar-buffer-groups-function 'tabbar-buffer-ignore-groups)

;; ԭ���� tabbar ǿ�ж���� buffer ���з��飬���������������༭��buffer���л�������������ʲô�飬��
;; ô�ƺ�û��һ���ð취������ tabbar �����ṩ��һ�����ƣ���������Լ�ȷ�� tab �������飬ֻҪ�޸�
;; tabbar-buffer-groups-function �����ˡ��������ҿ��԰�ÿ�� buffer ͬʱ���������ڵ� major mode �����
;; һ������ "default" ���飬�������� default ����Ϳ��Է������������е� buffer �ˡ����л����������
;; ���Է���������㻹�������а�ĳЩ buffer �ֵ�һ�飬�����ҿ��԰� scheme-mode �� buffer ��
;; inferer-scheme-mode �� buffer �ֵ�ͬһ���顣
(defun tabbar-buffer-ignore-groups (buffer)
  "Return the list of group names BUFFER belongs to.
Return only one group for each buffer."
  (with-current-buffer (get-buffer buffer)
    (cond
     ((member (buffer-name)
              '("*scratch*" "*Messages*"))
      '("Common")
      )
     ((memq major-mode
            '(help-mode apropos-mode Info-mode Man-mode))
      '("Help")
      )
     ((memq major-mode
            '(rmail-mode
              rmail-edit-mode vm-summary-mode vm-mode mail-mode
              mh-letter-mode mh-show-mode mh-folder-mode
              gnus-summary-mode message-mode gnus-group-mode
              gnus-article-mode score-mode gnus-browse-killed-mode))
      '("Mail")
      )
     (t
      (list
       "all" ;; no-grouping
       (if (and (stringp mode-name) (string-match "[^ ]" mode-name))
           mode-name
         (symbol-name major-mode)))
      )
     )))


(tabbar-mode t)

(provide 'wuxch-tabbar)
