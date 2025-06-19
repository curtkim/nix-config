{
  nix = {
    # 분산 빌드 설정
    distributedBuilds = true;

    # 빌드 머신 정의
    buildMachines = [
      {
        hostName = "192.168.0.198";
        system = "x86_64-linux";
        maxJobs = 2;
        speedFactor = 2;
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
    };
  };
}
