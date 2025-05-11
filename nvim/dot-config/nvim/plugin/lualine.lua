local function location_formatted()
	local line = vim.fn.line(".")
	local col = vim.fn.col(".")
	return string.format("%02d:%02d", line, col)
end

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		require("lualine").refresh()
	end,
})

-- Setup lualine
require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = "auto",
		component_separators = { left = "|", right = "|" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 100,
			tabline = 100,
			winbar = 100,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff" },
		lualine_c = { { "filename", path = 1 } },
		lualine_x = { "filetype" },
		lualine_y = { "progress" },
		lualine_z = { { location_formatted } },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { { "filename", path = 1 } },
		lualine_x = { "filetype" },
		lualine_y = { "progress" },
		lualine_z = { { location_formatted } },
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})
