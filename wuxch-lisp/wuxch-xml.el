;;;;;;;;;;; dtd

;; (add-to-list 'load-path (concat emacs-site-lisp-dir "dtd"))

;; (require 'tdtd)

;; (autoload 'tdtd "dtd-mode" nil t)

;;;;;;;;;;;    nxml ;;;;;;;;;;;;;;;;;;;;;;;;

;; (modify-coding-system-alist 'file "\\.xml\\'" 'utf-8)

;; (setq auto-coding-alist (cons '("\\.xml\\'" . utf-8-dos) auto-coding-alist))

(require 'nxml-mode)

(defun my-nxml-style()

  (add-hook 'local-write-file-hooks 'delete-trailing-whitespace)
  (turn-on-show-trailing-whitespace)

  ;;输入左边的括号，就会自动补全右边的部分.包括(), "", [] , {} , 等等。
  (make-local-variable 'skeleton-pair-alist)
  (setq skeleton-pair-alist  '(
                               (?\(  _ ")")
                               (?\[  _ "]")
                               (?\" _ "\"")
                               (?\'  _ "'")
                               (?{ \n > _ \n ?} >)))

  (setq skeleton-pair t)
  (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)

  (define-key nxml-mode-map [(control c)(control c)] 'nxml-complete)

  ;; (define-key nxml-mode-map [(control c)(home)]      'nxml-beginning-of-element)
  ;; (define-key nxml-mode-map [(control c)(end)]       'nxml-end-of-element)
  ;; (define-key nxml-mode-map [(control c)(return)]    'cabo:nxml-split-element)
  )

(defun my-nxml-mode-hook ()
  ""
  (my-nxml-style)
  )

(add-hook 'nxml-mode-hook 'my-nxml-mode-hook)

(defun ant ()
  "compile java file in compile mode"
  (interactive)
  (setq my-command (format "ant -f %s" (buffer-file-name)))
  (compile my-command t)
  )


(defun my-nxml-style()

  (add-hook 'local-write-file-hooks 'delete-trailing-whitespace)
  ;; (add-hook 'local-write-file-hooks 'indent-dwim)
  (turn-on-show-trailing-whitespace)

  ;;输入左边的括号，就会自动补全右边的部分.包括(), "", [] , {} , 等等。
  (make-local-variable 'skeleton-pair-alist)
  (setq skeleton-pair-alist  '(
                               (?\(  _ ")")
                               (?\[  _ "]")
                               (?{  _ "}")
                               (?\" _ "\"")
                               (?\'  _ "'")
                               ))

  (setq skeleton-pair t)

  (modify-syntax-entry ?_ "w")

  (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)

  ;; (define-key nxml-mode-map [(control c)(control c)] 'nxml-complete)

  (define-key nxml-mode-map [(meta h)] 'ignored)
  (define-key nxml-mode-map [(meta h)] 'mark-sexp)

  (define-key nxml-mode-map [(control up)] 'nxml-backward-element)
  (define-key nxml-mode-map [(control down)] 'nxml-forward-element)

  ;; (define-key nxml-mode-map [(control c)(home)]      'nxml-beginning-of-element)
  ;; (define-key nxml-mode-map [(control c)(end)]       'nxml-end-of-element)
  ;; (define-key nxml-mode-map [(control c)(return)]    'cabo:nxml-split-element)

  (define-key nxml-mode-map [(control c)(control c)] 'ignored)
  (define-key nxml-mode-map [(control c)(control c)] 'nxml-complete)

  ;; (define-key nxml-mode-map [(control c)(c)] 'ignored)
  ;; (define-key nxml-mode-map [(control c)(c)] 'xsl-process)
  (define-key nxml-mode-map [(control c)(w)] 'ignored)
  (define-key nxml-mode-map [(control c)(w)] 'xsl-wiki-process)
  (define-key nxml-mode-map [(control c)(h)] 'ignored)
  (define-key nxml-mode-map [(control c)(h)] 'xsl-html-process)

  (define-key nxml-mode-map [(control c)(s)] 'ignored)
  (define-key nxml-mode-map [(control c)(s)] 'xsl-open)

  (local-set-key [(home)] 'back-to-indentation-or-beginning-of-line)
  (local-set-key [(shift home)] 'back-to-indentation-or-beginning-of-line-with-shift)

  (local-set-key [(f5)] 'ignored)
  (local-set-key [(f5)] 'para)

  (define-key nxml-mode-map [(meta h)] 'ignored)
  (define-key nxml-mode-map [(meta h)] 'wuxch-mark-element)

  )

(defun my-nxml-mode-hook ()
  ""
  (my-nxml-style)
  )

(add-hook 'nxml-mode-hook 'my-nxml-mode-hook)

(defun ant ()
  "compile java file in compile mode"
  (interactive)
  (setq my-command (format "ant -f %s" (buffer-file-name)))
  (compile my-command t)
  )

(defun wuxch-get-xsl-file-name ()
  "wuxch-get-xsl-file-name:"
  ;; (interactive)
  (let ((pos (point))(xsl-file-name nil))
    (goto-char (point-min))
    ;; if using "^", "?" must be quote with parentheses, which is weired.
    (when (re-search-forward "^<\[?]xml-stylesheet.*href[ ]*=[ ]*\"\\([[:graph:]]+\\)\".*\?>[[:blank:]]*$")
      (setq xsl-file-name (substring-no-properties (match-string 1)))
      )
    (goto-char pos)
    ;; (message "xsl-file-name is:%s" xsl-file-name)
    xsl-file-name
    )
  )

(defun wuxch-build-java-xalan-command (xml-name xsl-name output-name output-format)
  "wuxch-build-java-xalan-command:"
  (let* ((xalan-path "d:/work/xsl/xalan-j_2_7_1/")
         (xalan-jar (list "xalan.jar" "serializer.jar" "xml-apis.jar" "xercesImpl.jar"))
         (xalan-command "org.apache.xalan.xslt.Process")
         (xalan-output-format-option nil)

         (xalan-debug-info (concat "-edump "
                                   "-tt " ;; -TT (Trace the templates as they are being called)
                                   "-tg " ;; -TG (Trace each generation event)
                                   ;; "-ts "
                                   ;; "-ttc "
                                   "-l"
                                   ))
         ;; -QC (Quiet Pattern Conflicts Warnings)

         ;; -TS (Trace each selection event)
         ;; -TTC (Trace the template children as they are being processed)
         ;; -TCLASS (TraceListener class for trace extensions)
         ;; -L (use line numbers for source document)

         (cmd "java"))


    ;; classpath
    (setq cmd (concat cmd " -classpath "))
    (dolist (jar xalan-jar)
      (setq cmd (concat cmd xalan-path jar ";"))
      )
    ;; remove last ;
    (setq cmd (substring cmd 0 (- (length cmd) 1)))

    ;; process class
    (setq cmd (concat cmd " " xalan-command))

    ;; options
    (cond ((string= output-format "html")
           (setq xalan-output-format-option "-html"))
          ((or (string= output-format "txt")
               (string= output-format "text"))
           (setq xalan-output-format-option "-text"))
          )
    (setq cmd (concat cmd " " xalan-output-format-option))
    (setq cmd (concat cmd " " xalan-debug-info))

    ;; input/output file
    (setq cmd (concat cmd " -in " xml-name))
    ;; (setq cmd (concat cmd " -xsl " xsl-name))
    (setq cmd (concat cmd " -out " output-name))
    ;; return cmd
    cmd
    )
  )

(defun xsl-open ()
  "xsl-open:"
  (interactive)
  (let* ((xml-window (selected-window))
         (xml-name (buffer-file-name))
         (current-dir (file-name-directory xml-name))
         (xsl-name (wuxch-get-xsl-file-name))
         )
    (when xsl-name
      (setq xsl-name (concat current-dir xsl-name))
      (find-file-other-window xsl-name)
      (select-window xml-window)
      )
    )
  )

(defun xsl-wiki-process ()
  "xsl-wiki-process:"
  (interactive)
  (do-xsl-process "txt" "output.wiki")
  )

(defun xsl-html-process ()
  "xsl-html-process:"
  (interactive)
  (do-xsl-process "html" "output.html")
  )

(defun do-xsl-process (output-format output-name)
  "do-xsl-process:"
  (let* ((xml-window (selected-window))
         (xml-name (buffer-file-name))
         (current-dir (file-name-directory xml-name))
         (xsl-name (wuxch-get-xsl-file-name))
         (output-buffer nil)
         (output-message-buffer-name (concat "*xalan-" output-format "-output*"))
         (cmd nil)
         (buf)
         )
    (when xsl-name
      (setq xsl-name (concat current-dir xsl-name))
      (setq output-name (concat current-dir output-name))
      (setq cmd (wuxch-build-java-xalan-command xml-name xsl-name output-name output-format))
      ;; (message "cmd is :%s" cmd)
      ;; (delete-other-windows)
      (setq buf (get-file-buffer output-name))
      (when buf
        (kill-buffer buf)
        )

      (message "xsl running...:%s" cmd)

      ;; (prefer-coding-system 'utf-8)
      (setq buf (get-buffer output-message-buffer-name))
      (when buf
        (kill-buffer buf)
        )

      (shell-command cmd output-message-buffer-name)

      (find-file-other-window output-name)
      ;; (html-mode)

      (select-window xml-window)
      )
    )
  )

;; (defun para ()
;;   "para:"
;;   (interactive)
;;   (if mark-active
;;       (let ((beg (region-beginning))
;;             (end (region-end)))
;;         (deactivate-mark)
;;         (goto-char beg)
;;         (insert "<p>")
;;         (goto-char (+ end (length "<p>")))
;;         (insert "</p>")
;;         (save-buffer)
;;         (goto-char beg)
;;         (re-search-forward "</p>" nil t)
;;         )
;;     (progn
;;       (beginning-of-line)
;;       (if (re-search-forward "\\(<description>\\|<comment>\\)" nil t)
;;           (progn
;;             (insert "\n<p>")
;;             (if (re-search-forward "\\(</description>\\|</comment>\\)" nil t)
;;                 (let ((pos (point))
;;                       (str (match-string 0)))
;;                   (goto-char (- pos (length str)))
;;                   (insert "</p>\n")
;;                   (save-buffer)
;;                   (re-search-forward "\\(</description>\\|</comment>\\)" nil t)
;;                   )
;;               )
;;             )
;;         )
;;       )
;;     )
;;   (recenter-top-bottom 20)
;;   )

(defun para ()
  "para:"
  (interactive)
  (let ((command-string "run.bat"))
    (shell-command command-string)
    )
  )

(defun wuxch-mark-element (&optional arg allow-extend)
  "wuxch-mark-element:"
  (interactive "P\np")
  (let ((pos (point))
        (end-pos))
    (if (looking-at "<")
        (progn
          (set-mark pos)
          (nxml-forward-element)
          )
      (progn
        (mark-sexp arg allow-extend)
        )
      )
    )
  )

(provide 'wuxch-xml)
