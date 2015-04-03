;; 1. �� C:\Documents and Settings\<CurrentUser>\SendTo �н�����ݷ�ʽ���ִ����£�

;; <PathToEmacs>\bin\emacsclientw.exe -a <PathToEmacs>\bin\runemacs.exe -f <PathToEmacsHOME>\HOME\.emacs.d\server\server -n

;; ��ݷ�ʽ�����ֿ������о�����

;; 2. �� .emacs �м������¼��У�

;; (server-start)
;; (add-hook 'kill-emacs-hook
;;         (lambda()
;;                 (if (file-exists-p "~/.emacs.d/server/server")
;;                    (delete-file "~/.emacs.d/server/server"))))
;; ����ʾ������Ϣ
(setq inhibit-startup-message t)


;; ���ȣ��� shell �����½�һ�ȡ��Ϊ Emacs���༭���ַ�������ֵ����Ϊ���� Emacs �༭����
;; ���������Ҫ���е��� runemacs.exe ��һ������
;; Ȼ�������� Emacs �������½�һ�ȡ��Ϊ Command��Ȼ��༭���ַ�������ֵ����Ϊ��C:\Program
;; Files\emacs-21.3\bin\runemacs.exe %0��������Ҫȷ����� Emacs ��װ���ģ�Ȼ���滻һ���ַ����Ϳ����ˣ�
;; �ӡ�%0����Ŀ������ Emacs��ѡ�е���һ���ļ������������Ǵ�һ���յ� Emacs��

;; win������Ҽ��˵�Emacs�
;; ���ע����
;; [HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\Emacs\command]
;; ����ֵ��Ϊ��
;; "C:\Program Files\ntemacs23\bin\emacsclientw.exe" -n -a "C:\Program Files\ntemacs23\bin\runemacs.exe"  -f c:\.emacs.d\server\server "%1"


;; win������Ҽ����͵�emacs�˵���
;; ��emacsclientw.exe�Ŀ�ݷ�ʽ��ӵ�
;; C:\Documents and Settings\Administrator\SendTo Ŀ¼��

;; �޸Ŀ�ݷ�ʽ���������ԣ�
;; "C:\Program Files\ntemacs23\bin\emacsclientw.exe" -a "C:\Program Files\ntemacs23\bin\runemacs.exe" -f c:\.emacs.d\server\server -n

;; dos��ʹ�÷�ʽ�ǣ�;111���кš�
;; gnuclientw +111 file

(add-to-list 'load-path "d:/wuxch/emacs_home/site-lisp/")


(defvar start-using-gunserv nil)

(defun customize-start-for-windows32 ()

  (if start-using-gunserv
      (progn
        ;; ����gnuserv��������ͬ�ļ���һ��������emacs
        (require 'gnuserv)
        (setq server-done-function 'bury-buffer
              gnuserv-frame (car (frame-list)))
        (gnuserv-start)
        ;; �ڵ�ǰframe��
        (setq gnuserv-frame (selected-frame))
        (message "gunserv started")
        )
    ;; һЩ�µİ汾�Ѿ����Բ�ʹ��gnuserver
    (progn
      (server-start)
      )
    )

  ;; �򿪺���emacs����ǰ����
  (setenv "GNUSERV_SHOW_EMACS" "1")
  ;;(add-hook 'after-make-frame-functions 'w32-maximize-frame)
  ;; �г�w32������
  (setq w32-list-proportional-fonts t)
  ;; ���������
  ;;   (w32-restore-frame)
  ;;   (w32-maximize-frame)

  ;;   ���ڿ��Բ���tool-bar�ˡ�
  (if (fboundp 'tool-bar-mode)
      (tool-bar-mode -1))
  ;;   (require 'tool-bar+)
  ;;    (tool-bar-pop-up-mode 1)
  )


(defun customize-start-for-linux ()
  )

;; �жϲ���ϵͳ���ͣ�ִ��windows����ز���
(cond ((equal 'windows-nt system-type)
       (customize-start-for-windows32)
       )
      ((equal 'gnu/linux system-type)
       (customize-start-for-linux)
       )
      (t nil)
      )

(provide 'wuxch-startup)
