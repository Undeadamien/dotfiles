math.randomseed(os.time())
local colors = {
	"kanagawa-dragon",
	"lackluster-hack",
	"lackluster-mint",
	"lackluster-night",
	"poimandres",
	"rose-pine",
	"tokyonight-night",
}

local previous_scheme = nil

local function ChangeColor()
	local cursor_hl = vim.api.nvim_get_hl_by_name("CursorLine", true)
	local normal_hl = vim.api.nvim_get_hl_by_name("Normal", true)
	local number_hl = vim.api.nvim_get_hl_by_name("LineNr", true)
	local status_hl = vim.api.nvim_get_hl_by_name("StatusLine", true)

	vim.api.nvim_set_hl(0, "CursorColumn", cursor_hl)
	vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = normal_hl.background })
	vim.api.nvim_set_hl(0, "NormalNC", normal_hl)
	vim.api.nvim_set_hl(0, "WinSeparator", { fg = number_hl.foreground })
end

local function NewColorScheme()
	local scheme
	repeat
		scheme = colors[math.random(#colors)]
	until scheme ~= previous_scheme
	previous_scheme = scheme
	vim.cmd("colorscheme " .. scheme)
end

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	callback = function()
		ChangeColor()
	end,
})

vim.api.nvim_create_user_command("NewColorScheme", NewColorScheme, {})

NewColorScheme()
