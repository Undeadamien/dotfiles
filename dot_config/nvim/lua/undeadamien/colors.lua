vim.cmd("colorscheme adwaita")

local normal = vim.api.nvim_get_hl_by_name("Normal", true)
local cursor = vim.api.nvim_get_hl_by_name("CursorLine", true)
local number = vim.api.nvim_get_hl_by_name("LineNr", true)

vim.api.nvim_set_hl(0, "CursorLineNr", { fg = normal.foreground, bold = true })
vim.api.nvim_set_hl(0, "CursorColumn", cursor)
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = normal.background })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC", normal)
vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE" })
vim.api.nvim_set_hl(0, "WinSeparator", { fg = number.foreground })
