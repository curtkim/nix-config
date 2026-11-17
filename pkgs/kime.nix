# kime 3.2.0 의 kime-wayland 는 libwayland-client.so 를 dlopen 하는데
# RUNPATH 에 wayland 가 없어서 "Failed to connect wayland display: NoWaylandLib" 로 죽는다.
# (NixOS 에는 전역 라이브러리 경로가 없다) RUNPATH 에 wayland 를 추가한다.
{
  lib,
  kime,
  wayland,
}:
kime.overrideAttrs (old: {
  postFixup = (old.postFixup or "") + ''
    patchelf --add-rpath ${lib.getLib wayland}/lib $out/bin/kime-wayland
  '';
})
