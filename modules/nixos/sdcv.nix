# StarDict Console Version. user/sdcv.nix 의 hjem 버전.
# 사전 데이터는 ~/.local/share/stardict/dic 에 있어야 하므로 hjem 으로 링크한다.
{ config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.modules.nixos.sdcv =
    { pkgs, lib, ... }:
    let
      dictSources = [
        {
          url = "http://download.huzheng.org/ko/stardict-quick_eng-kor-2.4.2.tar.bz2";
          sha256 = "sha256-XZILEToXHSeBiDSlnIoPsv1SEIckCY/0AVmU5eJ7Jgc=";
        }
      ];

      fetchedArchives = map (
        spec:
        pkgs.fetchurl {
          url = spec.url;
          sha256 = spec.sha256;
        }
      ) dictSources;

      stardict-dicts = pkgs.stdenv.mkDerivation {
        name = "stardict-dictionaries-combined";
        srcs = fetchedArchives;
        sourceRoot = ".";

        nativeBuildInputs = [ pkgs.unzip ];

        installPhase = ''
          mkdir -p $out
          for src in $srcs; do
            if [[ "$src" == *.zip ]]; then
              unzip $src -d $out
            else
              tar -xjvf $src -C $out --strip-components=1
            fi
          done
        '';
      };

      # See: https://github.com/Dushistov/sdcv/issues/107
      # home-manager 가 없으면 fzf/jq 가 PATH 에 없을 수 있어서 store 경로를 쓴다.
      sdcv = lib.getExe pkgs.sdcv;
      fzfSdcv = pkgs.writeShellScriptBin "sdcv-fzf" ''
        ${lib.getExe pkgs.fzf} --prompt="Dict: " \
            --phony \
            --bind "enter:reload(${sdcv} {q} -n --json | ${lib.getExe pkgs.jq} '.[].dict' -r)" \
            --preview "${sdcv} {q} -en --use-dict={}" \
            --preview-window=wrap \
           < <(echo)
      '';
    in
    {
      imports = [ nixos.hjem ];

      hjem.users.curt = {
        packages = [
          pkgs.sdcv
          fzfSdcv
        ];

        # ~/.local/share/stardict/dic
        xdg.data.files."stardict/dic".source = stardict-dicts;
      };
    };
}
