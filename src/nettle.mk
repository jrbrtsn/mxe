# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := nettle
$(PKG)_WEBSITE  := https://www.lysator.liu.se/~nisse/nettle/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.8
$(PKG)_CHECKSUM := 7576c68481c198f644b08c160d1a4850ba9449e308069455b5213319f234e8e6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.lysator.liu.se/~nisse/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := cc gmp
$(PKG)_OO_DEPS   = $(BUILD)~autotools

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.lysator.liu.se/~nisse/archive/' | \
    $(SED) -n 's,.*nettle-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'pre' | \
    grep -v 'rc' | \
    sort | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(SOURCE_DIR)/configure' \
        $(MXE_CONFIGURE_OPTS) \
        --disable-documentation \
        $(if $(call seq,darwin,$(OS_SHORT_NAME)),gmp_cv_prog_exeext_for_build='')
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)' SUBDIRS=
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install SUBDIRS=
endef
