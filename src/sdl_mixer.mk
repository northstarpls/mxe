# This file is part of MXE.
# See index.html for further information.

PKG             := sdl_mixer
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := a20fa96470ad9e1052f1957b77ffa68fb090b384
$(PKG)_SUBDIR   := SDL_mixer-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL_mixer-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libsdl.org/projects/SDL_mixer/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc sdl libmodplug ogg vorbis smpeg

define $(PKG)_UPDATE
    wget -q -O- 'http://hg.libsdl.org/SDL_mixer/tags' | \
    $(SED) -n 's,.*release-\([0-9][^<]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,^\(Requires:.*\),\1 vorbisfile,' '$(1)/SDL_mixer.pc.in'
    echo \
        'Libs.private:' \
        "`$(TARGET)-pkg-config libmodplug --libs`" \
        "`$(PREFIX)/$(TARGET)/bin/smpeg-config     --libs`" \
        >> '$(1)/SDL_mixer.pc.in'
    $(SED) -i 's,for path in /usr/local; do,for path in; do,' '$(1)/configure'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        $(LINK_STYLE) \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-music-mod \
        --enable-music-mod-modplug \
        --enable-music-ogg \
        --disable-music-flac \
        --enable-music-mp3 \
        --disable-music-mod-shared \
        --disable-music-ogg-shared \
        --disable-music-flac-shared \
        --disable-music-mp3-shared \
        --disable-smpegtest \
        --with-smpeg-prefix='$(PREFIX)/$(TARGET)' \
        LIBS='-lvorbis -logg'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-sdl_mixer.exe' \
        `'$(TARGET)-pkg-config' SDL_mixer --cflags --libs`
endef

$(PKG)_BUILD_i686-static-mingw32   = $($(PKG)_BUILD)
$(PKG)_BUILD_x86_64-static-mingw32 =
