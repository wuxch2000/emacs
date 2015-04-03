;;; parser babylon dictionary result, and insert into my personal dictionary.

(defun do-vocabulary-insert-word (new-word)
  "do-vocabulary-insert-word:"
  (do-vocabulary-insert-all new-word "" "" "" "")
  )

(defun do-vocabulary-insert-all (new-word new-phonetic term-list english-list new-chinese)
  "do-vocabulary-insert-all:"
  (let ((vocabulary-file-name wuxch-vocabulary-file-name)
        (comment-str "@comment{")
        (first-times)
        (infected-list nil)
        (already-exist nil))
    (find-file vocabulary-file-name)
    (goto-char (point-min))
    (if (search-forward (concat "VOCABULARY{" new-word ",") nil t)
        (progn
          (message "%s is already in vocabulary" new-word)
          (setq already-exist t))
      (progn
        (goto-char (point-min))
        (when (search-forward comment-str nil t)
          (previous-line)
          (beginning-of-line)
          (insert (concat "\n@VOCABULARY{" new-word ",\n"))
          (insert (concat "  key = {" new-word "},\n"))
          (insert (concat "  word = {" new-word "},\n"))
          (insert (concat "  phonetic = {\\char\"005B" new-phonetic "\\char\"005D},\n"))

          (insert (concat "  term = {"))
          (setq first-times t)
          (dolist (term term-list)
            (if first-times
                (setq first-times nil)
              (insert ";"))
            (insert term)
            )
          (insert "},\n")


          (insert (concat "  english = {"))
          (setq first-times t)
          (dolist (english english-list)
            (if first-times
                (setq first-times nil)
              (insert ";"))
            (insert english)
            )
          (forward-char -1)(delete-char 1)
          (insert "},\n")


          (insert (concat "  chinese = {" new-chinese "},\n"))

          (insert (concat "  infected = {"))
          (setq first-times t)
          (setq infected-list nil)
          (dolist (term term-list)
            (dolist (infected (infected-form-of-word new-word term))
              (unless (or (string= infected "") (assoc infected infected-list))
                (setq infected-list (append infected-list (list (cons infected infected))))
                (if first-times
                    (setq first-times nil)
                  (insert ";")
                  )
                ;; 避免重复条目，所以使用一个list记录已经记录的条目
                (insert infected)
                )
              )
            )

          (insert "},\n")

          (insert (concat "  owner = {吴晓春},\n"))
          (insert (concat "  timestamp = {" (format-time-string "%Y.%m.%d") "},\n"))
          (insert (concat "}\n"))

          (save-buffer)
          )
        )
      )
    already-exist
    )
  )

(defun vocabulary-insert (new-word)
  "lookup-dict-input:"
  (interactive "sWord:")
  (do-vocabulary-insert-word: new-word)
  )

(defun test-babylon-translation-parse ()
  "test:"
  (interactive)
  (let ((parse-result (babylon-translation-parse (current-buffer))))
    (message "parse-result is %s" parse-result)
    )
  )

(defun remove-sharp-in-string (str)
  "remove-sharp-in-string:"
  (let ((str-without-sharp nil)
        (string-char nil))
    (dotimes (i (length str))
      (setq string-char (substring str i (+ i 1)))
      (unless (string= string-char "#")
        (setq str-without-sharp (concat str-without-sharp string-char))
        )
      )
    str-without-sharp
    )
  )

