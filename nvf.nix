{pkgs}: {
  viAlias = false;
  vimAlias = true;
  luaConfigPost = ''
    require('lspconfig').glsl_analyzer.setup{}
  '';
  debugMode = {
    enable = false;
    level = 16;
    logFile = "/tmp/nvim.log";
  };

  spellcheck.enable = true;

  autocomplete = {
    nvim-cmp.enable = true;
  };

  treesitter = {
    context.enable = true; # 코드 상단에 함수선언부를 표시, 클래스 이름, 메소드 이름 표시
    addDefaultGrammars = false;
    grammars = [
      pkgs.glsl_analyzer
      pkgs.vimPlugins.nvim-treesitter-parsers.glsl
    ];
  };

  lsp = {
    null-ls.enable = true;
    formatOnSave = true;
    lspconfig.enable = true;

    #lspkind.enable = true;
    lspsaga.enable = true;
    lspSignature.enable = true;
    lsplines.enable = true;
    nvim-docs-view.enable = true;

    #nvimCodeActionMenu.enable = false;
    lightbulb.enable = false;
    trouble.enable = false;
  };

  debugger = {
    nvim-dap = {
      enable = true;
      ui.enable = true;
    };
  };

  languages = {
    enableLSP = true;
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = true;

    #    ts = {
    #      enable = true;
    #      #format.enable = true;
    #      lsp.enable = true;
    #      treesitter.enable = true;
    #      extraDiagnostics.enable = false;
    #    };
    nix.enable = true;
    css.enable = true;
    html.enable = true;
    bash.enable = true;
    java = {
      enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };
    rust = {
      enable = true;
      lsp.enable = true;
      dap.enable = true;
      #crates.enable = true;
      #format.enable = true;
    };
    clang = {
      enable = true;
      dap.enable = true;
      lsp.enable = true;
      treesitter.enable = true;
    };
  };

  visuals = {
    #enable = true;
    nvim-web-devicons.enable = true;
    nvim-scrollbar.enable = true;
    #smoothScroll.enable = true;
    cellular-automaton.enable = false;
    fidget-nvim.enable = true;
    highlight-undo.enable = true;

    indent-blankline = {
      enable = true;
      #fillChar = null;
      #eolChar = null;
      #scope.enabled = true;
    };

    nvim-cursorline = {
      # Highlight words and lines on the cursor
      enable = true;
      #line_timeout = 0;
    };
  };

  theme = {
    enable = true;
    name = "catppuccin";
    style = "mocha";
    transparent = false;
  };

  #autopairs.enable = true;

  #autocomplete = {
  #enable = true;
  #type = "nvim-cmp";
  #};

  filetree = {
    nvimTree.enable = true;
    nvimTree.setupOpts.git.enable = true;
  };

  tabline = {
    nvimBufferline.enable = true;
  };

  statusline = {
    lualine = {
      enable = true;
      theme = "catppuccin";
    };
  };

  binds = {
    whichKey.enable = true;
    cheatsheet.enable = true;
  };

  telescope.enable = true;

  git = {
    enable = true;
    gitsigns.enable = true;
    gitsigns.codeActions.enable = false;
  };

  # minimap = {
  #   minimap-vim.enable = true;
  #   codewindow.enable = true;
  # };

  dashboard = {
    dashboard-nvim.enable = false;
    alpha.enable = true;
  };

  notify = {
    nvim-notify.enable = true;
  };

  projects = {
    project-nvim.enable = true;
  };

  terminal = {
    toggleterm = {
      enable = true;
      lazygit.enable = true;
    };
  };

  ui = {
    borders.enable = true;
    noice.enable = true;
    colorizer.enable = true;
    modes-nvim.enable = false; # 모드(normal, insert, visual)에 따라 색상 feedback
    illuminate.enable = true; # 같은 단어의 다른 사용을 highlight
    breadcrumbs = {
      enable = false;
      navbuddy.enable = false;
    };
    smartcolumn = {
      # 80자가 넘어가면 경고 선으로 보여준다.
      enable = true;
      setupOpts.custom_colorcolumn = {
        nix = "110";
        rust = "120";
      };
    };
  };

  utility = {
    outline.aerial-nvim.enable = true;
    ccc.enable = false; # color picker and highlighter plugin
    vim-wakatime.enable = false;
    icon-picker.enable = false; # Nerd Font icon & Emojis를 추가하는 문자표
    surround.enable = true; # ys{motion}{char} ds{char} cs{target}{replacement}
    diffview-nvim.enable = true;
    motion = {
      hop.enable = false;
      leap.enable = true;
    };

    images = {
      image-nvim = {
        enable = true;
        setupOpts = {
          backend = "kitty";
        };
      };
    };
  };

  comments = {
    comment-nvim.enable = true;
  };

  notes = {
    obsidian = {
      enable = false;
      setupOpts = {
        dir = "~/notes";
      };
    };
    orgmode.enable = false;
    mind-nvim.enable = false;
    todo-comments.enable = true;
  };
}
