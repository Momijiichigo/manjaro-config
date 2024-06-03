
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = "\\" -- make sure to set `mapleader` before lazy so your mappings are correct

vim.filetype.add({extension = {wgsl = "wgsl"}})
vim.filetype.add({extension = {typst = "typ"}})

if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  require "neovide-config"
end


require("lazy").setup({
  "folke/which-key.nvim",
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  "folke/neodev.nvim",

  -- LSP / language features
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- require("mason").setup()
      -- require("mason-lspconfig").setup()
      require'lspconfig'.typst_lsp.setup {
        settings = {
          exportPdf = "onSave" -- Choose onType, onSave or never.
          -- serverPath = "" -- Normally, there is no need to uncomment it.
        }
      }
    end,
    -- dependencies = {
    --   "williamboman/mason-lspconfig.nvim",
    -- },
  },
  -- {
  --   "williamboman/mason.nvim",
  -- },
  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --   },
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdateSync",
    opts = function()
      -- Treesitter: wgsl
      local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
      parser_config.wgsl = {
          install_info = {
              url = "https://github.com/szebniok/tree-sitter-wgsl",
              files = {"src/parser.c"}
          },
      }
      return {
        ensure_installed = {
          "rust",
          "toml",
          "javascript",
          "typescript",
          "vim",
          "lua",
          "python",
          "fish",
          "zig",
          "julia",
          "wgsl",
        },
        highlight = {
          enable = true
        },
      }
    end,
  },
  {
    "neoclide/coc.nvim",
    branch = "release",
    build = ":CocUpdate",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = function()
      local highlight = {
          "RainbowOrange",
          "RainbowGreen",
          "RainbowViolet",
          -- "RainbowRed",
          -- "RainbowYellow",
          -- "RainbowCyan",
          "RainbowBlue",
      }
      local hooks = require "ibl.hooks"
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(
        hooks.type.HIGHLIGHT_SETUP,
        function()
          vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#ea6962" })
          vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#d8a657" })
          vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#7daea3" })
          vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#d8985d" })
          vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#a9b665" })
          vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#c693a1" })
          vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#89b482" })
        end
      )
      return {
        exclude = {
          filetypes = {
            -- "lua",
	    -- "vim",
	    -- "rust",

          }
        },
        indent = {
	  -- highlight = highlight,
	  char = "▏"
	  -- char = "┊"
	},
	scope = {
	  highlight = "RainbowBlue",
	}
      }
    end,
  },
  {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      -- you also will likely want nvim-cmp or some completion engine
    },
    -- see details below for full configuration options
    opts = {
      lsp = {
        on_attach = on_attach,
      },
      mappings = true,
    }
  },
  {
    'kaarmu/typst.vim',
    ft = 'typst',
  },
  {
    'elkowar/yuck.vim',
    ft = 'yuck',
  },
  {
    "NoahTheDuke/vim-just",
    ft = "just",
  },
  {
    "IndianBoy42/tree-sitter-just",
    ft = "just",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    }
  },
  "jghauser/mkdir.nvim",
  {
    'saecki/crates.nvim',
    tag = 'v0.4.0',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = "BufRead Cargo.toml",
    config = function()
        local crates = require('crates')
	crates.setup()
	local opts = { silent = true }

	vim.keymap.set('n', '<leader>cv', crates.show_versions_popup, opts)
	vim.keymap.set('n', '<leader>cf', crates.show_features_popup, opts)
	vim.keymap.set('n', '<leader>cd', crates.show_dependencies_popup, opts)

	vim.keymap.set('n', '<leader>cu', crates.update_crate, opts)
	vim.keymap.set('v', '<leader>cu', crates.update_crates, opts)
	vim.keymap.set('n', '<leader>ca', crates.update_all_crates, opts)
	vim.keymap.set('n', '<leader>cU', crates.upgrade_crate, opts)
	vim.keymap.set('v', '<leader>cU', crates.upgrade_crates, opts)
	vim.keymap.set('n', '<leader>cA', crates.upgrade_all_crates, opts)

	-- vim.keymap.set('n', '<leader>ct', crates.toggle, opts)
	-- vim.keymap.set('n', '<leader>cr', crates.reload, opts)

	-- vim.keymap.set('n', '<leader>ce', crates.expand_plain_crate_to_inline_table, opts)
	-- vim.keymap.set('n', '<leader>cE', crates.extract_crate_into_table, opts)

	vim.keymap.set('n', '<leader>cH', crates.open_homepage, opts)
	vim.keymap.set('n', '<leader>cR', crates.open_repository, opts)
	vim.keymap.set('n', '<leader>cD', crates.open_documentation, opts)
	vim.keymap.set('n', '<leader>cC', crates.open_crates_io, opts)
    end,
  },
  -- folder explorer
  {
    "lambdalisue/fern.vim",
  },
  {
    "lambdalisue/nerdfont.vim",
    dependencies = {
      "lambdalisue/fern.vim",
    },
  },
  {
    "lambdalisue/fern-renderer-nerdfont.vim",
    dependencies = {
      "lambdalisue/fern.vim",
      "lambdalisue/nerdfont.vim",
    },
  },
  {
    "lambdalisue/fern-git-status.vim",
    dependencies = {
      "lambdalisue/fern.vim",
    },
  },
  {
    "lambdalisue/glyph-palette.vim",
    dependencies = {
      "lambdalisue/fern.vim",
    },
  },
  {
    "yuki-yano/fern-preview.vim",
    dependencies = {
      "lambdalisue/fern.vim",
    },
  },
  -- tasks with Git 
  {
    "tpope/vim-fugitive",
  },
  -- Note taking

  {
    -- draw diagrams
    "jbyuki/venn.nvim",
    ft = {
      "markdown",
      "tex",
    },
    config = function()
      -- toggle keymappings for venn using <leader>v
      vim.api.nvim_set_keymap('n', '<leader>v', ":lua Toggle_venn()<CR>", { noremap = true })
    end
  },
