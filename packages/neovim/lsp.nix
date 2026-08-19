{self, ...}: {
  flake.modules.neovim = {
    lua = {pkgs, ...}: {
      runtimePkgs = [
        pkgs.lua-language-server
      ];

      specs.lua-language-server = {
        data = [
          pkgs.vimPlugins.nvim-lspconfig
          pkgs.vimPlugins.blink-cmp
        ];
        config = ''vim.lsp.enable("lua_ls")'';
      };
    };

    nix = {pkgs, ...}: {
      runtimePkgs = [
        pkgs.nixd
        pkgs.alejandra
      ];

      specs.nix = {
        data = [pkgs.vimPlugins.nvim-lspconfig];
        config =
          #lua
          ''
            vim.lsp.config("nixd", {
              cmd = { "nixd" },
              settings = {
                nixd = {
                  nixpkgs = {
                    expr = "import <nixpkgs> { }",
                  },
                  formatting = {
                    command = { "alejandra" },
                  },
                },
              },
            })
            vim.lsp.enable("nixd")
          '';
      };
    };

    rust = {pkgs, ...}: {
      runtimePkgs = [pkgs.rust-analyzer];

      specs.rust = {
        data = [pkgs.vimPlugins.nvim-lspconfig];
        config =
          #lua
          ''
            vim.lsp.enable("rust_analyzer")
          '';
      };
    };

    toml = {pkgs, ...}: {
      runtimePkgs = [pkgs.taplo];

      specs.toml = {
        data = [pkgs.vimPlugins.nvim-lspconfig];
        config =
          #lua
          ''
            vim.lsp.enable("taplo")
          '';
      };
    };

    yaml = {pkgs, ...}: {
      runtimePkgs = [pkgs.yaml-language-server];

      specs.yaml = {
        data = [pkgs.vimPlugins.nvim-lspconfig];
        config =
          #lua
          ''
            vim.lsp.enable("yamlls")
          '';
      };
    };

    ts = {pkgs, ...}: {
      runtimePkgs = [pkgs.typescript-language-server];

      specs.typescript = {
        data = [pkgs.vimPlugins.nvim-lspconfig];
        config =
          #lua
          ''
            vim.lsp.enable("ts_ls")
          '';
      };
    };

    bash = {pkgs, ...}: {
      runtimePkgs = [pkgs.bash-language-server];

      specs.bash = {
        data = [pkgs.vimPlugins.nvim-lspconfig];
        config =
          #lua
          ''
            vim.lsp.enable("bashls")
          '';
      };
    };

    python = {pkgs, ...}: {
      runtimePkgs = [pkgs.pyright];

      specs.python = {
        data = [pkgs.vimPlugins.nvim-lspconfig];
        config =
          #lua
          ''
            vim.lsp.enable("pyright")
          '';
      };
    };

    allServers = {
      imports = [
        self.modules.neovim.lua
        self.modules.neovim.nix
        self.modules.neovim.rust
        self.modules.neovim.toml
        self.modules.neovim.yaml
        self.modules.neovim.ts
        self.modules.neovim.bash
        self.modules.neovim.python
      ];
    };
  };
}
