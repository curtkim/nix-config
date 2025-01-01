{
  lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, python3
, libuuid
, xorg
, libXinerama
, cudaPackages
, vulkan-headers
, vulkan-loader
, wayland
}:
stdenv.mkDerivation rec {
  pname = "luisa-compute";
  version = "2024.10.29";

  src = fetchFromGitHub {
    owner = "LuisaGroup";
    repo = "LuisaCompute";
    rev = "4df551ddb38351810a780525b220bf34c4d08569";
    fetchSubmodules = true;
    hash = "sha256-L2mMPHimpfly6w5hi2ugTX8GQm7BYSlAl827Dj+yokg="; #lib.fakeHash;
  };

  nativeBuildInputs = [ 
    cmake
    ninja
    python3
    vulkan-headers
  ];

  buildInputs = [

    cudaPackages.cudatoolkit   # CUDA Toolkit을 포함
    cudaPackages.cuda_cudart # cuda_runtime.h, -lcudart
    cudaPackages.cuda_nvrtc
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_nvtx

    vulkan-loader
    wayland

    libuuid
    xorg.libX11
    xorg.libXrandr
    xorg.libXcursor
    xorg.xinput
    xorg.libXi
    libXinerama
  ];

  cmakeFlags = [
    "-DLUISA_ENABLE_WAYLAND=ON"
    "-DLUISA_COMPUTE_ENABLE_CUDA=ON"
    "-DLUISA_COMPUTE_BUILD_TESTS=OFF"
  ];

  #  buildPhase = ''
  #    cd ..
  #    cmake --build --preset releaseWithDebugInfo
  #  '';
  #
  #  installPhase = ''
  #    mkdir -p $out
  #    cp -r build/RelWithDebInfo/* $out/
  #  '';

  meta = with lib; {
    description = "High-Performance Rendering Framework on Stream Architectures";
    homepage = "https://github.com/LuisaGroup/LuisaCompute";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
