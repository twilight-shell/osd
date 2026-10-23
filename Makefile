PREFIX ?= /usr
QMLDIR ?= $(PREFIX)/lib/qt6/qml
DEST = $(DESTDIR)$(QMLDIR)/Twilight/Osd

install:
	install -d $(DEST)
	cp -r Twilight/Osd/. $(DEST)

uninstall:
	rm -rf $(DEST)

.PHONY: install uninstall
