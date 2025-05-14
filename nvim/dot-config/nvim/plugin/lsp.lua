--Keymaps
vim.keymap.set("n", "gl", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
	end,
})

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({ settings = { Lua = { diagnostics = { globals = { "vim" }, disable = {} } } } })
local default_setup = function(server)
	lspconfig[server].setup({ capabilities = lsp_capabilities })
end
require("mason").setup({})
require("mason-lspconfig").setup({ ensure_installed = {}, handlers = { default_setup } })

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.HINT] = "⚑",
			[vim.diagnostic.severity.INFO] = "ℹ",
		},
		linehl = {},
		numhl = {},
	},
	virtual_text = { prefix = "", suffix = "" },
	severity_sort = true,
	float = { style = "minimal", border = "rounded", source = "always", header = "", prefix = "" },
})

local cmp = require("cmp")
require("luasnip.loaders.from_vscode").lazy_load()

vim.opt.completeopt = { "menu", "menuone", "noselect" }

cmp.setup({
	formatting = {
		format = function(entry, vim_item)
			vim_item.menu = ({ buffer = "[Buffer]", nvim_lsp = "[LSP]", luasnip = "[Snip]", nvim_lua = "[Lua]" })[entry.source.name]
			return vim_item
		end,
	},
	preselect = "item",
	completion = { completeopt = "menu,menuone,noinsert" },
	window = { documentation = cmp.config.window.bordered() },
	sources = {
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
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
