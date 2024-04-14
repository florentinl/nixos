{
  pkgs,
  lib,
  ...
}: let
  qemu-static-derivation = {
    stdenv,
    fetchurl,
    dpkg,
    ...
  }:
    stdenv.mkDerivation {
      name = "qemu-static";
      pname = "qemu-static";

      dontPatchELF = true;
      dontConfigure = true;
      dontPatch = true;

      src = fetchurl {
        url = "http://ftp.fr.debian.org/debian/pool/main/q/qemu/qemu-user-static_9.0.0~rc2+ds-1_amd64.deb";
        sha256 = "sha256-JrYf2oKUCIptqllolzPhOopVuSEfATPo+fi2bjDlQl4=";
      };

      unpackPhase = ''
        mkdir -p $out

        ${dpkg}/bin/dpkg-deb -x $src $out
      '';
    };

  qemu-static = pkgs.callPackage qemu-static-derivation {};
in {
  ###################################
  # Enable device specific services #
  ###################################

  # Enable binfmt for aarch64
  environment.systemPackages = [
    qemu-static
  ];

  boot.binfmt.registrations."arm64-linux" = {
    interpreter = "${qemu-static}/usr/bin/qemu-aarch64-static";
    magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00'';
    mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff'';
    fixBinary = true;
    matchCredentials = true;
    wrapInterpreterInShell = false;
  };

  # Let's go wayland ozone on this one
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  ####################################################
  # Configure Hardware specificities for this Laptop #
  ####################################################

  # Configure for intel CPU
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = ["kvm-intel" "overlay" "br_netfilter"];
  boot.kernelParams = ["mem_sleep_default=deep"];

  # Enable kernel modules for peripherics
  boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["i915"];
  boot.extraModulePackages = [];

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

  swapDevices =
    lib.mkForce
    [
      {device = "/dev/mapper/luks-b63628b5-e216-43a4-8758-9ef72942d4c1";}
    ];

  boot.initrd.luks.devices."luks-b63628b5-e216-43a4-8758-9ef72942d4c1".device = "/dev/disk/by-uuid/b63628b5-e216-43a4-8758-9ef72942d4c1";
  boot.resumeDevice = "/dev/mapper/luks-b63628b5-e216-43a4-8758-9ef72942d4c1";

  # Configure Finger Print Reader
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # Configure integrated GPU
  environment.variables = {
    VDPAU_DRIVER = lib.mkDefault "va_gl";
  };

  hardware.opengl.extraPackages = with pkgs; [
    intel-vaapi-driver
    libvdpau-va-gl
    intel-media-driver
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = false;
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
  services.xserver.videoDrivers = ["nvidia"];
}
