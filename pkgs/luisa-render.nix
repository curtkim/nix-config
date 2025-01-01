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
  pname = "luisa-render";
  version = "2024.12.21";

  src = fetchFromGitHub {
    owner = "LuisaGroup";
    repo = "LuisaRender";
    rev = "2df84d1dab285b6051c93b8b8b60ba0b0e9e8426";
    fetchSubmodules = true;
    hash = "sha256-Wng7TtbmHmnCswDhEarQOD/kUgiZk9AtcxP5B6vshXI=";
  };

  nativeBuildInputs = [ 
    cmake
    ninja
    python3
    vulkan-headers
  ];

  buildInputs = [
    libuuid

    cudaPackages.cudatoolkit   # CUDA Toolkit을 포함
    cudaPackages.cuda_cudart # cuda_runtime.h, -lcudart
    cudaPackages.cuda_nvrtc
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_nvtx

    vulkan-loader
    wayland

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
    #"-DSLANG_ENABLE_TESTS=OFF"
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
