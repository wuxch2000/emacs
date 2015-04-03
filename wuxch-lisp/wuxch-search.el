;;; configuration for search command

(require 'color-moccur)

;;; 和标准的键盘定义靠拢。
(global-set-key [(control /)] 'isearch-forward-regexp)
(define-key isearch-mode-map [(control /)] (lookup-key isearch-mode-map [(control s)]))

;; ;; 改变普通搜索和正则表达式搜索的按键定义
;; ;; control f  进行正则查找
;; (global-set-key [(control f)] 'isearch-forward-regexp)



;; ;; control f 继续查找
;; (define-key isearch-mode-map [(control f)] (lookup-key isearch-mode-map [(control s)]))
;; (define-key minibuffer-local-isearch-map [(control f)]
;;   (lookup-key minibuffer-local-isearch-map [(control s)]))

;; 查找结果可以进行替换，把原来定义的control meta %功能绑定到meta s
(define-key isearch-mode-map [(meta s)] (lookup-key isearch-mode-map [(control meta %)]))
(define-key minibuffer-local-isearch-map [(meta s)]
  (lookup-key minibuffer-local-isearch-map [(control meta %)]))
(define-key isearch-mode-map [(meta s)] (lookup-key isearch-mode-map [(control meta %)]))
(define-key minibuffer-local-isearch-map [(meta s)]
  (lookup-key minibuffer-local-isearch-map [(control meta %)]))


;; 使用以前的查找条件，把原来定义的meta p功能绑定到up,meta n功能绑定到down
(define-key isearch-mode-map [(up)] (lookup-key isearch-mode-map [(meta p)]))
(define-key minibuffer-local-isearch-map [(up)]
  (lookup-key minibuffer-local-isearch-map [(meta p)]))
(define-key isearch-mode-map [(down)] (lookup-key isearch-mode-map [(meta n)]))
(define-key minibuffer-local-isearch-map [(down)]
  (lookup-key minibuffer-local-isearch-map [(meta n)]))

;; 查找也可以使用control v进行paste，把原来定义的meta y功能绑定到contrl v
(define-key isearch-mode-map [(control v)] (lookup-key isearch-mode-map [(meta y)]))
(define-key minibuffer-local-isearch-map [(control v)]
  (lookup-key minibuffer-local-isearch-map [(meta y)]))

;; ;; (global-set-key [(control meta f)] 'isearch-forward)
;; ;; control r  反向查找
;; (global-set-key [(control r)] 'isearch-backward-regexp)
;; ;; (global-set-key [(control meta r)] 'isearch-backward)

(global-set-key [(meta s)] 'query-replace-regexp)
;; (global-set-key [(meta f)] 'query-replace-regexp)


;; 缺省isearch map里control w拷贝当前光标处到word结束处的字符，现修改为整个word
;; 另：control y拷贝当前光标处直到line end的字符，也很好用
(define-key isearch-mode-map [(control w)] 'ignore)
(define-key isearch-mode-map [(control w)] 'isearch-whole-word-at-point)
(defun isearch-whole-word-at-point()
  (interactive)
  (setq isearch-string (thing-at-point 'word))
  (isearch-search-and-update))

;; 设置query replace高亮
(setq query-replace-lazy-highlight t)
(setq query-replace-highlight t)

;; 多文件，多buf查找，使用occur
;; 在isearch中触发occur
(defun isearch-occur ()
  "Invoke `occur' from within isearch."
  (interactive)
  (let ((occur-buffer-name "*Occur*")(case-fold-search isearch-case-fold-search))
    (occur (if isearch-regexp isearch-string (regexp-quote isearch-string)))
    (isearch-exit)
    (select-window (get-buffer-window occur-buffer-name))
    (next-error-no-select)
    )
  )
(define-key isearch-mode-map [(control o)] 'isearch-occur)

;; occur 非常的好用。因为 occor 只搜索出匹配行，所以不希望折行
(add-hook 'occur-mode-hook 'wuxch-occur-mode-hook)

(defun wuxch-occur-mode-hook()
  "wuxch-occur-mode-hook:"
  (toggle-truncate-lines 0)
  ;; (next-error-follow-minor-mode 1)
  (next-error-follow-minor-mode nil)
  (local-set-key "n"    'next-error-no-select)
  (local-set-key "p"    'previous-error-no-select)
  (custom-set-variables
   '(next-error-recenter 8)
   )
  )

(provide 'wuxch-search)
