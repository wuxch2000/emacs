(require 'windmove)

(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))

(define-key ctl-x-4-map "t" 'toggle-window-split)

 (defun swap-window-positions ()         ; Stephen Gildea
   "*Swap the positions of this window and the next one."
   (interactive)
   (let ((other-window (next-window (selected-window) 'no-minibuf)))
     (let ((other-window-buffer (window-buffer other-window))
           (other-window-hscroll (window-hscroll other-window))
           (other-window-point (window-point other-window))
           (other-window-start (window-start other-window)))
       (set-window-buffer other-window (current-buffer))
       (set-window-hscroll other-window (window-hscroll (selected-window)))
       (set-window-point other-window (point))
       (set-window-start other-window (window-start (selected-window)))
       (set-window-buffer (selected-window) other-window-buffer)
       (set-window-hscroll (selected-window) other-window-hscroll)
       (set-window-point (selected-window) other-window-point)
       (set-window-start (selected-window) other-window-start))
     (select-window other-window)))

(define-key ctl-x-4-map "s" 'swap-window-positions)

;; reserved for open-line
;; (global-set-key [(control o)] 'ignore)
;; (global-set-key [(control o)] 'other-window)
(global-set-key [(control tab)] 'ignore)
(global-set-key [(control tab)] 'other-window)

;;; WINDOW SPLITING
(global-set-key [(meta \1)] 'delete-other-windows)
(global-set-key [(meta \2)] 'split-window-vertically-and-goto)

(defun split-window-vertically-and-goto ()
  "split-window-vertically-and-goto:"
  (interactive)
  (split-window-vertically)
  (other-window 1)
  )

(global-set-key [(meta \3)] 'split-window-horizontally-and-goto)

(defun split-window-horizontally-and-goto ()
  "split-window-horizontally-and-goto:"
  (interactive)
  (split-window-horizontally)
  (other-window 1)
  )

(global-set-key [(meta -)] 'swap-window-positions)
(global-set-key [(meta \5)] 'toggle-window-split)
(global-set-key [(meta \0)] 'delete-window)
(global-set-key [(meta o)]  'other-window)
(global-set-key [(meta \4)]  'iswitchb-buffer-other-window)
;; (global-set-key [(meta \4)]  'iswitchb-display-buffer)
(global-set-key [(meta \`)] 'iswitchb-buffer)

(provide 'wuxch-windows)
