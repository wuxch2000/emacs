(add-to-list 'load-path (concat emacs-site-lisp-dir "emacs-w3m"))


(require 'w3m)

(setq w3m-profile-directory "~/w3m")

(setq w3m-default-save-directory "~/w3m")

(setq w3m-command-arguments
      (nconc w3m-command-arguments
             '("-o" "http_proxy=proxynj.zte.com.cn")))

(setq w3m-command "w3m.exe")

(setq w3m-use-mule-ucs t)
(setq w3m-use-toolbar t)
(setq w3m-use-cookies t)
(setq w3m-display-inline-image t)
(setq w3m-bookmark-file-coding-system 'chinese-iso-8bit)
(setq w3m-coding-system 'chinese-iso-8bit)
(setq w3m-default-coding-system 'chinese-iso-8bit)
(setq w3m-file-coding-system 'chinese-iso-8bit)
(setq w3m-file-name-coding-system 'chinese-iso-8bit)
(setq w3m-terminal-coding-system 'chinese-iso-8bit)
(setq w3m-input-coding-system 'chinese-iso-8bit)
(setq w3m-output-coding-system 'chinese-iso-8bit)
(setq w3m-tab-width 4)
;(setq w3m-home-page "file://home/homepage/index.html")
(setq w3m-view-this-url-new-session-in-background t)
;(require 'mime-w3m)  ;; 这个东西我没整好 :(
;; (add-hook 'w3m-fontify-after-hook 'remove-w3m-output-garbages)
(defun remove-w3m-output-garbages ()
  (interactive)
  (let ((buffer-read-only))
    ;; (setf point (point-min))
    (goto-char (point-min))
    (while (re-search-forward "[\200-\240]" nil t)
      (replace-match " "))
    (set-buffer-multibyte t))
  (set-buffer-modified-p nil))

(setq w3m-no-proxy-domains '("zte.com.cn" "10.*.*.*"))

(defun wuxch-w3m-mode-hook ()
  (define-key w3m-mode-map [down] 'ignore)
  (define-key w3m-mode-map [down] 'next-line)
  )

(add-hook 'w3m-mode-hook 'wuxch-w3m-mode-hook)

(defun w3m-browse-current-buffer ()
  (interactive)
  (let ((filename (concat (make-temp-file "w3m-") ".html")))
    (unwind-protect
        (progn
          (write-region (point-min) (point-max) filename)
          (w3m-find-file filename))
      (delete-file filename))))

(define-key dired-mode-map "W"  'wuxch-w3m-browse-current-file)
(defun wuxch-w3m-browse-current-file ()
  (interactive)
  (w3m-find-file (dired-get-filename))
  )



(provide 'wuxch-w3m)
