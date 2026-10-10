# Thin wrappers around the ds4 binaries for the two-Spark DeepSeek V4.1 Flash
# setup described in upstream docs/DGX_SPARK.md and docs/DISTRIBUTED.md.
{
  lib,
  writeShellApplication,
  ds4,
  coreutils,
  curl,
  python3,
  huggingface-hub,
  rdma-core,
  gnugrep,
  gnused,
}:

let
  defaultModelFile = "DeepSeek-V4.1-Flash-Q2.gguf";

  # The downloader reports 341 GiB for ds41f-q2; leave room for the final rename.
  ds41fQ2Gib = 360;

  # Deliberately outside the flake directory.  A flake that is not a git
  # checkout gets copied to the store wholesale -- .gitignore is not consulted --
  # so a 341 GiB gguf/ next to flake.nix would be copied on `nix develop`.
  ggufEnv = ''
    gguf=''${DS4_GGUF_DIR:-$HOME/ds4-gguf}
  '';

  stateEnv = ''
    state=''${DS4_STATE:-''${XDG_STATE_HOME:-$HOME/.local/state}/ds4}
  '';

  modelEnv = ggufEnv + ''
    model=''${DS4_MODEL:-$gguf/${defaultModelFile}}
  '';

  # Symlink farm of just the host NVIDIA driver libraries.  LD_LIBRARY_PATH wins
  # over DT_RUNPATH, so pointing it at /usr/lib/aarch64-linux-gnu wholesale would
  # let the host libc/libstdc++ shadow the Nix ones inside the ds4 binaries.
  driverLibs = writeShellApplication {
    name = "ds4-driver-libs";
    runtimeInputs = [ coreutils ];
    text = ''
      ${stateEnv}
      out=''${DS4_DRIVER_LIBS:-$state/driver-libs}
      src=''${DS4_DRIVER_DIR:-}

      if [ -z "$src" ]; then
        for dir in \
          /run/opengl-driver/lib \
          /usr/lib/aarch64-linux-gnu \
          /usr/lib64 \
          /usr/lib \
          /usr/local/cuda/compat/lib.real \
          /usr/local/cuda/compat/lib
        do
          if [ -e "$dir/libcuda.so.1" ]; then src=$dir; break; fi
        done
      fi

      if [ -z "$src" ]; then
        echo "ds4-driver-libs: libcuda.so.1 not found." >&2
        echo "  Install the NVIDIA driver for this machine, or point DS4_DRIVER_DIR" >&2
        echo "  at the directory that holds libcuda.so.1." >&2
        exit 1
      fi

      rm -rf "$out"
      mkdir -p "$out"
      shopt -s nullglob
      for so in \
        "$src"/libcuda.so* \
        "$src"/libnvidia-ml.so* \
        "$src"/libnvidia-nvvm.so* \
        "$src"/libnvidia-ptxjitcompiler.so* \
        "$src"/libnvidia-gpucomp.so*
      do
        ln -sfn "$so" "$out/$(basename "$so")"
      done

      echo "$out"
    '';
  };

  # The upstream downloader links ./ds4flash.gguf next to itself, so it needs a
  # writable copy outside the store.
  modelDownload = writeShellApplication {
    name = "ds4-model-download";
    runtimeInputs = [
      coreutils
      curl
      python3
      # Targets with FORCE_HF_DOWNLOAD=1 -- ds41f-q2 among them -- shell out to
      # the official `hf` CLI, which brings hf-xet for the chunked transfer.
      huggingface-hub
    ];
    text = ''
      target=''${1:-ds41f-q2}
      [ "$#" -eq 0 ] || shift

      ${ggufEnv}
      ${stateEnv}
      mkdir -p "$gguf"

      if [ "$target" = ds41f-q2 ]; then
        avail=$(df -BG --output=avail "$gguf" | tail -n1 | tr -dc '0-9')
        if [ -n "$avail" ] && [ "$avail" -lt ${toString ds41fQ2Gib} ]; then
          echo "ds4-model-download: $gguf has ''${avail} GiB free." >&2
          echo "  DeepSeek V4.1 Flash Q2 is about 341 GiB (189 GiB of that is" >&2
          echo "  disk-only Engram tables) and wants a fast local SSD." >&2
          exit 1
        fi
      fi

      work=$state/download
      mkdir -p "$work"
      install -m755 ${ds4}/share/ds4/download_model.sh "$work/download_model.sh"

      cd "$work"
      export DS4_GGUF_DIR=$gguf
      exec ./download_model.sh "$target" "$@"
    '';
  };

  preflight = writeShellApplication {
    name = "ds4-spark-preflight";
    runtimeInputs = [
      ds4
      driverLibs
      coreutils
      gnugrep
      gnused
      rdma-core
    ];
    text = ''
      ${modelEnv}
      status=0
      note() { printf '  %s\n' "$*"; }

      echo "ds4 build"
      note "binaries: $(command -v ds4)"
      note "commit:   ${ds4.passthru.rev or "unknown"}"
      note "cuda:     ${toString (ds4.passthru.cudaVersion or "unknown")} for ${
        ds4.passthru.cudaArch or "unknown"
      }"
      note "both peers must run this exact build (docs/DISTRIBUTED.md)"

      echo "GPU"
      if command -v nvidia-smi >/dev/null 2>&1; then
        nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader \
          | sed 's/^/  /' || status=1
      else
        note "nvidia-smi not on PATH -- cannot confirm the GPU is visible"
        status=1
      fi

      echo "driver libraries"
      if dir=$(ds4-driver-libs 2>/dev/null); then
        note "$dir -> $(readlink -f "$dir/libcuda.so.1")"
      else
        note "libcuda.so.1 not found; run ds4-driver-libs for details"
        status=1
      fi

      echo "RoCE link"
      if ibv_devinfo >/dev/null 2>&1; then
        ibv_devinfo | grep -E 'hca_id|^[[:space:]]+state:|link_layer' \
          | sed 's/^[[:space:]]*/  /' || true
        if ! ibv_devinfo | grep -q PORT_ACTIVE; then
          note "no port is PORT_ACTIVE -- --transport rdma will not come up"
          status=1
        fi
      else
        note "no verbs device; fix the link or use DS4_TP_TRANSPORT=tcp"
        status=1
      fi

      echo "model"
      if [ -r "$model" ]; then
        note "$model ($(du -h --apparent-size "$model" | cut -f1))"
      else
        note "missing: $model -- run 'ds4-model-download ds41f-q2'"
        status=1
      fi

      echo
      if [ "$status" -eq 0 ]; then
        echo "ready: start the worker first, then the coordinator."
      else
        echo "not ready: see the notes above."
      fi
      exit "$status"
    '';
  };

  # Coordinator and worker differ only in which side names the link address.
  mkTpScript =
    role:
    writeShellApplication {
      name = "ds4-spark-${role}";
      runtimeInputs = [
        ds4
        coreutils
      ];
      text = ''
        ${modelEnv}
        bin=''${DS4_TP_BIN:-ds4}
        ctx=''${DS4_TP_CTX:-32768}
        port=''${DS4_TP_PORT:-9911}
        transport=''${DS4_TP_TRANSPORT:-rdma}
        addr=''${DS4_TP_COORDINATOR:-}

        if [ -z "$addr" ]; then
          echo "ds4-spark-${role}: set DS4_TP_COORDINATOR to the coordinator's address" >&2
          echo "  on the direct RoCE link, not the management network (e.g. 172.31.250.1)" >&2
          exit 2
        fi

        if [ ! -r "$model" ]; then
          echo "ds4-spark-${role}: no model at $model" >&2
          echo "  run 'ds4-model-download ds41f-q2' on this host first" >&2
          exit 2
        fi

        # docs/DISTRIBUTED.md: these pick different memory/execution modes and
        # must not be combined with network tensor parallelism.
        for arg in "$@"; do
          case $arg in
            --ssd-streaming | --cuda-tensor-parallel)
              echo "ds4-spark-${role}: refusing $arg -- network TP excludes it" >&2
              exit 2
              ;;
          esac
        done

        args=(
          --cuda
          -m "$model"
          --ctx "$ctx"
          --tensor-parallel
          --transport "$transport"
          ${
            if role == "coordinator" then
              ''--role coordinator --listen "$addr" "$port"''
            else
              ''--role worker --coordinator "$addr" "$port"''
          }
        )
        args+=( "$@" )

        printf '+ %s' "$bin"
        printf ' %s' "''${args[@]}"
        printf '\n'
        exec "$bin" "''${args[@]}"
      '';
    };
in
{
  ds4-driver-libs = driverLibs;
  ds4-model-download = modelDownload;
  ds4-spark-preflight = preflight;
  ds4-spark-coordinator = mkTpScript "coordinator";
  ds4-spark-worker = mkTpScript "worker";
}
