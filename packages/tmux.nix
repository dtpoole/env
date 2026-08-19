{
  perSystem = {pkgs, ...}: let
    tmuxConf = pkgs.writeText "tmux.conf" ''
      set -g history-limit 10000
      setw -g mouse on
      set -g prefix C-a
      unbind C-b

      bind a send-prefix
      bind-key C-a last-window
      bind-key S command-prompt -p ssh: "new-window -n %1 'ssh %1'"

      run-shell ${pkgs.tmuxPlugins.nord.rtp}
    '';
  in {
    packages.tmux = pkgs.symlinkJoin {
      name = "tmux";
      paths = [pkgs.tmux];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/tmux \
          --add-flags "-f ${tmuxConf}"
      '';
    };
  };
}
