{ config, pkgs, ... }:
{
  
programs.git = {
  enable  = true;
  settings = {
      alias = {
        st = "status";
        lg = "log --oneline --graph";
       };
      user.name = "d4s";
      user.email = "dsgarciacv@gmail.com";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      core.editor = "hx";  
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
  enableDefaultConfig = false;
  enable = true;
  matchBlocks."github.com" = {
    identityFile = "~/.ssh/id_ed25519";
  };
};
}
