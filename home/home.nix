{ pkgs, ...}:

{
  imports = [
    ./helix.nix
    ./yazi.nix
    ./git.nix
    ./i3.nix
    ./i3blocks.nix
  ];
  home.username = "d4s";
  home.homeDirectory = "/home/d4s";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  
  home.packages = with pkgs;[
    #Editores de Codigo
    helix
    lazygit
    vscode
    gh
    jetbrains.idea-oss
    #Leguajes
    python3
    gcc
    jdk25
    rustc
    cargo
    rust-analyzer
    #Terminal ultis
    tree
    lshw
    bc
    starship
    fd
    fastfetch
    yazi          # file manager TUI
    android-tools # adb, fastboot
    #Desktop
    nitrogen
    arandr 
    #Audio
    pavucontrol
    #Click board
    copyq
    xclip
    xorg.setxkbmap
    xorg.xkbcomp
    # Compress and Uncompres
    unzip
    gnutar
    gzip
    bzip2
    xz
    p7zip
    unrar
    zip
    zstd
    #Trumbnails
    poppler-utils
    ffmpegthumbnailer
    #Notas and office
    zathura
    obsidian
    gromit-mpx
    #Terminal and shell
    kitty
    #Navigate and vpn
    firefox
    chromium
    #i3-utils
    rofi
    picom
    btop
    dmenu
    i3lock
    i3blocks
    libnotify
    dunst
    brightnessctl
    flameshot
    redshift
    #clound (Mega)
    megasync
    megatools
    #Media and comunications
    keepassxc
    zoom-us
    droidcam
    mpv
    ##Scaner
    simple-scan
    viewnior
    yt-dlp
    thunderbird
    obs-studio
    kdePackages.kdenlive
    gimp3-with-plugins
    inkscape
    godotPackages_4_6.godot
  ];
  
  #zsh
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;    # nombre correcto en home-manager
    syntaxHighlighting.enable = true;
    oh-my-zsh = {                    # nombre correcto en home-manager
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "robbyrussell";
    };
  };
  # Starship shell
    programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };
    programs.lazygit = {
      enable = true;
    };
  # ── Variables de entorno de usuario ───────────────────────────────────>
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    };
}
              
