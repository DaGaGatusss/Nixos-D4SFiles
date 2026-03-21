{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration  = true;
    shellWrapperName = "y";
    
    initLua = ''
      require("starship"):setup()
    '';

    settings = {
      mgr = {
        show_hidden    = false;
        show_symlink   = true;
        sort_by        = "extension";
        sort_dir_first = true;
      };

      preview = {
        image_filter  = "lanczos3";
        image_quality = 90;
        max_width     = 1000;
        max_height    = 1000;
        pdf_pages     = 5;
      };
    };

#    keymap = {
#      manager.prepend_keymap = [
#        { on = [ "g" "l" ]; run = "plugin lazygit"; desc = "Abrir lazygit"; }
#        { on = [ "S" ];     run = "plugin sudo";    desc = "Abrir con sudo"; }
#      ];
#    };

    theme = {
      manager = {
        cwd             = { fg = "cyan"; };
        hovered         = { fg = "black"; bg = "lightblue"; bold = true; };
        preview_hovered = { underline = true; };
        find_keyword    = { fg = "yellow"; bold = true; italic = true; };
        find_position   = { fg = "magenta"; bold = true; };
        marker_selected = { fg = "white"; bg = "green"; };
        marker_copied   = { fg = "white"; bg = "yellow"; };
        marker_cut      = { fg = "white"; bg = "red"; };
      };
    };
  };

  # Plugins
  home.file = {
    ".config/yazi/plugins/starship.yazi".source = pkgs.yaziPlugins.starship;
    ".config/yazi/plugins/lazygit.yazi".source  = pkgs.yaziPlugins.lazygit;
    ".config/yazi/plugins/sudo.yazi".source      = pkgs.yaziPlugins.sudo;
  };

  # Dependencias para previews
  home.packages = with pkgs; [
    poppler-utils
    ffmpegthumbnailer
    unar
    jq
    fd
    zoxide
  ];
}
