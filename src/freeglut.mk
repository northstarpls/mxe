# This file is part of MXE.
# See index.html for further information.

PKG             := freeglut
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 4debbe559c6c9841ce1abaddc9d461d17c6083b1
$(PKG)_SUBDIR   := freeglut-$(word 1,$(subst -, ,$($(PKG)_VERSION)))
$(PKG)_FILE     := freeglut-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/freeglut/freeglut/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/freeglut/files/freeglut/' | \
    $(SED) -n 's,.*freeglut-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        $(LINK_STYLE) \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-replace-glut \
        --disable-debug \
        --without-progs \
        --without-x
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= EXPORT_FLAGS='-DFREEGLUT_STATIC'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-freeglut.exe' \
        `'$(TARGET)-pkg-config' glut --cflags --libs`
endef

$(PKG)_BUILD_i686-static-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32 = $($(PKG)_BUILD)
