;;; I think maybe I need a simple wiki mode ,just for simple editing without publish or online editing fuction.

;; outline mode is a good start.

(defvar simple-wiki-font-lock-keywords
  (list
         '("#.*" . font-lock-comment-face)
         ))

(define-derived-mode simple-wiki-mode outline-mode "simple-wiki"
  "Major mode for wiki editing"
  (setq comment-start "#")
  (setq comment-start-skip "#\\W*")

  (font-lock-add-keywords 'simple-wiki-mode
                          '(
                            ("^#.*" . font-lock-comment-face)
                            ("==.*==" . font-lock-function-name-face)
                            ("===.*===" . font-lock-variable-name-face)
                            ("\\[\\[.*\\]\\]" . font-lock-constant-face)
                            ))
  (font-lock-mode)
  )

(add-to-list 'auto-mode-alist '("\\.wiki$" . simple-wiki-mode))

(provide 'wuxch-wiki)

;; (add-to-list 'load-path (concat emacs-site-lisp-dir "emacs-wiki"))

;; (require 'emacs-wiki)

;; (defun wuxch-wiki-hook ()
;;   ""
;;   (define-key emacs-wiki-mode-map (kbd "C-c C-h") 'emacs-wiki-preview-html)
;;   (define-key emacs-wiki-mode-map (kbd "C-c C-c") 'emacs-wiki-preview-source)
;;   (define-key emacs-wiki-mode-map (kbd "C-c C-v") 'emacs-wiki-change-project)

;;   (predictive-mode 1)
;;   (ispell-minor-mode 1)
;;   )

;; (add-hook 'emacs-wiki-mode-hook 'wuxch-wiki-hook)

;; ;; (setq emacs-wiki-grep-command "glimpse -nyi "%W"")

;; (setq emacs-wiki-publishing-directory "publish")

;; (setq emacs-wiki-directories '("~/WiKi"))
;; (setq emacs-wiki-meta-charset "gb2312")
;; (setq emacs-wiki-style-sheet  "")

;; (setq emacs-wiki-inline-relative-to 'emacs-wiki-publishing-directory)

;; (defun emacs-wiki-preview-source ()
;;   (interactive)
;;   (emacs-wiki-publish-this-page)
;;   (find-file (emacs-wiki-published-file)))

;; (defun emacs-wiki-preview-html ()
;;   (interactive)
;;   (emacs-wiki-publish-this-page)
;;   (browse-url (emacs-wiki-published-file)))

;; (setq emacs-wiki-projects
;;       `(("default" . ((emacs-wiki-directories . ("~/WiKi"))))
;;         ("work" . ((fill-column . 65)
;;                    (emacs-wiki-directories . ("~/workwiki/"))))))

