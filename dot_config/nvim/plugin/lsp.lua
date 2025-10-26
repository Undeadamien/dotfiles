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
vim.lsp.config["lua_ls"] = { settings = { Lua = { diagnostics = { globals = { "vim" }, disable = {} } } } }
vim.lsp.enable("lua_ls")
local default_setup = function(server)
	vim.lsp.config[server] = { capabilities = lsp_capabilities }
	vim.lsp.enable(server)
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

-- local cmp = require("cmp")
require("luasnip.loaders.from_vscode").lazy_load()

vim.opt.completeopt = { "menu", "menuone", "noselect" }
