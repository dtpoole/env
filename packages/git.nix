{
  perSystem = {pkgs, ...}: let
    gitConfig = pkgs.writeText "gitconfig" ''
      [user]
        name = David Poole
        email = dtpoole@users.noreply.github.com
    '';
  in {
    # Identity goes in system-scope config, not GIT_AUTHOR_*/GIT_COMMITTER_* env vars:
    # env vars outrank even repo-local .git/config, so they silently hijack commits in
    # any repo with its own user.email. System scope is the lowest precedence, so
    # ~/.gitconfig and per-repo config both override it.
    #
    # Wrap only bin/git. git-upload-pack and git-receive-pack are symlinks to git and
    # rely on argv[0] dispatch, which an exec'ing shell wrapper destroys.
    packages.git = pkgs.symlinkJoin {
      name = "git";
      paths = [pkgs.git];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/git \
          --set-default GIT_CONFIG_SYSTEM ${gitConfig}
      '';
    };
  };
}
