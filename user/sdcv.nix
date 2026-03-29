# StarDict Console Version
{ pkgs, ... }:
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
  fzfSdcv = pkgs.writeShellScriptBin "sdcv-fzf" ''
    fzf --prompt="Dict: " \
        --phony \
        --bind "enter:reload(sdcv {q} -n --json | jq '.[].dict' -r)" \
        --preview "sdcv {q} -en --use-dict={}" \
        --preview-window=wrap \
       < <(echo)
  '';
in
{
  home.packages = with pkgs; [
    sdcv
    fzfSdcv
  ];

  # ~/.local/share/stardict/dic
  xdg.dataFile."stardict/dic" = {
    source = stardict-dicts;
  };
}
