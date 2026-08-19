{
  inputs,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.fzf = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      runtimeInputs = [
        pkgs.fd
      ];
      package = pkgs.fzf;
      env = {
        "FZF_DEFAULT_COMMAND" = "${lib.getExe pkgs.fd} --type f";
      };
    };
  };
}
