vim.cmd("colorscheme vscode")

local function make_transparent(group)
	local hl = vim.api.nvim_get_hl(0, { name = group })
	hl.bg = "NONE"
	vim.api.nvim_set_hl(0, group, hl)
end

local major_groups = {
	"Normal",
	"NormalNC",
	"NormalFloat",
	"LineNr",
	"CursorLineNr",
	"Pmenu",
	"EndOfBuffer",
	"FloatBorder",
	"WinSeparator",
	"SignColumn",
	"VertSplit",
}

for _, group in ipairs(major_groups) do
	make_transparent(group)
end
