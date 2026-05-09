{config,lib,pkgs,...}:

let 
  cfg = config.gaming.steam;
in {
  options.gaming.steam = {
     enable = lib.mkEnableOption "Steam con soporte para gaming";
     gpu = lib.mkOption {
      type    = lib.types.enum [ "amd" "nvidia" "intel" ];
      default = "amd";
      description = "Tipo de GPU para cargar los drivers correctos.";
  };
  proton = lib.mkOption {
      type    = lib.types.bool;
      default = true;
      description = "Activar Proton para jugar juegos de Windows.";
  };
  extraPaquetes = lib.mkOption {
      type    = lib.types.listOf lib.types.package;
      default = [];
      description = "Paquetes adicionales de gaming (ej: lutris, heroic).";
  };
};

## Cuando el modulo esta activo
config = lib.mkIf cfg.enable {

    #soporte 32-bit
    hardware.opengl = {
      enable      = true;
      driSupport   = true;
      driSupport32Bit = true;
    };

    # Drivers GPU
    hardware.opengl.extraPackages = lib.mkMerge [
     # (lib.mkIf (cfg.gpu == "amd")    [ pkgs.amdvlk pkgs.rocmPackages.clr ])
     # (lib.mkIf (cfg.gpu == "nvidia") [ pkgs.linuxPackages.nvidia_x11 ])
      (lib.mkIf (cfg.gpu == "intel")  [ pkgs.intel-media-driver ])
    ];

    # Steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    # Proton 
    environment.systemPackages = lib.mkMerge [
      (lib.mkIf cfg.proton [
        pkgs.protonup-qt    # Gestor de versiones
        pkgs.wine
      ])
      (lib.mkIf cfg.controladores [
        pkgs.game-devices-udev-rules  # reglas udev para mandos
        pkgs.xboxdrv                  # driver Xbox
      ])
      cfg.extraPaquetes
    ];

    # GameMode: optimice
      programs.gamemode.enable = true;

    # Permisos udev para mandos
      services.udev.packages = lib.mkIf cfg.controladores [
      pkgs.game-devices-udev-rules
    ];
  };
}
