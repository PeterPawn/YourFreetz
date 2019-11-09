# Summary of current differences between this fork and the upstream project

- the 'offset' option for mounting an image file is implemented in a different manner in the BusyBox patch (branch bb_mount)
- the ‘dropbear’ package has an option to create a special version to be used in YourFritz projects, where only RSA encryption is supported and the FRITZ!OS certificate will be used automatically for server and client authentication     (depends on the role of the device in a connection) - this version is somewhat ‘crippled’ in some aspects and it's not really intended,  to use it in a ‘normal’ Freetz image (branch dropbear)
- the shared database of the 'ncurses' package (terminfo and tabsets) may be shifted to another location than '/usr/share' (branch ncurses)
- the Midnight Commander package may also be shifted … this makes it possible, to include it in a 'later-mounted image' outside of the root filesystem (branch mc)
- an existing package configuration may be re-used with a different model without hassle with Kconfig values (branch clearconfig)
- tagging any icons isn't supported in this fork - no more needs to have ImageMagicks or GraphicMagicks as a prerequisite (branch no_tagging)
- my projects 'decoder' and 'privatekeypassword' are included as sub-modules for independent updates (branch submodules)
- add support for models (e.g. 4040), where swapping is disabled by AVM (branch swapping_maybe_disabled)
- use 'native' SquashFS4 format, where the superblock contains a timestamp of filesystem creation (timestamp_for_squashfs_images) - the Freetz behavior (storing length of filesystem instead) needs an additional command line switch now

## Cloning this repository

If you want to clone the `YourFritz` branch from this repository, you have to specify the `--recurse-submodules` option to get your copy of the external projects, too.

```
git clone --recurse-submodules https://github.com/PeterPawn/YourFreetz.git <local_name>
```

## Original README may be found here: https://github.com/PeterPawn/YourFreetz/blob/master/README
