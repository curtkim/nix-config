# max1 을 원격 빌더 겸 substituter 로 쓴다. max1 은 nix-distributed-build-machine 을 import 해야 하고,
# 이 호스트 root 의 공개키(/root/.ssh/id_ed25519.pub)가 그 모듈의 authorizedKeys 에 있어야 한다.
{ ... }:
{
  flake.modules.nixos.nix-distributed-build-client =
    {
      nix = {
        # 분산 빌드 설정
        distributedBuilds = true;

        # 빌드 머신 정의(/etc/nix/machines 에 기록됨)
        buildMachines = [
          {
            hostName = "max1"; # 공유기 DNS 로 192.168.1.16 (max1.lan)
            system = "x86_64-linux";
            maxJobs = 8; # max1: 32 스레드
            speedFactor = 4;
            supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
            mandatoryFeatures = [ ];
            sshUser = "nix-remote";
            sshKey = "/root/.ssh/id_ed25519"; # SSH 개인키 경로
            protocol = "ssh-ng";
          }
        ];

        # 추가 설정
        settings = {
          # 로컬에서 빌드하지 않고 원격에서만 빌드
          #max-jobs = 0; # 로컬 빌드 비활성화하려면
          # 또는 로컬과 원격 빌드 병행하려면 적절한 숫자 설정
          max-jobs = 1;

          # 빌드 결과를 로컬에 복사
          builders-use-substitutes = true;

          # max1 의 store 를 substituter 로도 쓴다. 원격 빌드와 같은 ssh 연결(nix-remote, root 키)이다.
          # - trusted=true: max1 이 빌드한 경로는 서명이 없으므로 서명 확인 없이 받는다.
          # - priority=50: cache.nixos.org(40) 등에 없는 경로(직접 빌드한 것)만 max1 에서 받는다.
          extra-substituters = [
            "ssh-ng://nix-remote@max1?ssh-key=/root/.ssh/id_ed25519&trusted=true&priority=50"
          ];
          # max1 이 꺼져 있을 때 substituter 연결에서 오래 기다리지 않는다.
          connect-timeout = 5;
        };
      };

      # nix-daemon(root) 의 ssh 가 호스트 키 확인에서 막히지 않도록 max1 의 호스트 키를 등록한다.
      programs.ssh.knownHosts.max1 = {
        hostNames = [ "max1" "max1.lan" "192.168.1.16" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhxexM2j2oL+2GGSecdXVQfrBiDiuYnl6mUyxaOvL6O";
      };
    }
    ;
}
