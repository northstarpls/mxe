# This file is part of MXE.
# See index.html for further information.

PKG             := edfbrowser
$(PKG)_IGNORE   := 
$(PKG)_CHECKSUM := 90d625a8529a4815dc949f3d7fe4408627482c90
$(PKG)_SUBDIR   := edfbrowser_151_source
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://www.teuniz.net/edfbrowser/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc qt

define $(PKG)_UPDATE
#    wget -q -O- 'http://biosig.sourceforge.net/download.html' | \
#    $(SED) -n 's_.*>libbiosig, version \([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

    #rm -rf '$(1)'
    #cp -rL ~/src/EDFbrowser '$(1)'

    cd '$(1)' && $(PREFIX)/$(TARGET)/qt/bin/qmake 

    $(MAKE) -C '$(1)'
    
    $(INSTALL) '$(1)/release/edfbrowser.exe' '$(PREFIX)/$(TARGET)/bin/'

endef

