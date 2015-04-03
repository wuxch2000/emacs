;; 覆盖原有的函数，不高亮显示当前行，原函数在dired.el和dired+.el都有
;; (fset 'insert-directory 'wuxch-insert-directory)

(defun wuxch-insert-directory (file switches &optional wildcard full-directory-p)
  "Insert directory listing for FILE, formatted according to SWITCHES.
Leaves point after the inserted text.
SWITCHES may be a string of options, or a list of strings.
Optional third arg WILDCARD means treat FILE as shell wildcard.
Optional fourth arg FULL-DIRECTORY-P means file is a directory and
switches do not contain `d', so that a full listing is expected.

This version of the function comes from `ls-lisp.el'.
If the value of `ls-lisp-use-insert-directory-program' is non-nil then
it works exactly like the version from `files.el' and runs a directory
listing program whose name is in the variable
`insert-directory-program'; if also WILDCARD is non-nil then it runs
the shell specified by `shell-file-name'.  If the value of
`ls-lisp-use-insert-directory-program' is nil then it runs a Lisp
emulation.

The Lisp emulation does not run any external programs or shells.  It
supports ordinary shell wildcards if `ls-lisp-support-shell-wildcards'
is non-nil; otherwise, it interprets wildcards as regular expressions
to match file names.  It does not support all `ls' switches -- those
that work are: A a c i r S s t u U X g G B C R and F partly."
  (if ls-lisp-use-insert-directory-program
      (funcall original-insert-directory
               file switches wildcard full-directory-p)
    ;; We need the directory in order to find the right handler.
    (let ((handler (find-file-name-handler (expand-file-name file)
                                           'insert-directory))
          wildcard-regexp)
      (if handler
          (funcall handler 'insert-directory file switches
                   wildcard full-directory-p)
        ;; Remove --dired switch
        (if (string-match "--dired " switches)
            (setq switches (replace-match "" nil nil switches)))
        ;; Convert SWITCHES to a list of characters.
        (setq switches (delete ?- (append switches nil)))
        ;; Sometimes we get ".../foo*/" as FILE.  While the shell and
        ;; `ls' don't mind, we certainly do, because it makes us think
        ;; there is no wildcard, only a directory name.
        (if (and ls-lisp-support-shell-wildcards
                 (string-match "[[?*]" file))
            (progn
              (or (not (eq (aref file (1- (length file))) ?/))
                  (setq file (substring file 0 (1- (length file)))))
              (setq wildcard t)))
        (if wildcard
            (setq wildcard-regexp
                  (if ls-lisp-support-shell-wildcards
                      (wildcard-to-regexp (file-name-nondirectory file))
                    (file-name-nondirectory file))
                  file (file-name-directory file))
          (if (memq ?B switches) (setq wildcard-regexp "[^~]\\'")))
        (ls-lisp-insert-directory
         file switches (ls-lisp-time-index switches)
         wildcard-regexp full-directory-p)
        ;; Try to insert the amount of free space.
        (save-excursion
          (goto-char (point-min))
          ;; First find the line to put it on.
          (when (re-search-forward "^total" nil t)
            (let ((available (get-free-disk-space ".")))
              (when available
                ;; Replace "total" with "total used", to avoid confusion.
                (replace-match "total used in directory")
                (end-of-line)
                ;; 05/30/2007 15:36:42
                ;; 修改此句，显示以M/G为单位的大小
                (insert " available " (ls-lisp-format-file-size (* (string-to-number available) 1024) nil) )))))))))


(defun wuxch-get-free-disk-space (dir)
  "Return the amount of free space on directory DIR's file system.
The result is a string that gives the number of free 1KB blocks,
or nil if the system call or the program which retrieve the information
fail.

This function calls `file-system-info' if it is available, or invokes the
program specified by `directory-free-space-program' if that is non-nil."
  ;; Try to find the number of free blocks.  Non-Posix systems don't
  ;; always have df, but might have an equivalent system call.
  (if (fboundp 'file-system-info)
      (let ((fsinfo (file-system-info dir)))
	(if fsinfo
	    (format "%.0f" (/ (nth 2 fsinfo) 1024))))
    (save-match-data
      (with-temp-buffer
	(when (and directory-free-space-program
		   (eq 0 (call-process directory-free-space-program
				       nil t nil
				       directory-free-space-args
				       dir)))
	  ;; Usual format is a header line followed by a line of
	  ;; numbers.
	  (goto-char (point-min))
	  (forward-line 1)
	  (if (not (eobp))
	      (progn
		;; Move to the end of the "available blocks" number.
		(skip-chars-forward "^ \t")
		(forward-word 3)
		;; Copy it into AVAILABLE.
		(let ((end (point)))
		  (forward-word -1)
		  (buffer-substring (point) end)))))))))

(provide 'wuxch-totalcommand)
