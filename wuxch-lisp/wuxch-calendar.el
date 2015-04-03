;;; calendar information

(autoload 'calendar "calendar+"
  "Display a 3-month calendar in another window." t)
(autoload 'insert-diary-entry "calendar+"
  "Insert a diary entry for date indicated by point." t)

;; 设置所在地的经纬度和地名，calendar 可以根据这些信息告知你每天的日出和日落的时间。(meta x sunrise-sunset)
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
  ;; 当天的face就是用font-lock-function-name-face
  (copy-face 'font-lock-keyword-face 'calendar-today)
  ;; calendar-mode-map
  (define-key calendar-mode-map [(control c)(control c)]    'ignore)
  (define-key calendar-mode-map [(control c)(control c)]    'wuxch-gen-date-string)


  ;; 设置 calendar 的显示
  (setq calendar-remove-frame-by-deleting t)
  (setq calendar-week-start-day 0)            ; 设置星期日为每周的第一天
  (setq mark-diary-entries-in-calendar t)     ; 标记calendar上有diary的日期
  (setq mark-holidays-in-calendar t)          ; 为了突出有diary的日期，calendar上不标记节日
  (setq view-calendar-holidays-initially nil) ; 打开calendar的时候不显示一堆节日

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

;;设置日历的一些颜色
;; (setq calendar-load-hook
;; '(lambda ()
;;    (set-face-foreground 'diary-face "skyblue")
;;    (set-face-background 'holiday-face "slate blue")
;; (set-face-foreground 'holiday-face "white")))

;; 设置阴历显示，在 calendar 上用 pC 显示阴历
;; (setq chinese-calendar-celestial-stem
;;   ["甲" "乙" "丙" "丁" "戊" "己" "庚" "辛" "壬" "癸"])
;; (setq chinese-calendar-terrestrial-branch
;;   ["子" "丑" "寅" "卯" "辰" "巳" "戊" "未" "申" "酉" "戌" "亥"])

;;Calendar模式支持各种方式来更改当前日期
;;（这里的“前”是指还没有到来的那一天，“后”是指已经过去的日子）
;;  q      退出calendar模式
;; C-f     让当前日期向前一天
;; C-b     让当前日期向后一天
;; C-n     让当前日期向前一周
;; C-p     让当前日期向后一周
;; M-}     让当前日期向前一个月
;; M-{     让当前日期向后一个月
;; C-x ]   让当前日期向前一年
;; C-x [   让当前日期向后一年
;; C-a     移动到当前周的第一天
;; C-e     移动到当前周的最后一天
;; M-a     移动到当前月的第一天
;; M-e     多动到当前月的最后一天
;; M-<     移动到当前年的第一天
;; M->     移动到当前年的最后一天

;;Calendar模式支持移动多种移动到特珠日期的方式
;; g d     移动到一个特别的日期
;;  o      使某个特殊的月分作为中间的月分
;;  .      移动到当天的日期
;; p d     显示某一天在一年中的位置，也显示本年度还有多少天。
;; C-c C-l 刷新Calendar窗口

;; Calendar支持生成LATEX代码。
;; t m     按月生成日历
;; t M     按月生成一个美化的日历
;; t d     按当天日期生成一个当天日历
;; t w 1   在一页上生成这个周的日历
;; t w 2   在两页上生成这个周的日历
;; t w 3   生成一个ISO-SYTLE风格的当前周日历
;; t w 4   生成一个从周一开始的当前周日历
;; t y     生成当前年的日历

;;EMACS Calendar支持配置节日：
;; h       显示当前的节日
;; x       定义当天为某个节日
;; u       取消当天已被定义的节日
;; e       显示所有这前后共三个月的节日。
;; M-x holiday  在另外的窗口的显示这前后三个月的节日。


;; 另外，还有一些特殊的，有意思的命令：
;; S       显示当天的日出日落时间(是大写的S)
;; p C     显示农历可以使用
;; g C     使用农历移动日期可以使用

(defun wuxch-gen-date-string ()
  "在calendar里面，Control-C Control-C把光标出的日期复制到剪贴板中"
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
  (cond ((eq arg 0) "星期日")
        ((eq arg 1) "星期一")
        ((eq arg 2) "星期二")
        ((eq arg 3) "星期三")
        ((eq arg 4) "星期四")
        ((eq arg 5) "星期五")
        ((eq arg 6) "星期六")
        )
  )

(provide 'wuxch-calendar)
