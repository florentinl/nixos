{ pkgs, pkgs-unstable, lib, ... }:

{
  # Configure booting.
  boot = {
    # Stay up-to-date on the kernel.
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      # Hide the systemd-boot menu by default.
      timeout = 0;
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };

    # Silent Boot
    plymouth.enable = true;

    # Secure Boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    # Required for TPM2 support to decrypt the root partition
    initrd.systemd.enable = true;

    # Configure Silent Boot https://wiki.archlinux.org/title/Silent_boot
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };

  environment.systemPackages = [
    pkgs-unstable.sbctl
    pkgs-unstable.tpm2-tss
  ];
}
