-- lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

require("lazy").setup({
    "bluz71/vim-moonfly-colors", -- colorscheme
    -- blink completion
    {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },

  -- use a release tag to download pre-built binaries
  version = '1.*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = 'super-tab' },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = false } },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" }
  },
  opts_extend = { "sources.default" }
},
    -- mason lsp 
    {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    }
},
    -- end mason-lsp

    -- nvim-tree
    {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons"
	},
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- optionally enable 24-bit colour
		vim.opt.termguicolors = true

		-- empty setup using defaults
		require("nvim-tree").setup()

		-- OR setup with some options
		require("nvim-tree").setup({
		  sort = {
		    sorter = "case_sensitive",
		  },
		  view = {
		    width = 30,
		  },
		  renderer = {
		    group_empty = true,
		  },
		  filters = {
		    dotfiles = true,
		  },
		})

		require("nvim-tree").setup({
		  renderer = {
		    icons = {
		      show = {
			git = true,
			file = false,
			folder = false,
			folder_arrow = true,
		      },
		      glyphs = {
			folder = {
			  arrow_closed = "⏵",
			  arrow_open = "⏷",
			},
			git = {
			  unstaged = "✗",
			  staged = "✓",
			  unmerged = "⌥",
			  renamed = "➜",
			  untracked = "★",
			  deleted = "⊖",
			  ignored = "◌",
			},
		      },
		    },
		  },
		})
	end
},
-- end of nvim-tree

-- nvim greeter because don't have friends((
{
    'goolord/alpha-nvim',
    config = function ()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end,
},

{
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Telescope: Find Files' },
    { '<leader>fg', function() require('telescope.builtin').live_grep() end, desc = 'Telescope: Live Grep' },
    { '<leader>fb', function() require('telescope.builtin').buffers() end, desc = 'Telescope: Buffers' },
    { '<leader>fh', function() require('telescope.builtin').help_tags() end, desc = 'Telescope: Help Tags' },
  },
},
})
