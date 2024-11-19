{config, ...}: {
  programs.ssh = {
    enable = true;
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
