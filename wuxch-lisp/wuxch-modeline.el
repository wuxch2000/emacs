;;; customize mode-line
(require 'modeline-posn)

;; ��ʾ�к�
(setq column-number-mode t)


;; ��ʾ�ļ���С
(setq size-indication-mode t)

(add-to-list 'default-mode-line-format
             '((mark-active
                (:eval (format "Selected: %d line(s), %d char(s) "
                               (count-lines (region-beginning)
                                            (region-end))
                               (- (region-end) (region-beginning)))))))

(custom-set-variables
 '(eol-mnemonic-dos "[dos]")
 '(eol-mnemonic-unix "[unix]")
 '(eol-mnemonic-mac "[mac]")
 '(eol-mnemonic-undecided "[unknown]")
 )

;; ** �C modified since last save
;; -- �C not modified since last save
;; %* �C read-only, but modified
;; %% �C read-only, not modifed

;; (require 'show-point-mode.el)
;; (show-point-mode 1)

(set-face-background 'modeline "gray60")
(set-face-foreground 'modeline "blue")
(set-face-bold-p 'modeline t)

(set-face-background 'mode-line-inactive "gray70")


(provide 'wuxch-modeline)
