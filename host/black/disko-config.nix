{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_2TB_S5B1NR0N700699T";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
      data = {
        type = "disk";
        device = "/dev/disk/by-id/ata-HGST_HDN726040ALE614_K4J82RAB";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/data";
              };
            };
          };
        };
      };
      # Seagate ST8000DM004 8TB — SMR (drive-managed shingled) 디스크.
      # 순차 write-once 아카이브/백업 전용. RAID 멤버나 작업 디렉토리로 쓰지 말 것.
      archive = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST8000DM004-2CX188_ZR11A384";
        content = {
          type = "gpt";
          partitions = {
            archive = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/archive";
                # -m 0        : root 예약 5%(=400GB) 제거, 데이터 전용이라 불필요
                # -i 262144   : bytes-per-inode 비율(블록 크기 아님, 블록은 4KB 유지).
                #               inode 30.5M개(7.8GB). 기본값은 big 프로파일이 적용되어
                #               244M개(62.5GB)이므로 약 55GB 절감.
                #               /data 평균 파일 440KB 기준 8TB 만재 시 ~18M개라 충분
                # lazy_*_init : 백그라운드 지연 초기화 비활성 — SMR에서 나중에
                #               랜덤 쓰기로 터지는 것을 방지 (대신 mkfs가 오래 걸림)
                extraArgs = [
                  "-m" "0"
                  "-i" "262144"
                  "-L" "archive"
                  "-E" "lazy_itable_init=0,lazy_journal_init=0"
                ];
                # noatime: 읽기마다 발생하는 메타데이터 쓰기 제거 (SMR에 특히 중요)
                mountOptions = [ "noatime" ];
              };
            };
          };
        };
      };
    };
  };
}

