require("lint").linters_by_ft = {
	sh = { "shellcheck" },
	bash = { "shellcheck" },
	zsh = { "shellcheck" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
