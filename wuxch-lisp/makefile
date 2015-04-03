# for mingw gcc usage

MINGW_PATH = c:/MinGW


TARGET = d:/wuxch/emacs_home/data/TAGS
SOURCE_PATH = d:/wuxch/emacs_home/wuxch-lisp

# SOURCES = $(wildcard *.el)

COMPILER = etags.exe
RM = rm -f

# FLAGS = -a -e -R
FLAGS =
FLAGS_APPEND = $(FLAGS) -a

lisp-path = e:/"Program Files"/emacs_nt/lisp/
lisp-file = outline.el window.el wid-edit.el progmodes/etags.el imenu.el \
textmodes/sgml-mode.el bookmark.el net/browse-url.el simple.el

site-lisp-path = d:/wuxch/emacs_home/site-lisp/
site-lisp-file = bm.el fringe-helper.el etags-select.el tree-mode.el imenu-tree.el color-theme.el \
color-theme-library.el auctex/auctex/tex-buf.el auctex/auctex/tex.el xcscope.el \
org/lisp/org.el dired+.el org/lisp/org-table.el

wuxch-lisp-path = d:/wuxch/emacs_home/wuxch-lisp/

wuxch-lisp-file = wuxch-xml.el wuxch-cite-analyse.el wuxch-indent.el wuxch-save.el \
wuxch-dict.el wuxch-fringe-bookmark.el wuxch-fringe.el wuxch-shell.el wuxch-mark.el wuxch-point-stack.el \
wuxch-imenu.el wuxch-tag.el wuxch-theme.el wuxch-outline.el wuxch-modeline.el \
wuxch-make-lint.el wuxch-tex.el wuxch-line.el wuxch-buffer.el wuxch-data.el \
wuxch-dired.el wuxch-cua.el wuxch-phone.el wuxch-org.el wuxch-dired-copy-paste.el wuxch-dired-play.el \
wuxch-elisp.el wuxch-elisp-tag.el wuxch-zte.el

SOURCES = $(addprefix $(lisp-path),$(lisp-file))
SOURCES1 += $(addprefix $(site-lisp-path),$(site-lisp-file))
SOURCES2 += $(addprefix $(wuxch-lisp-path),$(wuxch-lisp-file))

# $(TARGET) :
# 	@echo tagging $@ ...
# 	$(COMPILER) $(FLAGS) -o $@ $(SOURCES)
# 	$(COMPILER) $(FLAGS_APPEND) -o $@ $(SOURCES1)
# 	$(COMPILER) $(FLAGS_APPEND) -o $@ $(SOURCES2)
# 	@echo tagging $@ done

# here using the dos style for loop, in unix enviroment, it should be adjusted
$(TARGET) :
	@echo tagging $@ ...
	@for i in $(foreach file,$(site-lisp-file),$(addprefix $(site-lisp-path),$(file))) ; do \
		make -r -s addtag dest=$@ file=$$i ; done
	@for i in $(foreach file,$(wuxch-lisp-file),$(addprefix $(wuxch-lisp-path),$(file))) ; do \
		make -r -s addtag dest=$@ file=$$i ; done
	@echo tagging $@ done

.PHONY : rm re clean test tag addtag

addtag :
	@echo adding $(file) ...
	@$(COMPILER) -a $(FLAGS_APPEND) -o $(dest) $(file)
	@echo adding $(file) ... done

tag: $(TARGET)

rm:
	@echo removing $(TARGET) ...
	@$(RM) -f $(subst /,\,$(TARGET))
	@echo removing $(TARGET) done

re:
	make rm
	make tag

clean:
	make rm

test:
	@echo $(foreach file,$(site-lisp-file),$(addprefix $(site-lisp-path),$(file)))
