;;; list-func.el --- display function in new window

;; Copyright (C) 1998-2005  Wu Xiaochun <wuxch2000@hotmail.com>

;; Author: Wu Xiaochun <wuxch2000@hotmail.com>
;; Version: v20060412
;; Keywords: list-func emacs
;; Created: 2006-04-12
;; Compatibility: Emacs 21

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This package provides `list-func' functions,
;; used to list function of c/c++ file in new window.
;; by editing `list-func-alist'.
;;
;; To use this package, add these lines to your .emacs file:
;;     (require 'list-func)
;; Use:
;;     M-x list-func-mode-on
;;     M-x list-func-mode-off
;;     (global-set-key [(f2)] 'list-func-mode-toggle)
;;     (global-set-key [(control f2)] 'list-func-adjust-window)
;;
;; Note that it requires emacs 21 or later.

;;; Contributors:

;;; Code:
(require 'layout-restore)

;; 是否显示行号
(defvar list-func-show-line-number nil)
;; 缺省在左边显示函数列表
(defvar list-func-window-position "left")


;; 是否显示函数返回值类型
(defvar list-func-show-function-return-type nil)
;; 是否显示函数的入参列表
(defvar list-func-show-function-argments nil)
(defconst list-func-c-function-name-pos 9) ;functiona name 的()是第9个()


(defvar list-func-left-margin 30)
(defvar list-func-right-margin (- 120 30))
(defvar list-func-top-margin 10)
(defvar list-func-bottom-margin 30)

;; 当前是否是list-func方式
(defvar list-func-mode-is-on nil)

(defun list-func-get-func-buffer(source-buffer)
  ""
  (get-buffer (list-func-get-func-buffer-name source-buffer))
  )

(defun list-func-get-func-buffer-name(source-buffer)
  ""
  (let ((source-buffer-name))
    (if (bufferp source-buffer)
        (setq source-buffer-name (buffer-name source-buffer))
      (setq source-buffer-name source-buffer)
      )
    (concat "*Func[" source-buffer-name "]*")
    )
  )


(require 'wuxch-list-func-c-regex)

(require 'wuxch-list-func-lisp-regex)

(defvar list-func-mode-map
  (let ((map (make-sparse-keymap)))
    ;; We use this alternative name, so we can use \\[list-func-mode-mouse-goto].
    (define-key map [(control c)(control c)] 'list-func-mode-goto-occurrence)
    (define-key map "\C-m" 'list-func-mode-goto-occurrence)
    (define-key map "o" 'list-func-mode-goto-occurrence-other-window)
    (define-key map "\C-o" 'list-func-mode-display-occurrence)
;;;     (define-key map [(meta n)] 'list-func-next)
;;;     (define-key map [(meta p)] 'list-func-prev)
;;;     (define-key map "r" 'list-func-rename-buffer)
;;;     (define-key map "c" 'clone-buffer)
    (define-key map "g" 'revert-buffer)
;;;     (define-key map "q" 'quit-window)
;;;     (define-key map "z" 'kill-this-buffer)
    (define-key map "n" 'next-error-no-select)
    (define-key map "p" 'previous-error-no-select)
    (define-key map [down] 'next-error-no-select)
    (define-key map [up] 'previous-error-no-select)
    (define-key map "\C-c\C-f" 'next-error-follow-minor-mode)
    (define-key map [(f3)] 'list-func-goto-occurrence-and-kill-list)
    map)
  "Keymap for `list-func-mode'.")

(defun list-func-goto-occurrence-and-kill-list()
  "goto-occurrence-and-kill-list:"
  (interactive)
  (other-window 1)
  (list-func-mode-toggle)
  )


(defvar list-func-revert-arguments nil
  "Arguments to pass to `list-func-do' to revert an List-Func mode buffer.
See `list-func-revert-function'.")

(defcustom list-func-mode-hook '(turn-on-font-lock)
  "Hook run when entering List-Func mode."
  :type 'hook
  :group 'matching)

(defcustom list-func-hook nil
  "Hook run by List-Func when there are any matches."
  :type 'hook
  :group 'matching)

(put 'list-func-mode 'mode-class 'special)
(defun list-func-mode ()
  "Major mode for output from \\[list-func].
\\<list-func-mode-map>Move point to one of the items in this buffer, then use
\\[list-func-mode-goto-occurrence] to go to the occurrence that the item refers to.
Alternatively, click \\[list-func-mode-mouse-goto] on an item to go to it.

\\{list-func-mode-map}"
  (interactive)
  (kill-all-local-variables)
  (use-local-map list-func-mode-map)

  (local-set-key [mouse-2] 'ignore)
  (local-set-key [mouse-1] 'ignore)
  (local-set-key [double-mouse-1] 'list-func-mode-mouse-goto)

  (setq major-mode 'list-func-mode)
  (setq mode-name "List-Func")
  (set (make-local-variable 'revert-buffer-function) 'list-func-revert-function)
  (make-local-variable 'list-func-revert-arguments)
  (add-hook 'change-major-mode-hook 'font-lock-defontify nil t)
  (next-error-follow-minor-mode 1)
  (custom-set-variables
   '(next-error-recenter 16)
   )
  (setq next-error-function 'list-func-next-error)
  (run-mode-hooks 'list-func-mode-hook)
  )

(defun list-func-revert-function (ignore1 ignore2)
  "Handle `revert-buffer' for List-Func mode buffers."
  (apply 'list-func-do (append list-func-revert-arguments (list (buffer-name)))))

(defun list-func-mode-find-occurrence ()
  (let ((pos (get-text-property (point) 'list-func-target)))
    (unless pos
      (error "No occurrence on this line"))
    (unless (buffer-live-p (marker-buffer pos))
      (error "Buffer for this occurrence was killed"))
    pos))

(defalias 'list-func-mode-mouse-goto 'list-func-mode-goto-occurrence)
(defun list-func-mode-goto-occurrence (&optional event)
  "Go to the occurrence the current line describes."
  (interactive (list last-nonmenu-event))
  (let ((pos
         (if (null event)
             ;; Actually `event-end' works correctly with a nil argument as
             ;; well, so we could dispense with this test, but let's not
             ;; rely on this undocumented behavior.
             (list-func-mode-find-occurrence)
           (with-current-buffer (window-buffer (posn-window (event-end event)))
             (save-excursion
               (goto-char (posn-point (event-end event)))
               (list-func-mode-find-occurrence)))))
        same-window-buffer-names
        same-window-regexps)
    (pop-to-buffer (marker-buffer pos))
    (goto-char pos))
  (list-func-highlight-current-function (current-buffer))
  )

(defun list-func-mode-goto-occurrence-other-window ()
  "Go to the occurrence the current line describes, in another window."
  (interactive)
  (let ((pos (list-func-mode-find-occurrence)))
    (switch-to-buffer-other-window (marker-buffer pos))
    (goto-char pos)))

(defun list-func-mode-display-occurrence ()
  "Display in another window the occurrence the current line describes."
  (interactive)
  (let ((pos (list-func-mode-find-occurrence))
        window
        ;; Bind these to ensure `display-buffer' puts it in another window.
        same-window-buffer-names
        same-window-regexps)
    (setq window (display-buffer (marker-buffer pos)))
    ;; This is the way to set point in the proper window.
    (save-selected-window
      (select-window window)
      (goto-char pos))))

(defun list-func-find-match (n search message)
  (if (not n) (setq n 1))
  (let ((r))
    (while (> n 0)
      (setq r (funcall search (point) 'list-func-match))
      (and r
           (get-text-property r 'list-func-match)
           (setq r (funcall search r 'list-func-match)))
      (if r
          (goto-char r)
        (error message))
      (setq n (1- n)))))

(defun list-func-engine-add-prefix (lines)
  (mapcar
   #'(lambda (line)
       (concat "       :" line "\n"))
   lines))

(defun list-func-next (&optional n)
  "Move to the Nth (default 1) next match in an List-Func mode buffer."
  (interactive "p")
  (list-func-find-match n #'next-single-property-change "No more matches"))

(defun list-func-prev (&optional n)
  "Move to the Nth (default 1) previous match in an List-Func mode buffer."
  (interactive "p")
  (list-func-find-match n #'previous-single-property-change "No earlier matches"))

(defun list-func-next-error (&optional argp reset)
  "Move to the Nth (default 1) next match in an List-Func mode buffer.
Compatibility function for \\[next-error] invocations."
  (interactive "p")
  ;; we need to run list-func-find-match from within the List-Func buffer
  (with-current-buffer
      ;; Choose the buffer and make it current.
      (if (next-error-buffer-p (current-buffer))
          (current-buffer)
        (next-error-find-buffer nil nil
                                (lambda ()
                                  (eq major-mode 'list-func-mode))))

    (goto-char (cond (reset (point-min))
                     ((< argp 0) (line-beginning-position))
                     ((> argp 0) (line-end-position))
                     ((point))))
    (list-func-find-match
     (abs argp)
     (if (> 0 argp)
         #'previous-single-property-change
       #'next-single-property-change)
     "No more matches")
    ;; In case the *List-Func* buffer is visible in a nonselected window.
    (set-window-point (get-buffer-window (current-buffer)) (point))
    (list-func-mode-goto-occurrence)))

;; (defface list-func-face
;;   '((((class color) (min-colors 88) (background light))
;;      :background "White")
;;     (((class color) (min-colors 88) (background dark))
;;      :background "RoyalBlue3")
;;     (((class color) (min-colors 8))
;;      :background "blue" :foreground "white")
;;     (((type tty) (class mono))
;;      :inverse-video t)
;;     (t :background "gray"))
;;   "Face used to highlight matches permanently."
;;   :group 'matching
;;   :version "22.1")

(defface list-func-face '((t (t :background "gray"))) ""
  :group 'matching
  :version "22.1")

(defcustom list-func-lines-default-context-lines 0
  "*Default number of context lines included around `list-func-lines' matches.
A negative number means to include that many lines before the match.
A positive number means to include that many lines both before and after."
  :type 'integer
  :group 'matching)

(defalias 'list-func-lines 'list-func)

(defcustom list-func-lines-face 'list-func-face
  "*Face used by \\[list-func-lines] to show the text that matches.
If the value is nil, don't highlight the matching portions specially."
  :type 'face
  :group 'matching)

(defcustom list-func-lines-buffer-name-face 'underline
  "*Face used by \\[list-func-lines] to show the names of buffers.
If the value is nil, don't highlight the buffer names specially."
  :type 'face
  :group 'matching)

(defcustom list-func-excluded-properties
  '(read-only invisible intangible field mouse-face help-echo local-map keymap
              yank-handler follow-link)
  "*Text properties to discard when copying lines to the *List-Func* buffer.
The value should be a list of text properties to discard or t,
which means to discard all text properties."
  :type '(choice (const :tag "All" t) (repeat symbol))
  :group 'matching
  :version "22.1")

(defun list-func-accumulate-lines (count &optional keep-props)
  (save-excursion
    (let ((forwardp (> count 0))
          result beg end)
      (while (not (or (zerop count)
                      (if forwardp
                          (eobp)
                        (bobp))))
        (setq count (+ count (if forwardp -1 1)))
        (setq beg (line-beginning-position)
              end (line-end-position))
        (if (and keep-props (if (boundp 'jit-lock-mode) jit-lock-mode)
                 (text-property-not-all beg end 'fontified t))
            (if (fboundp 'jit-lock-fontify-now)
                (jit-lock-fontify-now beg end)))
        (push
         (if (and keep-props (not (eq list-func-excluded-properties t)))
             (let ((str (buffer-substring beg end)))
               (remove-list-of-text-properties
                0 (length str) list-func-excluded-properties str)
               str)
           (buffer-substring-no-properties beg end))
         result)
        (forward-line (if forwardp 1 -1)))
      (nreverse result))))

(defun list-func-read-primary-args ()
  (list (let* ((default (car regexp-history))
               (input
                (read-from-minibuffer
                 (if default
                     (format "List lines matching regexp (default %s): "
                             (query-replace-descr default))
                   "List lines matching regexp: ")
                 nil
                 nil
                 nil
                 'regexp-history
                 default)))
          (if (equal input "")
              default
            input))
        (when current-prefix-arg
          (prefix-numeric-value current-prefix-arg))))

(defun list-func-rename-buffer (&optional unique-p interactive-p)
  "Rename the current *List-Func* buffer to *List-Func: original-buffer-name*.
Here `original-buffer-name' is the buffer name were List-Func was originally run.
When given the prefix argument, or called non-interactively, the renaming
will not clobber the existing buffer(s) of that name, but use
`generate-new-buffer-name' instead.  You can add this to `list-func-hook'
if you always want a separate *List-Func* buffer for each buffer where you
invoke `list-func'."
  (interactive "P\np")
  (with-current-buffer
      (if (eq major-mode 'list-func-mode) (current-buffer) (list-func-get-func-buffer (current-buffer)))
    (rename-buffer (concat "*List-Func: "
                           (mapconcat #'buffer-name
                                      (car (cddr list-func-revert-arguments)) "/")
                           "*")
                   (or unique-p (not interactive-p)))))

(defun list-func-main (&optional nlines)
  "comment later"
  ;;  (interactive (list-func-read-primary-args))
  ;;  (interactive)
  (let ((ret))
    (cond ((or (string= major-mode "c++-mode") (string= major-mode "c-mode"))
           (list-func-do list-func-c-whole-regexp nlines (list (current-buffer)) list-func-c-function-name-pos )
           (setq ret t)
           )
          ((string= major-mode "emacs-lisp-mode")
           (list-func-do list-func-lisp-whole-regexp nlines (list (current-buffer)) list-func-lisp-function-name-pos)
           (setq ret t)
           )
          (t
           (message "list-func:not in c++-mode or c-mode or emacs-lisp-mode")
           (setq ret nil)
           )
          )
    ret)
  )

(defun list-func-do (regexp nlines bufs function-name-pos &optional buf-name)
  (unless buf-name
    (setq buf-name (list-func-get-func-buffer-name (current-buffer))))
  (let (list-func-buf
        (active-bufs (delq nil (mapcar #'(lambda (buf)
                                           (when (buffer-live-p buf) buf))
                                       bufs))))
    ;; Handle the case where one of the buffers we're searching is the
    ;; output buffer.  Just rename it.
    (when (member buf-name (mapcar 'buffer-name active-bufs))
      (with-current-buffer (get-buffer buf-name)
        (rename-uniquely)))

    ;; Now find or create the output buffer.
    ;; If we just renamed that buffer, we will make a new one here.
    (setq list-func-buf (get-buffer-create buf-name))

    (with-current-buffer list-func-buf
      (list-func-mode)
      (let ((inhibit-read-only t))
        (erase-buffer)
        (let ((count (list-func-engine
                      regexp active-bufs list-func-buf
                      (or nlines list-func-lines-default-context-lines)
                      (and case-fold-search
                           (isearch-no-upper-case-p regexp t))
                      list-func-lines-buffer-name-face
                      nil list-func-lines-face
                      (not (eq list-func-excluded-properties t))
                      function-name-pos)))
          ;; comment by me, wuxch
          ;; 	  (let* ((bufcount (length active-bufs))
          ;; 		 (diff (- (length bufs) bufcount)))
          ;; 	    (message "Searched %d buffer%s%s; %s match%s for `%s'"
          ;; 		     bufcount (if (= bufcount 1) "" "s")
          ;; 		     (if (zerop diff) "" (format " (%d killed)" diff))
          ;; 		     (if (zerop count) "no" (format "%d" count))
          ;; 		     (if (= count 1) "" "es")
          ;; 		     regexp))
          (setq list-func-revert-arguments (list regexp nlines bufs))
          (if (= count 0)
              (kill-buffer list-func-buf)
            (display-buffer list-func-buf)
            (setq next-error-last-buffer list-func-buf)
            (setq buffer-read-only t)
            (set-buffer-modified-p nil)
            (run-hooks 'list-func-hook)))))))

(defun list-func-engine (regexp buffers out-buf nlines case-fold-search
                                title-face prefix-face match-face keep-props function-name-pos)
  (with-current-buffer out-buf
    (let ((globalcount 0)
          ;; Don't generate undo entries for creation of the initial contents.
          (buffer-undo-list t)
          (coding nil))
      ;; Map over all the buffers
      (dolist (buf buffers)
        (when (buffer-live-p buf)
          (let ((matches 0)	;; count of matched lines
                (lines 1)	;; line count
                (matchbeg 0)
                (origpt nil)
                (begpt nil)
                (endpt nil)
                (marker nil)
                (curstring "")
                (headerpt (with-current-buffer out-buf (point))))
            (with-current-buffer buf
              (or coding
                  ;; Set CODING only if the current buffer locally
                  ;; binds buffer-file-coding-system.
                  (not (local-variable-p 'buffer-file-coding-system))
                  (setq coding buffer-file-coding-system))
              (save-excursion
                (goto-char (point-min)) ;; begin searching in the buffer
                (while (not (eobp))
                  (setq origpt (point))
                  (when (setq endpt (re-search-forward regexp nil t))
                    (setq matches (1+ matches)) ;; increment match count
                    (setq matchbeg (match-beginning 0))
                    (setq lines (+ lines (1- (count-lines origpt endpt))))
                    (save-excursion
                      (goto-char matchbeg)
                      (setq begpt (line-beginning-position)
                            endpt (line-end-position)))
                    (setq marker (make-marker))
                    (set-marker marker matchbeg)
                    (if (and keep-props
                             (if (boundp 'jit-lock-mode) jit-lock-mode)
                             (text-property-not-all begpt endpt 'fontified t))
                        (if (fboundp 'jit-lock-fontify-now)
                            (jit-lock-fontify-now begpt endpt)))
                    (if (and keep-props (not (eq list-func-excluded-properties t)))
                        (progn
                          (setq curstring (buffer-substring begpt endpt))
                          (remove-list-of-text-properties
                           0 (length curstring) list-func-excluded-properties curstring))
                      (setq curstring (buffer-substring-no-properties begpt endpt)))
                    ;; Highlight the matches
                    (let ((len (length curstring))
                          (start 0))
                      (while (and (< start len)
                                  (string-match regexp curstring start))
                        (add-text-properties
                         (match-beginning 0) (match-end 0)
                         (append
                          `(list-func-match t)
                          (when match-face
                            ;; Use `face' rather than `font-lock-face' here
                            ;; so as to override faces copied from the buffer.
                            `(face ,match-face)))
                         curstring)

                        (setq start (match-end 0))))

                    ;; 窗口不需要显示所有匹配内容，因此可以订制显示什么内容
                    (let ((pos-begin 0)
                          (pos-end nil))
                      ;; 是否显示函数返回定义
                      (if (not list-func-show-function-return-type)
                          (setq pos-begin (match-beginning function-name-pos)))
                      ;; 是否显示函数的入参
                      (if (not list-func-show-function-argments)
                          (setq pos-end (match-end function-name-pos)))
                      (setq curstring (substring curstring pos-begin pos-end))
                      )
                    ;; Generate the string to insert for this match
                    (let* ((out-line
                            (concat
                             ;; Using 7 digits aligns tabs properly.
                             ;; 是否显示行号 wuxch
                             (apply #'propertize
                                    (if list-func-show-line-number
                                        (format "%7d:" lines)
                                      (format "")
                                      )
                                    (append
                                     (when prefix-face
                                       `(font-lock-face prefix-face))
                                     `(list-func-prefix t mouse-face (highlight)
                                                        list-func-target ,marker follow-link t
                                                        help-echo "double-click: go to this function")
                                     )
                                    )
                             ;; We don't put `mouse-face' on the newline,
                             ;; because that loses.  And don't put it
                             ;; on context lines to reduce flicker.
                             (propertize curstring 'mouse-face (list 'highlight)
                                         'list-func-target marker
                                         'follow-link t
                                         'help-echo
                                         "double-click: go to this function")
                             ;; Add marker at eol, but no mouse props.
                             (propertize "\n" 'list-func-target marker)))
                           (data
                            (if (= nlines 0)
                                ;; The simple display style
                                out-line
                              ;; The complex multi-line display
                              ;; style.  Generate a list of lines,
                              ;; concatenate them all together.
                              (apply #'concat
                                     (nconc
                                      (list-func-engine-add-prefix (nreverse (cdr (list-func-accumulate-lines (- (1+ (abs nlines))) keep-props))))
                                      (list out-line)
                                      (if (> nlines 0)
                                          (list-func-engine-add-prefix
                                           (cdr (list-func-accumulate-lines (1+ nlines) keep-props)))))))))
                      ;; Actually insert the match display data
                      (with-current-buffer out-buf
                        (let ((beg (point))
                              (end (progn (insert data) (point))))
                          (unless (= nlines 0)
                            (insert "-------\n")))))
                    (goto-char endpt))
                  (if endpt
                      (progn
                        (setq lines (1+ lines))
                        ;; On to the next match...
                        (forward-line 1))
                    (goto-char (point-max))))))
            (when (not (zerop matches)) ;; is the count zero?
              (setq globalcount (+ globalcount matches))
              (with-current-buffer out-buf
                (goto-char headerpt)
                (let ((beg (point))
                      end)
                  ;; comment by me,wuxch
                  ;; 		  (insert (format "%d match%s for \"%s\" in buffer: %s\n"
                  ;; 				  matches (if (= matches 1) "" "es")
                  ;; 				  regexp (buffer-name buf)))
                  (setq end (point))
                  (add-text-properties beg end
                                       (append
                                        (when title-face
                                          `(font-lock-face ,title-face))
                                        `(list-func-title ,buf))))
                (goto-char (point-min)))))))
      (if coding
          ;; CODING is buffer-file-coding-system of the first buffer
          ;; that locally binds it.  Let's use it also for the output
          ;; buffer.
          (set-buffer-file-coding-system coding))
      ;; Return the number of matches
      globalcount)))

(defun list-func-mode-on ()
  (if (list-func-main)
      (let ((w))
        (setq w (get-buffer-window (list-func-get-func-buffer (current-buffer))))
        (if  (window-live-p w)
            (progn
              (list-func-make-varibale-local)
              (list-func-do-adjust-window list-func-window-position)
              (setq list-func-mode-is-on t)
              (list-func-highlight-current-function (current-buffer))
              (list-func-set-func-buffer-readonly (current-buffer))
              (list-func-set-timer)
              (layout-save-current)
              )
          (message "list-func:Can not find any funtion")))
    (message "list-func:return error"))
  )

(defun list-func-make-varibale-local()
  "list-func-make-varibale-local:"
  (make-local-variable 'list-func-left-margin)
  (make-local-variable 'list-func-right-margin)
  (make-local-variable 'list-func-top-margin)
  (make-local-variable 'list-func-bottom-margin)
  (make-local-variable 'list-func-window-position)
  (make-local-variable 'list-func-mode-is-on)
  )

(defun list-func-mode-off ()
  (list-func-put-window-none (current-buffer))
  (setq list-func-mode-is-on nil)
  (list-func-kill-timer)
  (layout-delete-current)
  )

(defun list-func-mode-update ()
  (if list-func-mode-is-on
      (list-func-mode-on))
  )

(defun list-func-mode-toggle ()
  (interactive)
  (if (not list-func-mode-is-on)
      (list-func-mode-on)
    (list-func-mode-off))
  )

(defun list-func-adjust-window ()
  (interactive)
  (list-func)
  (cond ((string= list-func-window-position "none")
         (setq list-func-window-position "left"))
        ((string= list-func-window-position "left")
         (setq list-func-window-position "right"))
        ((string= list-func-window-position "right")
         (setq list-func-window-position "left"))
        )
  (list-func-do-adjust-window list-func-window-position)
  )

(defun list-func-do-adjust-window (mode)
  (let ((buff (current-buffer)))
    (cond ((string= mode "right")
           (list-func-put-window-right buff))
          ((string= mode "left")
           (list-func-put-window-left buff))
          ((string= mode "up")
           (list-func-put-window-up buff))
          ((string= mode "down")
           (list-func-put-window-down buff))
          ((string= mode "none")
           (list-func-put-window-none buff))
          )
    )
  )

(defun list-func-put-window-left (source-buffer)
  (delete-other-windows)
  (set-window-buffer (selected-window) source-buffer)
  (split-window-horizontally list-func-left-margin)
  (other-window 1)
  (set-window-buffer (next-window) (list-func-get-func-buffer source-buffer))
  )

(defun list-func-put-window-right (source-buffer)
  (delete-other-windows)
  (set-window-buffer (selected-window) source-buffer)
  (split-window-horizontally list-func-right-margin)
  (set-window-buffer (next-window) (list-func-get-func-buffer source-buffer))
  )

(defun list-func-put-window-up (source-buffer)
  (delete-other-windows)
  (set-window-buffer (selected-window) source-buffer)
  (split-window-horizontally list-func-top-margin)
  (other-window 1)
  (set-window-buffer (next-window) (list-func-get-func-buffer source-buffer))
  )

(defun list-func-put-window-down (source-buffer)
  (delete-other-windows)
  (set-window-buffer (selected-window) source-buffer)
  (split-window-horizontally list-func-bottom-margin)
  (set-window-buffer (next-window) (list-func-get-func-buffer source-buffer))
  )

(defun list-func-put-window-none (source-buffer)
  (let ((w))
    (setq w (get-buffer-window (list-func-get-func-buffer source-buffer)))
    (if (window-live-p w)
        (delete-window w)))
  (kill-buffer (get-buffer-create (list-func-get-func-buffer source-buffer)))
  )


(defvar list-func-timer-id nil)
(defun list-func-set-timer ()
  ""
  (interactive)
  (setq list-func-timer-id (run-with-idle-timer 1 t 'list-func-timer-function))
  (make-local-variable 'list-func-timer-id)
  )

(defun list-func-timer-function ()
  ""
  (list-func-highlight-current-function (current-buffer))
  )

(defun list-func-kill-timer ()
  (if (not (eq list-func-timer-id nil))
      (progn
        (cancel-timer list-func-timer-id)
        (setq list-func-timer-id nil)
        )
    )
  )

(defun list-func-set-func-buffer-readonly(source-code-buffer)
  "list-func-set-func-buffer-readonly:"
  (let ((list-func-buffer (list-func-get-func-buffer source-code-buffer)))
    (select-window (get-buffer-window list-func-buffer))
    (toggle-read-only 1)
    (select-window (get-buffer-window source-code-buffer))
    )
  )

(defun list-func-kill-source-buffer-and-delete-corresponding()
  "list-func-kill-source-buffer-and-delete-corresponding:"
  (interactive)
  (let ((list-func-buffer (list-func-get-func-buffer (current-buffer))))
    (if (buffer-live-p list-func-buffer)
        (progn
          (message "buffer:%s is killed with its coresponding dired buffer" (buffer-name list-func-buffer))
          (kill-buffer list-func-buffer)
          (delete-other-windows)
          )
      )
    )
  (list-func-kill-timer)
  (layout-delete-current)
  (kill-this-buffer)
  )

(require 'which-func)
(defun list-func-highlight-current-function (source-code-buffer)
  ""
  (let ((function-name (which-function)))
    (if (eq function-name nil)
        (progn
          (message "no function")
          (list-func-kill-timer))
      (progn
        (let ((list-func-buffer (list-func-get-func-buffer source-code-buffer)))
          (if (eq list-func-buffer nil)
              (progn
                (list-func-kill-timer))
            (progn
              (let ((list-func-window (get-buffer-window list-func-buffer))
                    (source-code-window (selected-window)))
                (if (not (window-live-p list-func-window))
                    (progn
                      (message "buffer %s is not visible" (list-func-get-func-buffer source-code-buffer))
                      (list-func-kill-timer)
                      )
                  (progn
                    (select-window list-func-window)
                    ;; 通过打开关闭，把上次的highlight取消
                    (global-hi-lock-mode 0)
                    (global-hi-lock-mode 1)
                    ;; 点亮对应的行
                    (highlight-lines-matching-regexp (concat "^" function-name "$") font-lock-warning-face)
                    ;; 光标移动到这一行
                    (search-forward function-name nil t)
                    (beginning-of-line)
                    ;; 回到原来的source-code-window
                    (select-window source-code-window)
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
  )

(provide 'wuxch-list-func)
