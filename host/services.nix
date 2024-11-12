{

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.pcscd.enable = true;
  services.yubikey-agent.enable = true;   # pcscd이 필요하다

  #  services.avahi = {
  #    enable = true;
  #    nssmdns4 = true;
  #    openFirewall = true;
  #    publish = {
  #      enable = true;
  #      userServices = true;
  #    };
  #  };

}
