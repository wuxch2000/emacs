;;;

(defun generator-vocabulary-by-cite ()
  "generator-vocabulary-from-cite:"
  (interactive)
  (let ((vocabulary-list (ana-get-all-cite-info-with-occurence)))
    (when vocabulary-list
      (export-vocabulary-list-to-latex vocabulary-list)
      )
    )
  )

(defconst export-latex-file-name "d:/wuxch/tex/vocabulary/vocalbulary_new_word_list.tex")
(defun export-vocabulary-list-to-latex (vocabulary-list)
  "export-vocabulary-list-to-latex:"
  (switch-to-buffer (find-file export-latex-file-name))
  (erase-buffer)
  (let ((cite-info))
    (dolist (item vocabulary-list)
      ;; (setq cite-info (list (car (cdr item))))
      (setq cite-info (cdr item))
      (insert (format "\\myword{%d}" (car item)))
      (insert (concat "{" (ana-get-content-from-cite-info "word" cite-info) "}"))
      (insert (concat "{" (ana-get-content-from-cite-info "phonetic" cite-info) "}"))
      (insert (concat "{" (ana-get-content-from-cite-info "term" cite-info) "}"))
      (insert (concat "{" (ana-get-content-from-cite-info "english" cite-info) "}"))
      (insert (concat "{" (ana-get-content-from-cite-info "chinese" cite-info) "}"))
      (insert "\n\n")
      )
    )
  (save-buffer)
  )

;; 出现次数倒序，如果相同，按字母排序
(defun my-compare-large-to-small (arg1 arg2)
  "my-compare:"
  ;; (ana-get-content-from-cite-info "word" (cdr arg1))
  (if (> (car arg1) (car arg2))
      t
    (if (= (car arg1) (car arg2))
        (if (string< (ana-get-content-from-cite-info "word" (cdr arg1))
                     (ana-get-content-from-cite-info "word" (cdr arg2))
                     )
            t
          nil
          )
      nil
      )
    )
  )

(defun ana-cite-already-processed (cite-info-with-occurence cite-info-list)
  (let ((item nil)
        (ret nil))
    (setq item (assoc (car (car cite-info-with-occurence))  cite-info-list))
    (when item)
    )
  )

