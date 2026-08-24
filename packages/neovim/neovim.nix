{
  inputs,
  self,
  ...
}: {
  flake.modules.neovim.main = {pkgs, ...}: {
    settings.config_directory = ./.;

    hosts = {
      ruby.nvim-host.enable = false;
      node.nvim-host.enable = false;
      python3.nvim-host.enable = false;
    };

    specs = {
      init = {
        data = null;
        before = ["MAIN_INIT"];
        config = "require('init')";
      };

      plugins = {
        data = [
          pkgs.vimPlugins.lz-n
          pkgs.vimPlugins.plenary-nvim
          pkgs.vimPlugins.nvim-web-devicons
          {
            data = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
              with p; [
                bash
                markdown
                markdown_inline
                yaml
                nix
                lua
                python
                rust
                sql
                typescript
              ]);
          }
        ];
      };

      # `lazy` here is placement, not deferral: it puts the plugin in pack/../opt
      # instead of pack/../start, so nvim does not auto-add it to runtimepath and
      # lz.n's packadd is the only thing that does. Anything with an lz.n spec in
      # lua/plugins/ belongs here -- left in `plugins` it lands on runtimepath twice,
      # which breaks runtime-file lookups that expect one hit per file.
      #
      # nord/lualine still load at startup; their lz.n specs set lazy = false.
      lazyPlugins = {
        lazy = true;
        data = [
          pkgs.vimPlugins.oil-nvim
          pkgs.vimPlugins.telescope-nvim
          pkgs.vimPlugins.nord-nvim
          pkgs.vimPlugins.lualine-nvim
        ];
      };
    };
  };

  perSystem = {pkgs, ...}: {
    packages.neovim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
      imports = [
        self.modules.neovim.main
        self.modules.neovim.lua
        self.modules.neovim.nix
      ];
    };

    packages.neovimFull = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
      imports = [
        self.modules.neovim.main
        self.modules.neovim.allServers
      ];
    };
  };
}
