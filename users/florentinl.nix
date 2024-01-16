{ config, pkgs, ... }:

{
  users.users.florentinl = {
    isNormalUser = true;
    description = "Florentin Labelle";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      alacritty
      git
      microsoft-edge
      enpass
      vscode
      neovim
      zsh
    ];
  };
}