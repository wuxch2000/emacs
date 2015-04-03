;;; config for muse
(add-to-list 'load-path (concat emacs-site-lisp-dir "planner-3.42"))

(setq planner-project "WikiPlanner")
(setq muse-project-alist
	  '(("WikiPlanner"
		("~/plans"	 ;; Or wherever you want your planner files to be
		:default "index"
		:major-mode planner-mode
	:visit-link planner-visit-link))))
(require 'planner)

(provide 'wuxch-plan)
