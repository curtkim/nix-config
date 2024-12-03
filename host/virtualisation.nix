{pkgs, nixpkgs, ...}:{
  #  imports = [ 
  #    "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
  #    #<nixpkgs/nixos/modules/virtualisation/qemu-vm.nix> 
  #  ];
  #
  #  environment.systemPackages = [
  #    pkgs.qemu 
  #    pkgs.spice-gtk
  #  ];
  #
  #  virtualisation.qemu.options = [
  #    "-vga qxl"
  #    "-spice port=5924,disable-ticketing=on"
  #    "-device virtio-serial -chardev spicevmc,id=vdagent,debug=0,name=vdagent"
  #    "-device virtserialport,chardev=vdagent,name=com.redhat.spice.0"
  #  ];
  #services.spice-vdagentd.enable = true;

  environment.systemPackages = [
    pkgs.qemu 
  ];

  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };

    libvirtd = {
      enable = true;
    };

    #    incus = {
    #      enable = true;
    #    };
  };
  programs.virt-manager.enable = true;
}
