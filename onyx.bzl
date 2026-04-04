load(":target_variants.bzl", "la_variants")
load(":msm_kernel_la.bzl", "define_msm_la")
load(":image_opts.bzl", "boot_image_opts")
load(":xiaomi_sm8750_common.bzl", "xiaomi_common_in_tree_modules")
load(":sun.bzl",
        "target_arch",
        "target_arch_in_tree_modules",
        "target_arch_consolidate_in_tree_modules",
        "consolidate_board_kernel_cmdline_extras",
        "consolidate_board_bootconfig_extras",
        "consolidate_kernel_vendor_cmdline_extras",
        "perf_board_kernel_cmdline_extras",
        "perf_board_bootconfig_extras",
        "perf_kernel_vendor_cmdline_extras",
)

target_name = "onyx"

def define_onyx():
    for variant in la_variants:
        _target_in_tree_modules = target_arch_in_tree_modules + xiaomi_common_in_tree_modules +[
            # keep sorted
            "drivers/media/rc/ir-spi.ko",
            # Xiaomi Onyx-specific: tiantong msc06a
            "drivers/regulator/wl2868c-msc06a-regulator.ko",
            "drivers/gpio/gpio-tiantong-msc06a.ko",
            # Cirrus DSP
            "drivers/firmware/cirrus/cl_dsp-core.ko",
            # Haptics: CS40L26
            "drivers/input/misc/cs40l26_haptic/cs40l26-i2c.ko",
            "drivers/input/misc/cs40l26_haptic/cs40l26-core.ko",
            "sound/soc/codecs/snd-soc-cs40l26.ko",
            # Xiaomi debug/monitoring
            "drivers/xiaomi/mi_stack/mi_stack.ko",
            "drivers/xiaomi/hangdetect/hangdetect.ko",
            "drivers/gpio/gpio-mi-t1.ko",
            "drivers/xiaomi/bootmonitor/bootmonitor.ko",
            "drivers/xiaomi/mi_trace/mi_trace.ko",
            # MTD
            "drivers/mtd/mtd_blkdevs.ko",
            "drivers/mtd/parsers/ofpart.ko",
            "drivers/mtd/mtdoops.ko",
            "drivers/mtd/devices/block2mtd.ko",
            "drivers/mtd/chips/chipreg.ko",
            "drivers/mtd/mtdblock.ko",
            "drivers/mtd/mtd.ko",
            # LED
            "drivers/leds/leds-awrgb21024.ko",
            # CIFS/SMB
            "fs/nls/nls_ucs2_utils.ko",
            "fs/netfs/netfs.ko",
            "net/dns_resolver/dns_resolver.ko",
            "fs/smb/common/cifs_md4.ko",
            "fs/smb/common/cifs_arc4.ko",
            "fs/smb/client/cifs.ko",
            # Haptics: SI
            "drivers/input/misc/si_haptic/si_haptic.ko",
            # Haptics: AW86927
            "drivers/input/misc/aw86927_haptic/aw8697-haptic.ko",
            # MCA charging ICs
            "drivers/power/supply/mca/mca_common/mca_ut_test.ko",
            ]

        _target_consolidate_in_tree_modules = _target_in_tree_modules + \
                target_arch_consolidate_in_tree_modules + [
            # keep sorted
            ]

        if variant == "consolidate":
            mod_list = _target_consolidate_in_tree_modules
            board_kernel_cmdline_extras = consolidate_board_kernel_cmdline_extras
            board_bootconfig_extras = consolidate_board_bootconfig_extras
            kernel_vendor_cmdline_extras = consolidate_kernel_vendor_cmdline_extras
        else:
            mod_list = _target_in_tree_modules
            board_kernel_cmdline_extras = perf_board_kernel_cmdline_extras
            board_bootconfig_extras = perf_board_bootconfig_extras
            kernel_vendor_cmdline_extras = perf_kernel_vendor_cmdline_extras

        define_msm_la(
            msm_target = target_name,
            msm_arch = target_arch,
            variant = variant,
            in_tree_module_list = mod_list,
            boot_image_opts = boot_image_opts(
                earlycon_addr = "qcom_geni,0x00a9c000",
                kernel_vendor_cmdline_extras = kernel_vendor_cmdline_extras,
                board_kernel_cmdline_extras = board_kernel_cmdline_extras,
                board_bootconfig_extras = board_bootconfig_extras,
            ),
        )
