# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, hostname, user, ... }:

{
  imports = [
    ./boot.nix
    # ./gnome.nix
    ./hyprland.nix
    ./locals.nix
    ./nix.nix
    ./pipewire.nix
  ];

  # Set user
  users.users.user = user;

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

  # Set default shell to zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Enable Home-Manager
  environment.systemPackages = with pkgs; [
    home-manager
    # microsoft-edge
  ];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = hostname;
  networking.useDHCP = lib.mkDefault true;

  # Enable OpenGL acceleration
  hardware.opengl.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Keep the system updated
  services.fwupd.enable = true;
  system.autoUpgrade.enable = true;
}
