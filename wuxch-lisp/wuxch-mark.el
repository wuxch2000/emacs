;; (require 'visible-mark)

;; (when (require 'auto-mark nil t)
;;   (setq auto-mark-command-class-alist
;;         '((anything . anything)
;;           (goto-line . jump)
;;           (indent-for-tab-command . ignore)
;;           (undo . ignore)))
;;   (setq auto-mark-command-classifiers
;;         (list (lambda (command)
;;                 (if (and (eq command 'self-insert-command)
;;                          (eq last-command-char ? ))
;;                     'ignore))))
;;   (global-auto-mark-mode 1))

;; (custom-set-variables
;;  '(visible-mark-max 5)
;;  )

;; (defvar buffer-is-visible-mark-mode nil)
;; (make-variable-buffer-local 'buffer-is-visible-mark-mode)

;; ;; (require 'goto-chg)
;; ;; (global-set-key [(control b)] 'goto-last-change)
;; ;; (global-set-key [(control b)] 'show-mark-and-pop-to-mark-command)
;; ;; (global-set-key [(meta b)] 'unset-visible-mark-mode)

;; (defun show-mark-and-pop-to-mark-command()
;;   "show-mark-and-pop-to-mark-command:"
;;   (interactive)
;;   (set-visible-mark-mode)
;;   (pop-to-mark-command)
;;   )

;; (defun set-visible-mark-mode()
;;   "set-visible-mark-mode:"
;;   (if (not buffer-is-visible-mark-mode)
;;       (progn
;;         (set (make-local-variable 'buffer-is-visible-mark-mode) t)
;;         (visible-mark-mode 1)
;;         )
;;     )
;;   )

;; (defun unset-visible-mark-mode()
;;   "unset-visible-mark-mode:"
;;   (interactive)
;;   (if buffer-is-visible-mark-mode
;;       (progn
;;         (set (make-local-variable 'buffer-is-visible-mark-mode) nil)
;;         (visible-mark-mode 0)
;;         )
;;     )
;;   )

(custom-set-variables
 '(global-mark-ring-max 256)
 '(mark-ring-max 10)
 )

;; (global-set-key [(f3)] 'copy-next-block-text)
(defun copy-next-block-text ()
  "copy-next-block-text:"
  (interactive)
  (let ((pre-point (point)))
    (forward-char 55)
    (kill-new (buffer-substring pre-point (point)))
    )
  )

;; 多设置几个按键，包括meta-space和control-x space
;; (global-set-key [(meta \ )]         'cua-set-mark)
(global-set-key [(control x)(\ )]   'set-mark-command)
;; (global-set-key [(control \`)]      'set-mark-command-with-deactivate-mark)
(global-set-key [(control \')]      'set-mark-command-with-deactivate-mark)
;; (global-set-key [(control c)(\ )]   'pop-to-mark-command)


(require 'visible-mark)

(custom-set-variables
 '(visible-mark-max 10)
 )


;; (global-set-key [(control b)]      'show-mark-and-pop-to-mark-command)

(defconst visible-duration 3)  ;; be seconds
(defvar visible-timer-count 0)
(defvar visible-timer-id nil)

(defun show-mark-and-pop-to-mark-command()
  "show-mark-and-pop-to-mark-command:"
  (interactive)
  (setq visible-timer-count visible-duration)
  (if (not (timerp visible-timer-id))
      (progn
        (visible-change-display t)
        (setq visible-timer-id (run-with-timer 1 1 'visible-timer-function))
        (visible-mark-mode 1)
        )
    )
  (pop-to-mark-command-and-highlight)
  )

(defconst visible-current-point-face 'bm-face)

(defun pop-to-mark-command-and-highlight ()
  "pop-to-mark-command-and-highlight:"
  (let ((ov (wuxch-check-pos-overlay-face (point) visible-current-point-face)))
    (if ov
        (delete-overlay ov))
    )

  (pop-to-mark-command)

  (let ((ov (wuxch-check-pos-overlay-face (point) visible-current-point-face)))
    (if (not ov)
        (overlay-put (make-overlay (point) (+ 1 (point))) 'face visible-current-point-face))
    )
  )


(defun visible-change-display ( isTurnOn )
  "visible-change-display:"
  (if isTurnOn
      (progn
        ;; (bar-cursor-mode 0)
        ;; (show-paren-mode nil)
        )
    (progn
      ;; (bar-cursor-mode 1)
      ;; (show-paren-mode t)
      (let ((ov (wuxch-check-pos-overlay-face
                 (point) visible-current-point-face)))
        (if ov
            (delete-overlay ov))
        )
      )
    )
  )

(defun visible-timer-function ()
  "visible-timer-function:"
  (if (> visible-timer-count 0)
      (progn
        (setq visible-timer-count (- visible-timer-count 1))
        )
    (progn
      (visible-mark-mode 0)
      (visible-change-display nil)
      (if (timerp visible-timer-id)
          (progn
            (cancel-timer visible-timer-id)
            (setq visible-timer-id nil)
            )
        )
      )
    )
  )

(defun set-mark-command-with-deactivate-mark (arg)
  "set-mark-command-with-deactivate-mark:"
  (interactive "P")
  (set-mark-command arg)
  (deactivate-mark)
  )

(defun clear-mark-ring-local ()
  "clear-mark-ring-local:"
  (interactive)
  (setq mark-ring nil)
  (message "local mark ring was cleared.")
  )

(provide 'wuxch-mark)
