# env

Portable shell environment as a Nix flake: a wrapped zsh with a Nord-themed
prompt, neovim, and the CLI tools I expect on any machine. Each tool is a self-contained wrapped package carrying its own config.

## Install

```sh
nix profile add github:dtpoole/env#environment
```

Or run it without installing:

```sh
nix run github:dtpoole/env#environment
```

## Packages

| Output | What it is |
| --- | --- |
| `environment` | zsh + every tool below on `PATH`. This is the one you want. |
| `zsh` | Wrapped zsh: pure prompt, completions, history, direnv/zoxide/fzf integration |
| `neovim` | Neovim with lua + nix language servers |
| `neovimFull` | Neovim with all configured language servers |
| `bat` `btop` `fzf` `git` `tmux` | Individually wrapped, Nord-themed |

Nothing here reads `$HOME` state at build time, so it behaves identically on
NixOS, nix-darwin, or a bare `nix profile install`.

## Use as a flake input

```nix
{
  inputs.env = {
    url = "github:dtpoole/env";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Then reference `inputs.env.packages.${system}.environment` — e.g. as a login shell.

## License

MIT
