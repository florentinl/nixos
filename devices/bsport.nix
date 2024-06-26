{
  pkgs,
  lib,
  ...
}: {
  ###################################
  # Enable device specific services #
  ###################################

  programs.nix-ld.enable = true;

  networking.extraHosts = ''
    127.0.0.1 b-319e027b-0316-4169-a48a-cf1f0a2d07e6.mq.eu-west-3.amazonaws.com
    127.0.0.1 b-769ce1b9-0f55-417d-849e-1ce950554971.mq.eu-west-3.amazonaws.com
    127.0.0.1 b-feffbe8d-3d27-42b3-a03e-11f2a9c8db9b.mq.eu-west-3.amazonaws.com
  '';

  ####################################################
  # Configure Hardware specificities for this Laptop #
  ####################################################

  # Configure for intel CPU
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = ["kvm-intel"];
  boot.kernelParams = ["mem_sleep_default=deep"];

  # Enable kernel modules for peripherics
  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["i915"];
  boot.extraModulePackages = [];

  # Configure File Systems
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/15904bad-b799-460f-8237-eecb764a099d";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-1f6f33de-f0b4-4291-b3e2-e2f51cb9763f".device = "/dev/disk/by-uuid/1f6f33de-f0b4-4291-b3e2-e2f51cb9763f";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/13EF-13AF";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/9f767868-9bb7-4d02-bee3-64e5911bf9cc";}
  ];

  boot.initrd.luks.devices."luks-8ffb9a1e-1b3c-4cfd-9966-64efb3916ae9".device = "/dev/disk/by-uuid/8ffb9a1e-1b3c-4cfd-9966-64efb3916ae9";
  boot.resumeDevice = "/dev/disk/by-uuid/9f767868-9bb7-4d02-bee3-64e5911bf9cc";

  # Configure Finger Print Reader
  # services.fprintd.enable = true;
  # services.fprintd.tod.enable = true;
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # Configure integrated GPU
  environment.variables = {
    VDPAU_DRIVER = lib.mkDefault "va_gl";
  };

  hardware.opengl.extraPackages = with pkgs; [
    intel-vaapi-driver
    libvdpau-va-gl
    intel-media-driver
  ];
}
