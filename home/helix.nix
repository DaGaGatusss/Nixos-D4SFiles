{ config, pkgs, ... }:

{
  programs.helix = {
    enable = true;
  settings = {
    theme = "ao";
    editor.clipboard-provider = "x-clip";
    editor.cursor-shape = {
      normal ="block";
      insert = "bar";
      select = "underline";
    };
  };  
};
}
