(require 'smart-compile)
(require 'cc-mode)

(custom-set-variables
 '(compile-command "make -r -s")
 '(compilation-scroll-output t)
 '(compilation-read-command nil)
 '(compilation-auto-jump-to-first-error t)
 )

(defun compile-custom ()
  "custom-compile-command:"
  (interactive)
  (let* ((new-command nil)
         (file-name-with-dir (buffer-file-name))
         (file-name (file-name-nondirectory file-name-with-dir))
         (file-ext (file-name-extension file-name))
         (file-no-ext (file-name-sans-extension file-name))
         )
    (cond
     ((string= file-ext "cpp")
      (setq new-command (concat "g++ -g -Wall -enable-auto-import "
                                file-name " -o " file-no-ext ".exe"))
      )
     ((string= file-ext "c")
      (setq new-command (concat "gcc -g -Wall "
                                file-name " -o " file-no-ext ".exe"))
      )
     )
    (when new-command
      (let ((input))
        (setq input
              (read-from-minibuffer "enter compile command:" new-command))
        (set (make-local-variable 'compile-command) input)
        (minibuffer-message "compile command set to \"%s\"" input)
        )
      )
    )
  )

(add-hook 'compilation-mode-hook 'wuxch-compilation-mode-hook)

(defun wuxch-compilation-mode-hook ()
  (local-set-key " " 'wuxch-compilation-view-error-code)
  )

(defun wuxch-compilation-view-error-code ()
  "wuxch-compilation-view-error-code:"
  (interactive)
  (let ((cur (selected-window)))
    (compile-goto-error)
    (select-window cur)
    )
  )

(defun wuxch-compile-command (arg)
  "wuxch-compile-command:"
  (compile arg t)
  )


(defun lint-adjust-path-and-mode ()
  ""
  (interactive)
  ;;   (if flyspell-mode
  ;;       (flyspell-mode-off))
  (goto-char (point-min))
  (while (re-search-forward "E:\\\\CCwork" nil t)
    (replace-match "Z:"))
  (compilation-mode)
  (goto-char (point-min))
  )


;; Visual C++ 编译命令
;; (setq compile-command "nmake /S /C /NOLOGO /f ")


;; 重新编译某个目录下的所有脚本文件，需要的时候取消注释，eval-buffer一下即可


;; lint命令
;; (require 'compile)
;; (require 'pc-lint)

;; (autoload 'hide-lines "hide-lines" "Hide lines based on a regexp" t)
(require 'hide-lines)
(defun my-hide-line ()
  ""
  (interactive)
  ;; error 734: (Info -- Loss of precision
  ;; 3034个
  (hide-matching-lines "error 734")
  ;; error 715: (Info -- Symbol 'pDat' (line 1608) not referenced)
  ;; 1654个
  (hide-matching-lines "error 715")
  ;; error 785: (Info -- Too few initializers for aggregate 'tDbAccessForm')
  ;; 68个
  (hide-matching-lines "error 785")
  ;; error 762: (Info -- Redundantly declared symbol 'S_JudgeBrdProcIsRun(unsigned short)' previously declared at line 963, file Z:\SS1_v2.01.50.1\releaseSS_50\V2.01.50\support\sysctrl\include\sysctrl.h)
  ;; 126
  (hide-matching-lines "error 762")

  )


;; (defvar my-lint-directory  "d:/work/code/zxss10-ss3/SS/protocol/PSIP/lint")
;; (global-set-key [(f5)]  'lint-all)
;; (defun lint-all ()
;;   "lint all source file, use make"
;;   (interactive)
;;   (setq default-directory my-lint-directory)
;;   (cd my-lint-directory)
;;   (wuxch-compile-command (format "make.exe lint -s"))
;;   )

;;(global-set-key [(f6)]  'lint-single)
;; (defun lint-single ()
;;   "lint single source file, use make"
;;   (interactive)
;;   (setq default-directory my-lint-directory)
;;   (cd my-lint-directory)
;;   (wuxch-compile-command (format "make.exe single file=%s -s" buffer-file-name))
;;   )

;;(setq my-vc-project-name "graph1")

;; (global-set-key [(f7)] 'smart-compile)
;; (global-set-key [(f7)] 'vc-make)
;; (defun vc-make ()
;;   "compile vc project by nmake"
;;   (interactive)
;;   (setq my-vc-code-directory "d:/work/code/graph1")
;;   (setq default-directory my-vc-code-directory)
;;   (cd my-vc-code-directory)
;;   (wuxch-compile-command (format "nmake /S /C /NOLOGO /f %s.mak CFG=\"%s - Win32 Debug\"" my-vc-project-name my-vc-project-name))
;;   )

;; 重新编译某个目录下的所有脚本文件，需要的时候取消注释，eval-buffer一下即可


;; lint命令
;; (require 'compile)
;; (require 'pc-lint)

;; (autoload 'hide-lines "hide-lines" "Hide lines based on a regexp" t)
;; (require 'hide-lines)
;; (defun my-hide-line ()
;;   ""
;;   (interactive)
;;   ;; error 734: (Info -- Loss of precision
;;   ;; 3034个
;;   (hide-matching-lines "error 734")
;;   ;; error 715: (Info -- Symbol 'pDat' (line 1608) not referenced)
;;   ;; 1654个
;;   (hide-matching-lines "error 715")
;;   ;; error 785: (Info -- Too few initializers for aggregate 'tDbAccessForm')
;;   ;; 68个
;;   (hide-matching-lines "error 785")
;;   ;; error 762: (Info -- Redundantly declared symbol 'S_JudgeBrdProcIsRun(unsigned short)' previously declared at line 963, file Z:\SS1_v2.01.50.1\releaseSS_50\V2.01.50\support\sysctrl\include\sysctrl.h)
;;   ;; 126
;;   (hide-matching-lines "error 762")

;;   )

;Autoscroll the compile buffer
;; 不行把compilation-start 改成compile-internal试试，我的版本现在是用这个
;; (defadvice compilation-start (after my-scroll act comp)
;;   "Forces compile buffer to scroll. See around line 363 in compile.el"
;;   (let* ((ob (current-buffer))
;;          (obw (get-buffer-window ob t))
;;          win
;;          )
;;     (save-excursion
;;       (if (or (null (setq win (get-buffer-window ad-return-value t)))
;;               (null obw))
;;           nil
;;         (select-window win)
;;         (goto-char (point-max))
;;         (select-window obw)
;;         ))))

(defun wuxch-compile-make-rm ()
  "wuxch-compile-make-pdf:"
  (interactive)
  (wuxch-compile-command "make rm -r -s")
  )

(defun wuxch-compile-make-re ()
  "wuxch-compile-make-re:"
  (interactive)
  (wuxch-compile-command "make re -r -s")
  )

(defun wuxch-compile-make-arg (arg)
  "wuxch-compile-make-re:"
  (wuxch-compile-command (concat "make -r -s " arg))
  )


(provide 'wuxch-make-lint)
