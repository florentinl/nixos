{ pkgs, ... }:

{
    programs.zsh = {
        enable = true;
        autocd = true;
        enableCompletion = true;
        # enableAutosuggestions = true;

        initExtra = ''
          export EDITOR=nvim
          export STARSHIP_CONFIG=/etc/nixos/homes/florentinl/dotfiles/starship.toml
          eval "$(starship init zsh)"

          export LIBCLANG_PATH=${pkgs.llvmPackages.libclang.lib}/lib
        '';

        shellAliases = {
            # Eza
            ll = "eza -lhF";
            l = "eza -alhF";
            # Bat
            cat = "${pkgs.bat}/bin/bat";

            # NixOS
            nixos = "sudo nixos-rebuild switch";
        };

        oh-my-zsh = {
            enable = true;
            plugins = [
                "git"
                "fzf"
            ];
        };
    };

    programs.bat.enable = true;
    programs.eza.enable = true;

    programs.fzf = {
        enable = true;
        enableZshIntegration = true;
    };
}