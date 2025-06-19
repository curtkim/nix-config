{
  nix = {
    settings = {
      trusted-users = [
        "nix-remote"
      ];
      max-jobs = "auto";
      system-features = [
        "nixos-test" 
        "benchmark" 
        "big-paralle" 
        "kvm"
      ];
    };
  };

  users.users.nix-remote = {
    isNormalUser = true;
    # SSH 키를 추가할 그룹
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      # 클라이언트의 공개키를 여기에 추가
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbITVR+WM4GjJwU2fypunfWOE31UHKdDNpnJHq/zpqc root@black
"
    ];
  }; 
}
