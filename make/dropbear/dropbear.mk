# 2535ea9d0a6f = 2016.74 with some post-release fixes
$(call PKG_INIT_BIN, 2535ea9d0a6f)
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.bz2
#$(PKG)_SOURCE_SHA256:=2720ea54ed009af812701bcc290a2a601d5c107d12993e5d92c0f5f81f718891
#$(PKG)_SITE:=https://matt.ucc.asn.au/dropbear/releases,https://dropbear.nl/mirror/releases
$(PKG)_SITE:=hg@https://secure.ucc.asn.au/hg/dropbear

$(PKG)_BINARY:=$($(PKG)_DIR)/dropbearmulti
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/sbin/dropbearmulti

$(PKG)_STARTLEVEL=30

ifeq ($(strip $(FREETZ_PACKAGE_DROPBEAR_WITH_ZLIB)),y)
$(PKG)_DEPENDS_ON += zlib
endif

ifeq ($(strip $(FREETZ_PACKAGE_DROPBEAR_SERVER_ONLY)),y)
$(PKG)_MAKE_OPTIONS:=PROGRAMS="dropbear dropbearkey" MULTI=1
$(PKG)_EXCLUDED += $(patsubst %,$($(PKG)_DEST_DIR)/usr/bin/%,ssh scp)
else
$(PKG)_MAKE_OPTIONS:=PROGRAMS="dropbear dbclient dropbearkey scp" MULTI=1 SCPPROGRESS=1
endif

ifeq ($(strip $(FREETZ_PACKAGE_DROPBEAR_STATIC)),y)
$(PKG)_MAKE_OPTIONS += STATIC=1
endif

# disable argument null checking (libtomcrypt)
$(PKG)_CPPFLAGS := -DARGTYPE=3

# disable X11 forwarding
$(PKG)_CPPFLAGS += -DDROPBEAR_X11FWD=0

# enable/disable reverse DNS lookups
$(PKG)_CPPFLAGS += -DDO_HOST_LOOKUP=$(if $(FREETZ_PACKAGE_DROPBEAR_DISABLE_HOST_LOOKUP),0,1)

ifeq ($(strip $(FREETZ_PACKAGE_DROPBEAR_YOURFRITZ)),y)
$(PKG)_MAKE_OPTIONS:=PROGRAMS="dropbear dbclient scp" MULTI=1 SCPPROGRESS=1
$(PKG)_CPPFLAGS+=-DDROPBEAR_YOURFRITZ
$(PKG)_CONDITIONAL_PATCHES+=yourfritz
$(PKG)_EXTRA_LIBS += -lprivatekeypassword -ldl -lcrypto
endif

ifeq ($(strip $(FREETZ_PACKAGE_DROPBEAR_NONFREETZ)),y)
$(PKG)_CPPFLAGS += -DDB_NONFREETZ
endif

ifeq ($(strip $(FREETZ_PACKAGE_DROPBEAR_SFTP_SERVER)),y)
$(PKG)_CPPFLAGS += -DDROPBEAR_SFTPSERVER
endif

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_DROPBEAR_SERVER_ONLY
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_DROPBEAR_WITH_ZLIB
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_DROPBEAR_UTMP
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_DROPBEAR_WTMP
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_DROPBEAR_SFTP_SERVER
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_DROPBEAR_DISABLE_HOST_LOOKUP
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_DROPBEAR_STATIC
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_DROPBEAR_NONFREETZ
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_DROPBEAR_YOURFRITZ

$(PKG)_CONFIGURE_PRE_CMDS += $(AUTORECONF)

$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_DROPBEAR_WITH_ZLIB),,--disable-zlib)
$(PKG)_CONFIGURE_OPTIONS += --disable-pam
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_DROPBEAR_NONFREETZ),$(if $(FREETZ_PACKAGE_DROPBEAR_STATIC),--enable-openpty,--disable-openpty),--enable-openpty)
$(PKG)_CONFIGURE_OPTIONS += --enable-syslog
$(PKG)_CONFIGURE_OPTIONS += --enable-shadow
$(PKG)_CONFIGURE_OPTIONS += --disable-lastlog
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_DROPBEAR_UTMP),,--disable-utmp)
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_DROPBEAR_UTMP),,--disable-utmpx)
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_DROPBEAR_WTMP),,--disable-wtmp)
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_DROPBEAR_WTMP),,--disable-wtmpx)
$(PKG)_CONFIGURE_OPTIONS += --disable-loginfunc
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_DROPBEAR_UTMP),,--disable-pututline)
$(PKG)_CONFIGURE_OPTIONS += --disable-pututxline
$(PKG)_CONFIGURE_OPTIONS += --enable-bundled-libtom

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(DROPBEAR_DIR) \
		$(DROPBEAR_MAKE_OPTIONS) \
		EXTRA_CFLAGS="-ffunction-sections -fdata-sections" \
		CPPFLAGS="$(DROPBEAR_CPPFLAGS)" \
		EXTRA_LDFLAGS="-Wl,--gc-sections" \
		EXTRA_LIBS="$(DROPBEAR_EXTRA_LIBS)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(DROPBEAR_DIR) clean
	$(RM) $(DROPBEAR_FREETZ_CONFIG_FILE)

$(pkg)-uninstall:
	$(RM) $(DROPBEAR_TARGET_BINARY)

$(PKG_FINISH)
