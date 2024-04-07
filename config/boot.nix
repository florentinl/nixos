{ pkgs, pkgs-unstable, lib, ... }:

{
  # Configure booting.
  boot = {
    # Stay up-to-date on the kernel.
    kernelPackages = pkgs.linuxPackages_latest;


    # Configure the EFI boot loader.
    loader = {
      # Hide the systemd-boot menu by default. Pressing any key will show it.
      timeout = 0;
      # Lanzaboote overrides the default systemd-boot configuration
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };
    initrd.systemd.enable = true;

    # Silent Boot
    plymouth.enable = true;

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

  # Secure Boot
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  environment.systemPackages = [
    pkgs.sbctl
    pkgs.tpm2-tss
  ];
}
