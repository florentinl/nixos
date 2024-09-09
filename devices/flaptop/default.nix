{
  pkgs,
  lib,
  user,
  ...
}:
{
  ###################################
  # Enable device specific services #
  ###################################

  # Enable steam
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      # Enable NVidia Offloading for steam games
      extraEnv = {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
      };
    };
  };

  # Enable xpadneo
  hardware.xpadneo.enable = true;

  # Enable VirtualBox
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ user.name ];

  ####################################################
  # Configure Hardware specificities for this Laptop #
  ####################################################

  # Configure for intel CPU
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = [
    "kvm-intel"
    "overlay"
    "br_netfilter"
    "i915"
  ];

  # Enable kernel modules for peripherics
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "vmd"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];

  # Configure File Systems
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/727eaf35-7cd6-44b3-8820-78dacbe01c01";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-ac7b7b3d-1c0c-4dbb-81a2-576ba886b1f0".device = "/dev/disk/by-uuid/ac7b7b3d-1c0c-4dbb-81a2-576ba886b1f0";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2530-D7D5";
    fsType = "vfat";
  };

  swapDevices = lib.mkForce [ { device = "/dev/mapper/luks-b63628b5-e216-43a4-8758-9ef72942d4c1"; } ];

  boot.initrd.luks.devices."luks-b63628b5-e216-43a4-8758-9ef72942d4c1".device = "/dev/disk/by-uuid/b63628b5-e216-43a4-8758-9ef72942d4c1";
  boot.resumeDevice = "/dev/mapper/luks-b63628b5-e216-43a4-8758-9ef72942d4c1";

  # Configure Finger Print Reader
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # Configure Graphics Card
  hardware.graphics.extraPackages = with pkgs; [
    intel-vaapi-driver
    libvdpau-va-gl
    intel-media-driver
  ];

  hardware.nvidia = {
    open = false;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    modesetting.enable = true;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable fwupd for firmware updates
  services.fwupd.enable = true;
}
