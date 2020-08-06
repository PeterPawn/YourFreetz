# It doesn't matter, that no PKG_INIT and no PKG_FINISH macro was called here, the targets
# *-clean, *dirclean, *distclean and *source are created anyway - so let's add them with
# useful actions, at least for the 'cleaner targets'.

squashfs-host-tools: $(DL_DIR) $(SOURCE_DIR_ROOT) squashfs3-host squashfs4-host-be squashfs4-host-le

squashfs-host-tools-clean: squashfs3-host-clean squashfs4-host-be-clean squashfs4-host-le-clean
squashfs-host-tools-dirclean: squashfs3-host-dirclean squashfs4-host-be-dirclean squashfs4-host-le-dirclean
squashfs-host-tools-distclean: squashfs3-host-distclean squashfs4-host-be-distclean squashfs4-host-le-distclean

