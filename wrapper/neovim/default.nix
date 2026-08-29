{
  config,
  wlib,
  pkgs,
  lib,
  ...
}:
{
  imports = [ wlib.wrapperModules.neovim ];

  settings.config_directory = ./.;
  #settings.config_directory = "/home/curt/projects/nvim-wrappers/neovim";


  # --- lazy-loading engine ---------------------------------------------------
  specs.lze = [
    pkgs.vimPlugins.lze
    pkgs.vimPlugins.lzextras
  ];

  # --- colorscheme (must load before INIT_MAIN) ------------------------------
  specs.tokyonight = {
    data = pkgs.vimPlugins.tokyonight-nvim;
    before = [ "INIT_MAIN" ];
    config = ''vim.cmd.colorscheme("tokyonight-night")'';
  };

  # --- startup plugins (not lazy) --------------------------------------------
  specs.startup = {
    data = with pkgs.vimPlugins; [
      guess-indent-nvim
      vim-tmux-navigator
      plenary-nvim
      nvim-web-devicons
      nui-nvim
    ];
  };

  # --- treesitter -------------------------------------------------------------
  specs.treesitter = {
    data = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
  };

  # --- lean 4 ------------------------------------------------------------------
  # lean.nvim: filetype/syntax/ftplugin + treesitter query(highlights.scm) 제공
  # tree-sitter-lean: nvim-treesitter에 없는 grammar라서 parser/lean.so로 직접 붙임
  specs.lean = {
    data = [
      pkgs.vimPlugins.lean-nvim
      (pkgs.runCommandLocal "lean-treesitter-parser" { } ''
        mkdir -p "$out/parser"
        ln -s ${pkgs.tree-sitter-grammars.tree-sitter-lean}/parser "$out/parser/lean.so"
      '')
    ];
  };

  # --- completion & snippets --------------------------------------------------
  specs.completion = {
    data = with pkgs.vimPlugins; [
      blink-cmp
      luasnip
    ];
  };

  # --- LSP --------------------------------------------------------------------
  specs.lsp = {
    data = with pkgs.vimPlugins; [
      nvim-lspconfig
      fidget-nvim
    ];
  };

  # --- formatting & linting ---------------------------------------------------
  specs.formatting = {
    data = with pkgs.vimPlugins; [
      conform-nvim
      nvim-lint
    ];
  };

  # --- telescope --------------------------------------------------------------
  specs.telescope = {
    data = with pkgs.vimPlugins; [
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
    ];
  };

  # --- lazy-loaded plugins (lze triggers in init.lua) -------------------------
  specs.lazy-plugins = {
    lazy = true;
    data = with pkgs.vimPlugins; [
      neo-tree-nvim
      which-key-nvim
      gitsigns-nvim
      todo-comments-nvim
      mini-nvim
      nvim-autopairs
      bufferline-nvim
      auto-save-nvim
      bullets-vim
      image-nvim
    ];
  };

  # --- DAP (debugging) --------------------------------------------------------
  specs.dap = {
    lazy = true;
    data = with pkgs.vimPlugins; [
      nvim-dap
      nvim-dap-ui
      nvim-nio
      nvim-dap-go
    ];
  };

  # --- markdown-preview -------------------------------------------------------
  specs.markdown-preview = {
    lazy = true;
    data = pkgs.vimPlugins.markdown-preview-nvim;
  };

  # --- runtime packages (LSPs, formatters, tools) ----------------------------
  runtimePkgs = with pkgs; [
    typescript-language-server
    lua-language-server
    stylua
    ripgrep
    fd
    gnumake
    delve
    elan # lean/lake (lean.nvim LSP)
  ];

  # --- specMods for per-spec runtimePkgs -------------------------------------
  specMods =
    { lib, ... }:
    {
      options.runtimePkgs = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
      };
    };
}
