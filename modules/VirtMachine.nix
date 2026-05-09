{config, pkgs, lib, ...}:

with lib;

let
  cfg = config.modules.VirtMachine;
in {
  options.services.VirtMachine ={
    enable = mkEnableOption "Virtualization with KVM/Qemu and virt-manager";

    usuario = mkOption {
      type = types.str;
      description = "d4s";
    };
    
    runAsRoot = mkOption {
      type =types.bool;
      default = false;
      description = "Run libvirtd as root";
    };
    
    tpm = mkOption{
      type = types.bool;
      default = true;
      description = "Enable TPM for windows install";
    };
  };
  config = mkIf cfg.enable{
    boot.kernelModules = ["kvm-intel"];

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = cfg.runAsRoot;
        swtpm.enable = cfg.tpm;
      };
    };
    programs.virt-manager.enable = true;

    users.users.${cfg.d4s}.extraGroups = ["libvirtd"];
  };
}
