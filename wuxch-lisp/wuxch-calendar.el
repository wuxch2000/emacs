;;; calendar information

(autoload 'calendar "calendar+"
  "Display a 3-month calendar in another window." t)
(autoload 'insert-diary-entry "calendar+"
  "Insert a diary entry for date indicated by point." t)

;; �������ڵصľ�γ�Ⱥ͵�����calendar ���Ը�����Щ��Ϣ��֪��ÿ����ճ��������ʱ�䡣(meta x sunrise-sunset)
;; Xilinhot(43.95;116.1)
(setq calendar-latitude +32.03)
(setq calendar-longitude +118.83)
(setq calendar-location-name "NanJing")

(custom-set-variables
 '(calendar-view-diary-initially-flag nil)
 )

(defun wuxch-pop-or-hide-calendar ()
  ""
  (interactive)
  (let ((buf (current-buffer)))
    (if (string= (buffer-name buf) "*Calendar*")
        (exit-calendar)
      (calendar)
      )
    )
  )

(global-set-key [(f10)] 'ignore)
(global-set-key [(f10)] 'wuxch-pop-or-hide-calendar)


(defun wuxch-calendar-load-hook ()
  ""
  (setq today-visible-calendar-hook 'calendar-mark-today)
  ;; �����face������font-lock-function-name-face
  (copy-face 'font-lock-keyword-face 'calendar-today)
  ;; calendar-mode-map
  (define-key calendar-mode-map [(control c)(control c)]    'ignore)
  (define-key calendar-mode-map [(control c)(control c)]    'wuxch-gen-date-string)


  ;; ���� calendar ����ʾ
  (setq calendar-remove-frame-by-deleting t)
  (setq calendar-week-start-day 0)            ; ����������Ϊÿ�ܵĵ�һ��
  (setq mark-diary-entries-in-calendar t)     ; ���calendar����diary������
  (setq mark-holidays-in-calendar t)          ; Ϊ��ͻ����diary�����ڣ�calendar�ϲ���ǽ���
  (setq view-calendar-holidays-initially nil) ; ��calendar��ʱ����ʾһ�ѽ���

  (my-holiday)
  )

(add-hook 'calendar-load-hook 'wuxch-calendar-load-hook)

(setq view-diary-entries-initially t
       mark-diary-entries-in-calendar t
       number-of-diary-entries 7)
(add-hook 'diary-display-hook 'fancy-diary-display)
(add-hook 'today-visible-calendar-hook 'calendar-mark-today)

(add-hook 'fancy-diary-display-mode-hook
          '(lambda ()
             (alt-clean-equal-signs)))

(add-hook 'list-diary-entries-hook 'sort-diary-entries t)

(defun alt-clean-equal-signs ()
  "This function makes lines of = signs invisible."
  (goto-char (point-min))
  (let ((state buffer-read-only))
    (when state (setq buffer-read-only nil))
    (while (not (eobp))
      (search-forward-regexp "^=+$" nil 'move)
      (add-text-properties (match-beginning 0)
                           (match-end 0)
                           '(invisible t)))
    (when state (setq buffer-read-only t))))

(defun wuxch-initial-calendar-window-hook ()
  ""
  ;; (delete-other-windows)
  )

(add-hook 'initial-calendar-window-hook 'wuxch-initial-calendar-window-hook)

;; (require 'cal-china-x)

;;����������һЩ��ɫ
;; (setq calendar-load-hook
;; '(lambda ()
;;    (set-face-foreground 'diary-face "skyblue")
;;    (set-face-background 'holiday-face "slate blue")
;; (set-face-foreground 'holiday-face "white")))

;; ����������ʾ���� calendar ���� pC ��ʾ����
;; (setq chinese-calendar-celestial-stem
;;   ["��" "��" "��" "��" "��" "��" "��" "��" "��" "��"])
;; (setq chinese-calendar-terrestrial-branch
;;   ["��" "��" "��" "î" "��" "��" "��" "δ" "��" "��" "��" "��"])

;;Calendarģʽ֧�ָ��ַ�ʽ�����ĵ�ǰ����
;;������ġ�ǰ����ָ��û�е�������һ�죬������ָ�Ѿ���ȥ�����ӣ�
;;  q      �˳�calendarģʽ
;; C-f     �õ�ǰ������ǰһ��
;; C-b     �õ�ǰ�������һ��
;; C-n     �õ�ǰ������ǰһ��
;; C-p     �õ�ǰ�������һ��
;; M-}     �õ�ǰ������ǰһ����
;; M-{     �õ�ǰ�������һ����
;; C-x ]   �õ�ǰ������ǰһ��
;; C-x [   �õ�ǰ�������һ��
;; C-a     �ƶ�����ǰ�ܵĵ�һ��
;; C-e     �ƶ�����ǰ�ܵ����һ��
;; M-a     �ƶ�����ǰ�µĵ�һ��
;; M-e     �ද����ǰ�µ����һ��
;; M-<     �ƶ�����ǰ��ĵ�һ��
;; M->     �ƶ�����ǰ������һ��

;;Calendarģʽ֧���ƶ������ƶ����������ڵķ�ʽ
;; g d     �ƶ���һ���ر������
;;  o      ʹĳ��������·���Ϊ�м���·�
;;  .      �ƶ������������
;; p d     ��ʾĳһ����һ���е�λ�ã�Ҳ��ʾ����Ȼ��ж����졣
;; C-c C-l ˢ��Calendar����

;; Calendar֧������LATEX���롣
;; t m     ������������
;; t M     ��������һ������������
;; t d     ��������������һ����������
;; t w 1   ��һҳ����������ܵ�����
;; t w 2   ����ҳ����������ܵ�����
;; t w 3   ����һ��ISO-SYTLE���ĵ�ǰ������
;; t w 4   ����һ������һ��ʼ�ĵ�ǰ������
;; t y     ���ɵ�ǰ�������

;;EMACS Calendar֧�����ý��գ�
;; h       ��ʾ��ǰ�Ľ���
;; x       ���嵱��Ϊĳ������
;; u       ȡ�������ѱ�����Ľ���
;; e       ��ʾ������ǰ�������µĽ��ա�
;; M-x holiday  ������Ĵ��ڵ���ʾ��ǰ�������µĽ��ա�


;; ���⣬����һЩ����ģ�����˼�����
;; S       ��ʾ������ճ�����ʱ��(�Ǵ�д��S)
;; p C     ��ʾũ������ʹ��
;; g C     ʹ��ũ���ƶ����ڿ���ʹ��

(defun wuxch-gen-date-string ()
  "��calendar���棬Control-C Control-C�ѹ��������ڸ��Ƶ���������"
  (interactive)
  ;; (message "string is:%s" (calendar-date-string (calendar-cursor-to-date t)))
  (let ((date (calendar-cursor-to-date t))
        (year)
        (month)
        (day)
        (day-of-week)
        (clipboard)
        )
    (setq year (extract-calendar-year date))
    (setq month (extract-calendar-month date))
    (setq day (extract-calendar-day date))
    (setq day-of-week (wuxch-get-week-string (calendar-day-of-week date)))

    (setq clipboard (format "<%04d-%02d-%02d %s>" year month day day-of-week))
    (kill-new clipboard)
    (message "copy string \"%s\" to clipboard" clipboard)
    )
  )

(defun wuxch-get-week-string (arg)
  ""
  (cond ((eq arg 0) "������")
        ((eq arg 1) "����һ")
        ((eq arg 2) "���ڶ�")
        ((eq arg 3) "������")
        ((eq arg 4) "������")
        ((eq arg 5) "������")
        ((eq arg 6) "������")
        )
  )

(provide 'wuxch-calendar)
