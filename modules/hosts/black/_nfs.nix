{ ... }:
{
  services.nfs.server = {
    enable = true;
    exports = ''
      /data 192.168.0.0/255.255.255.0(rw,no_root_squash,no_subtree_check,fsid=0)
    '';
    createMountPoints = true;
  };
}
