{ pkgs, ... }:

{
    programs.zsh = {
        enable = true;
        autocd = true;
        enableCompletion = true;
        # enableAutosuggestions = true;

        initExtra = ''
          export STARSHIP_CONFIG=/etc/nixos/homes/florentinl/dotfiles/starship.toml
          eval "$(starship init zsh)"
        '';

        oh-my-zsh = {
            enable = true;
            plugins = [
                "git"
                "fzf"
            ];
        };
    };

    programs.fzf = {
        enable = true;
        enableZshIntegration = true;
    };
}