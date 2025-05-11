local lsp_zero = require("lsp-zero")

local lsp_attach = function(client, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
end

lsp_zero.extend_lspconfig({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	lsp_attach = lsp_attach,
	float_border = "rounded",
	sign_text = {
		error = "✘",
		warn = "▲",
		hint = "⚑",
		info = "ℹ",
	},
})

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "clangd", "lua_ls" },
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
		lua_ls = function()
			require("lspconfig").lua_ls.setup({
				on_init = function(client)
					lsp_zero.nvim_lua_settings(client, {})
				end,
			})
		end,
	},
})

vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")

vim.diagnostic.config({
	virtual_text = { prefix = "", suffix = "" },
	severity_sort = true,
	float = {
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

local cmp = require("cmp")
local cmp_action = lsp_zero.cmp_action()
local cmp_format = lsp_zero.cmp_format()

require("luasnip.loaders.from_vscode").lazy_load()

vim.opt.completeopt = { "menu", "menuone", "noselect" }

cmp.setup({
	formatting = cmp_format,
	preselect = "item",
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	window = {
		documentation = cmp.config.window.bordered(),
	},
	sources = {
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "luasnip", keyword_length = 2 },
		{
			name = "buffer",
			option = {
				get_bufnrs = function()
					local bufs = {}
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						bufs[vim.api.nvim_win_get_buf(win)] = true
					end
					return vim.tbl_keys(bufs)
				end,
			},
			keyword_length = 3,
		},
	},
	mapping = {
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
})
