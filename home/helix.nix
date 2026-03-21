{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "ao";
      editor.clipboard-provider = "x-clip";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
  };

  home.packages = with pkgs; [
  #  rust-analyzer
    nil
    pyright
    nodePackages.typescript-language-server
    bash-language-server
    clang-tools
    ty
    marksman
    yaml-language-server
  ];
}
