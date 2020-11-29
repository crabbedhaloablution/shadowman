prefix = /usr
libdir = $(prefix)/lib
datarootdir = $(prefix)/share
datadir = $(datarootdir)
eselectdir = $(datadir)/eselect/modules
moduledir = $(datadir)/shadowman
libexecdir = $(prefix)/libexec
CHOST = default-unknown-change-me

INSTALL_MODULES_COMPILER = clang gcc posix
INSTALL_MODULES_TOOL = ccache distcc icecc

all:
	:

install: install-eselect install-modules-compiler install-modules-tool

install-eselect: compiler-shadow.eselect
	install -d "$(DESTDIR)$(eselectdir)"
	rm -f $<.tmp
	sed -e "s@^\(MASQ_MODULEDIR=\).*\$$@\1$(moduledir)@" $< > $<.tmp
	install -m0644 $<.tmp "$(DESTDIR)$(eselectdir)/$<"
	rm -f $<.tmp

install-distcc-wrapper: distcc-wrapper
	install -d "$(DESTDIR)$(libexecdir)"
	rm -f $<.tmp
	sed -e "s@^TUPLE=##CHOST##@TUPLE=$(CHOST)@" $< > $<.tmp
	install -m0755 $<.tmp "$(DESTDIR)$(eselectdir)/$<"
	rm -f $<.tmp

install-modules-compiler:
	install -d "$(DESTDIR)$(moduledir)/compilers"
	for f in $(INSTALL_MODULES_COMPILER); do \
		install -m0644 modules/compilers/"$${f}" "$(DESTDIR)$(moduledir)/compilers/" || \
			exit $${?}; \
	done

install-modules-tool:
	install -d "$(DESTDIR)$(moduledir)/tools"
	for f in $(INSTALL_MODULES_TOOL); do \
		install -m0644 modules/tools/"$${f}" "$(DESTDIR)$(moduledir)/tools/" || \
			exit $${?}; \
	done

.PHONY: all install install-eselect install-modules-compiler install-modules-tool
