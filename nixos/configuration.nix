{ config, pkgs, inputs, ... }:

let
  # Отдельный набор пакетов из зафиксированного nixpkgs
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
  ];

  # Передаём pkgs-godot в другие модули через _module.args
  _module.args = { inherit pkgs-godot; };

  system.stateVersion = "26.05";
}
