INSTALL = install
DESTDIR ?= /
PREFIX  ?= $(DESTDIR)

TARGET = $(PREFIX)/usr/bin

all:
	@echo "Nothing to do"

install:
	$(INSTALL) -m0755 -D regolith-config-init.sh $(TARGET)/regolith-config-init.sh
	$(INSTALL) -m0755 -D regolith-config-reset.sh $(TARGET)/regolith-config-reset.sh

uninstall:
	rm -Rf $(TARGET)/regolith-config-init.sh $(TARGET)/regolith-config-reset.sh

.PHONY: all install uninstall
