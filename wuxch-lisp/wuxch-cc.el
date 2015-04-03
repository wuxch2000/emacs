;;; cc-mode customize

(require 'hideshow)

(setq tab-always-indent nil)

(defun indent-or-complete ()
  "Complete if point is at end of a word, otherwise indent line."
  (interactive)
  (if (looking-at "\\>")
      (hippie-expand nil)
    (indent-for-tab-command)
    ))

(defun my-c-java-style()
  (make-local-variable 'skeleton-pair-alist)
  (setq skeleton-pair-alist  '(
                               (?\(  _ ")")
                               (?\[  _ "]")
                               (?\" _ "\"")
                               (?\'  _ "'")
                               (?{ \n > _ \n ?} >)))

  (setq skeleton-pair t)
  (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)

  ;; (c-toggle-auto-newline 1)
  (c-toggle-hungry-state 1)

  (setq require-final-newline t)

  (local-set-key [(tab)] 'indent-or-complete)
  (local-set-key [(home)] 'back-to-indentation-or-beginning-of-line)
  (local-set-key [(shift home)] 'back-to-indentation-or-beginning-of-line-with-shift)

  (hs-minor-mode 1)
  (local-set-key [(control meta left)] 'hs-hide-all)
  (local-set-key [(control meta right)] 'hs-show-all)
  (local-set-key [(control x)(left)] 'hs-hide-block)
  (local-set-key [(control x)(right)] 'hs-show-block)

  ;; (local-set-key [double-mouse-1] 'wuxch-c-java-hs-toggle-hiding)

  ;; (local-set-key [(control =)] 'wuxch-count-lines)
  (local-set-key [(return)]    'newline-and-indent)

  (local-set-key [(control c)(control c)] 'ignore)
  (local-set-key [(control c)(control c)] 'wuxch-insert-windows-config-to-register)

;;;   (local-set-key [(f3)] 'list-func-mode-toggle)
;;;   (local-set-key [(control f3)] 'list-func-adjust-window)
;;;   (local-set-key [(control x)(k)] 'list-func-kill-source-buffer-and-delete-corresponding)

  (local-set-key [(control c)(\,)] 'ignore)
  (local-set-key [(control c)(\.)] 'ignore)
  (local-set-key [(control c)(\,)] 'pop-tag-mark)
  (local-set-key [(control c)(\.)] 'etags-select-find-tag-at-point)

  (local-set-key [(control x)(\,)] 'ignore)
  (local-set-key [(control x)(\.)] 'ignore)
  (local-set-key [(control x)(\,)] 'pop-tag-mark)
  (local-set-key [(control x)(\.)] 'etags-select-find-tag-at-point)

  ;; (which-func-mode 1)

  (local-set-key [(control c)(\^)] 'ignore)
  (local-set-key [(control c)(\^)] 'ff-find-related-file)

  (local-set-key [(control \;)] 'ignore)
  (local-set-key [(control \;)] 'closing-statement)

  (local-set-key [(control f7)] 'ignore)
  (local-set-key [(control f7)] 'compile-custom)
  )

;; 基本的设置方法是：
;; C-c C-s看一下当前是什么语句，与哪里对齐(高亮部分)
;; 可以通过C-c C-o设定这个预计的对齐方式
;; 可以通过s-set-offset在代码中写上。
;; 偏移可以是`+', `-', `++', `--', `*', or `/'
;; 分别对应:
    ;; `+'          `c-basic-offset' times 1
    ;; `-'          `c-basic-offset' times -1
    ;; `++'          `c-basic-offset' times 2
    ;; `--'          `c-basic-offset' times -2
    ;; `*'          `c-basic-offset' times 0.5
    ;; `/'          `c-basic-offset' times -0.5
;; 还可以是数字，如0
;; 可以检查变量c-offsets-alist

(defun c-set-my-style ()
  "c-set-my-style:"
  (interactive)
  (c-set-style "java")
  (c-set-offset 'friend '-)
  (c-set-offset 'substatement-open '0)
  (c-set-offset 'case-label '+)
  (c-set-offset 'statement-case-open '0)
  )

(defun my-c-mode-hook()
  ;; (setq tab-width 4 indent-tabs-mode nil)
  (c-set-my-style)

  ;;   (define-key c-mode-map [(control m)] 'newline-and-indent)
  ;;   (define-key c++-mode-map [(control m)] 'newline-and-indent)
  ;; set "_" is part if word
  (modify-syntax-entry ?_ "w")

  ;;   (imenu-add-menubar-index)
  (setq c-tab-always-indent nil)
  (my-c-java-style)
  ;; list-func
  (require 'wuxch-list-func)
  (local-set-key [(f4)] 'ignore)
  (local-set-key [(f4)] 'list-func-mode-toggle)
  (local-set-key [(control f4)] 'list-func-adjust-window)
  (local-set-key [(f7)] 'compile)
  ;; (list-func-mode-update)
  ;; (if (not buffer-read-only)
  ;;       (progn
  ;;         (turn-on-show-trailing-whitespace)
  ;;         )
  ;;     )
  ;; (which-func-mode 1)

  (local-set-key [(control x)(\;)] 'ignore)
  (local-set-key [(control x)(\;)] 'comment-current-line-or-region)
  (local-set-key [(meta \;)] 'ignore)
  (local-set-key [(meta \;)] 'comment-current-line-or-region)

  (local-set-key [(control c)(/)] 'semantic-ia-complete-symbol)
  (local-set-key [(control c)(control /)] 'semantic-ia-complete-symbol-menu)
  )

(add-hook 'c++-mode-hook 'my-c-mode-hook)
(add-hook 'c-mode-hook 'my-c-mode-hook)


(defun my-makefile-mode-hook()
  (modify-syntax-entry ?_ "w")
  )
(add-hook 'makefile-mode-hook 'my-makefile-mode-hook)



(defun comment-current-line-or-region(arg)
  "Comment current line. If current line is emply line, add
comment, if current line is commentted, uncomment it"
  (interactive "*P")
  ;; mark current line if there's not any acitve mark.
  (if (not mark-active)
      (let ((begin-pos)(end-pos))
        (back-to-indentation)
        (setq begin-pos (point))
        (cua-set-mark)
        (move-end-of-line arg)
        (setq end-pos (point))
        (if (eq begin-pos end-pos)
            (deactivate-mark))
        )
    )
  (comment-dwim arg)
  )


(defun insert-cpp-head ()
  "insert-cpp-head:"
  (interactive)
  (let* ((file-name (file-name-nondirectory (buffer-file-name)))
         (head-str)
         (final-pos)
         )
    (setq head-str (concat (upcase (file-name-sans-extension file-name))
                           "_"
                           (upcase (file-name-extension file-name))
                           ))
    (goto-char (point-min))
    (insert "#ifndef ") (insert head-str) (insert "\n")
    (insert "#define ") (insert head-str) (insert "\n")
    (setq final-pos (point))
    (insert "\n")
    (insert "#endif //") (insert head-str) (insert "\n")
    (goto-char final-pos)
    )

  )

(defun closing-statement ()
  "close-statement:"
  (interactive)
  (move-end-of-line nil)
  (if (not (looking-back ";"))
      (insert ";")
    )
  (newline-and-indent)
  )

(defun cpp-add-function (function-string)
  "cpp-add-function:"
  (interactive "sInput function declare:")
  (let ((buffer-str (buffer-name))
        (class-name))
    (when (string-match "\\([[:alpha:]][[:alnum:]]*\\)\\.hpp" buffer-str)
      ;; (message "class-name is:%s" (match-string 1 buffer-str))
      (setq class-name (match-string 1 buffer-str))

      (let ((return-parameter "\\(.*[[:blank:]]+\\)") (str-return-parameter)
            (function-name "\\([[:alpha:]][[:alnum:]]*\\)")(str-function-name)
            (input-parameter "\\([[:blank:]]*(.*).*\\)")(str-input-parameter)
            (comma ";")
            (return-point)
            )
        (when (string-match (concat return-parameter function-name input-parameter comma)
                            function-string))
        (setq str-return-parameter (match-string 1 function-string))
        (setq str-function-name (match-string 2 function-string))
        (setq str-input-parameter (match-string 3 function-string))

        (insert (concat function-string "\n"))

        (ff-find-related-file)
        (goto-char (point-max))
        (insert "\n")
        (insert str-return-parameter)
        (insert (concat class-name "::"))
        (insert str-function-name)
        (insert str-input-parameter)
        (insert "\n{\n")
        (setq return-point (point))
        (insert "\n}\n")

        (goto-char return-point)
        )
      )
    )
  )

;; in gdb, using : set non-stop off
(setq gdb-non-stop-setting nil)

(provide 'wuxch-cc)
