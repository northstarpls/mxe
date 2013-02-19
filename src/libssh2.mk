# This file is part of MXE.
# See index.html for further information.

PKG             := libssh2
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := c27ca83e1ffeeac03be98b6eef54448701e044b0
$(PKG)_SUBDIR   := libssh2-$($(PKG)_VERSION)
$(PKG)_FILE     := libssh2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libssh2.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgcrypt zlib openssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.libssh2.org/download/?C=M;O=D' | \
    grep 'libssh2-' | \
    $(SED) -n 's,.*libssh2-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./buildconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-openssl \
        --with-libgcrypt \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= html_DATA=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libssh2.exe' \
        `'$(TARGET)-pkg-config' --cflags --libs libssh2`
endef

$(PKG)_BUILD_x86_64-w64-mingw32 = \
    $(subst --without-openssl ,--with-openssl ,\
    $(subst --with-libgcrypt ,--without-libgcrypt ,\
    $($(PKG)_BUILD)))
