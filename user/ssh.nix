{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
    #    extraConfig = ''
    #      Host 192.168.0.147
    #        IdentityAgent /run/user/1000/yubikey-agent/yubikey-agent.sock
    #    '';

    #    matchBlocks = {
    #      "192.168.0.147" = {
    #        extraOptions = {
    #          IdentityAgent = "/run/user/1000/yubikey-agent/yubikey-agent.sock";
    #        };
    #      };
    #    };
  };
}