--  {
--    "lervag/vimtex",
--    ft = {
--      -- "markdown",
--      "tex",
--      "latex",
--    },
--  },
  {
    -- Latex features
    "jbyuki/nabla.nvim",
    ft = {
      -- "markdown",
      "tex",
      "latex",
    },
    config = function()
      vim.api.nvim_set_keymap(
        'n',
	'<leader>p',
	":lua require('nabla').popup()<CR>",
	{ noremap = true }
      )
      require"nabla".enable_virt({
        autogen = true, -- auto-regenerate ASCII art when exiting insert mode
	silent = true,     -- silents error messages
      })
    end
  },


  -- for Svelte
  {
    "othree/html5.vim",
    ft = {
      "svelte",
      "html",
    },
  },
  -- "pangloss/vim-javascript",
  {
    "evanleck/vim-svelte",
    ft = "svelte",
    branch = "main",
    dependencies = {
      "othree/html5.vim",
      "pangloss/vim-javascript",
    },
  },
  -- file explorer
  {
    "nvim-telescope/telescope.nvim",
    branch = '0.1.x',
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      enable = true,
    }
  },

  -- color theme
  {
    "sainnhe/gruvbox-material",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      vim.fn.SetupTheme()
    end
  },

  -- icons
  "nvim-tree/nvim-web-devicons",

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = { theme = 'gruvbox-material' }
    },
  },

  {
    "akinsho/toggleterm.nvim",
    opts = {
      open_mapping = [[<c-\>]],
    },
    enabled = true,
    -- tag = '*'
  },

  "github/copilot.vim",


})
-- venn.nvim: enable or disable keymappings
function _G.Toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
    else
        vim.cmd[[setlocal ve=]]
        vim.cmd[[mapclear <buffer>]]
        vim.b.venn_enabled = nil
    end
end

-- terminal keymaps
function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jj', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

