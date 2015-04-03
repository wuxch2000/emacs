(require 'snippet)
;; (require 'smart-snippet)
;; smart-snippet好像冲突比较多，还是用snippet比较方便。

(define-abbrev-table 'wuxch-elisp-mode-abbrev-table ())

(snippet-with-abbrev-table
 'wuxch-elisp-mode-abbrev-table
 ("defun_" . "$>(defun $${func-name} ()\n$>\"$${func-name}:\"\n$>$.\n$>)")
 ("msg_" . "$>(message \"$${message}\" $${ })$.")
 ("progn_" . "$>(progn\n$>$${exp}\n$>)$.")
 ("let_" . "$>(let (($${ var}))\n$> $${exp}$.)")
 ("if_" . "$>(if $${cond}\n$>$.)")
 ("hook_" . "$>(add-hook '$${HOOK} 'wuxch-$${HOOK})\n\n(defun wuxch-$${HOOK} ()\n$>\"\"\n$>$.\n$>)")
 )

;; (defun get-word-at-cursor ()
;;   "as function's name"
;;   (let ((str)(cur-point (point)))
;;     (backward-word)
;;     (re-search-forward "[0-9a-zA-Z-_]+")
;;     (goto-char cur-point)
;;     (setq str (match-string 0))
;;     )
;;   )

;; (defun item-is-in-vector (item vect)
;;   ""
;;   (let ((max-length-minor-1)(i)(ret))
;;     (setq max-length-minor-1 (- (length vect) 1))
;;     (setq i 0)
;;     (setq ret nil)
;;     (while (< i max-length-minor-1)
;;       (if (string= item (format "%s"(elt vect i)))
;;           (progn
;;             (setq ret t)
;;             (setq i max-length-minor-1)
;;             )
;;         )
;;       (setq i (+ 1 i))
;;       )
;;     ret
;;     )
;;   )

(defun indent-or-complete-or-snippet ()
  "Complete if point is at end of a word, otherwise indent line."
  (interactive)
  (if snippet
      (snippet-next-field)
    (indent-or-complete))
  )

(defun snippet-emacs-lisp-mode-hook ()
  (interactive)

  (abbrev-mode 1)


  ;; This line is not in the documentation of snippet.el, but seems to be
  ;; essential for various modes (not for python-mode though, which serves as
  ;; the example mode in said documentation)
  (setq local-abbrev-table wuxch-elisp-mode-abbrev-table)
  )



(add-hook 'emacs-lisp-mode-hook 'snippet-emacs-lisp-mode-hook)

;; (require 'tempo-snippets)
;; (tempo-define-snippet "java-class"
;;   '("class " (p "Class: " class) " {\n\n"
;;     > "public " (s class) "(" p ") {\n" > p n
;;     "}" > n n "}" > n))

;; (tempo-define-snippet "java-get-set"
;;   '("private " (p "Type: " type) " _" (p "Name: " var) ";\n\n"
;;     > "public " (s type) " get" (upcase-initials (tempo-lookup-named 'var))
;;     "() {\n"
;;     > "return _" (s var)  ";\n" "}" > n n
;;     > "public set" (upcase-initials (tempo-lookup-named 'var))
;;     "(" (s type) " value) {\n"
;;     > "_" (s var) " = value;\n" "}" > n))


;; (defvar tempo-snippets-source-map (make-sparse-keymap))
;; (define-key tempo-snippets-source-map (kbd "<tab>") 'tempo-snippets-next-field)
;; (define-key tempo-snippets-source-map (kbd "<backtab>") 'tempo-snippets-previous-field)
;; (define-key tempo-snippets-source-map (kbd "C-m") 'tempo-snippets-clear-latest)

;; (defadvice tempo-snippets-finish-source (before clear-post-overlay (o) act)
;;   (delete-overlay (overlay-get o 'tempo-snippets-post)))

;; (defadvice tempo-snippets-insert-source (after install-custom-map act)
;;   (let ((overlay (car tempo-snippets-sources)))
;;     (overlay-put overlay 'keymap tempo-snippets-source-map)
;;     (overlay-put overlay 'tempo-snippets-post (point))))

;; (defadvice tempo-snippets-insert-template (after install-post-map act)
;;   (dolist (s tempo-snippets-sources)
;;     (let ((pos (overlay-get s 'tempo-snippets-post)))
;;       (when (integerp pos)
;;         (let ((o (make-overlay pos (1+ pos))))
;;           (overlay-put o 'keymap tempo-snippets-source-map)
;;           (overlay-put s 'tempo-snippets-post o)))))
;;   ad-return-value)

(provide 'wuxch-snippet)
