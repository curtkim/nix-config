{
  # Enable DGX Spark hardware support with NVIDIA kernel
  hardware.dgx-spark.enable = true;

  # Enable zram swap for better memory management
  # zramSwap.enable = true;

  # dgx-spark 모듈이 mkDefault 없이 true로 켜므로 mkForce가 필요하다.
  # 끄는 이유: rank당 ~117.5 GiB / 121.7 GiB 예산에서 여유가 ~4 GiB뿐이다.
  services.dgx-dashboard.enable = lib.mkForce false;
}
