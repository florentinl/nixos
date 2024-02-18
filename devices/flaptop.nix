{ config, pkgs, lib, ... }:

{
  ###################################
  # Enable device specific services #
  ###################################

  # Enable VirtualBox
  virtualisation.virtualbox.host.enable = true;
  # Enable Tailscale
  services.tailscale.enable = true;

  ####################################################
  # Configure Hardware specificities for this Laptop #
  ####################################################

  # Configure for intel CPU
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # Enable kernel modules for peripherics
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.extraModulePackages = [ ];


  # Configure File Systems
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/727eaf35-7cd6-44b3-8820-78dacbe01c01";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-ac7b7b3d-1c0c-4dbb-81a2-576ba886b1f0".device = "/dev/disk/by-uuid/ac7b7b3d-1c0c-4dbb-81a2-576ba886b1f0";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/2530-D7D5";
      fsType = "vfat";
    };

  swapDevices = lib.mkForce
    [
      { device = "/dev/mapper/luks-b63628b5-e216-43a4-8758-9ef72942d4c1"; }
    ];

  boot.initrd.luks.devices."luks-b63628b5-e216-43a4-8758-9ef72942d4c1".device = "/dev/disk/by-uuid/b63628b5-e216-43a4-8758-9ef72942d4c1";
  boot.resumeDevice = "/dev/mapper/luks-b63628b5-e216-43a4-8758-9ef72942d4c1";

  # Configure Finger Print Reader
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # Configure integrated GPU
  environment.variables = {
    VDPAU_DRIVER = (lib.mkDefault "va_gl");
  };

  hardware.opengl.extraPackages = with pkgs; [
    intel-vaapi-driver
    libvdpau-va-gl
    intel-media-driver
  ];
}
