local config = require("nvim-treesitter.configs")
local context = require("treesitter-context")

config.setup({
	sync_install = true,
	auto_install = true,
	highlight = { enable = true },
})

vim.keymap.set("n", "<leader>c", function()
	context.go_to_context()
end, { silent = true })
