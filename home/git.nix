{ config, pkgs, ... }:
{
  
programs.git = {
  enable  = true;
  userName = "d4s";
  userEmail = "dsgarciacv@gmail.com";
  extraConfig ={
    init.defaulBranch = "main";
    push.autoSetupRemote = true;
    core.editor = "hx";
  };
  aliases = {
    st = "status";
    lg = "log --oneline --graph";
  };
};

programs.lazygit = {
  enable = true;
  settings = {
    gui.theme = {
      activeBorderColor = ["cyan" "bold"];
      inactiveBorderColor = ["white"];
      selectedLineBgColor = ["blue"];
    };
    git.autoFetch = true;
  };
};

programs.ssh = {
  enable = true;
  matchBlocks."github.com" = {
    identityFile = "~/.ssh/id_ed25519";
  };
};
}
