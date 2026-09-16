{ config, pkgs, ... }:

{
  programs.firefox.enable = true;
  programs.yazi.enable = true;

  programs.nix-ld = {
    enable = true;
  };

  environment.variables = {
    NB_MANAGEMENT_URL = "https://vpn.example.com:443";
  };

  environment.etc."profile.d/load-user-profile.sh" = {
    text = ''
      if [ -f "$HOME/.profile" ]; then
        set -a
        source "$HOME/.profile"
        set +a
      fi
    '';
    mode = "0755";
  };
}
