{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Color scheme
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    # Global options
    opts = {
      # Line numbers
      number = true;
      relativenumber = true;

      # Indentation
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      smartindent = true;

      # Search
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;

      # UI
      termguicolors = true;
      signcolumn = "yes";
      wrap = false;
      scrolloff = 8;
      sidescrolloff = 8;
      cursorline = true;
      splitbelow = true;
      splitright = true;

      # Performance
      updatetime = 50;
      timeout = true;
      timeoutlen = 300;

      # Backup
      swapfile = false;
      backup = false;
      undofile = true;

      # Completion
      completeopt = "menu,menuone,noselect";

      # Mouse
      mouse = "a";

      # Clipboard
      clipboard = "unnamedplus";

      # Folding
      foldmethod = "expr";
      foldexpr = "nvim_treesitter#foldexpr()";
      foldenable = false;
      foldlevel = 99;
      foldlevelstart = 99;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # Key mappings
    keymaps = [
      # Better up/down
      { mode = ["n" "x"]; key = "j"; action = "v:count == 0 ? 'gj' : 'j'"; options = { expr = true; silent = true; }; }
      { mode = ["n" "x"]; key = "k"; action = "v:count == 0 ? 'gk' : 'k'"; options = { expr = true; silent = true; }; }

      # Move to window
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.desc = "Go to left window"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.desc = "Go to lower window"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.desc = "Go to upper window"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.desc = "Go to right window"; }

      # Resize window
      { mode = "n"; key = "<C-Up>"; action = "<cmd>resize +2<cr>"; options.desc = "Increase window height"; }
      { mode = "n"; key = "<C-Down>"; action = "<cmd>resize -2<cr>"; options.desc = "Decrease window height"; }
      { mode = "n"; key = "<C-Left>"; action = "<cmd>vertical resize -2<cr>"; options.desc = "Decrease window width"; }
      { mode = "n"; key = "<C-Right>"; action = "<cmd>vertical resize +2<cr>"; options.desc = "Increase window width"; }

      # Buffers
      { mode = "n"; key = "<S-h>"; action = "<cmd>bprevious<cr>"; options.desc = "Previous buffer"; }
      { mode = "n"; key = "<S-l>"; action = "<cmd>bnext<cr>"; options.desc = "Next buffer"; }
      { mode = "n"; key = "[b"; action = "<cmd>bprevious<cr>"; options.desc = "Previous buffer"; }
      { mode = "n"; key = "]b"; action = "<cmd>bnext<cr>"; options.desc = "Next buffer"; }

      # Clear search with esc
      { mode = ["i" "n"]; key = "<esc>"; action = "<cmd>noh<cr><esc>"; options.desc = "Escape and clear hlsearch"; }

      # Save file
      { mode = ["i" "v" "n" "s"]; key = "<C-s>"; action = "<cmd>w<cr><esc>"; options.desc = "Save file"; }

      # Better indenting
      { mode = "v"; key = "<"; action = "<gv"; }
      { mode = "v"; key = ">"; action = ">gv"; }

      # New file
      { mode = "n"; key = "<leader>fn"; action = "<cmd>enew<cr>"; options.desc = "New File"; }

      # Quit
      { mode = "n"; key = "<leader>qq"; action = "<cmd>qa<cr>"; options.desc = "Quit all"; }

      # Windows
      { mode = "n"; key = "<leader>ww"; action = "<C-W>p"; options.desc = "Other window"; }
      { mode = "n"; key = "<leader>wd"; action = "<C-W>c"; options.desc = "Delete window"; }
      { mode = "n"; key = "<leader>w-"; action = "<C-W>s"; options.desc = "Split window below"; }
      { mode = "n"; key = "<leader>w|"; action = "<C-W>v"; options.desc = "Split window right"; }

      # Tabs
      { mode = "n"; key = "<leader><tab>l"; action = "<cmd>tablast<cr>"; options.desc = "Last Tab"; }
      { mode = "n"; key = "<leader><tab>f"; action = "<cmd>tabfirst<cr>"; options.desc = "First Tab"; }
      { mode = "n"; key = "<leader><tab><tab>"; action = "<cmd>tabnew<cr>"; options.desc = "New Tab"; }
      { mode = "n"; key = "<leader><tab>]"; action = "<cmd>tabnext<cr>"; options.desc = "Next Tab"; }
      { mode = "n"; key = "<leader><tab>d"; action = "<cmd>tabclose<cr>"; options.desc = "Close Tab"; }
      { mode = "n"; key = "<leader><tab>["; action = "<cmd>tabprevious<cr>"; options.desc = "Previous Tab"; }

      # Diagnostics
      { mode = "n"; key = "[d"; action.__raw = "vim.diagnostic.goto_prev"; options.desc = "Go to previous diagnostic"; }
      { mode = "n"; key = "]d"; action.__raw = "vim.diagnostic.goto_next"; options.desc = "Go to next diagnostic"; }
      { mode = "n"; key = "<leader>cd"; action.__raw = "vim.diagnostic.open_float"; options.desc = "Line diagnostics"; }
      { mode = "n"; key = "<leader>cl"; action.__raw = "vim.diagnostic.setloclist"; options.desc = "Location list diagnostics"; }

      # Neo-tree
      { mode = "n"; key = "<leader>e"; action = "<cmd>Neotree toggle<cr>"; options.desc = "Explorer NeoTree"; }
      { mode = "n"; key = "<leader>fe"; action = "<cmd>Neotree focus<cr>"; options.desc = "Focus NeoTree"; }

      # Telescope
      { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<cr>"; options.desc = "Find Files"; }
      { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<cr>"; options.desc = "Grep Files"; }
      { mode = "n"; key = "<leader>fb"; action = "<cmd>Telescope buffers<cr>"; options.desc = "Buffers"; }
      { mode = "n"; key = "<leader>fh"; action = "<cmd>Telescope help_tags<cr>"; options.desc = "Help Tags"; }
      { mode = "n"; key = "<leader>fr"; action = "<cmd>Telescope oldfiles<cr>"; options.desc = "Recent Files"; }
      { mode = "n"; key = "<leader>/"; action = "<cmd>Telescope live_grep<cr>"; options.desc = "Grep (root dir)"; }

      # Flash
      { mode = ["n" "x" "o"]; key = "s"; action.__raw = "function() require('flash').jump() end"; options.desc = "Flash"; }
      { mode = ["n" "x" "o"]; key = "S"; action.__raw = "function() require('flash').treesitter() end"; options.desc = "Flash Treesitter"; }

      # DAP
      { mode = "n"; key = "<leader>db"; action.__raw = "function() require('dap').toggle_breakpoint() end"; options.desc = "Toggle breakpoint"; }
      { mode = "n"; key = "<leader>dc"; action.__raw = "function() require('dap').continue() end"; options.desc = "Continue"; }
      { mode = "n"; key = "<leader>di"; action.__raw = "function() require('dap').step_into() end"; options.desc = "Step into"; }
      { mode = "n"; key = "<leader>do"; action.__raw = "function() require('dap').step_over() end"; options.desc = "Step over"; }
      { mode = "n"; key = "<leader>dO"; action.__raw = "function() require('dap').step_out() end"; options.desc = "Step out"; }
      { mode = "n"; key = "<leader>dr"; action.__raw = "function() require('dap').repl.open() end"; options.desc = "Open REPL"; }
      { mode = "n"; key = "<leader>dl"; action.__raw = "function() require('dap').run_last() end"; options.desc = "Run last"; }
      { mode = "n"; key = "<leader>dt"; action.__raw = "function() require('dap').terminate() end"; options.desc = "Terminate"; }
      { mode = "n"; key = "<leader>du"; action.__raw = "function() require('dapui').toggle() end"; options.desc = "Toggle DAP UI"; }
    ];

    # Plugins
    plugins = {
      # UI
      lualine = {
        enable = true;
        settings.options = {
          theme = "catppuccin";
          globalstatus = true;
        };
      };

      bufferline = {
        enable = true;
        settings.options = {
          diagnostics = "nvim_lsp";
          always_show_bufferline = false;
          offsets = [{
            filetype = "neo-tree";
            text = "Neo-tree";
            highlight = "Directory";
            text_align = "left";
          }];
        };
      };

      # File explorer
      neo-tree = {
        enable = true;
        settings = {
          filesystem = {
            follow_current_file.enabled = true;
            hijack_netrw_behavior = "open_default";
          };
          window = {
            width = 30;
            mappings = {
              "<space>" = "none";
            };
          };
        };
      };

      # Git
      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "▎";
          change.text = "▎";
          delete.text = "▎";
          topdelete.text = "▎";
          changedelete.text = "▎";
          untracked.text = "▎";
        };
      };

      # Treesitter
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      treesitter-context.enable = true;

      # Telescope
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
        settings.defaults = {
          mappings.i = {
            "<C-j>" = "move_selection_next";
            "<C-k>" = "move_selection_previous";
          };
        };
      };

      # Which-key
      which-key = {
        enable = true;
        settings.spec = [
          { __unkeyed-1 = "<leader>b"; group = "Buffers"; icon = "󰓩"; }
          { __unkeyed-1 = "<leader>c"; group = "Code"; icon = ""; }
          { __unkeyed-1 = "<leader>d"; group = "Debug"; icon = ""; }
          { __unkeyed-1 = "<leader>f"; group = "Find"; icon = ""; }
          { __unkeyed-1 = "<leader>g"; group = "Git"; icon = ""; }
          { __unkeyed-1 = "<leader>q"; group = "Quit"; icon = "󰗼"; }
          { __unkeyed-1 = "<leader>s"; group = "Search"; icon = ""; }
          { __unkeyed-1 = "<leader>u"; group = "UI"; icon = "󰔃"; }
          { __unkeyed-1 = "<leader>w"; group = "Windows"; icon = ""; }
          { __unkeyed-1 = "<leader>x"; group = "Diagnostics"; icon = ""; }
          { __unkeyed-1 = "<leader><tab>"; group = "Tabs"; icon = "󰌒"; }
        ];
      };

      # Indent guides
      indent-blankline = {
        enable = true;
        settings = {
          indent = {
            char = "│";
            tab_char = "│";
          };
          scope = {
            show_start = false;
            show_end = false;
          };
          exclude.filetypes = [
            "help" "alpha" "dashboard" "neo-tree" "Trouble" "lazy" "mason" "notify" "toggleterm" "lazyterm"
          ];
        };
      };

      # Auto pairs
      nvim-autopairs.enable = true;

      # Comments
      comment.enable = true;

      # Surround
      nvim-surround.enable = true;

      # Todo comments
      todo-comments.enable = true;

      # Trouble
      trouble.enable = true;

      # Flash for quick navigation
      flash = {
        enable = true;
        settings.label.rainbow.enabled = true;
      };

      # LSP
      lsp = {
        enable = true;
        keymaps = {
          lspBuf = {
            "gD" = "declaration";
            "gd" = "definition";
            "K" = "hover";
            "gi" = "implementation";
            "<C-k>" = "signature_help";
            "<leader>D" = "type_definition";
            "<leader>cr" = "rename";
            "<leader>ca" = "code_action";
            "gr" = "references";
          };
        };
        servers = {
          nil_ls = {
            enable = true;
            settings.formatting.command = [ "nixfmt" ];
          };
          lua_ls = {
            enable = true;
            settings = {
              Lua = {
                diagnostics.globals = [ "vim" ];
                workspace.checkThirdParty = false;
                telemetry.enable = false;
              };
            };
          };
          pyright.enable = true;
          ts_ls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          gopls.enable = true;
          bashls.enable = true;
          yamlls.enable = true;
          jsonls.enable = true;
          html.enable = true;
          cssls.enable = true;
          marksman.enable = true;
        };
      };

      # Completion
      cmp = {
        enable = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
        };
      };
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp_luasnip.enable = true;

      # Snippets
      luasnip.enable = true;
      friendly-snippets.enable = true;

      # Notifications
      notify = {
        enable = true;
        settings.background_colour = "#000000";
      };

      # Dashboard
      alpha = {
        enable = true;
        theme = "dashboard";
      };

      # Formatting
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            lua = [ "stylua" ];
            python = [ "black" ];
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            javascriptreact = [ "prettier" ];
            typescriptreact = [ "prettier" ];
            json = [ "prettier" ];
            html = [ "prettier" ];
            css = [ "prettier" ];
            markdown = [ "prettier" ];
            yaml = [ "prettier" ];
            nix = [ "nixfmt" ];
            rust = [ "rustfmt" ];
            go = [ "gofmt" ];
            sh = [ "shfmt" ];
          };
          format_on_save = {
            lsp_fallback = true;
            timeout_ms = 500;
          };
        };
      };

      # Linting
      lint = {
        enable = true;
        lintersByFt = {
          python = [ "pylint" ];
          javascript = [ "eslint" ];
          typescript = [ "eslint" ];
          sh = [ "shellcheck" ];
        };
      };

      # Debug Adapter Protocol
      dap.enable = true;
      dap-ui.enable = true;
      dap-virtual-text.enable = true;

      # Web devicons
      web-devicons.enable = true;
    };

    # Extra packages for formatters, linters, and tools
    extraPackages = with pkgs; [
      # Formatters
      stylua
      black
      nodePackages.prettier
      nixfmt-classic
      rustfmt
      go
      shfmt

      # Linters
      pylint
      nodePackages.eslint
      shellcheck

      # Debug adapters
      delve
      python312Packages.debugpy

      # Tools
      ripgrep
      fd
      gcc
      wl-clipboard
    ];

    # Extra Lua config for DAP adapters
    extraConfigLua = ''
      -- DAP Adapters configuration
      local dap = require('dap')

      -- Go (delve)
      dap.adapters.delve = {
        type = 'server',
        port = "''${port}",
        executable = {
          command = 'dlv',
          args = {'dap', '-l', "127.0.0.1:''${port}"},
        }
      }
      dap.configurations.go = {
        {
          type = 'delve',
          name = 'Debug',
          request = 'launch',
          program = "''${file}",
        },
        {
          type = 'delve',
          name = 'Debug Package',
          request = 'launch',
          program = "''${fileDirname}",
        },
      }

      -- Python (debugpy)
      dap.adapters.python = {
        type = 'executable',
        command = 'python',
        args = { '-m', 'debugpy.adapter' },
      }
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',
          program = "''${file}",
          pythonPath = function()
            return 'python'
          end,
        },
      }

      -- Auto open/close DAP UI
      local dapui = require('dapui')
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- Linting autocommand
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require('lint').try_lint()
        end,
      })
    '';
  };
}
