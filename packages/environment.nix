{
  lib,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    runtimeInputs = [
      pkgs.file
      pkgs.unzip
      pkgs.zip
      pkgs.p7zip
      pkgs.wget
      pkgs.killall
      pkgs.htop
      pkgs.fd
      pkgs.dua
      pkgs.dust
      pkgs.ripgrep
      pkgs.lazygit
      pkgs.just
      pkgs.parallel
      pkgs.tldr
      pkgs.zoxide

      # completions
      pkgs.zsh-completions

      # wrapped
      self'.packages.bat
      self'.packages.btop
      self'.packages.fzf
      self'.packages.git
      self'.packages.neovim
      self'.packages.tmux
    ];
  in {
    # primary shell with packages
    packages.default = self'.packages.environment;

    # wrapPackage inherits the wrapped package's name, so without the rename this
    # lands in `nix profile list` as "zsh" and collides with packages.zsh.
    packages.environment =
      (inputs.wrappers.lib.wrapPackage {
        inherit pkgs runtimeInputs;
        package = self'.packages.zsh;
        env = {
          EDITOR = "nvim";
          NIX_EXTRA_PATHS = lib.makeBinPath runtimeInputs;
        };
      })
      .overrideAttrs (old: {
        name = "environment";
        meta = old.meta // {mainProgram = "zsh";};
      });
  };
}
