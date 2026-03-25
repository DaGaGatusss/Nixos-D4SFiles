{config, pkgs, ...}:
{
  imports =
    [
      ./hardware-configuration.nix
    ];
  #Experimental Feactures
  nix.settings.experimental-features = ["nix-command" "flakes"];
  #Nix Steore Optimice $ GC
    nix = {
      settings ={
        auto-optimise-store = true;
      };
      gc = {
        automatic = true;
        dates = "monthly";
        options = "--delete-older-than 30d";
      };
    };
  #Bootloader
  boot.loader = {
    systemd-boot.enable =true;
    efi.canTouchEfiVariables = true;
  };

  boot.supportedFilesystems = ["exfat"];
  # Mount filesystems exfat external disks
  fileSystems."/mnt/fujitsu" = {
    device = "/dev/disk/by-uuid/FF5D-B3F9";
    fsType = "exfat";
    options = ["nofail" "uid=1000" "gid=1000"];
  };

  #Kernel modules
boot.extraModulePackages = with config.boot.kernelPackages;
  [ v4l2loopback.out ];
    boot.kernelModules = [
    "v4l2loopback"
    "snd-aloop"
  ];
  boot.extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=0 card_label="DroidCam" exclusive_caps=1
    '';

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
  };
  
# Networking
  networking = {
    hostName = "Nxo";
    firewall = {
      enable = true;
      allowedTCPPorts =[];
      allowedUDPPorts =[];
    };
    networkmanager = {
      enable = true;
      wifi = {
        scanRandMacAddress = true;
        macAddress = "random";
        powersave = true; 
      };
    };
  };
  # Local and Timee
  time.timeZone = "America/Lima";
  i18n.defaultLocale = "en_GB.UTF-8";
  # keyboard (X11)
  services.xserver.xkb = {
    layout = "us,latam";
    variant = "";
    options = "grp:alt_shift_toggle";
  };
  #x11 and i3
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+i3";
    };
  };
  #Security and Polkit
  security = {
    polkit.enable = true;
    protectKernelImage = true;
  };
  #Shell: zsh
    programs.zsh = {
    enable = true;
     };

  #dconf (necesario para GTK apps)
    programs.dconf.enable = true;
  #Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;
  #Printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr pkgs.epson-escpr2 ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  #storage and file management
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  #Flatpak and XDG Portals
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  #Users
  users.users.d4s = {
    isNormalUser = true;
    description = "D4S";
    extraGroups = [ "networkmanager" "wheel" "users" "video" ];
    shell = pkgs.zsh;
    # Los paquetes de usuario ahora van en home.nix
  };
  environment.systemPackages = with pkgs; [
    brightnessctl
    git      
    wget
    ntfs3g
    udisks    # gestión de discos (nivel sistema)
    usbutils  # lsusb, etc.
    bluez     # stack bluetooth (nivel sistema)
    bluez-tools
    pulseaudio
    pulseaudioFull
    epson-escpr  # driver impresora (nivel sistema)
    helix
    exfatprogs
  ];

  environment.variables = {
    PATH = "/run/current-system/sw/bin";
  };
# Unfree Packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
