;;; set mode according to suffix.

;; �����ļ���չ����Ӧ��ģʽ���б�
(setq auto-mode-alist
      '(("\\.m$"  . octave-mode)
        ("\\.\\(c\\|h\\)$"  . c-mode)
        ("\\.\\(lnt\\|cpp\\|hpp\\)$" . c++-mode)
        ("\\.java$"  . java-mode)
        ("\\.js$"  . js-mode)
        ("[Mm]akefile$" . makefile-mode)
        ("\\.\\(mak\\|mk\\|sed\\|lax\\)$" . makefile-mode)
        ("\\.\\(tex\\|cls\\|sty\\)" . latex-mode)
        ("\\.outline$" . outline-mode)
        ("\\.ol$" . outline-mode)
        ("\\.py$" . python-mode)
        ("\\.txt$" . text-mode)
        ("\\.pl$" . cperl-mode)
        ("\\.\\(err\\|compilation\\|compile\\)$" . compilation-mode)
        ("\\.\\(el\\|emacs\\)$" . emacs-lisp-mode)
        ("\\.[bB][aA][tT]$" . bat-mode)
        ("/rfc[0-9]+\\.txt\\(\\.gz\\)?\\'" . rfcview-mode)
        ("\\.\\(ini\\|conf\\)$" . any-ini-mode)
        ("[Cc]onfig$" . any-ini-mode)
        ("hosts" . shell-script-mode)
        ("\\.org$" . org-mode)
        ("\\.\\(html\\|jsp\\|jspf\\)$" . html-mode)
        ("\\.mp$" . metapost-mode)
        ("\\.mf$" . metafont-mode)
        ;; ("\\.xml$" . nxml-mode)
        ;; ("\\.\\(dtd\\|ent\\|mod\\)$" . dtd-mode)
        ;; ("\\.\\(dtd\\|ent\\|mod\\)$" . nxml-mode)
        ;; ("\\.\\(xml\\|xsl\\|dtd\\|ent\\|mod\\)$" . nxml-mode)
        ("\\.\\(xml\\|xsl\\|dtd\\|ent\\|mod\\|xsd\\)$" . sgml-mode)
        ("\\.css$" . css-mode)
        ))

(autoload 'bat-mode "bat-mode" nil t)
(autoload 'rfcview-mode "rfcview" nil t)
(autoload 'any-ini-mode "any-ini-mode" nil t)
(autoload 'html-helper-mode "html-helper-mode" "Yay HTML" t)
(autoload 'metafont-mode "meta-mode" "Metafont editing mode." t)
(autoload 'metapost-mode "meta-mode" "MetaPost editing mode." t)

;; ȱʡģʽʹ��textģʽ
(setq default-major-mode 'text-mode)

(provide 'wuxch-mode)