(defun babylon-translation-parse (buf)
  "babylon-translation-parser:"
  (let ((word nil)(phonetic nil)(term nil)(english nil)(chinese nil))
    (switch-to-buffer buf)
    (goto-char (point-min))
    (setq word (thing-at-point 'word))
    ;; (message   "word is    :%s" word)
    (when (re-search-forward "\\[\\(.*|| \\)*\\(.*\\)\\]" nil t)
      (setq phonetic (babylon-phonetic-adjust (match-string 2)))
      ;; (message "phonetic is:%s" phonetic)
      )
    (when (re-search-forward "(.*) \\(.*\\)[ ]*" nil t)
      (setq chinese (remove-sharp-in-string (match-string 1)))
      ;; (message "chinese is :%s" chinese)
      )
    (while (re-search-forward "^\\(n\\|adj\\|adv\\|v\\|prep\\|vi\\|vt\\|conj\\)\\.[ ]" nil t)
      (setq term (append term (list (match-string 1))))
      ;; (message "term is    :%s" term)

      (setq english (append english
                            (list
                             (remove-sharp-in-string
                              (buffer-substring (point) (line-end-position))))))
      ;; (message "english is :%s" english)
      )
    (if (and word phonetic term english chinese)
        (progn
          ;; (message "parse from babylon translation OK!")
          (list word phonetic term english chinese)
          )
      (progn
        (message "parse from babylon translation error!" )
        nil
        )
      )
    )
  )

;; (global-set-key [(control c)(b)]    'babylon-translation-to-my-dict-and-cite)

(defun babylon-translation-utility-add-cite (text-word dict-word)
  "babylon-translation-function:"
  (insert (concat "\\cite{" dict-word "}"))
  (fill-paragraph t)
  (save-buffer)
  )

(defun babylon-utility-word-suggestion (parse-result)
  "babylon-utility-word-suggestion:"
  ;; (let ((suggestion)
  ;;       (len (length word))
  ;;       (number-of-last-letter-to-be-ignore 1)
  ;;       )
  ;;   (setq suggest (concat (substring word 0 (- len number-of-last-letter-to-be-ignore)) "[a-z]*" ))
  ;;   )
  (let ((word (nth 0 parse-result))
        (term-list (nth 2 parse-result))
        (ret-string nil)
        )
    (setq ret-string (concat "\\b\\(" word))
    (dolist (term term-list)
      ;; (if first-time
      ;;     (setq first-time nil)
      ;;   (seq ret-string (concat ret-string "\\|")))
      (dolist (infected (infected-form-of-word word term))
        (setq ret-string (concat ret-string "\\|" infected))
        )
      )

    (setq ret-string (concat ret-string "\\)\\b"))
    )
  )



(defun babylon-translation-to-my-dict-and-cite ()
  "babylon-transation-to-dict-and-cite:"
  (interactive)
  (let* ((ret)
         (parse-result)
         (text-word)
         (dict-word)
         (matched-text-word)
         (original-buff (current-buffer))
         (already-exist)
         )
    (setq ret (babylon-translation-to-my-dict))
    (setq parse-result (car ret))
    (setq already-exist (car (cdr ret)))

    (when parse-result

      (setq dict-word (nth 0 parse-result))
      (switch-to-buffer original-buff)
      (if (re-search-forward (babylon-utility-word-suggestion parse-result) nil t)
          (progn
            (setq text-word (match-string 1))
            (babylon-translation-utility-add-cite text-word dict-word)

            (let ((pure-text-word (substring-no-properties text-word))
                  (pure-dict-word (substring-no-properties dict-word)))
              (if already-exist
                  (message "cite \"%s\" with \"%s\" OK! ... with old item." pure-text-word pure-dict-word)
                (message "cite \"%s\" with \"%s\" OK! ... with new item" pure-text-word pure-dict-word)
                )
              )

            )
        (progn
          (message "search failed, abort!" )
          )
        )
      )
    )
  )

(defun babylon-translation-to-my-dict ()
  "parse-babylon-dict:"
  (interactive)
  (let ((buf "*babylon-temp-buffer*")
        (parse-result nil)
        (word)
        (already-exist))
    ;; clear buffer first
    (if (get-buffer buf)
        (kill-buffer buf)
      (progn
        (switch-to-buffer (get-buffer-create buf))
        (clipboard-yank)))

    (setq parse-result (babylon-translation-parse buf))
    (if parse-result
        (progn
          (setq word (nth 0 parse-result))
          (setq already-exist
                (do-vocabulary-insert-all word
                                          (nth 1 parse-result)
                                          (nth 2 parse-result)
                                          (nth 3 parse-result)
                                          (nth 4 parse-result)))
          ;; (kill-new word)
          (kill-buffer buf)
          (if already-exist
              (message "word [%s] already exist" word)
            (message "put [%s] into vocabulary OK" word)
            )
          (cons parse-result (list already-exist))
          )
      (progn
        (message "parse from babylon translation error!" )
        nil
        )
      )
    )
  )

(defvar babylon-phonetic-adjust-list nil)
(setq babylon-phonetic-adjust-list '(
                                     ("ɪ" . "i")
                                     ("ʊ" . "u")
                                     ("‚" . "\\char\"0345")
                                     ("ː" . ":")
                                     ("ɒ" . "ɔ")
                                     ))

(defun babylon-phonetic-adjust (original-str)
  "babylon-phonetic-adjust:"
  (let ((len (length original-str))
        (i 0)(ch nil)(adjust-pair)
        (out-string nil))
    (while (< i len)
      (setq ch (substring original-str i (+ i 1)))
      (setq adjust-pair (assoc ch babylon-phonetic-adjust-list))
      (if adjust-pair
          (setq out-string (concat out-string (cdr adjust-pair)))
        (setq out-string (concat out-string ch))
        )
      (setq i (+ i 1))
      )
    out-string
    )
  )

;; (defun lookup-dict (arg)
;;   "lookup-dict:"
;;   (let ((browser-program "c:/\"Program Files\"/Safari/Safari.exe")

;;         (dict-web-site
;;         "http://services.aonaware.com/DictService/Default.aspx?action=define&dict=*&query=")

;;         (command))
;;     ;; 注意：需要给参数添加引号
;;     (setq command (concat browser-program " \"" dict-web-site arg "\""))
;;     (wuxch-shell-command-background command)
;;     )
;;   )

;; (defun lookup-dict-word (&optional arg)
;;   "Copy words at point"
;;   (interactive "P")
;;   (let ((current-pos (point))
;;         (beg (progn (if (looking-back "[a-zA-Z]" 1) (backward-word 1)) (point)))
;;       	(end (progn (forward-word arg) (point))))
;;     (lookup-dict (buffer-substring beg end))
;;     (goto-char current-pos)
;;     )
;;   )

;; (global-set-key [(control c)(d)]    'lookup-dict-word)

;; (defun lookup-dict-input (qurey-word)
;;   "lookup-dict-input:"
;;   (interactive "sDict:")
;;   (lookup-dict qurey-word)
;;   )

;; (global-set-key [(control f1)]    'lookup-dict-input)

;; 普通单词的变形模式
(defun infected-form-of-word (word term)
  "infected-form-of-word:"

  (let ((term-list (split-string term ";"))
        (infected-form-list nil)
        (infected-form))
    (dolist (term term-list)
      (cond
       ((or (string= term "noun")(string= term "n"))
        (setq infected-form (infected-form-of-noun word)))

       ((or (string= term "vi")(string= term "vt")(string= term "v")(string= term "verb"))
        (setq infected-form (infected-form-of-verb word)))

       ((string= term "adj")
        (setq infected-form (infected-form-of-adj word)))
       )

      (setq infected-form-list (append infected-form-list infected-form))
      )
    infected-form-list
    )
  )

(defun infected-form-of-adj (word)
  "infected-form-of-adj:"
  (let ((len (length word))
        (er nil)(est nil))
    (cond
     ((last-letters-equal word "e")
      (progn
        (setq er (concat word "r"))
        (setq est (concat word "st"))
        )
      )

     (t
      (progn
        (setq er (concat word "er"))
        (setq est (concat word "est"))
        ))
     )

    (list er est)
    )
  )

(defun infected-form-of-noun (word)
  "infected-form-of-noun:"
  ;; 名词只考虑复数形式。
  (let ((len (length word))
        ret-string)
    (cond
     ((or (last-letters-equal word "ay")(last-letters-equal word "ey")
          (last-letters-equal word "iy")(last-letters-equal word "oy")(last-letters-equal word "uy"))
      (setq ret-string (concat word "s")))

     ((last-letters-equal word "y")
      (setq ret-string (concat (substring word 0 (- len (length "y"))) "ies")))

     ((last-letters-equal word "f")
      (setq ret-string (concat (substring word 0 (- len (length "f"))) "ves")))

     ((last-letters-equal word "fe")
      (setq ret-string (concat (substring word 0 (- len (length "fe"))) "ves")))

     ((last-letters-equal word "is")
      (setq ret-string (concat (substring word 0 (- len (length "is"))) "es")))

     ((or (last-letters-equal word "s")(last-letters-equal word "ch")
          (last-letters-equal word "z")(last-letters-equal word "sh"))
      (setq ret-string (concat word "es")))

     (t
      (setq ret-string (concat word "s")))
     )
    (list ret-string)
    )
  )

(defun infected-form-of-verb (word)
  "infected-form-of-verb:"
  ;; 动词考虑过去时、现在时和第三人称复数
  (let ((len (length word))
        (ed nil)(ing nil)(pl nil))
    (cond
     ((or (last-letters-equal word "ay")(last-letters-equal word "ey")
          (last-letters-equal word "iy")(last-letters-equal word "oy")(last-letters-equal word "uy"))
      (progn
        (setq ed (concat word "ed"))
        (setq ing (concat word "ing"))
        (setq pl (concat (substring word 0 (- len (length "y"))) "ies"))
        )
      )

     ((last-letters-equal word "y")
      (progn
        (setq ed (concat (substring word 0 (- len (length "y"))) "ied"))
        (setq ing (concat word "ing"))
        (setq pl (concat (substring word 0 (- len (length "y"))) "ies"))
        )
      )

     ((last-letters-equal word "ie")
      (progn
        (setq ed (concat word "d"))
        (setq ing (concat (substring word 0 (- len (length "ie"))) "ying"))
        (setq pl (concat word "s"))
        )
      )

     ((last-letters-equal word "e")
      (progn
        (setq ed (concat word "d"))
        (setq ing (concat (substring word 0 (- len (length "e"))) "ing"))
        (setq pl (concat word "s"))
        )
      )

     (t
      (progn
        (setq ed (concat word "ed"))
        (setq ing (concat word "ing"))
        (setq pl (concat word "s"))
        ))
     )
    (list ed ing pl)
    )
  )

(defun last-letters-equal (word letters)
  "last-letters-equal:"
  (let ((len-word (length word))
        (len-letters (length letters)))
    (string= (substring word (- len-word len-letters)) letters)
    )
  )

;; (global-set-key [(f5)] 'add-infected)
;; (defun add-infected ()
;;   "add-infected:"
;;   (interactive)
;;   (let ((word)
;;         (term)
;;         (done nil))
;;     (when (re-search-forward "key = {\\(.*\\)}," nil t)
;;       (setq word (match-string 1))
;;       (when (re-search-forward "term = {\\(.*\\)}," nil t)
;;         (setq term (match-string 1))

;;         (when (re-search-forward "infected = {" nil t)
;;           (dolist (infected (infected-form-of-word word term))
;;             (insert infected) (insert ";")
;;             (setq done t)
;;             )
;;           (when done
;;             (forward-char -1)
;;             (delete-char 1)
;;             )
;;           (recenter-top-bottom 10)
;;           )
;;         )
;;       )
;;     )
;;   )

(require 'wuxch-cite-analyse)

(provide 'wuxch-dict)
