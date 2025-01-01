{
  lib
, clangStdenv
, fetchFromGitHub
, cmake
, ninja
, python3
, xorg
, libXinerama
, cudaPackages
, vulkan-headers
, vulkan-loader
, wayland
, python3Packages
, libllvm
, git
}:
clangStdenv.mkDerivation rec {
  pname = "taichi";
  version = "1.7.3";

  rev = "2df84d1dab285b6051c93b8b8b60ba0b0e9e8426";
  rev_short = "2df84d";

  src = fetchFromGitHub {
    owner = "taichi-dev";
    repo = "taichi";
    rev = "v"+version;
    fetchSubmodules = true;
    hash = "sha256-QWtxPgR8RGnIEpbGO18Y8TFNhbKd4pOi9VLEkK2nhfk=";
  };

  patches = [
    ./remove_execute_process.patch
  ];

  #  postPatch = ''
  #    substituteInPlace "CMakeLists.txt" \
  #      --replace "string(STRIP \${TI_COMMIT_HASH} TI_COMMIT_HASH)" "set(TI_COMMIT_HASH ${rev})"
  #    substituteInPlace "CMakeLists.txt" \
  #      --replace "string(STRIP \${TI_COMMIT_SHORT_HASH} TI_COMMIT_SHORT_HASH)" "set(TI_COMMIT_SHORT_HASH ${rev_short})"
  #  '';

  nativeBuildInputs = [ 
    cmake
    ninja
    python3
    git
    #vulkan-headers
  ];

  buildInputs = [
    libllvm
    python3Packages.pybind11

    cudaPackages.cudatoolkit   # CUDA Toolkit을 포함
    cudaPackages.cuda_cudart # cuda_runtime.h, -lcudart
    cudaPackages.cuda_nvrtc
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_nvtx

    #vulkan-loader
    #wayland

    xorg.libX11
    xorg.libXrandr
    xorg.libXcursor
    xorg.xinput
    xorg.libXi
    libXinerama
  ];

  cmakeFlags = [
    #"-DLUISA_COMPUTE_BUILD_TESTS=OFF"
  ];

  meta = with lib; {
    description = "Productive, portable, and performant GPU programming in Python.";
    homepage = "taichi-lang.org";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
