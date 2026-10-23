{ lib, config, ... }:
{
  # Enable DGX Spark hardware support with NVIDIA kernel
  hardware.dgx-spark.enable = true;

  # dgx-spark 모듈은 NVIDIA 7.0 커널과 R615 드라이버를 한 쌍으로 전제한다
  # (upstream PR #184/#185가 같은 날 함께 머지). 그런데 모듈은 드라이버를
  # `nvidiaPackages.latest`라는 이름으로 지정하고, 그 이름은 이 설정의 nixpkgs
  # 기준으로 해석된다. nixos-26.05에서는 latest == production == 595.71.05
  # (R595, CUDA 13.2)여서 7.0 커널에 R595가 붙고, 그 조합에서는 cuInit이
  # CUDA_ERROR_NOT_INITIALIZED로 실패해 CUDA가 전혀 뜨지 않는다. nvidia-smi는
  # NVML만 쓰므로 계속 동작해서 알아채기 어렵다.
  #
  # nixpkgs 26.05가 R615를 담을 때까지 명시적으로 고정한다. 해시는
  # nixpkgs-unstable의 pkgs/os-specific/linux/nvidia-x11/default.nix 기준.
  # NB: 모듈이 원래 드라이버의 .open/.mod에 씌우는 scrubKernelDevRefs는
  # 건너뛴다 (클로저에 dev 참조가 남을 뿐 동작에는 영향 없음).
  hardware.nvidia.package = lib.mkForce (
    config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "615.71.09";
      sha256_64bit = "sha256-zc7tIrvrYSSNGm3qvCWWZz46ZQFpjucayNL9wo87cP4=";
      sha256_aarch64 = "sha256-IbekQhE7cFfmnPZaLY9NDYcF7CoNZ+2Qb7sRd4EOgWM=";
      openSha256 = "sha256-3gByMYIwFzRaLdDG+roCEOuKRRJDrljG9AlLnRZTirM=";
      settingsSha256 = "sha256-LK1LU8mDkM/XVRKPBtuOZh9nIP/lGFLAJnmasEX8jhg=";
      persistencedSha256 = "sha256-qPRb+3d88+2RcpUkoBTbjIaImnQ+jX+/6p1vXcJ5geE=";
    }
  );

  # GLM5.3-Flash-E224 서빙: 노드당 71 GiB 가중치 로드 + FlashInfer JIT 스파이크를 흡수한다.
  # 128 GB UMA에서 이게 없으면 로딩 중 OOM kill이 나고 GPU 메모리 ~80 GB가 누수된다.
  swapDevices = [ { device = "/swapfile2"; size = 65536; } ];   # MiB = 64 GiB

  # dgx-spark 모듈이 mkDefault 없이 true로 켜므로 mkForce가 필요하다.
  # 끄는 이유: rank당 ~117.5 GiB / 121.7 GiB 예산에서 여유가 ~4 GiB뿐이다.
  services.dgx-dashboard.enable = lib.mkForce false;
}
