;;; configuration about cscope.

(require 'xcscope+)

(setq cscope-initial-directory "d:/work/ss_code/SS1_v2.01.50.3/releaseSS_50/V2.01.50")

;; gfind . -name *.cpp -or -name *.h -or -name *.c > cscope.files
;; cscope -b -q -k

(define-key cscope:map "\C-css"    'cscope-find-this-symbol-no-prompting-no-updates)
(define-key cscope:map "\C-csd"    'cscope-find-global-definition-no-prompting-no-updates)
(define-key cscope:map "\C-cst"    'cscope-find-this-text-string-no-updates)
(define-key cscope:map "\C-csS"    'cscope-find-this-symbol-no-updates)
(define-key cscope:map "\C-csf"    'cscope-find-functions-calling-this-function-no-updates)
(define-key cscope:map "\C-csD"    'cscope-find-global-definition-no-updates)
(define-key cscope:map "\C-cs."    'cscope-pop-mark)
;; (define-key cscope:map [(control shift f9)]  'cscope-find-this-text-string)
;; (define-key cscope:map [(control shift f10)] 'cscope-find-this-symbol)
;; (define-key cscope:map [(control shift f11)] 'cscope-find-functions-calling-this-function)
;; (define-key cscope:map [(control shift f12)] 'cscope-find-global-definition)
;; (define-key cscope:map [(control ?*)]        'cscope-pop-mark)

(defun cscope-dired-initial-directory ()
  (interactive)
  (setq cscope-initial-directory (dired-current-directory))
  )

(provide 'wuxch-cscope)
