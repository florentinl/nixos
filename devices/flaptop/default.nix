{
  pkgs,
  lib,
  user,
  hardwareModules,
  ...
}:
{
  ###################################
  # Enable device specific services #
  ###################################

  # Enable Flatpak
  services.flatpak.enable = true;

  # Enable other architectures for emulation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Enable tailscale
  services.tailscale.enable = true;

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

  # Enable libvirtd (for Gnome Boxes)
  environment.systemPackages = [ pkgs.gnome-boxes ];
  virtualisation.libvirtd = {
    enable = true;
    qemu.ovmf.enable = true;
    qemu.ovmf.packages = [ pkgs.OVMFFull.fd ];
    qemu.swtpm.enable = true;
  };
  systemd.tmpfiles.rules =
    let
      firmware = pkgs.runCommandLocal "qemu-firmware" { } ''
        mkdir $out
        cp ${pkgs.qemu}/share/qemu/firmware/*.json $out
        substituteInPlace $out/*.json --replace ${pkgs.qemu} /run/current-system/sw
      '';
    in
    [ "L+ /var/lib/qemu/firmware - - - - ${firmware}" ];

  ####################################################
  # Configure Hardware specificities for this Laptop #
  ####################################################

  imports = [
    hardwareModules.common-cpu-intel
    hardwareModules.common-gpu-nvidia
  ];

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload.enable = true;
      offload.enableOffloadCmd = true;
    };
  };

  # Configure for intel CPU
  nixpkgs.hostPlatform = "x86_64-linux";

  boot.kernelModules = [
    "kvm-intel"
    "overlay"
    "br_netfilter"
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

  # Enable fwupd for firmware updates
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;

  #####################
  # Nix state version #
  #####################

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
