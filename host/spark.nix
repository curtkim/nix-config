{ lib, ... }:
{
  # Enable DGX Spark hardware support with NVIDIA kernel
  hardware.dgx-spark.enable = true;

  # GLM5.3-Flash-E224 서빙: 노드당 71 GiB 가중치 로드 + FlashInfer JIT 스파이크를 흡수한다.
  # 128 GB UMA에서 이게 없으면 로딩 중 OOM kill이 나고 GPU 메모리 ~80 GB가 누수된다.
  swapDevices = [ { device = "/swapfile2"; size = 65536; } ];   # MiB = 64 GiB

  # dgx-spark 모듈이 mkDefault 없이 true로 켜므로 mkForce가 필요하다.
  # 끄는 이유: rank당 ~117.5 GiB / 121.7 GiB 예산에서 여유가 ~4 GiB뿐이다.
  services.dgx-dashboard.enable = lib.mkForce false;
}
