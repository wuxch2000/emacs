;; 1. 在 C:\Documents and Settings\<CurrentUser>\SendTo 中建立快捷方式，字串如下：

;; <PathToEmacs>\bin\emacsclientw.exe -a <PathToEmacs>\bin\runemacs.exe -f <PathToEmacsHOME>\HOME\.emacs.d\server\server -n

;; 快捷方式的名字可以自行决定。

;; 2. 在 .emacs 中加入以下几行：

;; (server-start)
;; (add-hook 'kill-emacs-hook
;;         (lambda()
;;                 (if (file-exists-p "~/.emacs.d/server/server")
;;                    (delete-file "~/.emacs.d/server/server"))))
;; 不显示启动信息
(setq inhibit-startup-message t)


;; 首先，在 shell 项下新建一项，取名为 Emacs，编辑其字符串的数值数据为“用 Emacs 编辑”，
;; 这次我们需要运行的是 runemacs.exe 这一个程序，
;; 然后我们在 Emacs 项下再新建一项，取名为 Command，然后编辑其字符串的数值数据为“C:\Program
;; Files\emacs-21.3\bin\runemacs.exe %0”，你需要确认你的 Emacs 安装在哪，然后替换一下字符串就可以了，
;; 加“%0”的目的是用 Emacs打开选中的这一个文件，而不仅仅是打开一个空的 Emacs。

;; win下添加右键菜单Emacs项：
;; 添加注册表项：
;; [HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\Emacs\command]
;; 属性值设为：
;; "C:\Program Files\ntemacs23\bin\emacsclientw.exe" -n -a "C:\Program Files\ntemacs23\bin\runemacs.exe"  -f c:\.emacs.d\server\server "%1"


;; win下添加右键发送到emacs菜单：
;; 把emacsclientw.exe的快捷方式添加到
;; C:\Documents and Settings\Administrator\SendTo 目录中

;; 修改快捷方式的命令属性：
;; "C:\Program Files\ntemacs23\bin\emacsclientw.exe" -a "C:\Program Files\ntemacs23\bin\runemacs.exe" -f c:\.emacs.d\server\server -n

;; dos下使用方式是：;111是行号。
;; gnuclientw +111 file

(add-to-list 'load-path "d:/wuxch/emacs_home/site-lisp/")


(defvar start-using-gunserv nil)

(defun customize-start-for-windows32 ()

  (if start-using-gunserv
      (progn
        ;; 设置gnuserv，这样不同文件用一个启动的emacs
        (require 'gnuserv)
        (setq server-done-function 'bury-buffer
              gnuserv-frame (car (frame-list)))
        (gnuserv-start)
        ;; 在当前frame打开
        (setq gnuserv-frame (selected-frame))
        (message "gunserv started")
        )
    ;; 一些新的版本已经可以不使用gnuserver
    (progn
      (server-start)
      )
    )

  ;; 打开后让emacs跳到前面来
  (setenv "GNUSERV_SHOW_EMACS" "1")
  ;;(add-hook 'after-make-frame-functions 'w32-maximize-frame)
  ;; 列出w32的字体
  (setq w32-list-proportional-fonts t)
  ;; 启动后最大
  ;;   (w32-restore-frame)
  ;;   (w32-maximize-frame)

  ;;   现在可以不用tool-bar了。
  (if (fboundp 'tool-bar-mode)
      (tool-bar-mode -1))
  ;;   (require 'tool-bar+)
  ;;    (tool-bar-pop-up-mode 1)
  )


(defun customize-start-for-linux ()
  )

;; 判断操作系统类型，执行windows的相关操作
(cond ((equal 'windows-nt system-type)
       (customize-start-for-windows32)
       )
      ((equal 'gnu/linux system-type)
       (customize-start-for-linux)
       )
      (t nil)
      )

(provide 'wuxch-startup)
