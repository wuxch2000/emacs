;;;
;; ����ƥ�������
;; (show-paren-mode nil)
;; (setq show-paren-style 'parentheses)


;; ����ʹ�� % ��ƥ������ż���ת
(global-set-key [(%)] 'match-paren)
;; �� % �������ϰ���ʱ����ôƥ�����ţ���������һ�� %
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  ;; �������)���棬��ôǰ��һλ��
  (if (> (point) 1)
      (progn
        (backward-char 1)
        (if (not (looking-at "\\s\)"))
            (forward-char 1)
          )
        )
    )
  (cond ((looking-at "\\s\(")
         (forward-list 1)
         ;; (backward-char 1)
         )
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))
        )
  )

(defun mark-action-after-move ()
  "mark-action-after-move:"
  (mark-sexp)
  )

(defun move-forward-paren (&optional arg)
  "Move forward parenthesis"
  (interactive "P")
  ;; ע��]������ڵ�һ����ĸλ��
  (let ((have-forward nil))
    (if (looking-at "[[({]")
        (progn
          (setq have-forward t)
          (forward-char)
          )
      )
    (if (re-search-forward "[[({]" nil t)
        (progn
          (backward-char)
          (mark-action-after-move)
          )
      (progn
        (if have-forward
            (backward-char)
          )
        )
      )
    )
  )

(defun move-backward-paren (&optional arg)
  "Move backward parenthesis"
  (interactive "P")
  (if (re-search-backward "[[({]" nil t)
      (progn
        (mark-action-after-move)
        )
    )
  )

(global-set-key [(meta \[)] 'ignore)
(global-set-key [(meta \[)] 'move-backward-paren)
(global-set-key [(meta \])] 'ignore)
(global-set-key [(meta \])] 'move-forward-paren)

;; (global-set-key [(meta 0)] 'ignore)
;; (global-set-key [(meta \))] 'ignore)
;; (global-set-key [(meta 0)] 'move-forward-paren)
;; (global-set-key [(meta \))] 'move-forward-paren)

(defun chinese-parenthesis ()
  "replace-chinese-parenthesis:replace chinese parenthesis with english parenthesis
becuase chinese parenthesis looks suck"
  (interactive)
  (let ((current-point (point)))
    (while (re-search-forward "��" nil t)
      (replace-match "("))
    (goto-char current-point)
    (while (re-search-forward "��" nil t)
      (replace-match ")"))
    (goto-char current-point)
    (while (re-search-forward "��" nil t)
      (replace-match "-"))
    (goto-char current-point)
    (while (re-search-forward "��" nil t)
      (replace-match "?"))
    (goto-char current-point)
    (while (re-search-forward "��" nil t)
      (replace-match ":"))
    (goto-char current-point)
    (while (re-search-forward "��" nil t)
      (replace-match "!"))
    (goto-char current-point)
    (if (equal major-mode 'latex-mode)
        (progn
          (while (re-search-forward "��" nil t)
            (replace-match "``"))
          (goto-char current-point)
          (while (re-search-forward "��" nil t)
            (replace-match "''"))
          (goto-char current-point)
          (while (re-search-forward "��" nil t)
            (replace-match ","))
          (goto-char current-point)
          (while (re-search-forward "��" nil t)
            (replace-match ";"))
          (goto-char current-point)
          ;; (while (re-search-forward "��" nil t)
          ;;   (replace-match "."))
          ;; (goto-char current-point)
          )
      )
    (goto-char current-point)
    )
  )

(provide 'wuxch-parenthesis)
