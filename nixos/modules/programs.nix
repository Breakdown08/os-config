{ config, pkgs, ... }:

{
  programs.firefox.enable = true;
  programs.yazi.enable = true;

  # nvim is $EDITOR: yazi, git commit and sudoedit open it
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.obs-studio.enable = true;

  programs.nix-ld = {
    enable = true;
  };

  # Project secrets: secrets/ at the repository root, see the README
  programs.direnv.enable = true;
}
