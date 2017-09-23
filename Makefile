
PARTS = args.pl cmdline.pl cmds.pl color.pl curses.pl draw.pl env.pl exec.pl \
  getch.pl misc.pl prompt.pl read.pl search.pl screen.pl vitrc.pl

PREFIX=/usr/local
VERSION=vit-1.3.dev
TASK=/usr/bin/task
PERL=/usr/bin/perl
CLEAR=/usr/bin/clear

.PHONY : install

build: 
	@echo "adding vit.pl to vit"
	@if which git > /dev/null && git rev-parse > /dev/null 2>&1; \
	  then GITHASH=" ($$(git rev-parse --short HEAD))"; \
	else GITHASH=""; \
	fi && \
	cat vit.pl | grep -v ^require \
	  | sed "s:%prefix%:$(PREFIX):" \
	  | sed "s/%BUILD%/$(VERSION) built `date`/" \
	  | sed "s/%VERSION%/$(VERSION)$${GITHASH}/" \
	  | sed "s:%TASK%:$(TASK):" \
	  | sed "s:%CLEAR%:$(CLEAR):" \
	  > vit
	@for f in $(PARTS); do \
	  echo "adding $$f to vit"; \
	  echo "########################################################" >> vit; \
	  echo "## $$f..." >> vit; \
	  grep -v ^return $$f >> vit; \
	done
	chmod 755 vit

install:
	mkdir -p $(DESTDIR)//usr/local/bin
	cp vit $(DESTDIR)//usr/local/bin/
	mkdir -p $(DESTDIR)//usr/local/share/man/man1
	cp vit.1 $(DESTDIR)//usr/local/share/man/man1/
	mkdir -p $(DESTDIR)//usr/local/share/man/man5
	cp vitrc.5 $(DESTDIR)//usr/local/share/man/man5/
	mkdir -p $(DESTDIR)//usr/local/share/vit
	cp commands $(DESTDIR)//usr/local/share/vit/commands

autoconf:
	@make -f .makefile autoconf

release:
	@make -f .makefile release

push:
	@make -f .makefile push

debug:
	@make -f .makefile debug

test:
	@make -f .makefile test

diffs:
	@make -f .makefile diffs

ci:
	@make -f .makefile ci

