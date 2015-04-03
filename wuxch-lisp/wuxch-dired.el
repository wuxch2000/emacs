;;; wuxch-dired.el

(if (equal 'windows-nt system-type)
    (progn
      (require 'w32-symlinks)
      (require 'w32-browser)
      )
  )

(require 'dired-aux)
(require 'dired+)
;; use '(' key or  ')' key to toogle detail display mode
(require 'dired-details+)
(require 'wdired)
;; (require 'dired-isearch)
(require 'find-dired+)
(require 'cl)

(define-key dired-mode-map "r" 'wuxch-wdired-change-to-wdired-mode)
(define-key wdired-mode-map [return]   'ignore)
(define-key wdired-mode-map [return]   'wuxch-wdired-finish-edit)
(define-key wdired-mode-map [(control g)]    'wuxch-wdired-abort-changes)

;; ���������������ڵ��������ĺ���֮ǰ�ı�����ʽ
(defun wuxch-set-cursor-wdired-mode ()
  (bar-cursor-mode -1)
  ;; (set-cursor-color "red")
  )

(defun wuxch-reset-cursor-wdired-mode ()
  (bar-cursor-mode 1)
  ;; (set-cursor-color "black")
  (wuxch-set-default-theme)
  )


(defun wuxch-wdired-change-to-wdired-mode ()
  ""
  (interactive)
  (wuxch-set-cursor-wdired-mode)
  (wdired-change-to-wdired-mode)
  )

(defun wuxch-wdired-finish-edit ()
  ""
  (interactive)
  (wuxch-reset-cursor-wdired-mode)
  (wdired-finish-edit)
  (wuxch-dired-up-directory)
  (diredp-find-file-reuse-dir-buffer)
  )

(defun wuxch-wdired-abort-changes ()
  ""
  (interactive)
  (wuxch-reset-cursor-wdired-mode)
  (wdired-abort-changes)
  )



;; ������Ŀ¼��ʱ��ʹ��ͬһ��buffer
(toggle-dired-find-file-reuse-dir 1)
;; �� dired ���Եݹ�Ŀ�����ɾ��Ŀ¼
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)
;; ������ʾĿ¼
(setq ls-lisp-dirs-first t)

;; ���¼���������totalcommandһ��
(define-key dired-mode-map [tab] 'wuxch-dired-tab-process)
(define-key dired-mode-map [return] 'wuxch-dired-w32-browser)
(define-key dired-mode-map [backspace] 'wuxch-dired-up-directory)
(define-key dired-mode-map [delete] 'dired-do-delete)
(define-key dired-mode-map [double-down-mouse-1] 'wuxch-diredp-mouse-find-file)
(define-key dired-mode-map (kbd "<C-down-mouse-1>") 'ignore)
(define-key dired-mode-map (kbd "<C-mouse-1>") 'ignore)
(define-key dired-mode-map (kbd "<C-down-mouse-1>") 'diredp-mouse-mark/unmark)
;; ȱʡ��*m��m�����һ�µģ�����mark������ڰ�*m����ӳ�䵽���ļ�mark���
(define-key dired-mode-map "*m" 'ignore)
(define-key dired-mode-map "*m" 'dired-mark-files-regexp)
(define-key dired-mode-map "*n" 'ignore)
(define-key dired-mode-map "*n" 'dired-mark-files-regexp)

;; ���������������⡣
;; (define-key dired-mode-map (kbd "C-s") 'dired-isearch-forward-regexp)
;; (define-key dired-mode-map (kbd "C-r") 'dired-isearch-backward-regexp)

;; ��Ŀ¼���ݸı�֮����Ҫ���¼�������У�after-revert-hook����û����dired���������ã��ɴ��Լ�д��һ��
;; revert��ǿ�Ƽ��ϸ�������б����Ĳ�����
(define-key dired-mode-map "g" 'ignore)
(define-key dired-mode-map "g" 'wuxch-dired-revert-and-goto-marked-file)
;; (define-key dired-mode-map [(control o)] 'ignore)
;; (define-key dired-mode-map [(control o)]    'other-window)

(define-key dired-mode-map [(control end)]    'wuxch-dired-goto-last-line)
(define-key dired-mode-map [(control home)]     'wuxch-dired-goto-first-line)
(define-key dired-mode-map [(control down)]    'wuxch-dired-goto-last-line)
(define-key dired-mode-map [(control up)]     'wuxch-dired-goto-first-line)

(define-key dired-mode-map [(control a)]    'wuxch-mark-all-files-directories)
(define-key dired-mode-map "A"    'wuxch-mark-all-files-directories)
(define-key dired-mode-map "I"  'wuxch-dired-open-info-file)
;; (define-key dired-mode-map "F"  'wuxch-foobar-add-to-list)
;; (define-key dired-mode-map "X"  'wuxch-uncompress-file)

(define-key dired-mode-map "=" 'ignore)
(define-key dired-mode-map "=" 'wuxch-dired-equal-process)

;; same key assignment as totalcommand
(define-key dired-mode-map [(control \1)] 'ignore)
(define-key dired-mode-map [(control \1)] 'wuxch-get-file-name-only-path)
(define-key dired-mode-map [(control \2)] 'ignore)
(define-key dired-mode-map [(control \2)] 'wuxch-get-file-name-without-path)
(define-key dired-mode-map [(control \3)] 'ignore)
(define-key dired-mode-map [(control \3)] 'wuxch-get-file-name-with-path)
(define-key dired-mode-map [(control c)(control \3)] 'wuxch-get-file-name-with-path-with-double-slash)
(define-key dired-mode-map [(control x)(control \3)] 'wuxch-get-file-name-with-path-with-unix-style)
(define-key dired-mode-map [f5] 'wuxch-dired-do-copy)
(define-key dired-mode-map [f6] 'wuxch-dired-do-rename)

(define-key dired-mode-map [f3]  'wuxch-w32-find-dired)
;; (define-key dired-mode-map [(control f3)] 'wuxch-find-grep-dired)
;; wuxch-dired-open-ie
(define-key dired-mode-map [(control c)(i)] 'wuxch-dired-open-ie)

(define-key dired-mode-map [home]    'wuxch-dired-move-beginning-of-line)
(define-key dired-mode-map [end]     'wuxch-dired-move-end-of-line)

(define-key dired-mode-map [(control meta up)]     'wuxch-move-to-up-dir)
(define-key dired-mode-map [(control meta down)]     'wuxch-move-to-down-dir)

(define-key dired-mode-map [(meta o)] 'nil)

(define-key dired-mode-map "l"  'wuxch-bookmark-bmenu-list)

(define-key dired-mode-map "a"  'wuxch-dired-tag)


(define-key dired-mode-map "/"  'wuxch-dired-search)

(defun wuxch-dired-search ()
  (interactive)
  (wuxch-dired-goto-first-line)
  (hl-line-mode t)
  (isearch-forward-regexp)
  (hl-line-mode -1)
  )


(defun double-quote-file-name (file-name)
  "double-quote-file-name:"
  (concat "\"" file-name "\"")
  )


(defun wuxch-dired-open-info-file ()
  ""
  (interactive)
  (info (dired-get-filename))
  )

;; (define-key dired-mode-map (kbd "?") 'dired-get-size)
;; ����ԭ�еĺ�������������ʾ��ǰ�У�ԭ������dired.el��dired+.el����
(fset 'dired-insert-set-properties 'wuxch-dired-insert-set-properties)

(defun wuxch-dired-insert-set-properties (beg end)
  "Make the file names highlight when the mouse is on them."
  )

(defun wuxch-dired-move-beginning-of-line (arg)
  ""
  (interactive "p")
  (move-beginning-of-line arg)
  (dired-move-to-filename))

(defun wuxch-dired-move-end-of-line (arg)
  ""
  (interactive "p")
  (move-end-of-line arg)
  ;; (dired-move-to-filename)
  )

;; ����֮����ù������Ŀ��Ŀ¼�������dired-do-copy�����ٴ�һ����
(defun wuxch-dired-do-copy(&optional arg)
  ""
  (interactive "P")
  (dired-do-copy arg)
  (if (not (one-window-p))
      (other-window 1))
  (wuxch-dired-revert)
  ;; (wuxch-dired-revert-and-goto-marked-file)
  ;;   (dired-previous-line 1)
  )

;; �ƶ�֮����ù������Ŀ��Ŀ¼�������dired-do-copy�����ٴ�һ����
(defun wuxch-dired-do-rename(&optional arg)
  ""
  (interactive "P")
  (dired-do-rename arg)
  (wuxch-dired-revert)
  (if (not (one-window-p))
      (other-window 1))
  (wuxch-dired-revert)
  ;; (wuxch-dired-revert-and-goto-marked-file)
  ;; (dired-previous-line 1)
  )

;; ���ϼ�Ŀ¼���Ǵ�һ���µ�buffer���������buffer��������
(defun wuxch-dired-up-directory ()
  "Dired to up directory, reuse the current buffer"
  (interactive)
  (let ((temp-previous-buffer)(up-directory-buffer)(should-kill-temp-buffer))
    (setq should-kill-temp-buffer (not (wuxch-other-windows-has-same-buffer)))
    (setq temp-previous-buffer (current-buffer))
    (dired-up-directory nil)
    (setq up-directory-buffer (current-buffer))
    ;; ���ͬʱ�򿪶�����ڣ�������2�����ڵ�buffer����һ������ô�Ͳ��ذ�ԭĿ¼��bufferɾ��
    (if should-kill-temp-buffer
        (kill-buffer temp-previous-buffer))
    (set-buffer up-directory-buffer)
    )
  )

(defun wuxch-other-windows-has-same-buffer ()
  ""
  (if (one-window-p)
      (null '(1))
    (progn
      (let ((other-side-window-buffer (window-buffer (next-window))))
        (if (eq other-side-window-buffer (current-buffer))
            (null '())
          (null '(1))))
      )
    )
  )

(defun wuxch-diredp-mouse-find-file (event)
  "Replace dired in its window by this file or directory."
  (interactive "e")
  (let (file)
    (save-excursion
      (set-buffer (window-buffer (posn-window (event-end event))))
      (save-excursion
        (goto-char (posn-point (event-end event)))
        (setq file (dired-get-filename))))
    (if (file-directory-p file)
        (progn
          (diredp-find-file-reuse-dir-buffer))
      (w32-browser (convert-standard-filename file)))))

;; �޸�dired-w32-browser,������Ŀ¼��ʱ�����diredp-find-file-reuse-dir-buffer���������Բ���Ҫ�¿�һ
;; ��buffer��
(defun wuxch-dired-w32-browser ()
  "Run default Windows application associated with current line's file.
If file is a directory, then `dired-find-file' instead.
If no application is associated with file, then `find-file'."
  (interactive)
  (let ((file (dired-get-filename)))
    (if (file-directory-p file)
        (progn
          (if (not (wuxch-other-windows-has-same-buffer))
              (diredp-find-file-reuse-dir-buffer)
            (find-file (dired-get-file-for-visit)))
          )
      (progn
        ;; �����.ĳЩ�ļ�����ôֱ�Ӵ򿪣�����Ҫ����ie��
        (let ((ext (file-name-extension file)))
          (if (or (string= ext "el") (string= ext "c") (string= ext "h") (string= ext "outline"))
              (find-file (dired-get-file-for-visit))
            (w32-browser (convert-standard-filename file))
            )
          )
        )
      )
    )
  )

(defun wuxch-dired-open-ie ()
  "open directory by IE. If cursor is on some sub-directory, open this sub-directory,
else open the current directory.06/11/2007 10:54:28 wuxch"
  (interactive)
  (let ((directory-path (dired-current-directory)))
    ;; �����ǰ���û���κ����ݣ���ֱ��ʹ�õ�ǰ��Ŀ¼
    ;; (if (not directory-path)
    ;;         (setq directory-path (dired-current-directory)))
    ;; �����ǰ�Ĺ����Ŀ¼����ô�򿪴�Ŀ¼��������ļ�����ô�򿪵�ǰĿ¼
    ;; 10/28/2008 09:20:42,��ʹ��Ŀ¼�����Ǵ򿪵�ǰĿ¼�ȽϷ��㣬���ԸĻ�ȥ��
    ;; (if (not (file-directory-p directory-path))
    ;;         (setq directory-path (dired-current-directory)))
    (w32-shell-execute "open" (convert-standard-filename directory-path))
    )
  ;; (message "directory-path is %s" (dired-get-filename nil t))
  )



(defun wuxch-dired-tag()
  "wuxch-dired-tag:"
  (interactive)
  (let* ((files (dired-get-marked-files))
         (number-of-files (safe-length files)))
    (cond
     ;; not mark any one
     ((eq number-of-files 0)
      (let ((file-dir-name (dired-get-filename nil t)))
        (if file-dir-name
            (if (file-directory-p file-dir-name)
                (make-elisp-tag t file-dir-name t)
              (make-elisp-tag nil file-dir-name t)
              )
          )
        )
      )
     ;; have marked some
     (t
      (progn
        (while files
          (let ((file (car files)))
            (if (file-directory-p file)
                (make-elisp-tag t file nil)
              (make-elisp-tag nil file nil)
              )
            )
          (setq files (cdr files))
          )
        )
      )
     )
    )
  )

(defun wuxch-dired-hook ()
  ""
  ;;   (setq hl-line-sticky-flag nil)
  ;;   (hl-line-mode)
  )
(add-hook 'dired-load-hook 'wuxch-dired-hook)

(defun wuxch-dired-mode-hook-fun ()
  ""
  ;; �޸�buffer���ƣ�����ʶ����Ŀ¼
  ;; (let ((new-buffer-name (concat "<" (buffer-name) ">"))(buffer-seq 0))
  ;;     ;; ��Ҫ�ȿ����Ƿ��Ѿ���ͬ����Ŀ¼buffer������еĻ����ں�������������
  ;;     (while  (bufferp (get-buffer new-buffer-name))
  ;;       (setq new-buffer-name (concat "<" (buffer-name) (number-to-string buffer-seq) ">"))
  ;;       (setq buffer-seq (1+ buffer-seq))
  ;;       )
  ;;     (rename-buffer new-buffer-name)
  ;;     )
  (wuxch-dired-set-doc-face)
  (wuxch-dired-set-elisp-face)
  (wuxch-dired-set-exe-face)
  (wuxch-dired-set-avi-face)
  )

(add-hook 'dired-mode-hook 'wuxch-dired-mode-hook-fun)

(defface wuxch-dired-doc-face   '((t (:inherit font-lock-warning-face))) "doc files")
(defface wuxch-dired-elisp-face '((t (:inherit font-lock-keyword-face))) "elisp files")
(defface wuxch-dired-exe-face   '((t (:inherit font-lock-function-name-face))) "exe files")
(defface wuxch-dired-avi-face   '((t (:inherit font-lock-variable-name-face))) "avi files")

(defun wuxch-dired-set-doc-face ()
  "wuxch-dired-set-doc-face:"
  (font-lock-add-keywords
   nil '(("^  .*\\.\\(tex\\|doc\\|docx\\|xls\\|xlsx\\|txt\\|org\\|ppt\\|pptx\\|html\\|css\\|xml\\|xsl\\|xsd\\|sty\\|mod\\|dtd\\)$"
          (".+"
           (dired-move-to-filename)
           nil
           (0 'wuxch-dired-doc-face)))))
  )

(defun wuxch-dired-set-elisp-face ()
  "wuxch-dired-set-elisp-face:"
  (font-lock-add-keywords
   nil '(("^  .*\\.\\(el\\)$"
          (".+"
           (dired-move-to-filename)
           nil
           (0 'wuxch-dired-elisp-face)))))
  )

(defun wuxch-dired-set-exe-face ()
  "wuxch-dired-set-exe-face:"
  (font-lock-add-keywords
   nil '(("^  .*\\.\\(exe\\|EXE\\|bat\\|BAT\\)$"
          (".+"
           (dired-move-to-filename)
           nil
           (0 'wuxch-dired-exe-face)))))
  )

(defun wuxch-dired-set-avi-face ()
  "wuxch-dired-set-avi-face:"
  (font-lock-add-keywords
   nil '(("^  .*\\.\\(pdf\\|PDF\\|chm\\|flv\\|avi\\|AVI\\|mkv\\|rmvb\\|mpeg\\|mpg\\|MPG\\|rm\\|mp4\\|mp3\\|MP3\\|wmv\\|wma\\|m4v\\|mov\\|MOV\\)$"
          (".+"
           (dired-move-to-filename)
           nil
           (0 'wuxch-dired-avi-face)))))
  )

(defun wuxch-dired (dirname &optional switches)
  "�޸Ĵ˺����Ķ��壬Ŀ���ǵ���dired��ʱ��ȱʡĿ¼ʹ�����Լ���Ҫ��Ŀ¼"
  (interactive (wuxch-dired-read-dir-and-switches ""))
  (switch-to-buffer (dired-noselect dirname switches)))

(defvar wuxch-dired-default-directory "C:/Work")
(defun wuxch-dired-read-dir-and-switches (str)
  ;; For use in interactive.
  (reverse (list
            (if current-prefix-arg
                (read-string "Dired listing switches: "
                             dired-listing-switches))
            ;; If a dialog is about to be used, call read-directory-name so
            ;; the dialog code knows we want directories.  Some dialogs can
            ;; only select directories or files when popped up, not both.
            (if (next-read-file-uses-dialog-p)
                (read-directory-name (format "Dired %s(directory): " str)
                                     nil wuxch-dired-default-directory nil)
              (read-file-name (format "Dired %s(directory): " str)
                              nil default-directory nil)))))

(global-set-key [(control x)(d)] 'ignore)
(global-set-key [(control x)(d)] 'wuxch-dired)

;; ��������Ƚ���Ҫ����ͬʱ��2��bufferʱ�����Ƶ�ȱʡ·��������һ��buffer��dired·����ʹ��������Щ��
;; totalcommand
(setq dired-dwim-target t)

(defun do-wuxch-get-file-name (with-full-path only-path)
  ""
  (let ((clipboard))
    (if only-path
        ;; ֻҪ·�����������ļ���
        (progn
          (setq clipboard (convert-standard-filename (dired-current-directory)))
          )
      ;; ��Ҫ�ļ���
      (progn
        (let ((file (dired-get-file-for-visit)))
          (if with-full-path
              (progn
                ;; �����·������ô�����һ��"/"
                (if (file-directory-p file)
                    (setq file (concat file "/")))
                ;; ��Ҫ����·�����ļ���
                (setq clipboard (convert-standard-filename file))
                )
            ;; ������·�����ļ�����������Ŀ¼����
            (progn
              (if (file-directory-p file)
                  (progn
                    (setq clipboard (file-name-nondirectory file))
                    )
                (progn
;;;                 ;; �������ͨ�ļ�������ô����Ҫ��չ��
;;;                 (setq clipboard (file-name-sans-extension (file-name-nondirectory file))))))
                  (setq clipboard (file-name-nondirectory file))
                  )
                )
              )
            )
          )
        )
      )

    (kill-new clipboard)
    (message "copy string \"%s\" to clipboard" clipboard)
    clipboard
    )
  )



;; дһ�����������Ը��Ƶ�ǰ�ļ������ƺ�·���������塣
(defun wuxch-get-file-name-with-path ()
  ""
  (interactive)
  (do-wuxch-get-file-name t nil)
  )

(defun wuxch-get-file-name-with-path-with-unix-style ()
  ""
  (interactive)
  (let ((full-string (do-wuxch-get-file-name t nil))
        (clipboard))
    (setq clipboard (replace-regexp-in-string "\\\\" "/" full-string))
    (kill-new clipboard)
    (message "copy string \"%s\" to clipboard" clipboard)
    )
  )

(defun wuxch-get-file-name-with-path-with-double-slash ()
  ""
  (interactive)
  (let ((full-string (do-wuxch-get-file-name t nil))
        (clipboard))
    (setq clipboard (replace-regexp-in-string "\\\\" "\\\\\\\\" full-string))
    (kill-new clipboard)
    (message "copy string \"%s\" to clipboard" clipboard)
    )
  )


(defun wuxch-get-file-name-without-path ()
  ""
  (interactive)
  (do-wuxch-get-file-name nil nil)
  )

(defun wuxch-get-file-name-only-path ()
  ""
  (interactive)
  (do-wuxch-get-file-name t t)
  )


(defun wuxch-dired-tab-process ()
  ""
  (interactive)
  (let ((buf (current-buffer)))
    (if (one-window-p)
        ;; ���ֻ��һ�����ڣ���һ���µĴ��ڣ����ݺͱ�Ŀ¼��һ��
        (progn
          (split-window-horizontally)
          (other-window 1)
          (set-window-buffer (selected-window) buf))
      ;; �����ֻһ�����ڣ�������һ������
      (other-window 1))
    )
  )

(defun wuxch-dired-equal-process ()
  ""
  (interactive)
  (if (not (one-window-p))
      (let ((buf (current-buffer)))
        ;; ������һ�����ڣ�ͬʱ�趨2�����ڵ�����һ��
        (other-window 1)
        (set-window-buffer (selected-window) buf))))

(define-key dired-mode-map "n" 'ignore)
(define-key dired-mode-map "n" 'wuxch-dired-next-line)
(define-key dired-mode-map [down] 'ignore)
(define-key dired-mode-map [down] 'wuxch-dired-next-line)

;; �������local-variable���÷��ˡ�
;; ��ʹ��global-variable��ע��ʹ��setq-default���ã�һ��make-local-variable֮��Ͳ��ڸı��ˡ�
;; (defvar wuxch-temp-buffer-local-value 0)
;; (defun wuxch-temp-use-local-value ()
;;   ""
;;   (interactive)
;;   (if (local-variable-p 'wuxch-temp-buffer-local-value)
;;       (progn
;;         (message "variable is local, value is %d" wuxch-temp-buffer-local-value))
;;     (progn
;;       (setq-default wuxch-temp-buffer-local-value (+ wuxch-temp-buffer-local-value 1))
;;       (make-local-variable 'wuxch-temp-buffer-local-value)
;;       (message "make variable locally, and set it to %d" wuxch-temp-buffer-local-value))
;;     )
;;   )

(defvar static-wuxch-first-line-of-buffer)
(defun wuxch-get-first-line-of-dired ()
  ""
  (if (local-variable-p 'static-wuxch-first-line-of-buffer)
      (progn
        ;; (message "------%d" static-wuxch-first-line-of-buffer )
        )
    (progn
      (setq-default static-wuxch-first-line-of-buffer (wuxch-get-first-line-of-dired-by-search-double-dot))
      (make-local-variable 'static-wuxch-first-line-of-buffer)
      ;; (message "++++++%d" static-wuxch-first-line-of-buffer)
      )
    )
  static-wuxch-first-line-of-buffer
  )

(defvar static-wuxch-max-line-of-buffer)
(defun update-dired-static-variables ()
  ""
  (if (local-variable-p 'static-wuxch-first-line-of-buffer)
      (kill-local-variable 'static-wuxch-first-line-of-buffer))
  (if (local-variable-p 'static-wuxch-max-line-of-buffer)
      (kill-local-variable 'static-wuxch-max-line-of-buffer))

  (setq-default static-wuxch-first-line-of-buffer (wuxch-get-first-line-of-dired-by-search-double-dot))
  (make-local-variable 'static-wuxch-first-line-of-buffer)
  (setq-default static-wuxch-max-line-of-buffer (wuxch-dired-max-line-by-count))
  (make-local-variable 'static-wuxch-max-line-of-buffer)
  )

(defun wuxch-dired-revert ()
  ""
  (revert-buffer)
  (update-dired-static-variables)
  (goto-line (wuxch-get-first-line-of-dired))
  (dired-move-to-filename)
  )

(defun wuxch-dired-revert-and-goto-marked-file (arg)
  ""
  (interactive "p")
  (wuxch-dired-revert)
  ;; go to marked file if there is any
  (dired-next-marked-file arg)
  )


(defun wuxch-dired-max-line ()
  ""
  (if (local-variable-p 'static-wuxch-max-line-of-buffer)
      (progn
        ;; (message "------%d" static-wuxch-max-line-of-buffer )
        )
    (progn
      (setq-default static-wuxch-max-line-of-buffer (wuxch-dired-max-line-by-count))
      (make-local-variable 'static-wuxch-max-line-of-buffer)
      ;; (message "++++++%d" static-wuxch-max-line-of-buffer)
      )
    )
  (+ static-wuxch-max-line-of-buffer 0)
  )


;; �����������������������ǵ�ÿ�ε��û����Ĳ��ٵ�CPU�����ʹ��������c�ľ�̬������ʽ��
;; ����һ�ξͱ�����ֵ��֮�󲻶ϵ��ظ����ã����Ǹ���Ŀ¼���ݡ�

;; ÿ��dired buffer�������һ�л��һ�����У����������һ�С�
(defconst wuxch-dired-add-addtional-line 1)
(defun wuxch-dired-max-line-by-count ()
  ""
  (+ (count-lines (point-min) (point-max)) wuxch-dired-add-addtional-line))

(defun wuxch-get-first-line-of-dired-by-search-double-dot ()
  ""
  (goto-char (point-min))
  (if (search-forward ".." nil t)
      ;; �ҵ��ˡ���ʱ������ڵĵ�һ�о���..����һ��
      (+ (line-number-at-pos) 1)
    ;; û���ҵ� ..�����Թ�����ڵĵ�һ���ǵڶ���
    (+ (line-number-at-pos) 1)
    )
  )

(defun wuxch-dired-next-line (arg)
  "moving to the next line with wrapping"
  (interactive "p")
  (dired-next-line arg)
  (let ((temp-current-line (line-number-at-pos))
        (temp-max-line (wuxch-dired-max-line)))
    (if (eq temp-current-line temp-max-line)
        (progn
          (goto-line (wuxch-get-first-line-of-dired))
          (dired-move-to-filename)))
    )
  )

(defun wuxch-dired-goto-last-line ()
  "moving to the last line"
  (interactive)
  (goto-line (- (wuxch-dired-max-line) 1))
  (dired-move-to-filename))

(defun wuxch-dired-goto-first-line ()
  "moving to the last line"
  (interactive)
  (goto-line (wuxch-get-first-line-of-dired))
  (dired-move-to-filename))

(define-key dired-mode-map "p" 'ignore)
(define-key dired-mode-map "p" 'wuxch-dired-previous-line)
(define-key dired-mode-map [up] 'ignore)
(define-key dired-mode-map [up] 'wuxch-dired-previous-line)

(defun wuxch-dired-previous-line (arg)
  "moving to the previous line with wrapping"
  (interactive "p")
  (dired-previous-line arg)
  (let ((temp-current-line (line-number-at-pos))
        (temp-max-line (wuxch-dired-max-line))
        (temp-first-line-of-dried (wuxch-get-first-line-of-dired)))
    ;; ��Ϊwuxch-get-first-line-of-dired��������һ�У����������һ�в�����ʱ����Ҫ�Ȼָ���굽��ʼ��λ�á�
    (goto-line temp-current-line)
    (dired-move-to-filename)
    (if (eq temp-current-line (- temp-first-line-of-dried 1))
        (progn
          (goto-line (- temp-max-line 1))
          (dired-move-to-filename)))
    )
  )

(defun wuxch-mark-all-files-directories ()
  "mark all files and directoies"
  (interactive)
  (dired-mark-files-regexp ".*"))

(defun wuxch-move-to-up-dir (&optional arg)
  "move marked files to up directory"
  (interactive "P")
  ;; (wuxch-mark-all-files-directories)
  (let ((up-dir (file-name-directory (directory-file-name (dired-current-directory))))
        (file-list (dired-get-marked-files t arg))
        (file-name-only)
        (old-file-name)
        (new-file-name))
    (while (not (null file-list))
      (setq file-name-only (pop file-list))
      (setq old-file-name (concat (dired-current-directory) file-name-only) )
      (setq new-file-name (concat up-dir file-name-only) )
      ;; (message "old name:%s, new name:%s" old-file-name new-file-name)
      (dired-rename-file old-file-name new-file-name nil)
      )
    )
  (wuxch-dired-up-directory)
  (wuxch-dired-revert)
  )

(defun wuxch-move-to-down-dir (&optional arg)
  "move marked files to down directory"
  (interactive "P")
  ;; (wuxch-mark-all-files-directories)
  (let ((down-dir (dired-get-file-for-visit))
        (file-list (dired-get-marked-files t arg))
        (file-name-only)
        (old-file-name)
        (new-file-name))
    (while (not (null file-list))
      (setq file-name-only (pop file-list))
      (setq old-file-name (concat (dired-current-directory) file-name-only) )
      (setq new-file-name (concat down-dir "/" file-name-only) )
      ;; (message "old name:%s, new name:%s" old-file-name new-file-name)
      (dired-rename-file old-file-name new-file-name nil)
      )
    )
  (wuxch-dired-revert)
  )

(define-key dired-mode-map [(control =)] 'ignore)
(define-key dired-mode-map [(control =)] 'wuxch-dired-compare-files)
(define-key dired-mode-map [(control c)(=)] 'wuxch-dired-compare-files)


(defun wuxch-compare-two-directories-of-current-2-windows ()
  (let ((dir1)(dir2))
    (if (or (one-window-p) (wuxch-other-windows-has-same-buffer))
        (message "please split windows or set diffenent directory in tow windows")
      (progn
        (setq dir1 (dired-current-directory))
        (other-window 1)
        (setq dir2 (dired-current-directory))
        (other-window 1)
        (ediff-directories dir1 dir2 nil)
        )
      )
    )
  )

(defun wuxch-dired-compare-2 (a b)
  (cond
   ( ;; both are directories
    (and (file-directory-p a)(file-directory-p b))
    (ediff-directories a b))
   ( ;; both are files
    (and (not (file-directory-p a))(not (file-directory-p b)))
    (ediff-files a b))
   (t
    (message "can not compare because 2 marked things have different type" ))
   )
  )

(defun wuxch-dired-compare-3 (a b c)
  (cond
   ( ;; both are directories
    (and (file-directory-p a)(file-directory-p b)(file-directory-p c))
    (ediff-directories3 a b))
   ( ;; both are files
    (and (not (file-directory-p a))(not (file-directory-p b))(not (file-directory-p c)))
    (ediff-files a b))
   (t
    (message "can not compare because 3 marked things have different type" ))
   )
  )

(defun wuxch-dired-compare-files ()
  "wuxch-dired-compare-files:"
  (interactive)
  (let* ((files (dired-get-marked-files))
         (number-of-files (safe-length files)))
    (cond
     ((eq number-of-files 2)
      (wuxch-dired-compare-2 (nth 0 files) (nth 1 files))
      )
     ((eq number-of-files 3)
      (wuxch-dired-compare-3 (nth 0 files) (nth 1 files) (nth 2 files))
      )
     (t
      (wuxch-compare-two-directories-of-current-2-windows))
     )
    )
  )


;; (defun wuxch-compare-two-directories ()
;;   "compare tow directories by Araxis Merge"
;;   (interactive)
;;   (let ((quoto-string "\"")(compare-command)(dir1)(dir2))
;;     (if (or (one-window-p) (wuxch-other-windows-has-same-buffer))
;;         (message "please split windows or set diffenent directory in tow windows")
;;       (progn
;;         ;; (setq dir1 (concat quoto-string (dired-replace-in-string "/" "\\" (dired-current-directory)) quoto-string))
;;         (setq dir1 (wuxch-quoto-string (dired-replace-in-string "/" "\\" (dired-current-directory))))
;;         (other-window 1)
;;         ;; (setq dir2 (concat quoto-string (dired-replace-in-string "/" "\\" (dired-current-directory)) quoto-string))
;;         (setq dir1 (wuxch-quoto-string (dired-replace-in-string "/" "\\" (dired-current-directory))))
;;         (other-window 1)
;;         (message "dir1:%s" dir1)
;;         (setq compare-command (concat merge-exec-string dir1 " " dir2 " &"))
;;         (message "command is:%s" compare-command)
;;         ;; (shell-command compare-command)
;;         (wuxch-shell-command-background compare-command)
;;         )
;;       )
;;     )
;;   )

(defun wuxch-quoto-string (arg-string)
  "��arg-string������ţ���Ҫ����һЩĿ¼���пո�"
  (let ((quoto-string "\""))
    (concat quoto-string arg-string quoto-string)
    )
  )

(defun netdir()
  (interactive)
  (require 'widget)
  (let* ((drvL))
    (with-temp-buffer
      (let ((out (shell-command "net use" (current-buffer))))
        (if (eq out 0)
            (while (re-search-forward "[A-Z]: +\\\\\\\\[^ ]+" nil t nil)
              (setq drvL (cons (split-string (match-string 0)) drvL)))
          (error "Unable to issue the NET USE command"))))
    (pop-to-buffer "*NET DIR LIST*")
    (erase-buffer)
    (widget-minor-mode 1)
    (mapcar
     (lambda (x)
       (lexical-let ((x x))
         (widget-create 'push-button
                        :notify (lambda (widget &rest ignore)
                                  (kill-buffer (current-buffer))
                                  (dired (car x)))
                        (concat (car x) "  " (cadr x))))
       (widget-insert "\n")
       (goto-char (point-min))
       )
     (reverse drvL))))

(defun wuxch-w32-find-dired (pattern)
  "Use cmd.exe's `dir' command to find files recursively, and go
into Dired mode on a buffer of the output. The command run (after
changing into DIR) is

    dir /s /b DIR\\PATTERN

   --wuxch: change pattern, add *, such as *pattern*
"

  (interactive (list (read-string "Search for: " w32-find-dired-pattern
                                  '(w32-find-dired-pattern-history . 1))))
  (let ((dir (dired-current-directory))
        (dired-buffers dired-buffers)(pattern_around_star (concat "*" pattern "*")))

    ;; Expand DIR ("" means default-directory)
    (setq dir (abbreviate-file-name
               (file-name-as-directory (expand-file-name dir))))
    ;; Check that it's really a directory.
    (or (file-directory-p dir)
        (error "w32-find-dired needs a directory: %s" dir))

    (switch-to-buffer (get-buffer-create "*w32-find-dired*"))

    ;; See if there's still a process running, and offer to kill it
    ;; first, if it is.
    (let ((find (get-buffer-process (current-buffer))))
      (when find
        (if (or (not (eq (process-status find) 'run))
                (yes-or-no-p "A `for' process is running; kill it? "))
            (condition-case nil
                (progn
                  (interrupt-process find)
                  (sit-for 1)
                  (delete-process find))
              (error nil))
          (error "Cannot have two processes in `%s' at once" (buffer-name)))))
    (widen)
    (kill-all-local-variables)
    (setq buffer-read-only nil)
    (erase-buffer)
    (setq default-directory dir
          w32-find-dired-pattern pattern) ; save for next interactive
                                        ; call
    ;; The next statement will bomb in classic dired (no optional arg
    ;; allowed)
    (dired-mode dir (cdr find-ls-option))
    ;; This really should rerun the find command, but I don't
    ;; have time for that.
    (use-local-map (append (make-sparse-keymap) (current-local-map)))
    (define-key (current-local-map) "g" 'undefined)
    ;; Set subdir-alist so that Tree Dired will work:
    (if (fboundp 'dired-simple-subdir-alist)
        ;; will work even with nested dired format (dired-nstd.el,v
        ;; 1.15 and later)
        (dired-simple-subdir-alist)
      ;; else we have an ancient tree dired (or classic dired, where
      ;; this does no harm)
      (set (make-local-variable 'dired-subdir-alist)
           (list (cons default-directory (point-min-marker)))))
    (setq buffer-read-only nil)
    ;; Subdir headlerline must come first because the first marker in
    ;; subdir-alist points there.
    (insert "  " dir ":\n")
    ;; Make second line a ``dir'' line in analogy to the ``total'' or
    ;; ``wildcard'' line.
    (insert "  " pattern_around_star "\n")
    ;; Start the dir process.
    (let ((proc (start-process
                 "dir"
                 (current-buffer)
                 "cmd"
                 "/c" "dir" "/b" "/s"
                 (concat (substitute ?\\ ?/ dir) pattern_around_star))))
      (set-process-filter proc (function w32-find-dired-filter))
      (set-process-sentinel proc (function w32-find-dired-sentinel))
      ;; Initialize the process marker; it is used by the filter.
      (move-marker (process-mark proc) 1 (current-buffer))
      )
    (setq mode-line-process '(":%s"))
    )

  )

(define-key dired-mode-map [(control c)(+)] 'ignore)
(define-key dired-mode-map [(control c)(+)] 'wuxch-dired-create-directory)
(defun wuxch-dired-create-directory (directory)
  "Create a directory called DIRECTORY, with current date as suffix"
  (interactive
   (list (read-file-name "Create directory(with Date as suffix)): " (dired-current-directory))))
  (let ((expanded (directory-file-name
                   (expand-file-name
                    (concat directory (format-time-string "%Y%m%d"))))))
    (make-directory expanded)
    (dired-add-file expanded)
    (dired-move-to-filename)
    )
  )

(define-key dired-mode-map [(control c)(f)] 'ignore)
(define-key dired-mode-map [(control c)(f)] 'wuxch-dired-open-file-other-window)
(defun wuxch-dired-open-file-other-window ()
  "wuxch-dired-open-file-other-window:"
  (interactive)
  (split-window-vertically-and-goto)
  (diredp-find-file-reuse-dir-buffer)
  )

(provide 'wuxch-dired)
