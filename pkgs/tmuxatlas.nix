{ lib
, buildGoModule
, buildNpmPackage
, fetchFromGitHub
, makeWrapper
, tmux
, installShellFiles
}:

let
  pname = "tmuxatlas";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "LosFurina";
    repo = "tmuxatlas";
    rev = "v${version}";
    hash = "sha256-6ajrE5l11TwvGHuPoOlvsdMA0q38XedCKeOF/n/th/U=";
  };

  # web/ 의 vite 빌드 결과물. go:embed 로 pkg/server/dist 에 포함된다.
  frontend = buildNpmPackage {
    pname = "${pname}-web";
    inherit version src;

    sourceRoot = "${src.name}/web";

    npmDepsHash = "sha256-x4S31wCA0J7f0qENrFcvkrNZgmpvcfiPTjg+8zXBPS0=";

    # vite 가 소스 트리 밖(../pkg/server/dist)에 결과물을 쓰므로 쓰기 권한이 필요하다.
    preBuild = ''
      chmod -R u+w ..
    '';

    # vite.config.ts 의 outDir 이 ../pkg/server/dist 이다.
    installPhase = ''
      runHook preInstall
      cp -r ../pkg/server/dist $out
      runHook postInstall
    '';
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-sffme9vh8nZAITa8EP1c97WJTIZsYoxRnPr21bs6ZOU=";

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  preBuild = ''
    mkdir -p pkg/server/dist
    cp -r ${frontend}/. pkg/server/dist/
    chmod -R u+w pkg/server/dist
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/LosFurina/tmuxatlas/pkg/common.SUMMARY=v${version}"
    "-X github.com/LosFurina/tmuxatlas/pkg/common.VERSION=v${version}"
    "-X github.com/LosFurina/tmuxatlas/pkg/common.BRANCH=release"
    "-X github.com/LosFurina/tmuxatlas/pkg/common.COMMIT=v${version}"
  ];

  # 테스트가 tmux 등 런타임 환경을 요구한다.
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/tmuxatlas \
      --prefix PATH : ${lib.makeBinPath [ tmux ]}
  '';

  meta = with lib; {
    description = "Web dashboard for monitoring and interacting with tmux sessions";
    homepage = "https://github.com/LosFurina/tmuxatlas";
    license = licenses.mit;
    mainProgram = "tmuxatlas";
    platforms = platforms.unix;
  };
}
