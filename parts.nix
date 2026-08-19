{inputs, ...}: {
  imports = [
    inputs.wrapper-modules.flakeModules.wrappers

    # needed for neovim configs
    inputs.flake-parts.flakeModules.modules
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}
