;;;
(require 'faces)

;; 查看颜色列表：M-x list-colors-display

;; (set-face-foreground 'font-lock-comment-face "DarkGreen")
;; (set-face-foreground 'font-lock-comment-delimiter-face "DarkGreen")
;; (set-face-foreground 'font-lock-doc-face "Forest Green")
;; (set-face-foreground 'font-lock-keyword-face "#7f0055")
;; (set-face-foreground 'font-lock-type-face "black")
;; (set-face-foreground 'font-lock-string-face "blue")

;; (set-face-bold-p 'font-lock-keyword-face t)


;; for visual studio
;; (custom-set-faces
;;   ;; custom-set-faces was added by Custom -- don't edit or cut/paste it!
;;   ;; Your init file should contain only one such instance.
;;  '(font-lock-builtin-face ((((class color) (background light)) (:foreground "Forest Green"))))
;;  '(font-lock-comment-face ((((class color) (background light)) (:foreground "Forest Green"))))
;;  '(font-lock-constant-face ((((class color) (background light)) (:foreground "DodgerBlue"))))
;;  '(font-lock-function-name-face ((((class color) (background light)) (:foreground "black"))))
;;  '(font-lock-keyword-face ((((class color) (background light)) (:foreground "blue"))))
;;  '(font-lock-string-face ((((class color) (background light)) (:foreground "Brown"))))
;;  '(font-lock-type-face ((((class color) (background light)) (:foreground "blue"))))
;;  '(font-lock-variable-name-face ((((class color) (background light)) (:foreground "black"))))
;; )


;; 显示某个字符的属性命令
;; C-u C-x =

;; 主题选择，M-x color-theme-select
;; (require 'color-theme)

;; 修改语法显示的颜色
;; 列出所有颜色列表
;; meta-x list-colors-display
;; 配置颜色
;; meta-x customize-apropos-faces，输入font-lock
;; 也可以用meta-x customize-face，all faces里面也有font-lock

(require 'color-theme-autoloads)
(require 'color-theme-library)

(defface phone-number-face      '((t (:inherit font-lock-function-name-face))) "")
(defface mobile-number-face     '((t (:inherit font-lock-keyword-face))) "")
(defface speed-dial-face        '((t (:inherit font-lock-constant-face))) "")

(defun theme ()
  "select color theme"
  (interactive)
  ;; (require 'color-theme)
  ;; (require 'color-theme-autoloads)
  ;; (require 'color-theme-library)
  (color-theme-select)
  )

(defun wuxch-set-default-theme ()
  "wuxch-set-default-theme:"
  (interactive)
  ;; using white on black theme
  ;; (color-theme-pok-wob)
  ;; (color-theme-blue-sea)
  (color-theme-deep-blue)
  ;; some other faces, for examples: org-mode related faces, should update manually.
  (wuxch-update-face)
  ;; (set-face-foreground 'default "grey92")
  )


(defun wuxch-set-light-theme ()
  "wuxch-set-light-theme:"
  (interactive)
  (color-theme-emacs-21)
  (wuxch-update-face)
  )


(defun wuxch-update-face ()
  "wuxch-update-face:"
  ;; (interactive)
  ;; (copy-face 'from-face 'to-face)
  (copy-face 'font-lock-function-name-face	'org-level-1)
  (copy-face 'font-lock-variable-name-face	'org-level-2)
  (copy-face 'font-lock-keyword-face	    'org-level-3)
  (copy-face 'font-lock-comment-face	    'org-level-4)
  (copy-face 'font-lock-type-face	        'org-level-5)
  (copy-face 'font-lock-constant-face	    'org-level-6)
  (copy-face 'font-lock-builtin-face	    'org-level-7)
  (copy-face 'font-lock-string-face	        'org-level-8)
  (copy-face 'font-lock-string-face	        'org-special-keyword)
  (copy-face 'font-lock-function-name-face	'org-drawer)
  (copy-face 'font-lock-warning-face        'wuxch-dired-doc-face)
  (copy-face 'font-lock-doc-face            'wuxch-dired-elisp-face)
  (copy-face 'font-lock-function-name-face  'wuxch-dired-exe-face)
  (copy-face 'font-lock-variable-name-face  'wuxch-dired-avi-face)
  (copy-face 'font-lock-warning-face        'dired-marked)
  (copy-face 'font-lock-keyword-face        'dired-directory)
  (copy-face 'highlight                     'trailing-whitespace)
  (copy-face 'font-lock-warning-face        'hs-face)
  (copy-face 'cua-global-mark               'hl-line)
  )

(defun wuxch-next-theme ()
  "wuxch-next-theme:"
  (interactive)
  (next-line)
  (color-theme-install-at-point)
  (wuxch-update-face)
  )

(defun wuxch-prev-theme ()
  "wuxch-prev-theme:"
  (interactive)
  (previous-line)
  (color-theme-install-at-point)
  (wuxch-update-face)
  )

(defun wuxch-color-theme-mode-hook ()
  (local-set-key [(control down)]   'wuxch-next-theme)
  (local-set-key [(control up)]     'wuxch-prev-theme)
  )
(add-hook 'color-theme-mode-hook 'wuxch-color-theme-mode-hook)

(defmacro wuxch-new-face (new-face template-face new-front-color)
  (defface new-face '((t ())) "phone number face")
  (copy-face template-face new-face)
  (set-face-foreground new-face new-front-color)
  )

(defmacro wuxch-enlarge-face (face)
  "enlarge-face:"
  (set-face-attribute face (window-frame (selected-window))
                      :height 800)
  ;; (make-face-italic face)
  )

(provide 'wuxch-theme)
