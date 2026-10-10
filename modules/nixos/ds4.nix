# NixOS module: DeepSeek V4.1 Flash Q2 over network tensor parallelism on two
# DGX Sparks (upstream docs/DISTRIBUTED.md).  One host runs the coordinator as
# ds4-server, the other runs the worker as plain ds4 -- ds4-server refuses
# `--role worker`.
#
# package / downloadPackage have no default: ds4 needs its own nixpkgs instance
# (CUDA 13.3, sm_121), which parts/shared.nix builds as ds4For.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.ds4;
  tp = cfg.tensorParallel;

  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    optional
    optionals
    ;

  isCoordinator = cfg.role == "coordinator";

  bin = if isCoordinator then "ds4-server" else "ds4";

  # Both peers must agree on these; keep them in one shared host file.
  args = [
    "--cuda"
    "-m"
    cfg.model
    "--ctx"
    (toString cfg.ctx)
  ]
  ++ optionals (cfg.prefillChunk != null) [
    "--prefill-chunk"
    (toString cfg.prefillChunk)
  ]
  ++ [
    "--tensor-parallel"
    "--transport"
    tp.transport
  ]
  ++ optionals (tp.rdmaDevice != null) [
    "--rdma-device"
    tp.rdmaDevice
  ]
  ++ optionals (tp.rdmaGidIndex != null) [
    "--rdma-gid-index"
    (toString tp.rdmaGidIndex)
  ]
  ++ (
    if isCoordinator then
      [
        "--role"
        "coordinator"
        "--listen"
        tp.coordinator
        (toString tp.port)
      ]
    else
      [
        "--role"
        "worker"
        "--coordinator"
        tp.coordinator
        (toString tp.port)
      ]
  )
  ++ optionals isCoordinator (
    [
      "--host"
      cfg.server.host
      "--port"
      (toString cfg.server.port)
    ]
    ++ optionals (cfg.server.batchedSessions != null) [
      "--batched-session"
      (toString cfg.server.batchedSessions)
    ]
    ++ optionals cfg.server.kvDisk.enable [
      "--kv-disk-dir"
      "${cfg.stateDir}/kv"
      "--kv-disk-space-mb"
      (toString cfg.server.kvDisk.spaceMB)
    ]
  )
  ++ cfg.extraArgs;

  # docs/DISTRIBUTED.md: these pick other memory/execution modes.
  forbiddenArgs = [
    "--ssd-streaming"
    "--cuda-tensor-parallel"
  ];
