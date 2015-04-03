;;;
(require 'ange-ftp)

;; (setq tramp-default-method "ftp")

(custom-set-variables
 '(ange-ftp-ftp-program-name "gftp.exe")
 )

;; 需要在~/.netrc文件中添加
;; machine 10.44.19.240 login guest password zxss
;; machine 10.30.1.158 login down password down@zte
;; machine 10.44.106.211 login public password music
;; machine 10.16.28.252#1127 login anonymous password anonymous
;; machine 10.30.1.168 login anonymous password anonymous
;; machine 10.40.17.1#1000 login anonymous password anonymous

;; C-x d
;; /ftp:10.44.19.240:

;; (defun wuxch-dired-mode-hook-fun-ftp ()
;;   (if (wuxch-buffer-is-ftp-directory)
;;       (progn
;;         ;; (rename-buffer (concat "ftp:" (buffer-name)))
;;         ;; (change-ftp-coding-system)
;;         (local-set-key "g" 'update-ftp-dired-buffer)
;;         ;; 不能使用wuxch-dired-open-ie
;; ;;;         (local-set-key [(control x)(i)] 'ignore)
;; ;;;         (local-set-key [(control x)(i)] 'wuxch-ftp-dired-open-ie)
;;         ;; (message "Press \"F\" to change coding system")
;;         ;; (add-hook 'kill-buffer-hook 'wuxch-ftp-buffer-kill-hook)
;;         (local-set-key [(control x)(k)] 'ignore)
;;         (local-set-key [(control x)(k)] 'wuxch-kill-ftp-buffer-and-delete-corresponding)
;;         )
;;     )
;;   )



;; (defun wuxch-kill-ftp-buffer-and-delete-corresponding()
;;   (interactive)
;;   (wuxch-ftp-buffer-kill-hook)
;;   (kill-this-buffer)
;;   )

;; (defun wuxch-ftp-buffer-kill-hook()
;;   "wuxch-ftp-buffer-kill-hook:"
;;   (let ((buf (wuxch-get-ange-ftp-buffer)))
;;     (if (buffer-live-p buf)
;;         (progn
;;           (message "buffer:%s is killed with its coresponding dired buffer" (buffer-name buf))
;;           (kill-buffer buf)
;;           )
;;       )
;;     )
;;   )

;; ;; (add-hook 'dired-mode-hook 'wuxch-dired-mode-hook-fun-ftp)

;; (defun update-ftp-dired-buffer (arg)
;;   "update-ftp-dired-buffer:"
;;   (interactive "p")
;;   (if (wuxch-buffer-is-ftp-directory)
;;       (wuxch-change-ftp-coding-system))
;;   (wuxch-dired-revert-and-goto-marked-file arg)
;;   )

;; (defun wuxch-change-ftp-coding-system ()
;;   (interactive)
;;   (let ((buf (current-buffer)))
;;     (set-buffer (wuxch-get-ange-ftp-buffer buf))
;;     (set-buffer-process-coding-system 'chinese-gbk-dos 'chinese-gbk-dos)
;;     (set-buffer buf)
;;     (message "change ftp buffer to chinese-gbk-dos OK!")
;;     )
;;   )

;; (defun wuxch-buffer-is-ftp-directory ()
;;   ""
;;   (interactive)
;;   (let ((file-string (or (buffer-file-name (current-buffer))
;;                          (with-current-buffer (current-buffer) default-directory)))
;;         (match-regex "/ftp:\\([0-9\.]+\\):.*"))
;;     (if (eq nil (string-match match-regex file-string))
;;         nil
;;       t
;;       )
;;     )
;;   )

;; (defun wuxch-get-ange-ftp-buffer (&optional buffer)
;;   ""
;;   (if (null buffer)
;;       (setq buffer (current-buffer))
;;     (setq buffer (get-buffer buffer)))
;;   (let ((file (or (buffer-file-name buffer)
;;                   (with-current-buffer buffer default-directory)))
;;         (ange-ftp-buffer))
;;     (if file
;;         (let ((host (wuxch-get-host-from-ftp-file file))
;;               (user))
;;           (setq user (ange-ftp-get-user host))
;;           ;; (message "host is %s, user is %s" host user)
;;           (setq ange-ftp-buffer (get-buffer (ange-ftp-ftp-process-buffer host user)))
;;           ;; (message "ange-ftp-buffer is %s" (buffer-name ange-ftp-buffer))
;;           )
;;       )
;;     )
;;   )

;; (defun wuxch-get-host-from-ftp-file (file-string)
;;   ""
;;   (let (
;;         ;; (file-string "/ftp:10.44.19.240:/version/SSV20_version/")
;;         (match-regex "/ftp:\\([0-9\.]+\\):.*")
;;         )
;;     (if (not (eq nil (string-match match-regex file-string)))
;;         (progn
;;           ;; (message "matched, the data is %s" (substring file-string (match-beginning 1) (match-end 1)))
;;           (substring file-string (match-beginning 1) (match-end 1))
;;           )
;;       nil
;;       )
;;     )
;;   )


(provide 'wuxch-ftp)
