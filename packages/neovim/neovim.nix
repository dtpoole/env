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
          pkgs.vimPlugins.nord-nvim
          pkgs.vimPlugins.lualine-nvim
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

      lazyPlugins = {
        lazy = true;
        data = [
          pkgs.vimPlugins.oil-nvim
          pkgs.vimPlugins.telescope-nvim
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
