;;;

;; (require 'wget)

;; (custom-set-variables
;;  '(wget-command "wget.exe")
;;  '(wget-default-options '("-r" "--no-proxy"))
;;  ;; '(wget-download-directory "d:/Download/song/download")
;;  )

(defconst local-song-dir "d:/Download/song/download")

(defconst wget-flag "-r -nd --no-proxy")

(defconst wget-exe "wget.exe")

(defun mp3-string (url)
  "mp3-download:"
  (interactive "sUrl:")
  (let ((cmd url))
    ;; (message "command is %s" cmd)
    ;; (prefer-coding-system 'utf-8)
    ;; (cd local-song-dir)
    ;; (shell-command cmd)
    (setq cmd (string-remove-newline-char cmd))
    (setq cmd (string-add-slash-before-char cmd "["))
    (setq cmd (string-add-slash-before-char cmd "]"))
    (setq cmd (build-wget-command cmd))
    (kill-new cmd)
    (message "dos command is saved in clipboard")
    )
  )

(defun build-wget-command (url)
  "build-wget-command:"
  (concat wget-exe " " wget-flag " " (string-wrap-double-quote url))
  )

(defun string-wrap-double-quote (str)
  "string-wrap-double-quote:"
  (concat "\"" str "\"")
  )

(defun string-remove-newline-char (str)
  (let ((str-len (length str))
        (ch nil)
        (str-out nil))
    (dotimes (i str-len)
      (setq ch (substring str i (+ 1 i)))
      (if (not (string= ch "\n"))
          (setq str-out (concat str-out ch))
        )
      )
    str-out
    )
  )

(defun string-add-slash-before-char (str special-ch)
  "string-add-slash-before-space:"
  (let ((str-len (length str))
        (ch nil)
        (str-out nil))
    (dotimes (i str-len)
      (setq ch (substring str i (+ 1 i)))
      (if (string= ch special-ch)
          (setq str-out (concat str-out "\\" ch))
        (setq str-out (concat str-out ch))
        )
      )
    str-out
    )
  )



(provide 'wuxch-wget)
