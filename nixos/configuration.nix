{ config, pkgs, inputs, ... }:

let
  # Separate package set from the pinned nixpkgs
  pkgs-godot = import inputs.nixpkgs-godot {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
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

  # Pass pkgs-godot to other modules through _module.args
  _module.args = { inherit pkgs-godot; };

  system.stateVersion = "26.05";
}
