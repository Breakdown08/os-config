{
  description = "NixOS configuration with pinned Godot 4.5.1";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Коммит с Godot 4.5.1 (16 сентября 2026)
    nixpkgs-godot = {
      url = "github:NixOS/nixpkgs/be3dab5b1a3c41ed2db86093b9f4e048305630b7";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-godot, ... }@inputs: {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
      specialArgs = { inherit inputs; };
    };
  };
}