in
{
  options.services.ds4 = {
    enable = mkEnableOption "ds4 DeepSeek V4.1 Flash Q2 over two-Spark tensor parallelism";

    package = mkOption {
      type = types.package;
      description = "ds4 build (pkgs/ds4). Both peers must run the same store path.";
    };

    downloadPackage = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "ds4-model-download (pkgs/ds4), used by ds4-download.service.";
    };

    user = mkOption {
      type = types.str;
      default = "ds4";
      description = "User the service runs as. Created when left at the default.";
    };

    group = mkOption {
      type = types.str;
      default = "ds4";
      description = "Group the service runs as. Created when left at the default.";
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/ds4";
      description = ''
        State directory. Holds gguf/ (models), kv/ (disk KV cache) and
        download/ (the downloader's working copy).
      '';
    };

    model = mkOption {
      type = types.path;
      default = "${cfg.stateDir}/gguf/DeepSeek-V4.1-Flash-Q2.gguf";
      defaultText = lib.literalExpression ''"''${config.services.ds4.stateDir}/gguf/DeepSeek-V4.1-Flash-Q2.gguf"'';
      description = "GGUF path. Both peers need the complete file on local SSD.";
    };

    role = mkOption {
      type = types.enum [
        "coordinator"
        "worker"
      ];
      description = ''
        coordinator runs ds4-server and serves HTTP; worker runs ds4 and
        connects to the coordinator over the direct link.
      '';
    };

    ctx = mkOption {
      type = types.ints.positive;
      default = 32768;
      description = "--ctx. Must match on both peers.";
    };

    prefillChunk = mkOption {
      type = types.nullOr types.ints.positive;
      default = null;
      description = "--prefill-chunk override. Must match on both peers.";
    };

    tensorParallel = {
      coordinator = mkOption {
        type = types.str;
        example = "192.168.100.11";
        description = "Coordinator address on the direct RoCE link, not the management network.";
      };

      port = mkOption {
        type = types.port;
        default = 9911;
        description = "TP port.";
      };

      transport = mkOption {
        type = types.enum [
          "rdma"
          "tcp"
          "auto"
        ];
        default = "rdma";
        description = "Must match on both peers.";
      };

      rdmaDevice = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "--rdma-device, only when automatic selection is ambiguous.";
      };

      rdmaGidIndex = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        description = "--rdma-gid-index, only when automatic selection is ambiguous.";
      };
    };

    server = {
      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "HTTP listen address (coordinator only).";
      };

      port = mkOption {
        type = types.port;
        default = 8000;
        description = "HTTP port (coordinator only).";
      };

      batchedSessions = mkOption {
        type = types.nullOr types.ints.positive;
        default = null;
        description = ''
          --batched-session (coordinator only). V4.1 uses native batched
          decode from five ready sessions, but every session preallocates
          its context: on two Sparks eight 4K contexts fit and eight 8K are
          rejected by memory admission (upstream QA_BEFORE_RELEASES.md).
        '';
      };

      kvDisk = {
        enable = mkEnableOption "the disk KV cache in <stateDir>/kv";
        spaceMB = mkOption {
          type = types.ints.positive;
          default = 8192;
          description = "--kv-disk-space-mb.";
        };
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open the HTTP port. The TP port is not opened here: keep it on the
          direct link (the protocol has no authentication).
        '';
      };
    };

    autoStart = mkOption {
      type = types.bool;
      default = false;
      description = "Start at boot. The worker retries while the coordinator loads, so order does not matter.";
    };

    download.enable = mkEnableOption ''
      ds4-download.service, a oneshot that fetches ds41f-q2 (~341 GiB) into
      <stateDir>/gguf when the model is missing. Never started automatically
    '';

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--nothink" ];
      description = "Extra arguments appended to the command line.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !lib.any (a: lib.elem a forbiddenArgs) cfg.extraArgs;
        message = "services.ds4.extraArgs: ${lib.concatStringsSep " and " forbiddenArgs} cannot be combined with network tensor parallelism.";
      }
      {
        assertion = cfg.download.enable -> cfg.downloadPackage != null;
        message = "services.ds4.download.enable needs services.ds4.downloadPackage.";
      }
    ];

    warnings = optional (
      !isCoordinator && (cfg.server.openFirewall || cfg.server.kvDisk.enable)
    ) "services.ds4.server.* only applies to the coordinator; the worker ignores it.";

    users.users = mkIf (cfg.user == "ds4") {
      ds4 = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.stateDir;
      };
    };
    users.groups = mkIf (cfg.group == "ds4") { ds4 = { }; };

    # Models are not secret; the KV cache holds prompt text.
    systemd.tmpfiles.settings."10-ds4" = {
      ${cfg.stateDir}.d = {
        inherit (cfg) user group;
        mode = "0755";
      };
      "${cfg.stateDir}/gguf".d = {
        inherit (cfg) user group;
        mode = "0755";
      };
      "${cfg.stateDir}/kv".d = {
        inherit (cfg) user group;
        mode = "0700";
      };
    };

    networking.firewall.allowedTCPPorts = optional (
      isCoordinator && cfg.server.openFirewall
    ) cfg.server.port;

    systemd.services.ds4 = {
      description = "ds4 DeepSeek V4.1 Flash Q2 (${cfg.role})";
      wantedBy = optional cfg.autoStart "multi-user.target";
      # spark-qsfp-arp-warm: RoCE does not wait for ARP; an empty neighbour
      # cache ends in IBV_WC_RETRY_EXC_ERR.  `wants` on a unit that does not
      # exist is a no-op, so this stays usable off the Spark config.
      wants = [
        "network-online.target"
        "spark-qsfp-arp-warm.service"
      ];
      after = [
        "network-online.target"
        "spark-qsfp-arp-warm.service"
      ];

      # Fail loudly instead of quietly fetching 341 GiB.
      unitConfig.AssertPathExists = cfg.model;
      # The worker restarts every 10 s while the coordinator is down.
      startLimitIntervalSec = 0;

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/${bin} ${lib.escapeShellArgs args}";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;

        # Worker reconnects after a coordinator restart.  The coordinator only
        # restarts on a signal: exit 1 is a startup error such as memory
        # admission, and retrying it every 10 s does not help.
        Restart = if isCoordinator then "on-abnormal" else "always";
        RestartSec = 10;
        # Mapping ~81 GiB per rank takes minutes.
        TimeoutStartSec = "infinity";
        TimeoutStopSec = 120;

        # RDMA memory registration pins the weights.
        LimitMEMLOCK = "infinity";
        # A resident model pushed to swap is slower than not running.
        MemorySwapMax = 0;

        # /dev/nvidia* and /dev/infiniband/uverbs* are needed, so no
        # PrivateDevices / DevicePolicy.
        SupplementaryGroups = [
          "video"
          "render"
        ];
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ cfg.stateDir ];
        PrivateTmp = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;
      };
    };

    systemd.services.ds4-download = mkIf cfg.download.enable {
      description = "Download DeepSeek V4.1 Flash Q2 for ds4";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      unitConfig.ConditionPathExists = "!${cfg.model}";
      environment = {
        DS4_GGUF_DIR = "${cfg.stateDir}/gguf";
        DS4_STATE = cfg.stateDir;
        HF_HOME = "${cfg.stateDir}/hf";
      };
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${cfg.downloadPackage}/bin/ds4-model-download ds41f-q2";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        TimeoutStartSec = "infinity";
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ cfg.stateDir ];
        PrivateTmp = true;
      };
    };
  };
}
