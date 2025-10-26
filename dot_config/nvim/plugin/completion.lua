local cmp = require("cmp")

local mapping_main = {
	["<C-n>"] = cmp.mapping.select_next_item(),
	["<C-p>"] = cmp.mapping.select_prev_item(),
	["<C-d>"] = cmp.mapping.scroll_docs(4),
	["<C-u>"] = cmp.mapping.scroll_docs(-4),
	["<C-y>"] = cmp.mapping.confirm({ select = true }),
	["<CR>"] = cmp.mapping.confirm({ select = false }),
	["<C-e>"] = cmp.mapping.abort(),
}
local mapping_cmdline = {
	["<Tab>"] = { c = cmp.mapping.select_next_item() },
	["<S-Tab>"] = { c = cmp.mapping.select_prev_item() },
	["<C-y>"] = { c = cmp.mapping.confirm({ select = true }) },
	["<C-e>"] = { c = cmp.mapping.abort() },
}

cmp.setup({
	formatting = {
		format = function(entry, vim_item)
			vim_item.menu = ({ buffer = "[Buffer]", nvim_lsp = "[LSP]", luasnip = "[Snip]", nvim_lua = "[Lua]" })[entry.source.name]
			return vim_item
		end,
	},
	preselect = cmp.PreselectMode.None,
	completion = { completeopt = "menu,menuone,noinsert" },
	window = { documentation = cmp.config.window.bordered() },
	experimental = { ghost_text = true },
	performance = { max_view_entries = 15 },
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
		},
	},
	mapping = mapping_main,
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
})

cmp.setup.cmdline("?", { mapping = mapping_cmdline, sources = { { name = "buffer" } } })
cmp.setup.cmdline("/", { mapping = mapping_cmdline, sources = { { name = "buffer" } } })
cmp.setup.cmdline(":", {
	mapping = mapping_cmdline,
	sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline", option = { ignore_cmds = { "!" } } } }),
})
