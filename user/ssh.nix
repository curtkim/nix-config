{
  programs.ssh = {
    matchBlocks = {
      "192.168.0.147" = {
        extraOptions = {
          IdentityAgent = "/run/user/1000/yubikey-agent/yubikey-agent.sock";
        };
      };
    };
  };
}
