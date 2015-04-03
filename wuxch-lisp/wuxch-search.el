;;; configuration for search command

(require 'color-moccur)

;;; �ͱ�׼�ļ��̶��忿£��
(global-set-key [(control /)] 'isearch-forward-regexp)
(define-key isearch-mode-map [(control /)] (lookup-key isearch-mode-map [(control s)]))

;; ;; �ı���ͨ������������ʽ�����İ�������
;; ;; control f  �����������
;; (global-set-key [(control f)] 'isearch-forward-regexp)



;; ;; control f ��������
;; (define-key isearch-mode-map [(control f)] (lookup-key isearch-mode-map [(control s)]))
;; (define-key minibuffer-local-isearch-map [(control f)]
;;   (lookup-key minibuffer-local-isearch-map [(control s)]))

;; ���ҽ�����Խ����滻����ԭ�������control meta %���ܰ󶨵�meta s
(define-key isearch-mode-map [(meta s)] (lookup-key isearch-mode-map [(control meta %)]))
(define-key minibuffer-local-isearch-map [(meta s)]
  (lookup-key minibuffer-local-isearch-map [(control meta %)]))
(define-key isearch-mode-map [(meta s)] (lookup-key isearch-mode-map [(control meta %)]))
(define-key minibuffer-local-isearch-map [(meta s)]
  (lookup-key minibuffer-local-isearch-map [(control meta %)]))


;; ʹ����ǰ�Ĳ�����������ԭ�������meta p���ܰ󶨵�up,meta n���ܰ󶨵�down
(define-key isearch-mode-map [(up)] (lookup-key isearch-mode-map [(meta p)]))
(define-key minibuffer-local-isearch-map [(up)]
  (lookup-key minibuffer-local-isearch-map [(meta p)]))
(define-key isearch-mode-map [(down)] (lookup-key isearch-mode-map [(meta n)]))
(define-key minibuffer-local-isearch-map [(down)]
  (lookup-key minibuffer-local-isearch-map [(meta n)]))

;; ����Ҳ����ʹ��control v����paste����ԭ�������meta y���ܰ󶨵�contrl v
(define-key isearch-mode-map [(control v)] (lookup-key isearch-mode-map [(meta y)]))
(define-key minibuffer-local-isearch-map [(control v)]
  (lookup-key minibuffer-local-isearch-map [(meta y)]))

;; ;; (global-set-key [(control meta f)] 'isearch-forward)
;; ;; control r  �������
;; (global-set-key [(control r)] 'isearch-backward-regexp)
;; ;; (global-set-key [(control meta r)] 'isearch-backward)

(global-set-key [(meta s)] 'query-replace-regexp)
;; (global-set-key [(meta f)] 'query-replace-regexp)


;; ȱʡisearch map��control w������ǰ��괦��word���������ַ������޸�Ϊ����word
;; ��control y������ǰ��괦ֱ��line end���ַ���Ҳ�ܺ���
(define-key isearch-mode-map [(control w)] 'ignore)
(define-key isearch-mode-map [(control w)] 'isearch-whole-word-at-point)
(defun isearch-whole-word-at-point()
  (interactive)
  (setq isearch-string (thing-at-point 'word))
  (isearch-search-and-update))

;; ����query replace����
(setq query-replace-lazy-highlight t)
(setq query-replace-highlight t)

;; ���ļ�����buf���ң�ʹ��occur
;; ��isearch�д���occur
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

;; occur �ǳ��ĺ��á���Ϊ occor ֻ������ƥ���У����Բ�ϣ������
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
