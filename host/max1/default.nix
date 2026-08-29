# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ xconfig, pkgs, disko, hostName, ... }:

{
  imports = [
    ../boot.nix
    disko.nixosModules.disko
    ./disko-config.nix
    ./hardware-configuration.nix
    ../amd.nix
    ../common.nix
  ];


  networking.hostName = hostName; # Define your hostname.

  boot.kernelParams = [ 
    "ttm.pages_limit=29360128" 

    # s2idle 에서 복귀하지 못하고 커널이 멈추는 문제 회피.
    # DC_DISABLE_IPS = 0x800  (drivers/gpu/drm/amd/include/amd_shared.h, linux-7.2)
    #
    # 2026-08-29 확인. DCN 3.5.1 (Strix Halo) 의 IPS(Idle Power States)가 원인:
    #   - pm_test 의 freezer / devices / platform 은 전부 통과했다.
    #     즉 드라이버의 suspend/resume 콜백 자체는 정상이고,
    #     실제 하드웨어 절전(S0i3) 진입·복귀 구간에서만 멈춘다.
    #   - amdgpu + amdxdna 를 모두 빼면 복귀 성공.
    #   - amdxdna(NPU) 만 빼면 여전히 실패  -> NPU 는 무관.
    #   - IPS 만 끄면 복귀 성공             -> 원인 확정.
    #
    # 대가로 유휴 전력이 조금 올라간다. 커널을 올린 뒤에는 이 줄을 빼고
    # 다시 확인해 볼 것. 더 약한 대안으로 0x2000(DC_DISABLE_IPS2_DYNAMIC)도 있으나
    # 이 기기에서 검증하지는 않았다.
    "amdgpu.dcdebugmask=0x800"
  ];

  environment.systemPackages = with pkgs; [
    amdgpu_top
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
    ds4
    fastflowlm
  ];

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "memlock";
      value = "8388608";
    }
    {
      domain = "*";
      type = "hard";
      item = "memlock";
      value = "8388608";
    }
  ];
}
