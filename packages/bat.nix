{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    wlib = inputs.wrapper-modules.lib;
    batConfig = pkgs.writeText "bat-config" ''
      --italic-text=always
      --tabs=2
      --theme=Nord
    '';
  in {
    packages.bat = wlib.wrapPackage {
      inherit pkgs;
      package = pkgs.bat;
      escapingFunction = wlib.escapeShellArgWithEnv;
      env = {
        "BAT_CONFIG_PATH" = "${batConfig}";
      };
    };
  };
}
