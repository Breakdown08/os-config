{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # AI agents: Claude Code + Codex CLI
    llm-agents = {
      # own nixpkgs, not follows: packages then match cache.numtide.com and are not built locally
      url = "github:numtide/llm-agents.nix";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
      specialArgs = { inherit inputs; };
    };
  };
}
