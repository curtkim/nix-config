# ds4 (DwarfStar) DeepSeek V4.1 Flash Q2: spark1 = coordinator(ds4-server), spark2 = worker(ds4).
# ctx/transport/주소는 양쪽이 같아야 하므로 이 파일 하나로 정의한다.
#
# 모델: 양쪽 모두 /var/lib/ds4/gguf/DeepSeek-V4.1-Flash-Q2.gguf (같은 파일시스템이라 mv는 즉시 끝난다)
#   sudo mv ~/ds4-gguf/DeepSeek-V4.1-Flash-Q2.gguf /var/lib/ds4/gguf/
#   sudo chown ds4:ds4 /var/lib/ds4/gguf/DeepSeek-V4.1-Flash-Q2.gguf
#
# 기동: worker가 coordinator 로딩 중 재시도하므로 순서는 무관하다.
#   spark2$ sudo systemctl start ds4
#   spark1$ sudo systemctl start ds4
#   curl http://spark1:8000/v1/models
{ hostName, ... }:
{
  services.ds4 = {
    enable = true;
    role = if hostName == "spark1" then "coordinator" else "worker";
    # 세션 1개 x 64K. 세션마다 ctx를 미리 잡으므로 batched-session 8은 ctx 4096이 상한이다
    # (8 x 8K부터 memory admission에서 거부, 업스트림 QA_BEFORE_RELEASES.md).
    ctx = 65536;
    # spark1-cx0 (spark-qsfp.nix). 9911은 QSFP trustedInterfaces로 이미 열려 있다.
    tensorParallel.coordinator = "192.168.100.11";

    server = {
      host = "0.0.0.0";
      port = 8000;
      openFirewall = true;
    };

    # 검증 전까지는 수동 기동.
    autoStart = false;
  };
}
