{ config, pkgs, inputs, ... }:

{
  imports = [
    ./modules/hardware-configuration.nix
    ./modules/system.nix
    ./modules/desktop.nix
    ./modules/users.nix
    ./modules/programs.nix
    ./modules/packages.nix
    ./modules/ai-agents.nix
  ];

  system.stateVersion = "26.05";
}
