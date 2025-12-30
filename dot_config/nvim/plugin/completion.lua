local cmp = require("cmp")

local completion_options = "fuzzy,menu,menuone,noinsert"
local mapping_main = {
	["<Tab>"] = nil,
	["<S-Tab>"] = nil,
	["<C-n>"] = cmp.mapping.select_next_item(),
	["<C-p>"] = cmp.mapping.select_prev_item(),
	["<C-d>"] = cmp.mapping.scroll_docs(4),
	["<C-u>"] = cmp.mapping.scroll_docs(-4),
	["<C-y>"] = cmp.mapping.confirm(),
	["<CR>"] = cmp.mapping.confirm(),
	["<C-e>"] = cmp.mapping.abort(),
}
local mapping_cmdline = {
	["<Tab>"] = { c = nil },
	["<S-Tab>"] = { c = nil },
	["<C-n>"] = { c = cmp.mapping.select_next_item() },
	["<C-p>"] = { c = cmp.mapping.select_prev_item() },
	["<C-y>"] = { c = cmp.mapping.confirm() },
	["<C-e>"] = { c = cmp.mapping.abort() },
}

cmp.setup({
	formatting = {
		format = function(entry, vim_item)
			vim_item.menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				luasnip = "[Snip]",
				nvim_lua = "[Lua]",
			})[entry.source.name]
			return vim_item
		end,
	},
	preselect = cmp.PreselectMode.Item,
	completion = { completeopt = completion_options },
	window = { documentation = cmp.config.window.bordered() },
	experimental = { ghost_text = false },
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

cmp.setup.cmdline("?", {
	completion = { completeopt = completion_options },
	mapping = mapping_cmdline,
	sources = { { name = "buffer" } },
})
cmp.setup.cmdline("/", {
	completion = { completeopt = completion_options },
	mapping = mapping_cmdline,
	sources = { { name = "buffer" } },
})
cmp.setup.cmdline(":", {
	completion = { completeopt = completion_options },
	sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline", option = { ignore_cmds = { "!" } } } }),
	mapping = mapping_cmdline,
})
