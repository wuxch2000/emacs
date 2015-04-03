;;; configure about java.

(add-to-list 'load-path (concat emacs-site-lisp-dir "jde-2.3.5.1/lisp"))

;; 关于java-open
(require 'java-open)
;; java-open-source-path is similar in function to CLASSPATH


(defun java-new-class-file ( n )
  "Create new java class file"
  (interactive "sNew Class Name:")
  (let ((java-file-full-name)(java-file-name))
    ;; build java file name, including directory
    (setq java-file-name (concat n ".java"))
    (setq java-file-full-name (concat my-java-code-directory (concat "/" java-file-name)))

    ;; create new buffer
    (if (file-exists-p java-file-full-name)
        (message "Jave Class confict with file:%s" java-file-full-name)
      (progn
        (get-buffer-create java-file-name)
        (switch-to-buffer java-file-name)
        (java-mode)
        ;; the best way is use skeleton-insert functiion, use java file name as class name.
        ;; but I don't know how to use the 2nd argment region, so just leave this behind.
        (skeleton-java-class)
        ;;         (set-mark 0)
        ;;         (skeleton-insert 'skeleton-java-class (0 0) n)
        (write-file java-file-full-name)
        (message "New Java file is %s" java-file-full-name)
        )
      )
    )
  )

(defun run-java-file ()
  "run java file in compile mode"
  (interactive)
  (setq my-command
        (format "java %s"  (substring (buffer-name) 0
                                      (- (string-bytes (buffer-name)) (string-bytes ".java")))))
  (compile my-command t)
  )

(defun compile-java-file ()
  "compile java file in compile mode"
  (interactive)
  (setq my-command (format "javac %s" (buffer-name)))
  (compile my-command t)
  )

(defun my-java-mode-hook()
  (setq tab-width 4 indent-tabs-mode nil)
  (c-set-style "stroustrup")
  (c-set-offset 'inline-open 0)
  (c-set-offset 'innamespace 0)
  (c-set-offset 'friend '-)
  ;;   (define-key java-mode-map [(control m)] 'newline-and-indent)
  (define-key java-mode-map [(f5)] 'run-java-file)
  (define-key java-mode-map [(f7)] 'compile-java-file)
  ;; 设置"_"是word的一部分
  (modify-syntax-entry ?_ "w")
  (setq c-tab-always-indent nil)

  (my-c-java-style)
  (turn-on-show-trailing-whitespace)
  (define-key java-mode-map [(control c)(\.)] 'ignore)
  (define-key java-mode-map [(control c)(\,)] 'wuxch-point-stack-push)
  (define-key java-mode-map [(control c)(\.)] 'wuxch-point-stack-pop)
  (font-lock-add-keywords 'java-mode '(("true" . font-lock-keyword-face)))
  (font-lock-add-keywords 'java-mode '(("false" . font-lock-keyword-face)))
  (font-lock-add-keywords 'java-mode '(("null" . font-lock-keyword-face)))
  )

(add-hook 'java-mode-hook 'my-java-mode-hook)

(provide 'wuxch-java)
