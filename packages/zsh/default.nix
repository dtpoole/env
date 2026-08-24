{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    e = "${lib.getExe pkgs.eza} --icons --grid --group-directories-first";

    lsColors = pkgs.runCommand "ls-colors-nord" {} ''
      eval $(${pkgs.coreutils}/bin/dircolors ${./dir_colors})
      echo -n "$LS_COLORS" > $out
    '';

    zoxideInit = pkgs.runCommand "zoxide-init-zsh" {} ''
      ${lib.getExe pkgs.zoxide} init zsh --cmd cd > $out
    '';

    fzfInit = pkgs.runCommand "fzf-init-zsh" {} ''
      ${lib.getExe self'.packages.fzf} --zsh > $out
    '';

    direnvInit = pkgs.runCommand "direnv-init-zsh" {} ''
      ${lib.getExe pkgs.direnv} hook zsh > $out
    '';

    zshrc =
      pkgs.writeText "zshrc"
      # zsh
      ''
        # Must come before the NIX_PROFILES fpath loop below: this script is what
        # sets NIX_PROFILES, and `setopt no_global_rcs` (.zshenv) suppresses the
        # /etc/zshrc that would otherwise have sourced it for us.
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi

        [[ -d /run/current-system/sw ]] && NIX_PROFILES="/run/current-system/sw ''${NIX_PROFILES}"
        for profile in ''${(z)NIX_PROFILES}; do
          fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
        done

        for bindir in ''${(s.:.)NIX_EXTRA_PATHS}; do
          [[ -d "''${bindir:h}/share/zsh/site-functions" ]] && fpath+=("''${bindir:h}/share/zsh/site-functions")
        done

        [[ -d /opt/homebrew/share/zsh/site-functions ]] && fpath+=(/opt/homebrew/share/zsh/site-functions)

        fpath+=(${pkgs.pure-prompt}/share/zsh/site-functions)

        HELPDIR="${pkgs.zsh}/share/zsh/$ZSH_VERSION/help"

        export LS_COLORS="$(<${lsColors})"

        ZSH_COMPDUMP="$HOME/.cache/zsh/zcompdump"
        mkdir -p -m 700 "''${ZSH_COMPDUMP:h}"

        autoload -Uz compinit
        () {
          emulate -L zsh -o extendedglob
          if [[ -n $ZSH_COMPDUMP(#qNmh-24) ]]; then
            compinit -C -d "$ZSH_COMPDUMP"
          else
            compinit -u -d "$ZSH_COMPDUMP"
          fi
        }

        zstyle ':completion:*' menu select
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        zstyle ':completion:*' group-name ""
        zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
        zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
        zstyle ':completion:*:messages' format '%F{blue}-- %d --%f'
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        ZSH_AUTOSUGGEST_STRATEGY=(history)
        ZSH_AUTOSUGGEST_MANUAL_REBIND=1

        source ${zoxideInit}

        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
        FAST_HIGHLIGHT_STYLES[variable]='fg=#A3BE8C'
        FAST_HIGHLIGHT_STYLES[here-string-text]='fg=#4C566A'

        source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

        HISTSIZE=100000
        SAVEHIST=100000
        HISTFILE="$HOME/.local/share/zsh/history"
        mkdir -p -m 700 "''${HISTFILE:h}"

        setopt EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_ALL_DUPS
        setopt HIST_FCNTL_LOCK HIST_IGNORE_SPACE SHARE_HISTORY
        unsetopt APPEND_HISTORY HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS

        export FZF_DEFAULT_OPTS="--layout=reverse --height=20 --border --color fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C --color pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B"

        if [[ $options[zle] = on ]]; then
          source ${fzfInit}
          _zsh_autosuggest_bind_widgets
        fi

        bindkey -e
        bindkey '^ ' autosuggest-accept
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down

        # Machine-local dirs go last: /usr/local/bin and /opt/homebrew/bin are
        # group-writable by admin, and anything there shadowing a wrapped tool would
        # defeat the point of pinning them.
        path=(
          $path
          $HOME/.local/bin
          $HOME/bin
          $HOME/.cargo/bin
          /usr/local/bin
          /usr/local/sbin
          /opt/homebrew/bin
        )

        # `cd ""` is a silent no-op in zsh, so an unguarded `cd "$(mktemp -d)"` would
        # leave us in $PWD and chmod -R the tree we were standing in.
        tempe () {
          local tmp
          tmp=$(mktemp -d) || return 1
          cd "$tmp" || return 1
          chmod -R 0700 .
          if [[ $# -eq 1 ]]; then
            \mkdir -p "$1" || return 1
            cd "$1" || return 1
            chmod -R 0700 .
          fi
          pwd
        }

        autoload -U promptinit && promptinit
        zstyle :prompt:pure:path color '#88C0D0'
        zstyle :prompt:pure:user color '#8FBCBB'
        zstyle :prompt:pure:user:root color '#8FBCBB'
        zstyle :prompt:pure:host color '#8FBCBB'
        zstyle :prompt:pure:execution_time color '#D08770'
        zstyle :prompt:pure:git:branch color '#3B4252'
        zstyle :prompt:pure:git:branch:cached color '#3B4252'
        zstyle :prompt:pure:git:dirty color '#3B4252'
        zstyle :prompt:pure:git:arrow color '#3B4252'
        zstyle :prompt:pure:git:stash color '#3B4252'
        zstyle :prompt:pure:prompt:success color '#A3BE8C'
        zstyle :prompt:pure:prompt:error color '#BF616A'
        prompt pure
        # state[username]; zsh single-pass prompt-subst won't re-expand them.
        # Force re-eval so user/host zstyle colors apply.
        PROMPT=''${PROMPT/$'\x24{prompt_pure_state[username]}'/$'\x24{(e)prompt_pure_state[username]}'}
        PROMPT="%B''${PROMPT}%b"
        source ${direnvInit}

        alias cls=clear
        alias dc='docker compose'
        alias destroy_ds='find . -type f \( -name .DS_Store -o -name "._*" \) -delete'
        alias df='df -h'
        alias dtail="docker logs -tf --tail='30'"
        alias du='du -h'
        alias grep='grep --color=auto'
        alias h='history -E'
        alias ip='ip --color=auto'
        alias j=jobs
        alias l='${e}'
        alias la='${e} -la'
        alias ll='${e} -l'
        alias ln='ln -v'
        alias ls='${e}'
        alias lt='${e} -snew -rl'
        alias more=less
        alias tree='${lib.getExe pkgs.eza} --tree'
        alias vi=nvim
        alias vim=nvim
        alias vimdiff='nvim -d'
      '';

    zshenv =
      pkgs.writeText "zshenv"
      # zsh
      ''
        # Set here rather than in .zshrc: .zshenv runs for non-interactive shells too,
        # and without dedup PATH grows on every nested `zsh -c`. Note the prepend below
        # goes through the `path` array, not the PATH scalar -- `typeset -U` only
        # dedupes on array assignment.
        typeset -U path cdpath fpath manpath
        [[ -n "$NIX_EXTRA_PATHS" ]] && path=(''${(s.:.)NIX_EXTRA_PATHS} $path)
        setopt no_global_rcs
        skip_global_compinit=1
      '';

    zdotdir = pkgs.runCommand "zsh-zdotdir" {} ''
      mkdir $out
      ln -s ${zshrc} $out/.zshrc
      ln -s ${zshenv} $out/.zshenv
    '';
  in {
    packages.zsh = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      runtimeInputs = [
        pkgs.direnv
        pkgs.zoxide
      ];
      package = pkgs.zsh;
      env = {
        ZDOTDIR = "${zdotdir}";
      };
    };
  };
}
