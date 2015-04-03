;; 支持显示tabbar，在tabbar中改动了tab button的样式和字体颜色
(require 'tabbar)

(global-set-key [(control prior)] 'tabbar-backward-tab)
(global-set-key [(control next)]       'tabbar-forward-tab)
(global-set-key [(meta prior)] 'tabbar-backward-group)
(global-set-key [(meta next)]       'tabbar-forward-group)
(setq tabbar-cycling-scope 'tabs)
(setq tabbar-buffer-groups-function 'tabbar-buffer-ignore-groups)

;; 原来的 tabbar 强行对你的 buffer 进行分组，但是如果你想在你编辑的buffer间切换而不论它们是什么组，那
;; 么似乎没有一个好办法。但是 tabbar 本来提供了一个机制，让你可以自己确定 tab 属于哪组，只要修改
;; tabbar-buffer-groups-function 就行了。这样，我可以把每个 buffer 同时加入它所在的 major mode 的组和
;; 一个叫做 "default" 的组，这样我在 default 组里就可以方便的浏览到所有的 buffer 了。而切换到其它组就
;; 可以分组浏览。你还可以自行把某些 buffer 分到一组，比如我可以把 scheme-mode 的 buffer 和
;; inferer-scheme-mode 的 buffer 分到同一个组。
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
