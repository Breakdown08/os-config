{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.llm-agents.packages.${pkgs.system}.claude-code
    inputs.llm-agents.packages.${pkgs.system}.codex
  ];
}
