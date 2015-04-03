;;; bookmark config file.
(require 'bm)
(require 'bookmark+)

(require 'wuxch-ibookmark)

(require 'wuxch-fringe-bookmark)

(global-set-key [(control f2)]  'fringe-bookmark-toggle-bookmark)
(global-set-key [(f2)]          'fringe-bookmark-goto-next-bookmark)


(setq bookmark-sort-flag nil)

(global-set-key [(control x)(l)] 'wuxch-bookmark-bmenu-list)


(provide 'wuxch-bookmark)
