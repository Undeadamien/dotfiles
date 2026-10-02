local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Mason
	{ "williamboman/mason.nvim", build = ":MasonUpdate" },
	"WhoIsSethDaniel/mason-tool-installer.nvim",

	-- ColorScheme
	-- Pinned: colors.lua uses the pre-3.0 `group_overrides` option and the
	-- `vscLeftDark`/`vscPopupFront` color_override keys, all removed in v3.
	-- On v3 the overrides are silently ignored and the palette reverts to stock.
	{ "Mofiqul/vscode.nvim", version = "6439ed89d0e10193f07e92268a321d7c6f6e93ee" },

	-- TreeSitter
	"nvim-treesitter/nvim-treesitter",
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({ multiwindow = true, separator = "─" })
			vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { link = "LineNr" })
			vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { link = "LineNr" })
		end,
	},

	-- LuaLine
	{ "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

	-- Telescope
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

	-- Comment
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},

	-- ColorHighlighter
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},

	-- UndoTree
	"mbbill/undotree",

	-- Surround
	{
		"kylechui/nvim-surround",
		version = "*",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	-- Markdown
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},

	-- CSV
	{
		"hat0uma/csvview.nvim",
		config = function()
			require("csvview").setup()
		end,
	},

	-- LSP & Completion
	"L3MON4D3/LuaSnip",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-path",
	"hrsh7th/nvim-cmp",
	"neovim/nvim-lspconfig",
	"saadparwaiz1/cmp_luasnip",
	"williamboman/mason-lspconfig.nvim",

	-- Lint
	"mfussenegger/nvim-lint",

	-- Auto-format
	"stevearc/conform.nvim",

	-- Git
	"tpope/vim-fugitive",
	"lewis6991/gitsigns.nvim",

	-- Clock
	{
		"laytan/cloak.nvim",
		config = function()
			require("cloak").setup()
		end,
	},
})
