{
  # nfs
  fileSystems = {
    "/mnt/data" = {
      device = "192.168.0.239:/data";
      fsType = "nfs";
      options = [
        "vers=3"
        "x-systemd.automount"
        "rw"
        #"noauto"
        #"x-systemd.idle-timeout=600"
      ];
    };
  };

  # Enable NFS client service
  services.rpcbind.enable = true;
}
