{

  # Enable networking
  networking.networkmanager.enable = true;
  networking.nftables.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 8096 8920 ];
    allowedUDPPortRanges = [
      #{ from = 631; to = 631; }
      { from = 4000; to = 4007; }
      { from = 8000; to = 8010; }
      { from = 51413; to = 51413; } # for transmission
    ];
  };

}
