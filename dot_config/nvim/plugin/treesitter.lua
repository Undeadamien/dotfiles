require("nvim-treesitter.configs").setup({
	sync_install = true,
	auto_install = true,
	highlight = { enable = true },
})

vim.keymap.set("n", "<leader>c", function()
	require("treesitter-context").go_to_context()
end, { silent = true })