;; (global-set-key [(f11)] 'check-cite-word)
(defun check-cite-word ()
  "check-cite-word:"
  (interactive)
  (let ((cite nil)
        (cite-info nil)
        (pos (point))
        (cite-pos nil)
        (regex nil)
        )
    (setq cite (ana-get-next-cite))
    (setq cite-info (ana-get-cite-info cite))
    (setq cite-pos (point))
    (goto-char pos)

    (while cite
      (setq regex (concat (vairy-from-of-cite cite-info) "\\\\cite{" cite "}"))
      (if (re-search-forward regex nil t)
          (progn
            (setq pos (point))
            (setq cite (ana-get-next-cite))
            (setq cite-info (ana-get-cite-info cite))
            (setq cite-pos (point))
            (goto-char pos)
            )
        (progn
          (goto-char cite-pos)
          (setq cite nil)
          (message "check stoped" )
          )
        )
      ;; (setq pos (point))
      ;; (setq pos cite-pos)
      ;; (goto-char pos)
      )
    )
  )

(defun ana-get-all-cite-info-with-occurence ()
  "ana-get-all-cite-info-with-occurence:"
  (interactive)
  (let ((cite nil)
        (cite-info-list nil)
        (cite-info-list-sorted nil)
        (cite-info-list-word nil))
    (goto-char (point-min))
    (setq cite (ana-get-next-cite))
    (while cite
      (if (or (eq cite-info-list-word nil)
              (eq (assoc cite cite-info-list-word) nil)
              )
          (progn
            (setq cite-info-list-word (append cite-info-list-word (list (ana-get-cite-info-with-word cite))))
            ;; (message "cite-info-list-word is %s" cite-info-list-word)
            (setq cite-info-list (append cite-info-list (list (ana-get-cite-info-with-occurence cite))))
            ;; (message "cite-info-list is %s" cite-info-list)
            )
        )
      (setq cite (ana-get-next-cite))
      )

    (when cite-info-list
      (setq cite-info-list-sorted (sort cite-info-list 'my-compare-large-to-small))
      ;; (message "result is %s" cite-info-list-sorted)
      )
    cite-info-list-sorted
    )
  )

(defun ana-get-next-cite ()
  "ana-get-next-cite:"
  (let ((ret nil))
    (when (re-search-forward "\\\\cite{\\([[:alpha:]]+\\)}" nil t)
      (setq ret (substring-no-properties (match-string 1)))
      ;; (message "result is %s" ret)
      )
    ret
    )
  )

(defun ana-get-cite-info-with-occurence (cite)
  "ana-get-cite-info-with-occur:"
  (let* ((cite-info (ana-get-cite-info cite))
         (occccurence (ana-count-cited-word cite-info))
         )
    (cons occccurence cite-info)
    )
  )

(defun ana-get-cite-info-with-word (cite)
  "ana-get-cite-info-with-occur:"
  (let* ((cite-info (ana-get-cite-info cite))
         )
    (cons cite cite-info)
    )
  )

(defun ana-get-content-from-cite-info (content-tag cite-info)
  "ana-get-content-from-cite-info:"
  (cdr (assoc content-tag (car cite-info)))
  )


(defun ana-get-cite-info (cite)
  "return info list as:(key word phonetic term english chinese owner timestamp)"
  (let ((vocabulary-file-name wuxch-vocabulary-file-name)
        (cite-info nil)
        (buf (current-buffer)))
    (find-file vocabulary-file-name)
    (goto-char (point-min))

    (when (re-search-forward (concat "@VOCABULARY{" cite ",") nil t)
      ;; (message "single is %s" (ana-get-cite-single-info "key"))
      (setq cite-info (append cite-info (list (ana-get-cite-single-info "key"))))
      (setq cite-info (append cite-info (list (ana-get-cite-single-info "word"))))
      (setq cite-info (append cite-info (list (ana-get-cite-single-info "phonetic"))))
      (setq cite-info (append cite-info (list (ana-get-cite-single-info "term"))))
      (setq cite-info (append cite-info (list (ana-get-cite-single-info "english"))))
      (setq cite-info (append cite-info (list (ana-get-cite-single-info "chinese"))))
      (setq cite-info (append cite-info (list (ana-get-cite-single-info "infected"))))
      (setq cite-info (append cite-info (list (ana-get-cite-single-info "owner"))))
      (setq cite-info (append cite-info (list (ana-get-cite-single-info "timestamp"))))
      (switch-to-buffer buf)
      )
    (list cite-info)
    )
  )

(defun ana-get-cite-single-info (title)
  "ana-get-cite-single-info:"
  (when (re-search-forward (concat title " = {" "\\(.*\\)" "}"))
    (cons title (match-string 1))
    )
  )

(defun ana-count-cited-word (cite-info)
  "ana-count-cited-word:"
  (let ((regexp (vairy-from-of-cite cite-info))
        (cite-string (concat "\\\\cite{" (ana-get-content-from-cite-info "word" cite-info) "}"))
        )
    (-
     (count-matches regexp (point-min) (point-max))
     ;; (count-matches cite-string (point-min) (point-max))
     0
     )
    )
  )

;; (defvar special-word-for-vairy-form nil)
;; ;; 0-无效 1-普通名词 2-名词复数是es
;; ;; 10-普通动词 20-最后一个字母需要double的动词 30-最后一个字母是e的动词 40-最后一个字母是y的动词
;; (setq special-word-for-vairy-form
;;       '(
;;         ;; 普通名词
;;         ("foe" . 01)("clan" . 01)("boon" . 01)("feat" . 01)
;;         ("brink" . 01)("credo" . 01)("blunt" . 01)
;;         ;; 名词 复数是es
;;         ("flex" . 02)("woo" . 02)("polio" . 02)

;;         ;; 普通名词+普通动词
;;         ("omen" . 11)("dent" . 11)("reel" . 11)
;;         ("ail" . 11)("dent" . 11)("clash" . 11)
;;         ("junk" . 11)("content" . 11)("leash" . 11)
;;         ("libel" . 11)("crux" . 11)("posit" . 11)
;;         ("rein" . 11)("hail" . 11)("peril" . 11)
;;         ("stall" . 11)("clash" . 11)("rivet" . 11)
;;         ("bias" . 11)

;;         ;; 普通动词
;;         ("bask" . 10)("cull" . 10)("avert" . 10)("shun" . 10)
;;         ("fend" . 10)("linger" . 10)

;;         ;; 动词 最后一个字母需要double
;;         ("peg" . 20)("rig" . 20)("lag" . 20)
;;         ;; 动词 最后一个字母是e的动词
;;         ("pare" . 30)("wane" . 30)("rive" . 30)
;;         ;; 动词 最后一个字母是y的动词
;;         ("defy" . 40)

;;         ;; 普通名词+最后一个字母需要double的动词
;;         ("don" . 21)("gig" . 21)("rev" . 21)
;;         ("lug" . 21)("whip" . 21)("ail" . 21)
;;         ("fret" . 21)("thud" . 21)("spar" . 21)
;;         ("flit" . 21)("glut" . 21)("slur" . 21)
;;         ;; 普通名词++最后一个字母是e的动词
;;         ("tinge" . 31)("awe" . 31)("hinge" . 31)("muse" . 31)
;;         ("decline" . 31)("lure" . 31)("edge" . 31)("rebate" . 31)
;;         ;; 普通名词++最后一个字母是y的动词
;;         ("stray" . 41)("fray" . 41)
;;         ))

;; (defun get-noun-form (word tag)
;;   "get-special-form-noun:"
;;   (cond
;;    ((= (% tag 10) 1)
;;     (concat "\\|" word "s"))
;;    ((= (% tag 10) 2)
;;     (concat "\\|" word "es"))
;;    (t
;;     "")
;;    )
;;   )

;; (defun get-verb-form (word tag)
;;   "get-special-form-noun:"
;;   (cond
;;    ((= (/ tag 10) 1)
;;     (concat "\\|" (concat word "ed")
;;             "\\|" (concat word "ing")))
;;    ((= (/ tag 10) 2)
;;     (concat "\\|" (concat word (substring word (- (length word) 1) (length word)) "ed")
;;             "\\|" (concat word (substring word (- (length word) 1) (length word)) "ing")))
;;    ((= (/ tag 10) 3)
;;     (concat "\\|" (concat word "d")
;;             "\\|" (concat (substring word 0 (- (length word) 1)) "ing")))
;;    ((= (/ tag 10) 4)
;;     (concat "\\|" (concat (substring word 0 (- (length word) 1)) "ied")
;;             "\\|" (concat word "ing")))
;;    (t
;;     "")
;;    )
;;   )

;; (defun get-special-form (word)
;;   "get-special-form:"
;;   (let ((item (assoc word special-word-for-vairy-form))
;;         (return-string nil)
;;         (function-tag nil))
;;     (when item
;;       (setq function-tag (cdr item))

;;       (setq return-string
;;             (concat "\\(" word
;;                     (get-noun-form word function-tag)
;;                     (get-verb-form word function-tag)
;;                     "\\)"))
;;       )
;;     return-string
;;     )
;;   )


(defun vairy-from-of-cite (cite-info)
  "vairy-from-of-cite:"
  ;; (babylon-utility-word-suggestion cite)
  (let ((cite-word (ana-get-content-from-cite-info "word" cite-info))
        ;; (cite-term (ana-get-content-from-cite-info "term" cite-info))
        (infected-list (split-string (ana-get-content-from-cite-info "infected" cite-info) ";"))
        (return-string nil)
        )
    ;; (setq return-string (get-special-form cite-word))
    ;; (unless return-string
    ;;   (cond
    ;;    ;; 通用的判断
    ;;    ((or (string= cite-term "n") (string= cite-term "v")
    ;;         (string= cite-term "vi") (string= cite-term "vt"))
    ;;     (setq return-string (babylon-utility-word-suggestion cite-word))
    ;;     )
    ;;    ((or (string= cite-term "adj") (string= cite-term "adv") (string= cite-term "prep"))
    ;;     (setq return-string cite-word)
    ;;     )
    ;;    (t
    ;;     (setq return-string (babylon-utility-word-suggestion cite-word))
    ;;     )
    ;;    )
    ;;   )
    (setq return-string (concat "\\(" cite-word))
    (dolist (infected infected-list)
      (setq return-string (concat return-string "\\|" infected))
      )
    (setq return-string (concat return-string "\\)"))
    (setq return-string (concat "\\b" return-string "\\b"))
    )

  )

(provide 'wuxch-cite-analyse)
