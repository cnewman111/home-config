{ ... }:

{
  programs.claude-code = {
    enable = true;
    settings = {
      model = "opus";
      theme = "dark";
      editorMode = "vim";
    };
  };
}
