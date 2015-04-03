;;; functions about date and time.

(cond ((string= wuxch-computer-id "X60")
       ()
       )
      ((string= wuxch-computer-id "X31")
       (setq display-time-format "%Y/%m/%d")
       (display-time)
       )
      (t
       (setq display-time-format "%Y/%m/%d")
       (display-time))
      )


;; date命令插入当前时间
(global-set-key [(control c)(d)] 'date)
(defun date ()
  "Insert a nicely formated date string."
  (interactive)
  ;; (insert (format-time-string "%m/%d/%Y %H:%M:%S")))
  (insert (format-time-string "%H:%M:%S")))
;; 关于时间输出控制符
;; %Y is the year, %y within the century, %C the century.
;; %G is the year corresponding to the ISO week, %g within the century.
;; %m is the numeric month.
;; %b and %h are the locale's abbreviated month name, %B the full name.
;; %d is the day of the month, zero-padded, %e is blank-padded.
;; %u is the numeric day of week from 1 (Monday) to 7, %w from 0 (Sunday) to 6.
;; %a is the locale's abbreviated name of the day of week, %A the full name.
;; %U is the week number starting on Sunday, %W starting on Monday,
;;  %V according to ISO 8601.
;; %j is the day of the year.

;; %H is the hour on a 24-hour clock, %I is on a 12-hour clock, %k is like %H
;;  only blank-padded, %l is like %I blank-padded.
;; %p is the locale's equivalent of either AM or PM.
;; %M is the minute.
;; %S is the second.
;; %Z is the time zone name, %z is the numeric form.
;; %s is the number of seconds since 1970-01-01 00:00:00 +0000.

;; %c is the locale's date and time format.
;; %x is the locale's "preferred" date format.
;; %D is like "%m/%d/%y".
;; %R is like "%H:%M", %T is like "%H:%M:%S", %r is like "%I:%M:%S %p".
;; %X is the locale's "preferred" time format.
;; Finally, %n is a newline, %t is a tab, %% is a literal %.
;; Certain flags and modifiers are available with some format controls.
;; The flags are `_', `-', `^' and `#'.  For certain characters X,
;; %_X is like %X, but padded with blanks; %-X is like %X,
;; but without padding.  %^X is like %X, but with all textual
;; characters up-cased; %#X is like %X, but with letter-case of
;; all textual characters reversed.
;; %NX (where N stands for an integer) is like %X,
;; but takes up at least N (a number) positions.
;; The modifiers are `E' and `O'.  For certain characters X,
;; %EX is a locale's alternative version of %X;
;; %OX is like %X, but uses the locale's number symbols.




(provide 'wuxch-date)
