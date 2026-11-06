{ config, pkgs, ... }:

{
  programs.firefox.enable = true;
  programs.yazi.enable = true;
  programs.obs-studio.enable = true;

  programs.nix-ld = {
    enable = true;
  };

  # Project secrets: secrets/ at the repository root, see the README
  programs.direnv.enable = true;
}
