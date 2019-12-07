SHELL = /bin/sh
BINDIR    = /usr/local/bin
LIBDIR    = /usr/local/lib/nhk-prginfo
CONF_DIR  = /usr/local/etc/nhk-prginfo
EXES      = nhk-prginfo.rb
DAT_FILES = areas.dat services.dat
LIB_FILES = youzaka/ariblib/genre_code.rb

install:
	install -d -m 0755 -o root -g root $(CONF_DIR)
	install -m 0755 -o root -g root $(EXES) $(BINDIR)
	install -m 0644 -o root -g root $(DAT_FILES) $(CONF_DIR)
	install -d -m 0755 -o root -g root $(LIBDIR)
	install -m 0644 -o root -g root $(LIB_FILES) $(LIBDIR)

clean:
	rm -f *~
	make -C youzaka/ariblib clean
