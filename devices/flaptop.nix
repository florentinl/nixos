{ config, pkgs, lib, ... }:

{
  # Configure Laptop Users
  users.users.florentinl = {
    isNormalUser = true;
    description = "Florentin Labelle";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Set default shell to zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Configure for intel CPU
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [ "i915.force_probe=46a6" "mem_sleep_default=deep" ];

  # Enable kernel modules for peripherics
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Configure suspend-then-hibernate
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendState=mem
    AllowSuspendThenHibernate=yes
  '';

  services.logind = {
    suspendKey = "suspend-then-hibernate";
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "suspend-then-hibernate";
  };

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
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Configure Nvidia Graphic Card
  /* hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    };

    hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  }; */
}
