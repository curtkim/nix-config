# ds4 (DwarfStar) built with the upstream `make cuda-spark` target.
#
# The Spark build is GB10 / sm_121a: see docs/DGX_SPARK.md upstream.  Everything
# below exists so that the plain upstream Makefile finds a CUDA toolchain in the
# Nix store instead of /usr/local/cuda.
{
  lib,
  stdenv,
  src,
  version,
  cudaPackages,
  rdma-core,
  patchelf,
  autoAddDriverRunpath,

  # GB10 is sm_121.  `make cuda-spark` hardcodes it; any other value switches to
  # the generic `make cuda CUDA_ARCH=...` target.
  cudaArch ? "sm_121",

  # Upstream default for Linux.  Both Sparks are the same machine, so -march=native
  # is fine; set e.g. "-mcpu=neoverse-v2" if you want a CPU-portable store path
  # (for example when one host builds and the other substitutes).
  cpuFlag ? "-march=native",

  # Network tensor parallelism over RoCE needs the libibverbs headers at build
  # time (ds4_tp.c gates on __has_include(<infiniband/verbs.h>)) and
  # libibverbs.so.1 at runtime (it is dlopen()ed, hence the extra RPATH below).
  enableRdma ? true,
}:

let
  sparkArch = cudaArch == "sm_121" || cudaArch == "sm_121a";

  cudartLib = lib.getLib cudaPackages.cuda_cudart;
  cublasLib = lib.getLib cudaPackages.libcublas;

  # Renamed from cuda_cccl to cccl in CUDA 13.3.  ds4_cuda.cu needs <cub/...>.
  cccl = cudaPackages.cccl or cudaPackages.cuda_cccl;

  binaries = [
    "ds4"
    "ds4-server"
    "ds4-bench"
    "ds4-eval"
    "ds4-agent"
  ];
in
stdenv.mkDerivation {
  pname = "ds4-cuda-${cudaArch}";
  inherit version src;

  strictDeps = true;

  nativeBuildInputs = [
    cudaPackages.cuda_nvcc
    patchelf
    autoAddDriverRunpath
  ];

  buildInputs = [
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
    cccl
  ]
  ++ lib.optional enableRdma rdma-core;

  # nvcc drives the link step and does not cope with the fortify wrappers.
  hardeningDisable = [
    "fortify"
    "fortify3"
  ];

  postPatch = ''
    patchShebangs --host download_model.sh
  '';

  # `make cuda-spark` == `make -B ds4 ds4-server ds4-bench ds4-eval ds4-agent
  # CUDA_ARCH=sm_121`, which expands to -gencode arch=compute_121a,code=sm_121a
  # plus -DDS4_CUDA_HAVE_MXF4=1.  We only redirect the toolchain:
  #   NVCC          - plain `nvcc`; the default is $(CUDA_HOME)/bin/nvcc
  #   CUDA_LDLIBS   - upstream points -L at .../targets/sbsa-linux/lib and lib64,
  #                   neither of which exists in the split Nix outputs
  # NVCCFLAGS is deliberately left alone: it carries the sm_121a gencode flags.
  # The cc-wrapper already feeds these to the host compiler nvcc shells out to
  # for preprocessing; passing them to nvcc directly removes the dependency on
  # that detail (cuda_runtime.h, cublas_v2.h, cub/...).
  preBuild = ''
    for inc in \
      "${lib.getInclude cudaPackages.cuda_cudart}/include" \
      "${lib.getInclude cudaPackages.libcublas}/include" \
      "${lib.getInclude cccl}/include"
    do
      export NVCC_PREPEND_FLAGS="''${NVCC_PREPEND_FLAGS:-} -I$inc"
    done
  '';

  buildPhase = ''
    runHook preBuild

    make ${if sparkArch then "cuda-spark" else "cuda CUDA_ARCH=${cudaArch}"} \
      -j"$NIX_BUILD_CORES" \
      NVCC=nvcc \
      CC="$CC" \
      NATIVE_CPU_FLAG="${cpuFlag}" \
      CUDA_LDLIBS="-lm -Xcompiler -pthread -L${cudartLib}/lib -L${cublasLib}/lib -lcudart -lcublas"

    runHook postBuild
  '';

  # No check phase: every upstream test worth running wants a GPU, a GGUF, or both.
  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -Dm755 ${lib.escapeShellArgs binaries} -t "$out/bin"

    # The downloader links ./ds4flash.gguf next to itself, so it has to run from
    # a writable copy; ds4-model-download in the dev shell does that.
    install -Dm755 download_model.sh "$out/share/ds4/download_model.sh"

    mkdir -p "$out/share/doc/ds4"
    cp README.md "$out/share/doc/ds4/"
    cp -r docs "$out/share/doc/ds4/"

    runHook postInstall
  '';

  # libibverbs is dlopen()ed by name, so nothing links against it and
  # --shrink-rpath would drop it again if we did this any earlier.
  postFixup = lib.optionalString enableRdma ''
    for bin in ${lib.escapeShellArgs binaries}; do
      patchelf --add-rpath "${lib.getLib rdma-core}/lib" "$out/bin/$bin"
    done
  '';

  passthru = {
    inherit
      cudaArch
      cpuFlag
      enableRdma
      binaries
      ;
    cudaVersion = cudaPackages.cudaMajorMinorPatchVersion or cudaPackages.cudaVersion;
    # Handy for the "run the same commit on every peer" rule in docs/DISTRIBUTED.md.
    rev = src.rev or "unknown";
  };

  meta = {
    description = "DwarfStar (ds4) CUDA build for NVIDIA DGX Spark / GB10";
    homepage = "https://github.com/antirez/ds4";
    license = lib.licenses.mit;
    mainProgram = "ds4";
    platforms = [ "aarch64-linux" ];
  };
}
