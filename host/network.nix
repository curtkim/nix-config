{

  # Enable networking
  networking.networkmanager.enable = true;
  networking.nftables.enable = true;


  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 
      80 443 8096 8200 8920 
      111 2049 4000 4001 4002 20048 # nfs
      3000  # dev server
      8211  # issac-sim
      11434 # ollama
    ];
    allowedTCPPortRanges = [
      { from = 1400; to = 1499;}    # soco-cli
      { from = 54000; to = 54099;}  # soco-cli
    ];

    allowedUDPPorts = [ 
      111 2049 4000 4001 4002 20048 # nfs
      8200  # for minidlna
      8211  # issac-sim
    ];     
    allowedUDPPortRanges = [
      #{ from = 631; to = 631; }
      { from = 4000; to = 4007; }
      { from = 8000; to = 8010; }
      { from = 51413; to = 51413; } # for transmission
    ];
  };

}
