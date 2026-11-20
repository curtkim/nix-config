{ ... }:
{
  flake.modules.nixos.spark =
    { lib, config, pkgs, ... }:
    let
      # dgx-spark 모듈의 scrubKernelDevRefs와 동일 (modules/dgx-spark.nix:77).
      # 커널 모듈 출력은 kernel.dev를 참조할 수 없다 — 참조 검사에서
      # "output ... is not allowed to refer to" 로 빌드가 실패한다.
      scrubKernelDevRefs =
        drv:
        drv.overrideAttrs (old: {
          postFixup = (old.postFixup or "") + ''
            if [ -d "$out/lib/modules" ]; then
              find $out/lib/modules -name '*.ko' -print0 \
                | xargs -0 -r ${pkgs.removeReferencesTo}/bin/remove-references-to \
                    -t ${config.boot.kernelPackages.kernel.dev}
            fi
          '';
        });

      # dgx-spark 모듈은 nvidiaPackages.latest를 쓰는데, 그게 R615
      # (615.71.09)로 해석된다. R615는 GB10에서 세 가지 문제를 낸다:
      #
      #   - NVIDIA 7.0 커널에서 cuInit은 성공하지만 1 MiB host-to-device
      #     cudaMemcpy가 무한 대기한다 (그래서 커널은 6.17에 고정되어 있다)
      #   - SM 클럭을 617/3003 MHz에 묶는다 (nvidia-smi: Reliability: Active).
      #     TP는 느린 랭크에 맞춰지므로 디코드가 23 -> 13.7 t/s로 떨어졌다
      #   - RDMA big-gate 전송이 실패해 TP prefill이 깨진다
      #     ("big gate header exchange failed ... Resource temporarily
      #     unavailable" / "worker sync send failed"). 두 QSFP 링크 모두에서
      #     재현된다
      #
      # R595에서는 두 Spark TP가 23.1 t/s로 정상 동작했다. nixpkgs의 latest가
      # GB10에서 쓸 만해지면 이 블록을 지운다.
      r595 = config.boot.kernelPackages.nvidiaPackages.production;
    in
    {
      # Enable DGX Spark hardware support with NVIDIA kernel
      hardware.dgx-spark.enable = true;

      # 모듈이 latest에 하는 것과 같은 모양으로 감싼다.
      hardware.nvidia.package = lib.mkForce (
        r595
        // {
          open = scrubKernelDevRefs r595.open;
          mod = scrubKernelDevRefs r595.mod;
        }
      );

      # GLM5.3-Flash-E224 서빙: 노드당 71 GiB 가중치 로드 + FlashInfer JIT 스파이크를 흡수한다.
      # 128 GB UMA에서 이게 없으면 로딩 중 OOM kill이 나고 GPU 메모리 ~80 GB가 누수된다.
      swapDevices = [ { device = "/swapfile2"; size = 65536; } ];   # MiB = 64 GiB

      # dgx-spark 모듈이 mkDefault 없이 true로 켜므로 mkForce가 필요하다.
      # 끄는 이유: rank당 ~117.5 GiB / 121.7 GiB 예산에서 여유가 ~4 GiB뿐이다.
      services.dgx-dashboard.enable = lib.mkForce false;
    }
    ;
}
