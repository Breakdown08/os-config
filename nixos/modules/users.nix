{ config, pkgs, ... }:

{
  users.users."breakdown" = {
    isNormalUser = true;
    description = "breakdown";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      # thunderbird
    ];
  };
}
