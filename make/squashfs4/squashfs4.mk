$(call PKG_INIT_BIN, 4.3)
$(PKG)_PRJNAME:=squashfs
$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/$($(PKG)_PRJNAME)$($(PKG)_VERSION)
$(PKG)_SOURCE:=$($(PKG)_PRJNAME)$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=d92ab59aabf5173f2a59089531e30dbf
$(PKG)_SITE:=@SF/$($(PKG)_PRJNAME)

$(PKG)_DEPENDS_ON += $(if $(FREETZ_PACKAGE_SQUASHFS4_LEGACY),zlib)
$(PKG)_DEPENDS_ON += xz

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_SQUASHFS4_LEGACY
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_SQUASHFS4_ALL_DYN
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_SQUASHFS4_COMP_STAT
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_SQUASHFS4_ALL_STAT

$(PKG)_BUILD_DIR := $($(PKG)_DIR)/squashfs-tools

$(PKG)_BINARIES            := mksquashfs unsquashfs
$(PKG)_BINARIES_BUILD_DIR  := $($(PKG)_BINARIES:%=$($(PKG)_BUILD_DIR)/%)
$(PKG)_BINARIES_TARGET_DIR := $($(PKG)_BINARIES:%=$($(PKG)_DEST_DIR)/usr/bin/%4-avm-be)

$(PKG)_LDFLAGS := -Wl,--gc-sections
$(PKG)_LDFLAGS += $(if $(FREETZ_PACKAGE_SQUASHFS4_ALL_STAT),-static)

ifneq ($(strip $(DL_DIR)/$(SQUASHFS4_SOURCE)),$(strip $(DL_DIR)/$(SQUASHFS4_HOST_BE_SOURCE)))
$(PKG_SOURCE_DOWNLOAD)
endif
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_BINARIES_BUILD_DIR): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(SQUASHFS4_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		EXTRA_CFLAGS="$(TARGET_CFLAGS) -DTARGET_FORMAT=AVM_BE -ffunction-sections -fdata-sections" \
		LEGACY_FORMATS_SUPPORT=$(if $(FREETZ_PACKAGE_SQUASHFS4_LEGACY),1,0) \
		GZIP_SUPPORT=$(if $(FREETZ_PACKAGE_SQUASHFS4_LEGACY),1,0) \
		LZMA_XZ_SUPPORT=$(if $(FREETZ_PACKAGE_SQUASHFS4_LEGACY),1,0) \
		XZ_SUPPORT=1 \
		COMP_DEFAULT=xz \
		XATTR_SUPPORT=0 \
		XATTR_DEFAULT=0 \
		$(if $(FREETZ_PACKAGE_SQUASHFS4_COMP_STAT),LINK_COMPRESSION_LIBS_STATICALLY=1) \
		EXTRA_LDFLAGS="$(SQUASHFS4_LDFLAGS)" \
		$(SQUASHFS4_BINARIES)

$($(PKG)_BINARIES_TARGET_DIR): $($(PKG)_DEST_DIR)/usr/bin/%4-avm-be: $($(PKG)_BUILD_DIR)/%
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_BINARIES_TARGET_DIR)

$(pkg)-clean:
	-$(SUBMAKE) -C $(SQUASHFS4_BUILD_DIR) clean

$(pkg)-uninstall:
	$(RM) $(SQUASHFS4_BINARIES_TARGET_DIR)

$(PKG_FINISH)
