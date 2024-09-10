{
  pkgs,
  lib,
  ...
}:
{
  # Configure booting.
  boot = {
    # Stay up-to-date on the kernel.
    kernelPackages = pkgs.linuxPackages_latest;

    # Required for Docker
    kernel.sysctl = {
      "net.bridge.bridge-nf-call-iptables" = 1;
      "net.bridge.bridge-nf-call-ip6tables" = 1;
      "net.ipv4.ip_forward" = 1;
    };

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
      "i915.fastboot=1"
      "quiet"
      "splash"
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
