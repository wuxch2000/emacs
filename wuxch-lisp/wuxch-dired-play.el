;;; wuxch-dired-play.el

(define-key dired-mode-map [(\ )]  'ignore)
(define-key dired-mode-map [(\ )]  'wuxch-dired-play)

(define-key dired-mode-map [(control c)(\ )]  'ignore)
(define-key dired-mode-map [(control c)(\ )]  'wuxch-dired-play-gui)


(defun wuxch-do-dired-get-subtitle ()
  "wuxch-do-dired-get-subtitle:"
  (let ((subtitle-ext "srt")
        (subtitle-files)
        (single-subtitle-file)
        (subtitle-string "")
        (is-first-subtitle t)
        (comma-string)
        )
    (dired-unmark-all-marks)
    (when (diredp-mark/unmark-extension subtitle-ext nil)
      (setq subtitle-files (dired-get-marked-files t))
      (if (listp subtitle-files)
          (progn
            (setq subtitle-string " -sub ")
            (dolist (element subtitle-files)

              (setq single-subtitle-file
                    (double-quote-file-name
                     (convert-standard-filename
                      (concat (dired-current-directory) element)))
                    )

              (if is-first-subtitle
                  (progn
                    (setq comma-string "")
                    (setq is-first-subtitle nil))
                (progn
                  (setq comma-string ",")
                  )
                )
              (setq subtitle-string (concat subtitle-string comma-string single-subtitle-file))
              )
            )
        )
      (dired-unmark-all-marks)
      )
    subtitle-string
    )
  )

(defun wuxch-dired-file-is-video-file (file-name)
  "wuxch-dired-file-is-video-file:"
  (if (file-directory-p file-name)
      nil
    (let ((ext (downcase (file-name-extension file-name))))
      (or (string= ext "avi")(string= ext "mkv")(string= ext "m4v")
          (string= ext "mp4")(string= ext "mpg")(string= ext "mpeg")
          (string= ext "rmvb")(string= ext "wmv")(string= ext "mp3")
          (string= ext "flv")(string= ext "wma")(string= ext "wmv")
          (string= ext "mov")
          )
      )
    )
  )

(defun wuxch-dired-file-is-srt-file (file-name)
  "wuxch-dired-file-is-video-file:"
  (if (file-directory-p file-name)
      nil
    (let ((ext (file-name-extension file-name)))
      (or (string= ext "srt")
          )
      )
    )
  )

(defun wuxch-dired-file-is-audio-file (file-name)
  "wuxch-dired-file-is-video-file:"
  (if (file-directory-p file-name)
      nil
    (let ((ext (file-name-extension file-name)))
      (or (string= ext "mp3")
          )
      )
    )
  )

;; file is f:/AUDIO_TS
;; file is f:/VIDEO_TS

(defun wuxch-dired-file-is-dvd-file (file-name)
  "wuxch-dired-file-is-dvd-file:
result-str = nil : the file-name is not a dvd directroy.
result-str = not nil : the file-name is a dvd directory. and result-str is the driver str. for example: f:/
"
  (let* ((replace-str nil)
         (result-str nil)
         )
    (setq replace-str (replace-regexp-in-string "\\(.*:/\\)\\(AUDIO_TS\\|VIDEO_TS\\)" "\\1" file-name))
    (if (string= replace-str file-name)
        (setq result-str nil)
      (setq result-str replace-str)
      )
    result-str
    )
  )


(defun wuxch-do-dired-standard-file-name (file-name)
  (double-quote-file-name
   (convert-standard-filename
    (concat (dired-current-directory) file-name)))
  )

(defun wuxch-do-dired-play-mark (marked-files)
  "wuxch-do-dired-play:"
  (let ((play-command)
        (player "mplayer.exe")
        (movie-file nil)
        (srt-file nil)
        )

    (message "marked files:%s" marked-files)

    (dolist (element marked-files)
      (cond
       ((wuxch-dired-file-is-video-file element)
        (setq movie-file
              (concat movie-file " "
                      (wuxch-do-dired-standard-file-name element)))
        )
       ((wuxch-dired-file-is-srt-file element)
        (setq srt-file
              (concat srt-file " -sub "
                      (wuxch-do-dired-standard-file-name element)))

        )
       )
      )

    (setq play-command (concat player " " movie-file srt-file " &"))

    (wuxch-do-dired-play-exec-command play-command)
    )
  )

(defun wuxch-do-dired-play-exec-command (play-command)
  "wuxch-do-dired-play-exec-command:"
  (interactive)
  (let* (;; chinese support config
         (coding-system-for-read (coding-system-from-name "chinese-gbk-dos"))
         (coding-system-for-write (coding-system-from-name "chinese-gbk-dos"))
         (coding-system-require-warning t)
         )

    (if play-command
        (progn
          (message "command is :%s" play-command)
          (shell-command play-command)
          )
      (progn
        (message "%s can not be played by mplayer." (file-name-nondirectory movie-file))
        )

      )
    )
  )

(defun wuxch-do-dired-play-unmark ()
  "wuxch-do-dired-play:"
  (let* ((play-command)
         (player "mplayer")
         (movie-file (dired-get-file-for-visit))
         (ext (file-name-extension movie-file))
         )

    (cond
     ((wuxch-dired-file-is-video-file movie-file)
      (progn
        (setq movie-file (double-quote-file-name (convert-standard-filename movie-file)))
        (setq play-command (concat player " " movie-file (wuxch-do-dired-get-subtitle) " &"))
        ))

     ((wuxch-dired-file-is-audio-file movie-file)
      (progn
        (setq movie-file (double-quote-file-name (convert-standard-filename movie-file)))
        (setq play-command (concat "cmd " player " " movie-file ""))
        ))
     ((wuxch-dired-file-is-dvd-file movie-file)
      (progn
        (setq play-command (concat player " dvd://2 -dvd-device "
                                   (wuxch-dired-file-is-dvd-file
                                    movie-file) "")) ))
     (t
      (setq play-command nil)
      )
     )

    (wuxch-do-dired-play-exec-command play-command)
    )
  )

(defun wuxch-dired-play ()
  "wuxch-dired-play:"
  (interactive)
  (let ((marked-files (dired-get-marked-files t)))
    (if (listp marked-files)
        (wuxch-do-dired-play-mark marked-files)
      (wuxch-do-dired-play-unmark))
    )

  )



(provide 'wuxch-dired-play)
