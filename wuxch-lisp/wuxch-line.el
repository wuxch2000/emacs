;;所有的line操作都在这。

;; show line number: M-x linum

(require 'hl-line)

(defun highlight-current-line-toogle ()
  ""
  (interactive)
  (hl-line-mode)
  )

;; (define-key outline-mode-map [(f4)] 'highlight-current-line-toogle)
(global-set-key [(control c)(control h)] 'highlight-current-line-toogle)

(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col))
  )

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(if (is-linux-terminal)
    (progn
      (global-set-key [(control x) up] 'move-line-up)
      (global-set-key [(control x) down] 'move-line-down)
      )
  (progn
    (global-set-key [(meta up)] 'move-line-up)
    (global-set-key [(meta down)] 'move-line-down)
    )
  )

;; control k 删除整行
(global-set-key [(control k)] 'kill-whole-line)

;; meta home 到句首
(global-set-key [(meta home)] 'ignore)
(global-set-key [(meta home)] 'backward-sentence)

(global-set-key [(meta end)] 'ignore)
(global-set-key [(meta end)] 'forward-sentence)

;; 设定home键开始到第一个字母处，之后到行首
(defun back-to-indentation-or-beginning-of-line ()
  (interactive)
  (if (= (point) (save-excursion (back-to-indentation) (point)))
      (beginning-of-line)
    (back-to-indentation)))

(defun wuxch-open-line (n)
  "wuxch-open-line:"
  (interactive "*p")
  (beginning-of-line)
  (open-line n)
  (indent-according-to-mode)
  )
(global-set-key [(control o)] 'ignore)
(global-set-key [(control o)] 'wuxch-open-line)

;; mark到行首
(defun back-to-indentation-or-beginning-of-line-with-shift (&optional arg)
  "Ensure mark is active; move point to beginning of current line.
With argument ARG not nil or 1, move forward ARG - 1 lines first.
If scan reaches end of buffer, stop there without error."
  (interactive "p")
  (or mark-active (set-mark-command nil))
  (back-to-indentation-or-beginning-of-line))

;; 显示行号
;; M-x setnu-mode切换是否显示行号
;; (require 'setnu)
;; 推荐使用linum.el
(defalias 'linum 'linum-mode)

(autoload 'longlines-mode
  "longlines.el"
  "Minor mode for automatically wrapping long lines." t)

;; toggle-truncate-lines 设定是否折行
(global-set-key [(meta w)]   'ignore)
(global-set-key [(meta w)]   'toggle-truncate-lines)

;; (global-set-key [(control =)] 'wuxch-count-lines)
(defun wuxch-count-lines ()
  "count lines of current buffer"
  (interactive)
  (let ((lines (count-lines (point-min) (point-max))))
    (message "buffer\"%s\" has %d lines, number has been copied to clipboard." (buffer-name) lines)
    (kill-new (number-to-string lines))
    )
  )


(defun is-line-end (pos)
  "is-line-end:"
  (let ((current-pos (point))
        (ret))
    (goto-char pos)
    (if (= pos (line-end-position))
        (setq ret t)
      (setq ret nil))
    (goto-char current-pos)
    ret
    )
  )

(defun is-line-begin (pos)
  (let ((current-pos (point))
        (ret))
    (goto-char pos)
    (if (= pos (line-beginning-position))
        (setq ret t)
      (setq ret nil))
    (goto-char current-pos)
    ret
    )
  )

(defun duplicate-line (n)
  "Duplicates the line point is on.
 With prefix arg, duplicate current line this many times."
  (interactive "p")
  (save-excursion
    (copy-region-as-kill (line-beginning-position)
                         (progn (forward-line 1) (point)))
    (while (< 0 n)
      (yank)
      (setq n (1- n))
      )
    )
  )

(autoload 'hide-lines "hide-lines" "Hide lines based on a regexp" t)
(global-set-key "\C-ch" 'hide-lines)


(provide 'wuxch-line)
