{ config, pkgs, ...}:

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
    #Leguajes
    python3
    gcc
    #Terminal ultis
    tree
    starship
    fd
    fastfetch
    yazi          # file manager TUI
    android-tools # adb, fastboot
    #Desktop
    viewnior
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
    riseup-vpn
    #i3-utils
    rofi
    picom
    btop
    dmenu
    i3status
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
    vlc
    thunderbird
    obs-studio
    pcmanfm
    kdePackages.kdenlive
    gimp3-with-plugins
    inkscape
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
    # Puedes agregar aliases aquí en el futuro:
    # shellAliases = {
    #   ll = "eza -la";
    #   cat = "bat";
    # };
  # ── Git ───────────────────────────────────────────────────────────────>
  # Configura aquí tus datos si aún no tienes ~/.gitconfig
  # programs.git = {
  #   enable = true;
  #   userName = "Tu Nombre";
  #   userEmail = "tu@email.com";
  # };
  # ── Kitty ─────────────────────────────────────────────────────────────>
  # Si en el futuro quieres manejar la config de kitty desde home-manager:
  # programs.kitty = {
  #   enable = true;
  #   font.name = "JetBrainsMono Nerd Font";
  #   font.size = 12;
  #   theme = "Tokyo Night";
  # };
  # ── Variables de entorno de usuario ───────────────────────────────────>
  home.sessionVariables = {
    EDITOR = "helix";   # helix como editor por defecto
    };
}
