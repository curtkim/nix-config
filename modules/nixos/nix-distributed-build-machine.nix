{ ... }:
{
  flake.modules.nixos.nix-distributed-build-machine =
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
            "big-parallel"
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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDbITVR+WM4GjJwU2fypunfWOE31UHKdDNpnJHq/zpqc root@black"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPL8aYh8c61ydBtynod4Ppd44K7+d3/XnG1M2jC7dWK+ root@gen53"
          # TODO gen53: gen53 에서 `sudo cat /root/.ssh/id_ed25519.pub` 결과를 여기에 추가
          #   (키가 없으면 `sudo ssh-keygen -t ed25519 -N "" -f /root/.ssh/id_ed25519`)
        ];
      }; 
    };
}
