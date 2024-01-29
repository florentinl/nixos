# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./gnome.nix
    ./locals.nix
    ./pipewire.nix
    ./nix.nix
  ];


  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "nixos";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  programs.steam.enable = true;
  programs.zsh.enable = true;
}
