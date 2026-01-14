--Visual Help
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.list = true
vim.o.signcolumn = "yes"

--Tabulation
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4

--Split
vim.o.splitbelow = false
vim.o.splitright = false

--Directory
vim.o.autochdir = false

--Text
vim.o.wrap = false

--File
vim.o.swapfile = false
vim.o.endofline = true

--Search
vim.o.ic = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true

--Undo
vim.o.undodir = vim.fn.expand("~/.cache/nvim/undo")
vim.o.undofile = true
vim.o.undolevels = 1000

--Other
vim.o.scrolloff = 8

--Cmd alias/abbrev
vim.cmd("cabbrev E Ex")

--Windows
vim.o.winborder = "rounded"

--Chars
vim.opt.fillchars = { eob = " " }
