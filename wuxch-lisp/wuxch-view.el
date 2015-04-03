;;;(define-key view-mode-map "." 'pager-page-down) view-mode enhancement for view-mode.

(global-set-key [(control x)(v)] (lambda ()
                                   (interactive)
                                   (view-mode t)
                                   ;; (wuxch-view-setup-theme)
                                   ))

(defun wuxch-view-mode-hook()
  "wuxch-view-mode-hook:"

  (when (buffer-file-name)
    (wuxch-view-setup-theme)

    (define-key view-mode-map "n" 'next-line)
    (define-key view-mode-map "p" 'previous-line)
    (define-key view-mode-map "/" 'isearch-forward)
    (define-key view-mode-map "f" 'forward-char)
    (define-key view-mode-map "b" 'backward-char)
    (define-key view-mode-map "q" 'wuxch-view-mode-exit)
    (define-key view-mode-map "." (lookup-key global-map [next]))
    (define-key view-mode-map "," (lookup-key global-map [prior]))
    )
  )

(add-hook 'view-mode-hook 'wuxch-view-mode-hook)

(defun wuxch-view-setup-theme ()
  (set-face-foreground 'modeline "red")
  (bar-cursor-mode -1)
  (set-cursor-color "red")
  )

(defun wuxch-view-restore-theme ()
  (set-face-foreground 'modeline "black")
  (bar-cursor-mode 1)
  (set-cursor-color "green")
  )

(defun wuxch-view-mode-exit ()
  (interactive)
  (View-exit-and-edit)
  (wuxch-view-restore-theme)
  )


;; (defun change-mode-line-color ()
;;   (interactive)
;;   (when (get-buffer-window (current-buffer))
;;     (cond (window-system
;;            (cond (view-mode
;;                   ;; (set-face-background 'modeline "black")
;;                   (set-face-foreground 'modeline "red")
;;                   (bar-cursor-mode nil)
;;                   (set-cursor-color "red")
;;                   )
;;                  (t
;;                   ;; (set-face-background 'modeline "black")
;;                   (set-face-foreground 'modeline "black")
;;                   (bar-cursor-mode t)
;;                   (set-cursor-color "green")
;;                   )
;;                  )
;;            )
;;           (t
;;            (set-face-background 'modeline
;;                                 (if view-mode "red"
;;                                   "white"))))))
;; (defmacro change-mode-line-color-advice (f)
;;   `(defadvice ,f (after change-mode-line-color activate)
;;      (change-mode-line-color)
;;      (force-mode-line-update)))
;; (progn
;;   (change-mode-line-color-advice set-window-configuration)
;;   (change-mode-line-color-advice switch-to-buffer)
;;   (change-mode-line-color-advice pop-to-buffer)
;;   (change-mode-line-color-advice other-window)
;;   (change-mode-line-color-advice toggle-read-only)
;;   (change-mode-line-color-advice vc-toggle-read-only)
;;   (change-mode-line-color-advice vc-next-action)
;;   (change-mode-line-color-advice view-mode-enable)
;;   (change-mode-line-color-advice view-mode-disable)
;;   (change-mode-line-color-advice bury-buffer)
;;   (change-mode-line-color-advice kill-buffer)
;;   (change-mode-line-color-advice delete-window)
;;   ;; for windows.el
;;   (change-mode-line-color-advice win-switch-to-window)
;;   (change-mode-line-color-advice win-toggle-window)
;;   )

(provide 'wuxch-view)
