;;; configure of CUA key definition, and some function about edit.
(require 'extraedit)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-enable-cua-keys t)
 '(cua-highlight-region-shift-only nil)
 '(cua-mode t nil (cua-base))
 '(cvs-dired-use-hook nil)
 '(font-lock-maximum-size 256000000)
 '(ibuffer-default-sorting-mode (quote major-mode))
 '(vc-cvs-use-edit nil)
 )

;; control-s: save-buffer
(global-set-key [(control s)] 'save-buffer)

;; meta-s: save-as
(global-set-key [(meta s)]    'write-file)

;; ignoring control-shift and control-space to avoid confict with IME input keymap.
(global-set-key [(control shift)] 'ignore)
(global-set-key [(control space)] 'ignore)

;; control a: mark-all
(global-set-key [(control a)] 'mark-whole-buffer)


(defun copy-current-word ()
  "put the current word where cursor is into killing-ring, even the cursor is not at the beginning of word"
  (interactive)
  (let ((w (bounds-of-thing-at-point 'word)))
    (kill-ring-save (car w)(cdr w))
    (message (concat "word:[" (buffer-substring (car w)(cdr w)) "] copied"))))

;; (global-set-key [(control w)] 'ignore)
;; (global-set-key [(control w)] 'copy-current-word)
;; ȱʡ��control w������kill region���ָ�Ϊmark-word�������ظ�ʹ�ã���isearch���һ��
(global-set-key [(control w)] 'ignore)
(global-set-key [(control w)] 'mark-word)

(if (equal 'windows-nt system-type)
    (progn
      ;; control x m: maxmize windows
      (global-set-key [(control x)(m)] 'ignore)
      (global-set-key [(control x)(m)]
                      (lambda ()
                        (interactive)
                        (w32-restore-frame)
                        (w32-maximize-frame)
                        (wuxch-set-default-theme)
                        ))))


;; meta h :Set mark after end of following balanced expression (mark-sexp),ԭΪC-M-@
(global-set-key [(meta h)] 'ignore)
(global-set-key [(meta h)] 'mark-sexp)

;; ��ʹ�� M-x COMMAND �󣬹� 1 ������ʾ�� COMMAND �󶨵ļ���
(setq suggest-key-bindings 1)

;; context-free tabstops in text mode
(define-key text-mode-map (kbd "TAB") 'tab-to-tab-stop)

;; �����м�࣬0Ϊȱʡ�м��
(defun line-space (n)
  "adjust line-space"
  (interactive "nEnter line-spacing(0,3,5,...):")
  (setq-default line-spacing n)
  )

;; gnuserv���̵�������server���趨�ر�emacsʱֱ�ӹر�gnuserv������ѯ�ʡ�
;; ��ʾ���н��̵������ǣ�meta x list-processes
(if (not-linux)
    (set-process-query-on-exit-flag (get-process "server") nil)
  )


;; winner-mode������ʹ��control-c + ���Ҽ�ͷ�ָ���һ�ε�windows����
;; (winner-mode)

;; ������ʾ��ǰ�� meta-x hl-line-mode

;; word-wrap
(require 'word-wrap)

;; ;; comment short key
;; (global-set-key [(control c)(c)] 'comment-region)
;; (global-set-key [(control c)(u)] 'uncomment-region)

;; ����tab
;; ȱʡģʽ��emacs����tab�������Ĳ�����indent�����ȷʵϣ������tab�������ǣ�ctrl-q ctrl-tab
;; ���� TAB �ַ���indent, �������ܶ���ֵĴ��󡣱༭ Makefile ��ʱ��Ҳ���õ��ģ�
;; ��Ϊ makefile-mode ��� TAB �����ó������� TAB �ַ������Ҽ�����ʾ��
(setq-default indent-tabs-mode nil)
;; tab�����
(setq default-tab-width 4)

;; ����ֱ���޸Ļ���ɾ��ѡ������
(delete-selection-mode t)

;; _��word��һ����
(setq dabbrev-abbrev-char-regexp "\\s_")

;; (modify-syntax-entry ?\$ "." text-mode-syntax-table)
;; (modify-syntax-entry ?\t "." text-mode-syntax-table)

;; ��ֹ��С�İ����˵��е� print ʱ��emacs ����
(fset 'print-buffer 'ignore)
(setq lpr-command "")
(setq printer-name "")

(global-set-key [(meta delete)] 'delete-horizontal-space)

(global-set-key [(control w)]  'ignore)
(global-set-key [(control w)]  'wuxch-mark-word)

(defun wuxch-mark-word (&optional arg allow-extend)
  "goto the beginning of the word and mark it"
  (interactive "P\np")
  (if  (and (not mark-active) (not (eq (point) (point-min))))
      (if (wuxch-char-before-is-alnum)
          (backward-word))
    )
  ;; the following codes are copied from orginal mark-word function.
  (cond ((and allow-extend (or (and (eq last-command this-command) (mark t))
                               (and transient-mark-mode mark-active)))
         (setq arg (if arg (prefix-numeric-value arg)
                     (if (< (mark) (point)) -1 1)))
         (set-mark
          (save-excursion
            (goto-char (mark))
            (forward-word arg)
            (point))))
        (t
         (push-mark
          (save-excursion
            (forward-word (prefix-numeric-value arg))
            (point))
          nil t)))
  )

(defun wuxch-char-before-is-alnum ()
  (if (string-match "[[:alnum:]]" (char-to-string (char-before (point))))
      t
    nil)
  )

;; �Դ���delete-blank-lineʵ�ڲ����ã�дһ���򵥵ģ�ֱ��ɾ�����еĿ���
;; ��Ϊ��һ��remove-duplicate-lines������ֱ�ӽ�remove-blank-lines
(defun remove-blank-lines ()
  ""
  (interactive "*")
  (goto-char (point-min))
  (let ((count 0)(buffername (buffer-name)))
    (while (re-search-forward "^[ \t]*\n" nil t)
      (progn
        (replace-match "")
        (setq count (+ count 1))
        )
      )
    (if (> count 0)
        (progn
          (message "remove %d line(s) in buffer %s" count buffername)
          (goto-char (point-min))
          )
      (message "no blank line in buffer %s" buffername)
      )
    )
  )
;; ��simple.el����� delete-blank-lines ���ε�
(defalias 'delete-blank-lines 'remove-blank-lines)

(defun remove-useless-lines ()
  "useless lines means blank lines and duplicate lines"
  (interactive "*")
  (remove-duplicate-lines)
  (remove-blank-lines)
  )

(defun move-to-end-of-word ()
  "move-to-end-of-word:"
  (if (looking-at "[[:alnum:]]")
      (forward-word)
    )
  )

(global-set-key [(control backspace)] 'ignore)
(global-set-key [(control backspace)] 'backward-kill-word-or-delete-horizontal-space)
(defun backward-kill-word-or-delete-horizontal-space (arg)
  ""
  (interactive "p")
  (if (or (string= (char-to-string (char-before)) " " )
          (string= (char-to-string (char-before)) "\n" )
          (string= (char-to-string (char-before)) "\t" ))
      (delete-space)
    (backward-kill-word arg))
  )

(defun delete-space (&optional backward-only)
  "Delete all spaces and tabs around point,including \n
If BACKWARD-ONLY is non-nil, only delete them before point."
  (interactive "*P")
  (let ((orig-pos (point)))
    (delete-region
     (if backward-only
         orig-pos
       (progn
         (skip-chars-forward " \t\n")
         (constrain-to-field nil orig-pos t)))
     (progn
       (skip-chars-backward " \t\n")
       (constrain-to-field nil orig-pos)))))

(defun copy-word (&optional arg)
  "Copy words at point"
  (interactive "P")
  (let ((pos (point))
        (beg (progn (if (looking-back "[a-zA-Z0-9]" 1) (backward-word 1)) (point)))
        (end (progn (forward-word arg) (point))))
    (copy-region-as-kill beg end)
    (message "\"%s\" is copied" (buffer-substring-no-properties beg end))
    (goto-char pos)
    )
  )

(global-set-key [(control c)(w)]   'copy-word)

(defun copy-line (&optional arg)
  "Save current line into Kill-Ring without mark the line "
  (interactive "P")
  (let ((pos (point))
        (beg (line-beginning-position))
      	(end (line-end-position)))
    (copy-region-as-kill beg end)
    (message "\"%s\" is copied" (buffer-substring-no-properties beg end))
    (goto-char pos)
    )
  )

;; (global-set-key [(control c)(l)]   'copy-line)

(defun copy-paragraph (&optional arg)
  "Copy paragraphes at point"
  (interactive "P")
  (let ((beg (progn (backward-paragraph 1) (point)))
      	(end (progn (forward-paragraph arg) (point))))
    (copy-region-as-kill beg end))
  (message "copying current paragraph to killing-ring")
  )

;; (global-set-key [(control c)(p)]   'copy-paragraph)
(global-set-key [(meta n)]  'cua-scroll-up)
(global-set-key [(meta p)]  'cua-scroll-down)

;; some key define for linux terminal
(if (is-linux-terminal)
    (progn
      (global-set-key [find]                'beginning-of-line)
      (global-set-key [select]              'end-of-line)
      (global-set-key [(control x)(find)] 	'beginning-of-buffer)
      (global-set-key [(control x)(select)] 'end-of-buffer)
      (global-set-key [(control c)(find)] 	'beginning-of-buffer)
      (global-set-key [(control c)(select)] 'end-of-buffer)
      )
  )

(global-set-key [(control /)]   'ignore)
(global-set-key [(control /)]   'repeat)

(provide 'wuxch-cua)
