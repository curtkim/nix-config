{ lib
, fetchFromGitHub
, python3
,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "claude-engineer";
  version = "unstable-2024-09-14";

  src = fetchFromGitHub {
    owner = "Doriandarko";
    repo = "claude-engineer";
    rev = "a89250b51da9d14e9a20aa47f95689b6e0c2939f";
    hash = "sha256-lbHE4bkV09XEj0BX+FQuIY87n0mTcthWRf0fu1XMJmQ=";
  };

  dependencies = with python3.pkgs; [
    anthropic
    python-dotenv
    #tavily-python
    pillow
    rich
    prompt_toolkit
    pydub
    websockets
    speechrecognition
  ];

  meta = {
    description = "Claude Engineer is an interactive command-line interface (CLI) that leverages the power of Anthropic's Claude-3.5-Sonnet model to assist with software development tasks. This tool combines the capabilities of a large language model with practical file system operations and web search functionality";
    homepage = "https://github.com/Doriandarko/claude-engineer";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "claude-engineer";
    platforms = lib.platforms.all;
  };
}
