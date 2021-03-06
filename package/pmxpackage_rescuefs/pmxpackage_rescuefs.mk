PMXPACKAGE_RESCUEFS_VERSION = 1.00.12
PMXPACKAGE_RESCUEFS_RELEASE_DATE = 2016-01-06
PMXPACKAGE_RESCUEFS_SITE_METHOD = local
PMXPACKAGE_RESCUEFS_SITE = $(TOPDIR)/project/prjPackages/rescuefs
PMXPACKAGE_RESCUEFS_DEPENDENCIES = linux

define PMXPACKAGE_RESCUEFS_EXTRACT_CMDS
	cp -Ra $(DL_DIR)/$(PMXPACKAGE_RESCUEFS_SOURCE)/* $(@D)
endef

define PMXPACKAGE_RESCUEFS_INSTALL_TARGET_CMDS
		$(INSTALL) -D -m 755 package/pmxpackage_rescuefs/version \
		$(TARGET_DIR)/etc/version
		$(INSTALL) -D -m 755 $(@D)/etc/mdev.conf \
		$(TARGET_DIR)/etc/mdev.conf
		$(INSTALL) -D -m 755 $(@D)/etc/S01init \
		$(TARGET_DIR)/etc/init.d/S01init
		$(INSTALL) -D -m 755 $(@D)/etc/S35mdev \
		$(TARGET_DIR)/etc/init.d/S35mdev
		$(INSTALL) -D -m 755 $(@D)/etc/S99recovery \
		$(TARGET_DIR)/etc/init.d/S99recovery
		$(INSTALL) -D -m 755 $(@D)/sbin/nas-loader_a \
		$(TARGET_DIR)/sbin/nas-loader_a
		$(INSTALL) -D -m 755 $(@D)/sbin/automount.sh \
		$(TARGET_DIR)/sbin/automount.sh
		$(INSTALL) -D -m 755 $(@D)/sbin/sdmount.sh \
		$(TARGET_DIR)/sbin/sdmount.sh
		$(INSTALL) -D -m 755 $(@D)/sbin/wipehdd.sh \
		$(TARGET_DIR)/sbin/wipehdd.sh
		$(INSTALL) -D -m 755 $(@D)/sbin/MCU_Temp_Trigger.sh \
		$(TARGET_DIR)/sbin/MCU_Temp_Trigger.sh
		$(INSTALL) -D -m 755 $(@D)/sbin/MCU_Temp_Log.sh \
		$(TARGET_DIR)/sbin/MCU_Temp_Log.sh
		$(INSTALL) -D -m 755 $(@D)/sbin/fwupgled.sh \
		$(TARGET_DIR)/sbin/fwupgled.sh
		$(INSTALL) -D -m 755 $(@D)/sbin/fwupgledoff.sh \
		$(TARGET_DIR)/sbin/fwupgledoff.sh
		mkdir -p $(TARGET_DIR)/usr/local/sbin
		$(INSTALL) -D -m 755 $(@D)/usr/local/sbin/sendHWCollect.sh \
		$(TARGET_DIR)/usr/local/sbin/sendHWCollect.sh
		@rm -f $(TARGET_DIR)/etc/init.d/S10mdev
		@rm -f $(TARGET_DIR)/etc/init.d/S40network
		mkdir -p $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/external/ufsd
		cp -a package/pmxpackage_rescuefs/ufsd/jnl.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/external/ufsd/
		cp -a package/pmxpackage_rescuefs/ufsd/ufsd.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/kernel/external/ufsd/
		$(MAKE) -C $(LINUX_DIR) $(LINUX_MAKE_FLAGS) M=$(TOPDIR)/package/pmxpackage_rescuefs/ufsd \
			INSTALL_MOD_STRIP=1 INSTALL_MOD_DIR=/kernel/external/ufsd \
			modules_install
		$(INSTALL) -m 0755 -D $(WDPACKAGE_BASIC_SITE)/etc/init.d/S09paragonfs \
			$(TARGET_DIR)/etc/init.d/S09paragonfs

endef
ifeq ($(BR2_PACKAGE_PMXPACKAGE_RESCUEFS_MASTERDRIVE),y)
define PMXPACKAGE_RESCUEFS_MASTERDRIVE
	$(INSTALL) -D -m 755 $(@D)/sbin/loadFWVer \
	$(TARGET_DIR)/sbin/loadFWVer
	$(INSTALL) -D -m 755 $(@D)/sbin/MasterHDDSetting \
	$(TARGET_DIR)/sbin/MasterHDDSetting
endef
PMXPACKAGE_RESCUEFS_POST_INSTALL_TARGET_HOOKS += PMXPACKAGE_RESCUEFS_MASTERDRIVE
endif

define PMXPACKAGE_RESCUEFS_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/sbin/automount.sh
	rm -f $(TARGET_DIR)/sbin/nas-hotplug
	rm -f $(TARGET_DIR)/sbin/nas-loader_a
	rm -f $(TARGET_DIR)/etc/mdev.conf
endef

$(eval $(generic-package))
