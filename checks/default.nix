# Checks for `nix flake check`: build the environment package plus fmt + lint gates.
#
# Auto-imported by flake.nix (no wiring needed). Flakes only see git-tracked files,
# so `git add` a new/edited file before running.
{self, ...}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    checks = {
      environment = self'.packages.environment;

      fmt =
        pkgs.runCommand "check-fmt" {
          nativeBuildInputs = [pkgs.alejandra];
        } ''
          alejandra --check ${self}
          touch $out
        '';

      # cd into the source so statix picks up ./statix.toml (which disables the
      # repeated_keys rule); running it against a path keeps the tmpdir as CWD and
      # silently falls back to default rules.
      statix =
        pkgs.runCommand "check-statix" {
          nativeBuildInputs = [pkgs.statix];
        } ''
          cd ${self}
          statix check
          touch $out
        '';
    };
  };
}
