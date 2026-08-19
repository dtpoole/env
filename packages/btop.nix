{
  flake.wrappers.btop = {wlib, ...}: {
    imports = [wlib.wrapperModules.btop];
    settings.color_theme = "nord";
  };
}
