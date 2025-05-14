local builtin = require("telescope.builtin")

-- Fix for the the double border
vim.api.nvim_create_autocmd("User", {
	pattern = "TelescopeFindPre",
	callback = function()
		vim.opt_local.winborder = "none"
		vim.api.nvim_create_autocmd("WinLeave", {
			once = true,
			callback = function()
				vim.opt_local.winborder = "rounded"
			end,
		})
	end,
})

vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fc", builtin.current_buffer_fuzzy_find, {})
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, {})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fa", function()
	builtin.find_files({ hidden = true, no_ignore = true })
end)
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fm", builtin.marks, {})
