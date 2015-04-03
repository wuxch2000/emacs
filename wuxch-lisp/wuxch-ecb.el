;;; my ecb config file

;; (add-to-list 'load-path (concat emacs-site-lisp-dir "cedet-1.0pre7"))
;; (add-to-list 'load-path (concat emacs-site-lisp-dir "cedet-1.0pre7/common"))
;; (add-to-list 'load-path (concat emacs-site-lisp-dir "cedet-1.0pre7/eieio"))
;; (add-to-list 'load-path (concat emacs-site-lisp-dir "cedet-1.0pre7/semantic"))
;; (add-to-list 'load-path (concat emacs-site-lisp-dir "cedet-1.0pre7/speedbar"))

;; (require 'cedet)

;; (semantic-load-enable-minimum-features)
;; (semantic-load-enable-code-helpers)

(add-to-list 'load-path (concat emacs-site-lisp-dir "ecb/ecb-2.32"))

(add-to-list 'load-path (concat emacs-site-lisp-dir "ecb/eieio-0.17"))

(add-to-list 'load-path (concat emacs-site-lisp-dir "ecb/semantic-1.4.4"))
(add-to-list 'load-path (concat emacs-site-lisp-dir "ecb/speedbar-0.14beta4"))


;; for semantic

(defun load-semantic (project-root-path)
  "load-semantic:"
  (interactive "Dsemantic project root path:")
  (setq semantic-load-turn-everything-on t)
  (load-file (concat emacs-site-lisp-dir "ecb/semantic-1.4.4" "/semantic-load.el"))
  (require 'semanticdb)
  (require 'semantic-ia)
  (add-to-list 'semanticdb-project-roots
               project-root-path)
  (global-semanticdb-minor-mode 1)
  )

;; info-path
(add-to-list 'Info-default-directory-list (concat emacs-site-lisp-dir "ecb/ecb-2.32/info-help"))
(add-to-list 'Info-default-directory-list (concat emacs-site-lisp-dir "ecb/semantic-1.4.4"))
;; add it's needed to change main-info-path/dir file, for example: add :
;; * ECB: (ecb.info). Emacs Code Browser

(require 'ecb-autoloads)

(defun my-ecb-minor-hook ()
  "my-ecb-minor-hook:"
  (message "my-ecb-minor-hook" )
  (local-set-key [(f11)] 'ecb-toggle-ecb-windows)
  (local-set-key [(control f11)] 'ecb-toggle-layout)
  )

(add-hook 'ecb-activate-hook 'my-ecb-minor-hook)

(defun my-ecb-common-tree-buffer-hook ()
  "my-ecb-common-tree-buffer-hook:"
  (interactive)
  (hl-line-mode t)
  (local-set-key "/" 'wuxch-ecb-common-search)
  )

(defun wuxch-ecb-common-search ()
  (interactive)
  (goto-char (point-min))
  ;; (hl-line-mode t)
  (isearch-forward-regexp)
  ;; (hl-line-mode -1)
  )


(add-hook 'ecb-common-tree-buffer-after-create-hook 'my-ecb-common-tree-buffer-hook)

(custom-set-variables
 '(ecb-primary-secondary-mouse-buttons 'mouse-1--mouse-2)
 '(ecb-tip-of-the-day nil)
 '(ecb-auto-compatibility-check nil)
 '(ecb-toggle-layout-sequence '("left8" "left9" "left16"))
 '(ecb-clear-caches-before-activate nil)
 '(ecb-auto-expand-tag-tree 'all)
 '(ecb-other-window-behavior 'all)
 '(ecb-history-sort-method nil)
 )


(defvar wuxch-using-ecb nil)

;; (defun wuxch-activate-ecb-and-toggle-layout ()
;;   "wuxch-activate-ecb-and-toggle-layout:"
;;   (interactive)
;;   (if wuxch-using-ecb
;;       (progn
;;         (ecb-toggle-layout)
;;         )
;;     (progn
;;       (setq wuxch-using-ecb t)
;;       (ecb-activate)
;;       )
;;     )
;;   )



;; ;; (global-set-key [(f3)]          'wuxch-activate-ecb-and-toggle-layout)
;; ;; (global-set-key [(shift f3)]    'ecb-toggle-ecb-windows)
;; ;; (global-set-key [(meta f3)]     'wuxch-deactive-ecb)

;; (defun wuxch-deactive-ecb ()
;;   "wuxch-deactive-ecb:"
;;   (interactive)
;;   (setq wuxch-using-ecb nil)
;;   (ecb-deactivate)
;;   )

(defun make-local-hook (a)
  "make-local-hook:"

  )

(provide 'wuxch-ecb)


;; "You can expand the ECB-methods-buffer with `ecb-expand-methods-nodes' [C-c . x]."

;; "You can toggle between different layouts with `ecb-toggle-layout' [C-c . t]."

;; "You can go back to the most recent layout with [C-u] `ecb-toggle-layout' [C-u C-c . t]."

;; "You can toggle displaying the ECB-windows with `ecb-toggle-ecb-windows' [C-c . w]."

;; "You can show and hide the ECB-windows on a major-mode-basis with
;; `ecb-major-modes-show-or-hide'."

;; "You can maximize a certain ECB-window either via its popup-menu or with [C-x 1] in that window."

;; "You can use speedbar instead of the native tree-buffers with option
;; `ecb-use-speedbar-instead-native-tree-buffer'."

;; "You can speedup access for big directories with option `ecb-cache-directory-contents'."

;; "You can display the online help also in HTML-format with option `ecb-show-help-format'."

;; "You can interactively create your own layouts with the command `ecb-create-new-layout'."

;; "You can start the eshell in the compile-window simply with `eshell' or [C-c . e]."

;; "Use the incremental search in the methods-buffer for fast node-selecting; see
;; `ecb-tree-incremental-search'."

;; "You can cycle through all currently opened \"compile-buffers\" with
;; `ecb-cycle-through-compilation-buffers'."

;; "You can change the window-sizes by dragging the mouse and storing the new sizes with
;; `ecb-store-window-sizes'."

;; "You can get a quick overlook of all built-in layouts with `ecb-show-layout-help'."

;; "Browse your sources as with a web-browser with `ecb-nav-goto-next' \[C-c . n],
;; `ecb-nav-goto-previous' \[C-c . p]."

;; "Download latest ECB direct from the website with `ecb-download-ecb'."

;; "Download latest semantic direct from the website with `ecb-download-semantic''."

;; "Customize the look\&feel of the tree-buffers with `ecb-tree-expand-symbol-before' and
;; `ecb-tree-indent'."

;; "Customize the contents of the methods-buffer with `ecb-tag-display-function',
;; `ecb-type-tag-display', `ecb-show-tags'."

;; "Customize the main mouse-buttons of the tree-buffers with
;; `ecb-primary-secondary-mouse-buttons'."

;; "Customize with `ecb-tree-do-not-leave-window-after-select' for which tree-buffers a selection
;; doesn't leave the window."

;; "Grep a directory \(recursive) by using the popup-menu \(the right mouse-button) in the
;; directories buffer."

;; "Customize the sorting of the sources with the option `ecb-sources-sort-method'."

;; "Narrow the source-buffer to the selected tag in the methods-buffer with
;; `ecb-tag-visit-post-actions'."

;; "Enable autom. enlarging of the compile-window by select with the option
;; `ecb-compile-window-temporally-enlarge'."

;; "Customize with `ecb-compile-window-temporally-enlarge' the situations the compile-window is
;; allowed to enlarge."

;; "Customize the meaning of `other-window' [C-x o] with the option `ecb-other-window-behavior'."

;; "Customize height and width of the ECB-windows with `ecb-windows-height' and
;; `ecb-windows-width'."

;; "Define with `ecb-compilation-buffer-names' and `ecb-compilation-major-modes' which buffers are
;; \"compile-buffers\"."

;; "Customize all faces used by ECB with the customize-groups `ecb-face-options' and `ecb-faces'."

;; "Auto-activate eshell with the option `ecb-eshell-auto-activate'."

;; "Get best use of big screen-displays with leftright-layouts like \"leftright1\" or
;; \"leftright2\"."

;; "Use the POWER-click in the methods-buffer to narrow the clicked node in the edit-window."

;; "Use the POWER-click in the sources- and history-buffer to get only an overlook of the
;; source-contents."

;; "Exclude not important sources from being displayed in the sources-buffer with
;; `ecb-source-file-regexps'."

;; "Use left- and right-arrow for smart expanding/collapsing tree-buffer-nodes; see
;; `ecb-tree-navigation-by-arrow'." ;;

;; "Add personal key-bindings to the tree-buffers with `ecb-common-tree-buffer-after-create-hook'."

;; "Add personal key-bindings to the directories-buffer with
;; `ecb-directories-buffer-after-create-hook'."

;; "Add personal key-bindings to the sources-buffer with `ecb-sources-buffer-after-create-hook'."

;; "Add personal key-bindings to the methods-buffer with `ecb-methods-buffer-after-create-hook'."

;; "Add personal key-bindings to the history-buffer with `ecb-history-buffer-after-create-hook'."

;; "Pop up a menu with the right mouse-button and do senseful things in the tree-buffers."

;; "Extend the builtin popup-menus to your needs - see `ecb-directories-menu-user-extension'."

;; "Call `ecb-show-help' [C-c . o] with a prefix-argument [C-u] and choose the help-format."

;; "You can change the prefix [C-c .] of all ECB-key-bindings quick and easy with `ecb-key-map'."

;; "Send a problem-report to the ECB-mailing-list quick and easy with `ecb-submit-problem-report'."

;; "Switch on/off auto. expanding of the ECB-methods-buffer with `ecb-auto-expand-directory-tree'."

;; "You can quickly toggle auto. expanding of the ECB-methods-buffer with
;; `ecb-toggle-auto-expand-tag-tree'."

;; "Highlight current semantic-tag of the edit-buffer in the ECB-methods-buffer with
;; `ecb-highlight-tag-with-point'."

;; "Apply a filter to the sources-buffer either via `ecb-sources-filter' or via the popup-menu."

;; "Apply a filter to the history-buffer either via `ecb-history-filter' or via the popup-menu."

;; "Apply tag-filters (can be layered) to the methods-buffer either via `ecb-methods-filter' or via
;; the popup-menu."

;; "Use `scroll-all-mode' to scroll both edit-windows of ECB simultaneously - and no other windows
;; are scrolled!"

;; "You can toggle having a compile window with `ecb-toggle-compile-window' if
;; `ecb-compile-window-height' is not nil."

;; "Start ECB automatically after Emacs is started. Use option `ecb-auto-activate'"

;; "Maximize a tree-buffer via modeline - ECB supports the standard-mechanism of (X)Emacs for
;; deleting other windows."

;; "Easy horizontal scrolling the tree-buffers with the mouse with [M-mouse-1] and [M-mouse-3]; see
;; `ecb-tree-easy-hor-scroll'."

;; "Expand and collapse very precisely the current node in a tree-buffer with commands in the
;; popup-menu."

;; "Let ECB display the version-control-state of your files in the tree-buffers. See
;; `ecb-vc-enable-support'."

;; "Work with remote paths (e.g. TRAMP-, ANGE-FTP-, or EFS-paths) as with local paths in
;; `ecb-source-path'."

;; "Exclude certain files from being displayed in the history-buffer. See
;; `ecb-history-exclude-file-regexps'."

;; "Get the most important options of ECB at a glance by viewing the customization group
;; \"ecb-most-important\"."



