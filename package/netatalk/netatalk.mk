#############################################################
#
# netatalk
#
#############################################################
NETATALK_VERSION = 3.0.3
NETATALK_SITE = http://downloads.sourceforge.net/project/netatalk/netatalk/$(NETATALK_VERSION)
NETATALK_SOURCE = netatalk-$(NETATALK_VERSION).tar.bz2

NETATALK_AUTORECONF = YES

NETATALK_DEPENDENCIES = host-pkgconf openssl berkeleydb libgcrypt libgpg-error acl attr
NETATALK_CONF_ENV += CC="$(TARGET_CC) -std=gnu99"
NETATALK_CONF_OPTS += --with-cnid-cdb-backend \
	--with-bdb=$(STAGING_DIR)/usr \
	--disable-zeroconf \
	--with-ssl-dir=$(STAGING_DIR)/usr \
	--with-libgcrypt-dir=$(STAGING_DIR)/usr \
	--with-shadow \
	--disable-shell-check \
	--without-kerberos \
	--without-pam

ifeq ($(BR2_PACKAGE_CUPS),y)
	NETATALK_DEPENDENCIES += cups
	NETATALK_CONF_ENV += ac_cv_path_CUPS_CONFIG=$(STAGING_DIR)/usr/bin/cups-config
	NETATALK_CONF_OPTS += --enable-cups
else
	NETATALK_CONF_OPTS += --disable-cups
endif

define NETATALK_INSTALL_EXTRA_FILES
	[ -f $(TARGET_DIR)/etc/init.d/S50netatalk ] || \
		$(INSTALL) -m 0755 -D package/netatalk/S50netatalk \
			$(TARGET_DIR)/etc/init.d/S50netatalk
	mkdir -p $(TARGET_DIR)/usr/var/netatalk
	mv $(TARGET_DIR)/usr/var/netatalk $(TARGET_DIR)/usr/var/netatalk-org
endef

NETATALK_POST_INSTALL_TARGET_HOOKS += NETATALK_INSTALL_EXTRA_FILES

$(eval $(autotools-package))
