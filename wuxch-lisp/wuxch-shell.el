;;; codes for shell command
(defalias 'cmd 'shell)


(setq sh-shell-file '"/bin/bash")

;; shell�������
(defun my-comint-init ()
  (setq comint-process-echoes t))

(add-hook 'comint-mode-hook 'my-comint-init)

(defun wuxch-shell-command-background (arg-shell-command)
  ""
  ;; ���� & ��ʾ�첽ִ��
  (shell-command (concat arg-shell-command " &"))
  ;; �������"*Async Shell Command*"����̨
  (delete-windows-on "*Async Shell Command*")
  )

(setq eshell-cmpl-cycle-completions nil)

;; (defun linux ()
;;   "linux:"
;;   (interactive)
;;   (wuxch-shell-command-background "C:\\\"Program Files\"\\putty\\putty.exe -load wuxch-linux")
;;   )

;; (defun mstsc ()
;;   "linux:"
;;   (interactive)
;;   (wuxch-shell-command-background "mstsc.exe d:\\work\\Default.rdp")
;;   )

(global-set-key [(control c)(i)] 'wuxch-open-ie)
(defun wuxch-open-ie ()
  "open directory by IE."
  (interactive)
  (let ((file-name (buffer-file-name)))
    ;; (message "file name is %s" file-name)
    ;; (message "directory name is %s" (file-name-directory file-name))
    (w32-shell-execute "open" (file-name-directory file-name))
    )
  )

(global-set-key [(control c)(n)] 'wuxch-dired-open-in-notepad++)
(defun wuxch-dired-open-in-notepad++ ()
  ""
  (interactive)
  (let* ((notepad-exe "\"C:/Program Files/Notepad++/notepad++.exe\" ")
         (notepad-command)
         (current-file)
         ;; chinese support config
         (coding-system-for-read (coding-system-from-name "chinese-gbk-dos"))
         (coding-system-for-write (coding-system-from-name "chinese-gbk-dos"))
         (coding-system-require-warning t)
         (lines)
         )
    (message "notepad-exe:%s" notepad-exe)
    (message "major mode is %s" major-mode)
    (if (string= major-mode "dired-mode")
        (progn
          (setq current-file (dired-get-file-for-visit))
          (unless (file-directory-p current-file)
            (setq notepad-command (concat notepad-exe "\"" current-file "\""))
            )
          )
      (progn
        (setq current-file (buffer-file-name))
        (setq lines (+ (count-lines (point-min) (point)) 1))
        (setq notepad-command (concat notepad-exe "-n" (number-to-string lines) " \"" current-file "\""))
        )
      )
    (message "command is :%s" notepad-command)
    (wuxch-shell-command-background notepad-command)
    )
  )


(provide 'wuxch-shell)
