
BIN ?= make-repl
PREFIX ?= /usr/local

install:
	install $(BIN).sh $(PREFIX)/bin/$(BIN)

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)
