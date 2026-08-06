{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Colin Newman";
      user.email = "54.central-view@icloud.com";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      core.editor = "nvim";
      diff.tool = "nvimdiff";
      difftool.nvimdiff.cmd = ''nvim -d "$LOCAL" "$REMOTE"'';
      difftool.prompt = false;
    };
  };

  programs.gh.enable = true;
}
