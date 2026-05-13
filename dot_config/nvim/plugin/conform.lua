local conform = require("conform")

local format_on_save_enabled = true
local formatters_by_ft = {
	bash = { "shfmt" },
	c = { "clang-format" },
	cpp = { "clang-format" },
	css = { "prettier" },
	h = { "clang-format" },
	hpp = { "clang-format" },
	html = { "prettier" },
	javascript = { "prettier" },
	javascriptreact = { "prettier" },
	json = { "prettier" },
	jsonc = { "prettier" },
	jsx = { "prettier" },
	lua = { "stylua" },
	make = { "mbake" },
	markdown = { "prettier" },
	python = { "black", "isort" },
	qml = { "qmlformat" },
	rust = { "rustfmt" },
	s = { "asmfmt" },
	sh = { "shfmt" },
	toml = { "tombi" },
	tsx = { "prettier" },
	typescript = { "prettier" },
	typescriptreact = { "prettier" },
	yaml = { "yamlfmt" },
	zsh = { "shfmt" },
}
local formatters = {
	mbake = {
		inherit = false,
		command = "mbake",
		args = { "format", "$FILENAME" },
		stdin = false,
	},
	isort = {
		inherit = false,
		command = "isort",
		args = { "--profile", "black", "$FILENAME" },
		stdin = false,
	},
}

vim.keymap.set("n", "<leader>cf", function()
	format_on_save_enabled = not format_on_save_enabled
	conform.setup({
		formatters_by_ft = formatters_by_ft,
		format_on_save = format_on_save_enabled,
	})
	print("Format on save: " .. (format_on_save_enabled and "Enabled" or "Disabled"))
end, { noremap = true, silent = true })

conform.setup({
	formatters_by_ft = formatters_by_ft,
	formatters = formatters,
	format_on_save = format_on_save_enabled,
})
