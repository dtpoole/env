{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.git = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.git;
      env = {
        GIT_AUTHOR_NAME = "David Poole";
        GIT_AUTHOR_EMAIL = "dtpoole@users.noreply.github.com";
        GIT_COMMITTER_NAME = "David Poole";
        GIT_COMMITTER_EMAIL = "dtpoole@users.noreply.github.com";
      };
    };
  };
}
